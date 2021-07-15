Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB053CA7F0
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbhGOS5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241018AbhGOS4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 396A8613D1;
        Thu, 15 Jul 2021 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375230;
        bh=uTfMtEl8lNqdnF0HOgRYsgNEB8zxn1gq3kZz34x9N7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRrL9uAa1MaI7EVCkgC5nUHBZipo9AB77uNi5tITrHoBlGqOJbSpOAC0+h5DO9ybk
         78X3R3+BB6H/UcMVcvQkEWAL+jXX/ovIRcNZQC26KHm0l+49EmhHSLuRcFi3wc0s9S
         CXzjm4jyolLZichM9Wj99d3Ib4qL6A6wB9KOijUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9d90dad32dd9727ed084@syzkaller.appspotmail.com,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 215/215] f2fs: fix to avoid racing on fsync_entry_slab by multi filesystem instances
Date:   Thu, 15 Jul 2021 20:39:47 +0200
Message-Id: <20210715182637.438443933@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit cad83c968c2ebe97905f900326988ed37146c347 upstream.

As syzbot reported, there is an use-after-free issue during f2fs recovery:

Use-after-free write at 0xffff88823bc16040 (in kfence-#10):
 kmem_cache_destroy+0x1f/0x120 mm/slab_common.c:486
 f2fs_recover_fsync_data+0x75b0/0x8380 fs/f2fs/recovery.c:869
 f2fs_fill_super+0x9393/0xa420 fs/f2fs/super.c:3945
 mount_bdev+0x26c/0x3a0 fs/super.c:1367
 legacy_get_tree+0xea/0x180 fs/fs_context.c:592
 vfs_get_tree+0x86/0x270 fs/super.c:1497
 do_new_mount fs/namespace.c:2905 [inline]
 path_mount+0x196f/0x2be0 fs/namespace.c:3235
 do_mount fs/namespace.c:3248 [inline]
 __do_sys_mount fs/namespace.c:3456 [inline]
 __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3433
 do_syscall_64+0x3f/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The root cause is multi f2fs filesystem instances can race on accessing
global fsync_entry_slab pointer, result in use-after-free issue of slab
cache, fixes to init/destroy this slab cache only once during module
init/destroy procedure to avoid this issue.

Reported-by: syzbot+9d90dad32dd9727ed084@syzkaller.appspotmail.com
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h     |    2 ++
 fs/f2fs/recovery.c |   23 ++++++++++++++---------
 fs/f2fs/super.c    |    8 +++++++-
 3 files changed, 23 insertions(+), 10 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3462,6 +3462,8 @@ void f2fs_destroy_garbage_collection_cac
  */
 int f2fs_recover_fsync_data(struct f2fs_sb_info *sbi, bool check_only);
 bool f2fs_space_for_roll_forward(struct f2fs_sb_info *sbi);
+int __init f2fs_create_recovery_cache(void);
+void f2fs_destroy_recovery_cache(void);
 
 /*
  * debug.c
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -777,13 +777,6 @@ int f2fs_recover_fsync_data(struct f2fs_
 	quota_enabled = f2fs_enable_quota_files(sbi, s_flags & SB_RDONLY);
 #endif
 
-	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
-			sizeof(struct fsync_inode_entry));
-	if (!fsync_entry_slab) {
-		err = -ENOMEM;
-		goto out;
-	}
-
 	INIT_LIST_HEAD(&inode_list);
 	INIT_LIST_HEAD(&tmp_inode_list);
 	INIT_LIST_HEAD(&dir_list);
@@ -856,8 +849,6 @@ skip:
 		}
 	}
 
-	kmem_cache_destroy(fsync_entry_slab);
-out:
 #ifdef CONFIG_QUOTA
 	/* Turn quotas off */
 	if (quota_enabled)
@@ -867,3 +858,17 @@ out:
 
 	return ret ? ret: err;
 }
+
+int __init f2fs_create_recovery_cache(void)
+{
+	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
+					sizeof(struct fsync_inode_entry));
+	if (!fsync_entry_slab)
+		return -ENOMEM;
+	return 0;
+}
+
+void f2fs_destroy_recovery_cache(void)
+{
+	kmem_cache_destroy(fsync_entry_slab);
+}
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4027,9 +4027,12 @@ static int __init init_f2fs_fs(void)
 	err = f2fs_create_checkpoint_caches();
 	if (err)
 		goto free_segment_manager_caches;
-	err = f2fs_create_extent_cache();
+	err = f2fs_create_recovery_cache();
 	if (err)
 		goto free_checkpoint_caches;
+	err = f2fs_create_extent_cache();
+	if (err)
+		goto free_recovery_cache;
 	err = f2fs_create_garbage_collection_cache();
 	if (err)
 		goto free_extent_cache;
@@ -4078,6 +4081,8 @@ free_garbage_collection_cache:
 	f2fs_destroy_garbage_collection_cache();
 free_extent_cache:
 	f2fs_destroy_extent_cache();
+free_recovery_cache:
+	f2fs_destroy_recovery_cache();
 free_checkpoint_caches:
 	f2fs_destroy_checkpoint_caches();
 free_segment_manager_caches:
@@ -4103,6 +4108,7 @@ static void __exit exit_f2fs_fs(void)
 	f2fs_exit_sysfs();
 	f2fs_destroy_garbage_collection_cache();
 	f2fs_destroy_extent_cache();
+	f2fs_destroy_recovery_cache();
 	f2fs_destroy_checkpoint_caches();
 	f2fs_destroy_segment_manager_caches();
 	f2fs_destroy_node_manager_caches();


