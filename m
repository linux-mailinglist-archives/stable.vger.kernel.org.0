Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADF8A6F00
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbfICQ3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbfICQ3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:29:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1BF4238C7;
        Tue,  3 Sep 2019 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528140;
        bh=JY321FLVpt2Dz+pjMSYaH1fx+xAPV6b3/H00N/2uyEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yC5CdqcYOkDUIOxKz9JegaPZ6IeWp0LskpFVqNHHV7sb49WqWu031EhisVtyrKYf+
         6x+Ijy8ns9hvpXykScwvHZcOrNW81b8ayErE47Fhaynef1TYr2jxDVHAePp6zC8TEV
         rRIsi4rUDP6G3FeYDhIXMWBvnV9YmfoI+37HC4Q8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 131/167] ceph: use ceph_evict_inode to cleanup inode's resource
Date:   Tue,  3 Sep 2019 12:24:43 -0400
Message-Id: <20190903162519.7136-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/40102
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 7 +++++--
 fs/ceph/super.c | 2 +-
 fs/ceph/super.h | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 3e518c2ae2bf9..2a64e8f695b93 100644
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
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c5cf46e43f2e7..02528e11bf331 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -827,9 +827,9 @@ static int ceph_remount(struct super_block *sb, int *flags, char *data)
 
 static const struct super_operations ceph_super_ops = {
 	.alloc_inode	= ceph_alloc_inode,
-	.destroy_inode	= ceph_destroy_inode,
 	.write_inode    = ceph_write_inode,
 	.drop_inode	= ceph_drop_inode,
+	.evict_inode	= ceph_evict_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
 	.remount_fs	= ceph_remount,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d8579a56e5dc2..6ef2a3b60951a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -854,7 +854,7 @@ static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
 extern const struct inode_operations ceph_file_iops;
 
 extern struct inode *ceph_alloc_inode(struct super_block *sb);
-extern void ceph_destroy_inode(struct inode *inode);
+extern void ceph_evict_inode(struct inode *inode);
 extern int ceph_drop_inode(struct inode *inode);
 
 extern struct inode *ceph_get_inode(struct super_block *sb,
-- 
2.20.1

