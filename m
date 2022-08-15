Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8E8594C6B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244116AbiHPA7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiHPA4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:56:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D619719DAA1;
        Mon, 15 Aug 2022 13:48:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B5761255;
        Mon, 15 Aug 2022 20:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15417C433D6;
        Mon, 15 Aug 2022 20:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596487;
        bh=YWq48jiqHPOFwg9n/lD9ndH4dNZqvChrfb3NlpZVGXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQP8uVRnS5b1rVLIRswzp7vaFRxMK4uDfO+W3rzpjN/bUSsSmms7OXI6PKGuRENfn
         C+yn8omuhLWHIm6OFMU5tPBG2R9Sbw2ip6MVmbi7zBgb7Xk0LVbtWP+amQ+IrXs5GF
         UCHzPdTbZexfhsVAdx818BsgV3YZKT+enMhs+EjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1096/1157] btrfs: zoned: wait until zone is finished when allocation didnt progress
Date:   Mon, 15 Aug 2022 20:07:32 +0200
Message-Id: <20220815180524.083026615@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index d306db5dbdc2..3a51d0c13a95 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -627,6 +627,9 @@ enum {
 	/* Indicate we have half completed snapshot deletions pending. */
 	BTRFS_FS_UNFINISHED_DROPS,
 
+	/* Indicate we have to finish a zone to do next allocation. */
+	BTRFS_FS_NEED_ZONE_FINISH,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
@@ -1063,6 +1066,8 @@ struct btrfs_fs_info {
 
 	spinlock_t zone_active_bgs_lock;
 	struct list_head zone_active_bgs;
+	/* Waiters when BTRFS_FS_NEED_ZONE_FINISH is set */
+	wait_queue_head_t zone_finish_wait;
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 804dcc69787d..bc3030661583 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3255,6 +3255,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
 	init_waitqueue_head(&fs_info->delayed_iputs_wait);
+	init_waitqueue_head(&fs_info->zone_finish_wait);
 
 	/* Usable values until the real ones are cached from the superblock */
 	fs_info->nodesize = 4096;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4f5249f5cb34..61496ecb1e20 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1642,8 +1642,13 @@ static noinline int run_delalloc_zoned(struct btrfs_inode *inode,
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
index 4df5b36dc574..31cb11daa8e8 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2007,6 +2007,9 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	/* For active_bg_list */
 	btrfs_put_block_group(block_group);
 
+	clear_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
+	wake_up_all(&fs_info->zone_finish_wait);
+
 	return 0;
 }
 
@@ -2043,6 +2046,9 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
 
+	if (!ret)
+		set_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
+
 	return ret;
 }
 
-- 
2.35.1



