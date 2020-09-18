Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C27926F3F4
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgIRCCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbgIRCCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E848235F8;
        Fri, 18 Sep 2020 02:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394532;
        bh=K4nUaNmLvBiaHjCXtJrH4Xt4KeHX2wQF+A7iBLMQEo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmPxTWLOzdN/DZOTBh8yGY6PAxc+Out6lzfUKlvEglLnrFGzKqm8T22PaAN4UzOMo
         tOsWqrbR/9yXRTyX3iHslQHSClBrfE2ts+Dlyg036cDLry0qZi62ZtgMbJTLGFWvdQ
         704M5zLTJyyHeL8cEkid+ELUTtjPtRkP7e02yEos=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 051/330] fix dget_parent() fastpath race
Date:   Thu, 17 Sep 2020 21:56:31 -0400
Message-Id: <20200918020110.2063155-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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

