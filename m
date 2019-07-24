Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DF373E97
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389754AbfGXTi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389628AbfGXTiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010D520665;
        Wed, 24 Jul 2019 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997102;
        bh=v/rpf5cge8jngp5FrMT21gEPO7smTExo8S0ty0E1sXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wd1zpGM+nFkiM/01ehVG4pDJZM8xuaPzznhdO/+p6uq7fIaZdBYaVxHVqA8TCl8GH
         MPo8bDdbGeNprPtNdB0TTdEP4D8j4tRyRvTrktkLl01Xf4Z02XA8DSkcLGCrOz5ZDB
         o3+KAR9/K9Cto0VHWhu8G74+o7A/0W2AlrAGzj/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.2 321/413] ceph: use ceph_evict_inode to cleanup inodes resource
Date:   Wed, 24 Jul 2019 21:20:12 +0200
Message-Id: <20190724191758.840133146@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan, Zheng <zyan@redhat.com>

commit 87bc5b895d94a0f40fe170d4cf5771c8e8f85d15 upstream.

remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
freeing inode to remove its caps. But VFS wakes freeing inode waiters
before calling destroy_inode().

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/40102
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/inode.c |    7 +++++--
 fs/ceph/super.c |    2 +-
 fs/ceph/super.h |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -523,13 +523,16 @@ void ceph_free_inode(struct inode *inode
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
 
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -840,10 +840,10 @@ static int ceph_remount(struct super_blo
 
 static const struct super_operations ceph_super_ops = {
 	.alloc_inode	= ceph_alloc_inode,
-	.destroy_inode	= ceph_destroy_inode,
 	.free_inode	= ceph_free_inode,
 	.write_inode    = ceph_write_inode,
 	.drop_inode	= ceph_drop_inode,
+	.evict_inode	= ceph_evict_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
 	.remount_fs	= ceph_remount,
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -876,7 +876,7 @@ static inline bool __ceph_have_pending_c
 extern const struct inode_operations ceph_file_iops;
 
 extern struct inode *ceph_alloc_inode(struct super_block *sb);
-extern void ceph_destroy_inode(struct inode *inode);
+extern void ceph_evict_inode(struct inode *inode);
 extern void ceph_free_inode(struct inode *inode);
 extern int ceph_drop_inode(struct inode *inode);
 


