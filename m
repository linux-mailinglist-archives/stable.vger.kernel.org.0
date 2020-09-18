Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8249E26EBF3
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgIRCIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgIRCIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 965C1239A1;
        Fri, 18 Sep 2020 02:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394918;
        bh=UmE6HDmKHh1tjp+4Mo2RuBKkzu03dbR/zl8DtI3X64A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp6lMXJMzCMghQVrHueuA+dmQXT8ZJ/nHjVPEXV2oiAudnA231264pQTEn8HuQvXC
         SUp399zt45mW1sxB2pFRcaqYpdVIL5+66p+UjsJfM3yG9FSpMDakTt7O2CfqQWkoB6
         TT7EmXzgH3OusSsavQ0PNhftCQAcD/4Fk1CVm8DQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 030/206] fix dget_parent() fastpath race
Date:   Thu, 17 Sep 2020 22:05:06 -0400
Message-Id: <20200918020802.2065198-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

