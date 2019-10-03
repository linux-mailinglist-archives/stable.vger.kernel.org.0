Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE64ECA445
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390456AbfJCQXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389206AbfJCQXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D346215EA;
        Thu,  3 Oct 2019 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119794;
        bh=WmrOGuY5GMN6eKGQLwtMcAe+ftTx4I0a4povACCJ4Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCR4FtDGbiCWYljZ5o5PC/CLYHMwIU0GlclKSFLxl+fBbPjQ9Jtrg19Uu2VzywMRn
         D07tIBUafwS0IMiu9+kaIURU71Zu4hfjMlMJdqqSfPS1wsFBq4MCs81pKgjNPDD8CO
         5n+aX6F13hVYwcVJL66k8GK1u3hPAiNCoLiA4DfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/211] ceph: use ceph_evict_inode to cleanup inodes resource
Date:   Thu,  3 Oct 2019 17:53:44 +0200
Message-Id: <20191003154524.124604407@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan, Zheng <zyan@redhat.com>

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

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 11f19432a74c4..c06845237cbaa 100644
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
index c5cf46e43f2e7..ccab249a37f6a 100644
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
index 0180193097905..8d3eabf06d66a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -854,6 +854,7 @@ static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
 extern const struct inode_operations ceph_file_iops;
 
 extern struct inode *ceph_alloc_inode(struct super_block *sb);
+extern void ceph_evict_inode(struct inode *inode);
 extern void ceph_destroy_inode(struct inode *inode);
 extern int ceph_drop_inode(struct inode *inode);
 
-- 
2.20.1



