Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30281676D08
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 13:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjAVMz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 07:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjAVMz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 07:55:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1402E1E2B0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 04:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C61460C07
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 12:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D587C4339B;
        Sun, 22 Jan 2023 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674392154;
        bh=iubP8wt7wOFKvykObPfDsgedT2GLn0OFTaH+ljSaMyo=;
        h=Subject:To:Cc:From:Date:From;
        b=cVe8e17LzmvZ46DRZjFHjehsQwuXRiuTsUESWn5Dq5Y6ujQ83M6aYnNGzLxbE3S34
         PMm//txfxVxMxALfaBR2cWSuB57MIK/4ZM9v2TgtSzHaEJqi35ZcE/CsrFgb9oknPY
         LIexlgHQihKGYLObFj9/xDuDDpTPLZLL2GmWz4L0=
Subject: FAILED: patch "[PATCH] btrfs: zoned: enable metadata over-commit for non-ZNS setup" failed to apply to 6.1-stable tree
To:     naohiro.aota@wdc.com, dsterba@suse.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 13:55:51 +0100
Message-ID: <167439215124657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

85e79ec7b78f ("btrfs: zoned: enable metadata over-commit for non-ZNS setup")
c52cc7b7acfb ("btrfs: add a BTRFS_FS_NEED_TRANS_COMMIT flag")
7966a6b5959b ("btrfs: move fs_info::flags enum to fs.h")
fc97a410bd78 ("btrfs: move mount option definitions to fs.h")
0d3a9cf8c306 ("btrfs: convert incompat and compat flag test helpers to macros")
ec8eb376e271 ("btrfs: move BTRFS_FS_STATE* definitions and helpers to fs.h")
9b569ea0be6f ("btrfs: move the printk helpers out of ctree.h")
e118578a8df7 ("btrfs: move assert helpers out of ctree.h")
c7f13d428ea1 ("btrfs: move fs wide helpers out of ctree.h")
63a7cb130718 ("btrfs: auto enable discard=async when possible")
f1e5c6185ca1 ("btrfs: move flush related definitions to space-info.h")
4300c58f8090 ("btrfs: move btrfs on-disk definitions out of ctree.h")
d60d956eb41f ("btrfs: remove unused set/clear_pending_info helpers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85e79ec7b78f863178ca488fd8cb5b3de6347756 Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Tue, 10 Jan 2023 15:04:32 +0900
Subject: [PATCH] btrfs: zoned: enable metadata over-commit for non-ZNS setup

The commit 79417d040f4f ("btrfs: zoned: disable metadata overcommit for
zoned") disabled the metadata over-commit to track active zones properly.

However, it also introduced a heavy overhead by allocating new metadata
block groups and/or flushing dirty buffers to release the space
reservations. Specifically, a workload (write only without any sync
operations) worsen its performance from 343.77 MB/sec (v5.19) to 182.89
MB/sec (v6.0).

The performance is still bad on current misc-next which is 187.95 MB/sec.
And, with this patch applied, it improves back to 326.70 MB/sec (+73.82%).

This patch introduces a new fs_info->flag BTRFS_FS_NO_OVERCOMMIT to
indicate it needs to disable the metadata over-commit. The flag is enabled
when a device with max active zones limit is loaded into a file-system.

Fixes: 79417d040f4f ("btrfs: zoned: disable metadata overcommit for zoned")
CC: stable@vger.kernel.org # 6.0+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a749367e5ae2..37b86acfcbcf 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -119,6 +119,12 @@ enum {
 	/* Indicate that we want to commit the transaction. */
 	BTRFS_FS_NEED_TRANS_COMMIT,
 
+	/*
+	 * Indicate metadata over-commit is disabled. This is set when active
+	 * zone tracking is needed.
+	 */
+	BTRFS_FS_NO_OVERCOMMIT,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d28ee4e36f3d..69c09508afb5 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -407,7 +407,8 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
-	if (btrfs_is_zoned(fs_info) && (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
+	if (test_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags) &&
+	    (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
 		avail = 0;
 	else
 		avail = calc_available_free_space(fs_info, space_info, flush);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a759668477bb..1f503e8e42d4 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -539,6 +539,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		}
 		atomic_set(&zone_info->active_zones_left,
 			   max_active_zones - nactive);
+		/* Overcommit does not work well with active zone tacking. */
+		set_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags);
 	}
 
 	/* Validate superblock log */

