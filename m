Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6099409FCC
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348356AbhIMWfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348317AbhIMWfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F62661107;
        Mon, 13 Sep 2021 22:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572436;
        bh=7S2HcTABLuW4rHZQ9x3c1/xDa7s9si42pirRIlJvCqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhHbR5CKy1vX9JCDkNPPc+jC2xaH702UWN3des8rkXpBSsUCwkFmGhzgR82zhbATi
         14SKnHTzjUEG3pA5YVS+WrxaCOnSLvdNoHMAnDUrEB6xAhJMly2Q7Xo+aSuphUhD+v
         5HOCD/aPKMvEK4oq05bxlbLgkG63Wxlh5hqgRqj6gVEufnHrvOIUnrIzY14GyCBAxH
         /2xo3ljdozZUE0SHw9jnftXZIvn8/i0Z1X5hZNUE/waPBxYQGVM6Qg7WsHczScLuXN
         ZUntc6n4hDtbP4I3DL5/PTypEe2ykMrfJyE1+ru9mR0VkHArKK6Xam5isF8jXGcnlf
         KMOtFBOrGJkAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?q?Jozef=20Kov=C3=A1=C4=8D?= <kovac@firma.zoznam.sk>,
        Xiubo Li <xiubli@redhat.com>,
        Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 12/25] ceph: request Fw caps before updating the mtime in ceph_write_iter
Date:   Mon, 13 Sep 2021 18:33:26 -0400
Message-Id: <20210913223339.435347-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b11ed50346683a749632ea664959b28d524d7395 ]

The current code will update the mtime and then try to get caps to
handle the write. If we end up having to request caps from the MDS, then
the mtime in the cap grant will clobber the updated mtime and it'll be
lost.

This is most noticable when two clients are alternately writing to the
same file. Fw caps are continually being granted and revoked, and the
mtime ends up stuck because the updated mtimes are always being
overwritten with the old one.

Fix this by changing the order of operations in ceph_write_iter to get
the caps before updating the times. Also, make sure we check the pool
full conditions before even getting any caps or uninlining.

URL: https://tracker.ceph.com/issues/46574
Reported-by: Jozef Kováč <kovac@firma.zoznam.sk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d1755ac1d964..3daebfaec8c6 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1722,32 +1722,26 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	}
 
-	err = file_remove_privs(file);
-	if (err)
+	down_read(&osdc->lock);
+	map_flags = osdc->osdmap->flags;
+	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
+	up_read(&osdc->lock);
+	if ((map_flags & CEPH_OSDMAP_FULL) ||
+	    (pool_flags & CEPH_POOL_FLAG_FULL)) {
+		err = -ENOSPC;
 		goto out;
+	}
 
-	err = file_update_time(file);
+	err = file_remove_privs(file);
 	if (err)
 		goto out;
 
-	inode_inc_iversion_raw(inode);
-
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
 		err = ceph_uninline_data(file, NULL);
 		if (err < 0)
 			goto out;
 	}
 
-	down_read(&osdc->lock);
-	map_flags = osdc->osdmap->flags;
-	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
-	up_read(&osdc->lock);
-	if ((map_flags & CEPH_OSDMAP_FULL) ||
-	    (pool_flags & CEPH_POOL_FLAG_FULL)) {
-		err = -ENOSPC;
-		goto out;
-	}
-
 	dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
 	     inode, ceph_vinop(inode), pos, count, i_size_read(inode));
 	if (fi->fmode & CEPH_FILE_MODE_LAZY)
@@ -1759,6 +1753,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (err < 0)
 		goto out;
 
+	err = file_update_time(file);
+	if (err)
+		goto out_caps;
+
+	inode_inc_iversion_raw(inode);
+
 	dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
 	     inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
 
@@ -1842,6 +1842,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	goto out_unlocked;
+out_caps:
+	ceph_put_cap_refs(ci, got);
 out:
 	if (direct_lock)
 		ceph_end_io_direct(inode);
-- 
2.30.2

