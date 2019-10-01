Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295CBC42A0
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 23:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfJAVY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 17:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfJAVY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 17:24:28 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358F12168B;
        Tue,  1 Oct 2019 21:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569965066;
        bh=jQ5zE9UYCh7mNDyAapzJSpEb0s39jCgJ6xDdia4cttA=;
        h=From:To:Cc:Subject:Date:From;
        b=aCAsNKoA5BL/OhJbzpfM/hn13sd+ySzwXD2BF1tXkAbSze6xPTQXpFMUwN49IDV29
         q78qzbgEclerTbE/7Ctj3+0xIdcv4dM9FAMHEnFo26P23UjtX78W4E4AZPbD/zGlCo
         niJYnz16DOc1vq/h3BJv0xbWqD+sU704XBWkvRkg=
From:   Jeff Layton <jlayton@kernel.org>
To:     sashal@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [v4.19-stable PATCH] ceph: use ceph_evict_inode to cleanup inode's resource
Date:   Tue,  1 Oct 2019 17:24:24 -0400
Message-Id: <20191001212425.3085-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Yan, Zheng" <zyan@redhat.com>

[ Upstream commit 87bc5b895d94a0f40fe170d4cf5771c8e8f85d15 ]

remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
freeing inode to remove its caps. But VFS wakes freeing inode waiters
before calling destroy_inode().

[ jlayton: mainline moved to ->free_inode before the original patch was
	   merged. This backport reinstates ceph_destroy_inode and just
	   has it do the call_rcu call. ]

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/40102
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 10 ++++++++--
 fs/ceph/super.c |  1 +
 fs/ceph/super.h |  1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

Hi Sasha,

Sorry for the resend -- forgot to cc stable@vger on the first one.

This patch should be applied after commit 81281039999 is reverted.
Sorry for the mixup!

-- Jeff

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 11f19432a74c..c06845237cba 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -528,13 +528,16 @@ static void ceph_i_callback(struct rcu_head *head)
 	kmem_cache_free(ceph_inode_cachep, ci);
 }
 
-void ceph_destroy_inode(struct inode *inode)
+void ceph_evict_inode(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_inode_frag *frag;
 	struct rb_node *n;
 
-	dout("destroy_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
+	dout("evict_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
+
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
 
 	ceph_fscache_unregister_inode_cookie(ci);
 
@@ -576,7 +579,10 @@ void ceph_destroy_inode(struct inode *inode)
 		ceph_buffer_put(ci->i_xattrs.prealloc_blob);
 
 	ceph_put_string(rcu_dereference_raw(ci->i_layout.pool_ns));
+}
 
+void ceph_destroy_inode(struct inode *inode)
+{
 	call_rcu(&inode->i_rcu, ceph_i_callback);
 }
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c5cf46e43f2e..ccab249a37f6 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -830,6 +830,7 @@ static const struct super_operations ceph_super_ops = {
 	.destroy_inode	= ceph_destroy_inode,
 	.write_inode    = ceph_write_inode,
 	.drop_inode	= ceph_drop_inode,
+	.evict_inode	= ceph_evict_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
 	.remount_fs	= ceph_remount,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 018019309790..8d3eabf06d66 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -854,6 +854,7 @@ static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
 extern const struct inode_operations ceph_file_iops;
 
 extern struct inode *ceph_alloc_inode(struct super_block *sb);
+extern void ceph_evict_inode(struct inode *inode);
 extern void ceph_destroy_inode(struct inode *inode);
 extern int ceph_drop_inode(struct inode *inode);
 
-- 
2.21.0

