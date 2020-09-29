Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6EC27CA9B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgI2MUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729876AbgI2Lfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04B472376E;
        Tue, 29 Sep 2020 11:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378496;
        bh=UmE6HDmKHh1tjp+4Mo2RuBKkzu03dbR/zl8DtI3X64A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwPtmxh0P2V1aUiyLIt8yc2s2hiqCfFo2FQuFDgD5jRjpp/dRlIokZxPMFtiDBICb
         vCnqcqnPzoxd73mlQRtr5X7xGam2KOrrgXWWEwa3BIcVss0IFnb2Kqfu7fL19OUvAY
         5ifVOC64Xb/3/RUN0lhmJlkufFA4VNCuANrTQqmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/245] fix dget_parent() fastpath race
Date:   Tue, 29 Sep 2020 12:58:05 +0200
Message-Id: <20200929105948.667514643@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index 6e0022326afe3..20370a0997bf9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -864,17 +864,19 @@ struct dentry *dget_parent(struct dentry *dentry)
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



