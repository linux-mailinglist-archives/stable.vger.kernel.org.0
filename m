Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C9BCA444
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390454AbfJCQXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389691AbfJCQXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3627222CB;
        Thu,  3 Oct 2019 16:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119791;
        bh=5cRDAKA5t7/TTzGgUnfSvSOrJ2+GOJhdYTJFcryfpfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJ/Z28xgkGsAP/ox7Zr4PLCAhFIallqoyNFxsLp9IHfb+Cp03Uo5ejgfN6YVju9RO
         gSyOScm4dxu/lsTj2LqqiercDy/cOdvBYHouFutmg1gbfI/8UKTsbcll+xIn7OOFxT
         0V1FygQVogvPKqJXOVyAZPjkW/KOMSoQV0W1K8x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/211] Revert "ceph: use ceph_evict_inode to cleanup inodes resource"
Date:   Thu,  3 Oct 2019 17:53:43 +0200
Message-Id: <20191003154523.940350966@linuxfoundation.org>
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

This reverts commit 812810399999a673d30f9d04d38659030a28051a.

The backport was incorrect and was causing kernel panics. Revert and
re-apply a correct backport from Jeff Layton.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 7 ++-----
 fs/ceph/super.c | 2 +-
 fs/ceph/super.h | 2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 665a86f83f4b0..11f19432a74c4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -528,16 +528,13 @@ static void ceph_i_callback(struct rcu_head *head)
 	kmem_cache_free(ceph_inode_cachep, ci);
 }
 
-void ceph_evict_inode(struct inode *inode)
+void ceph_destroy_inode(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_inode_frag *frag;
 	struct rb_node *n;
 
-	dout("evict_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
-
-	truncate_inode_pages_final(&inode->i_data);
-	clear_inode(inode);
+	dout("destroy_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
 
 	ceph_fscache_unregister_inode_cookie(ci);
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 02528e11bf331..c5cf46e43f2e7 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -827,9 +827,9 @@ static int ceph_remount(struct super_block *sb, int *flags, char *data)
 
 static const struct super_operations ceph_super_ops = {
 	.alloc_inode	= ceph_alloc_inode,
+	.destroy_inode	= ceph_destroy_inode,
 	.write_inode    = ceph_write_inode,
 	.drop_inode	= ceph_drop_inode,
-	.evict_inode	= ceph_evict_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
 	.remount_fs	= ceph_remount,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6e968e48e5e4b..0180193097905 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -854,7 +854,7 @@ static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
 extern const struct inode_operations ceph_file_iops;
 
 extern struct inode *ceph_alloc_inode(struct super_block *sb);
-extern void ceph_evict_inode(struct inode *inode);
+extern void ceph_destroy_inode(struct inode *inode);
 extern int ceph_drop_inode(struct inode *inode);
 
 extern struct inode *ceph_get_inode(struct super_block *sb,
-- 
2.20.1



