Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E740B27C9EE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731817AbgI2MPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730098AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 976D523B06;
        Tue, 29 Sep 2020 11:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379181;
        bh=K4nUaNmLvBiaHjCXtJrH4Xt4KeHX2wQF+A7iBLMQEo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B91yWBOWdz4wLi1nEZOq1HaWXn6Kz+blAGJzJnLPJDbY8gryB/uzR73qE+Ztz3os0
         hoBR6/sc1OaQLxWORJ6Z993QthGO2mTZuxB70uR2aAmoNCGPJdZ5nVpkiSH8PyGgwa
         sVkZLcwvWjq8A/GKise5BXmx68//yotKpxyY4WBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/388] fix dget_parent() fastpath race
Date:   Tue, 29 Sep 2020 12:56:19 +0200
Message-Id: <20200929110012.819755357@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e84009336711d2bba885fc9cea66348ddfce3758 ]

We are overoptimistic about taking the fast path there; seeing
the same value in ->d_parent after having grabbed a reference
to that parent does *not* mean that it has remained our parent
all along.

That wouldn't be a big deal (in the end it is our parent and
we have grabbed the reference we are about to return), but...
the situation with barriers is messed up.

We might have hit the following sequence:

d is a dentry of /tmp/a/b
CPU1:					CPU2:
parent = d->d_parent (i.e. dentry of /tmp/a)
					rename /tmp/a/b to /tmp/b
					rmdir /tmp/a, making its dentry negative
grab reference to parent,
end up with cached parent->d_inode (NULL)
					mkdir /tmp/a, rename /tmp/b to /tmp/a/b
recheck d->d_parent, which is back to original
decide that everything's fine and return the reference we'd got.

The trouble is, caller (on CPU1) will observe dget_parent()
returning an apparently negative dentry.  It actually is positive,
but CPU1 has stale ->d_inode cached.

Use d->d_seq to see if it has been moved instead of rechecking ->d_parent.
NOTE: we are *NOT* going to retry on any kind of ->d_seq mismatch;
we just go into the slow path in such case.  We don't wait for ->d_seq
to become even either - again, if we are racing with renames, we
can bloody well go to slow path anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index e88cf0554e659..b2a7f1765f0b1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -903,17 +903,19 @@ struct dentry *dget_parent(struct dentry *dentry)
 {
 	int gotref;
 	struct dentry *ret;
+	unsigned seq;
 
 	/*
 	 * Do optimistic parent lookup without any
 	 * locking.
 	 */
 	rcu_read_lock();
+	seq = raw_seqcount_begin(&dentry->d_seq);
 	ret = READ_ONCE(dentry->d_parent);
 	gotref = lockref_get_not_zero(&ret->d_lockref);
 	rcu_read_unlock();
 	if (likely(gotref)) {
-		if (likely(ret == READ_ONCE(dentry->d_parent)))
+		if (!read_seqcount_retry(&dentry->d_seq, seq))
 			return ret;
 		dput(ret);
 	}
-- 
2.25.1



