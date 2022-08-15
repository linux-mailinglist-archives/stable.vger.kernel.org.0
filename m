Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63745949CA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243496AbiHOXZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243449AbiHOXXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:23:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D429760E1;
        Mon, 15 Aug 2022 13:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4E2160A09;
        Mon, 15 Aug 2022 20:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2606C433D6;
        Mon, 15 Aug 2022 20:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593935;
        bh=bTsCd9Icqv/0YCZZqzLOPav4xkPiWJdkMSgwWN2iyyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxknUGqeKsRZAV8kJenlW21RgFJ0uOXLZJ/THC+RCCg0f3aF79d6dIZrDQQWM488U
         jTTClOw05Cf0csdWBVEZ0PMuVlxsbvHJ/LbrNJHIAcqfWEn+/scyjE70yJw27Ppp4X
         GGdnJn4MgN3aTS9Bg2R1sRvN9hlK3uQ/StqCMfeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1031/1095] btrfs: zoned: wait until zone is finished when allocation didnt progress
Date:   Mon, 15 Aug 2022 20:07:10 +0200
Message-Id: <20220815180511.711054007@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 2ce543f478433a0eec0f72090d7e814f1d53d456 ]

When the allocated position doesn't progress, we cannot submit IOs to
finish a block group, but there should be ongoing IOs that will finish a
block group. So, in that case, we wait for a zone to be finished and retry
the allocation after that.

Introduce a new flag BTRFS_FS_NEED_ZONE_FINISH for fs_info->flags to
indicate we need a zone finish to have proceeded. The flag is set when the
allocator detected it cannot activate a new block group. And, it is cleared
once a zone is finished.

CC: stable@vger.kernel.org # 5.16+
Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h   | 5 +++++
 fs/btrfs/disk-io.c | 1 +
 fs/btrfs/inode.c   | 9 +++++++--
 fs/btrfs/zoned.c   | 6 ++++++
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 97f5a3d320ff..76fbe4cf2a28 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -635,6 +635,9 @@ enum {
 	/* Indicate we have half completed snapshot deletions pending. */
 	BTRFS_FS_UNFINISHED_DROPS,
 
+	/* Indicate we have to finish a zone to do next allocation. */
+	BTRFS_FS_NEED_ZONE_FINISH,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
@@ -1074,6 +1077,8 @@ struct btrfs_fs_info {
 
 	spinlock_t zone_active_bgs_lock;
 	struct list_head zone_active_bgs;
+	/* Waiters when BTRFS_FS_NEED_ZONE_FINISH is set */
+	wait_queue_head_t zone_finish_wait;
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bf5c6ac67e87..59fa7bf3a2e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3239,6 +3239,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
 	init_waitqueue_head(&fs_info->delayed_iputs_wait);
+	init_waitqueue_head(&fs_info->zone_finish_wait);
 
 	/* Usable values until the real ones are cached from the superblock */
 	fs_info->nodesize = 4096;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9753fc47e488..64d310ecbb84 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1606,8 +1606,13 @@ static noinline int run_delalloc_zoned(struct btrfs_inode *inode,
 		if (ret == 0)
 			done_offset = end;
 
-		if (done_offset == start)
-			return -ENOSPC;
+		if (done_offset == start) {
+			struct btrfs_fs_info *info = inode->root->fs_info;
+
+			wait_var_event(&info->zone_finish_wait,
+				       !test_bit(BTRFS_FS_NEED_ZONE_FINISH, &info->flags));
+			continue;
+		}
 
 		if (!locked_page_done) {
 			__set_page_dirty_nobuffers(locked_page);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0c2d81b0e3d3..45e29b8c705c 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1993,6 +1993,9 @@ int btrfs_zone_finish(struct btrfs_block_group *block_group)
 	/* For active_bg_list */
 	btrfs_put_block_group(block_group);
 
+	clear_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
+	wake_up_all(&fs_info->zone_finish_wait);
+
 	return 0;
 }
 
@@ -2021,6 +2024,9 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
 
+	if (!ret)
+		set_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
+
 	return ret;
 }
 
-- 
2.35.1



