Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF1EB2037
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389678AbfIMNS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390209AbfIMNS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:27 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1882214D8;
        Fri, 13 Sep 2019 13:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380706;
        bh=XQ4AzhUxeDXOpARPpUKyidIwWVKS3TPFELNFLgstuSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8mERr8FNo0X+4cPQMoXAtLKD1mWdb/q/3GjScBJTj0DmmlzD/YTafbng1SKxQpTf
         IvchUdEC+VHNPCNJ67K2J3GMp4N0NLshEeR6NgVorTdZgHkHJ4gvv2CC1tLk0M4fTz
         XZZxY08YUapfJCl8si0Bx110DZRjZcW9sAqHnSnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/190] ceph: use ceph_evict_inode to cleanup inodes resource
Date:   Fri, 13 Sep 2019 14:06:46 +0100
Message-Id: <20190913130611.980843306@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 11f19432a74c4..665a86f83f4b0 100644
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
index 0180193097905..6e968e48e5e4b 100644
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



