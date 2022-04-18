Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E514B505170
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239186AbiDRMer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbiDRMc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:32:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C4112755;
        Mon, 18 Apr 2022 05:24:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59DA6B80ED7;
        Mon, 18 Apr 2022 12:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E19EC385A1;
        Mon, 18 Apr 2022 12:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284671;
        bh=NXGaI5IJ/qzbG2ytbzRFB2c1VafrslVJuy6Y/WpT9eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLLWDMHg06BvG8Fy4Cf5OqEu7rK45wHl9U/ZKo89ivVR2lU1qKP0hwBFQ3+o2UZ6B
         TK14b5TLEKILIEbigHBWFMpOZuGBAwCehMCamh7gvSQLNn//mRTJrMbcC5HszflSuO
         3ADd7yMn9dgjKU9OsflJOHWdwqf3PdgdMMKav4i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 191/219] btrfs: zoned: activate block group only for extent allocation
Date:   Mon, 18 Apr 2022 14:12:40 +0200
Message-Id: <20220418121212.221607002@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 760e69c4c2e2f475a812bdd414b62758215ce9cb upstream.

In btrfs_make_block_group(), we activate the allocated block group,
expecting that the block group is soon used for allocation. However, the
chunk allocation from flush_space() context broke the assumption. There
can be a large time gap between the chunk allocation time and the extent
allocation time from the chunk.

Activating the empty block groups pre-allocated from flush_space()
context can exhaust the active zone counter of a device. Once we use all
the active zone counts for empty pre-allocated block groups, we cannot
activate new block group for the other things: metadata, tree-log, or
data relocation block group.  That failure results in a fake -ENOSPC.

This patch introduces CHUNK_ALLOC_FORCE_FOR_EXTENT to distinguish the
chunk allocation from find_free_extent(). Now, the new block group is
activated only in that context.

Fixes: eb66a010d518 ("btrfs: zoned: activate new block group")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   24 ++++++++++++++++--------
 fs/btrfs/block-group.h |    4 ++++
 fs/btrfs/extent-tree.c |    2 +-
 3 files changed, 21 insertions(+), 9 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2479,12 +2479,6 @@ struct btrfs_block_group *btrfs_make_blo
 		return ERR_PTR(ret);
 	}
 
-	/*
-	 * New block group is likely to be used soon. Try to activate it now.
-	 * Failure is OK for now.
-	 */
-	btrfs_zone_activate(cache);
-
 	ret = exclude_super_stripes(cache);
 	if (ret) {
 		/* We may have excluded something, so call this just in case */
@@ -3636,8 +3630,14 @@ int btrfs_chunk_alloc(struct btrfs_trans
 	struct btrfs_block_group *ret_bg;
 	bool wait_for_alloc = false;
 	bool should_alloc = false;
+	bool from_extent_allocation = false;
 	int ret = 0;
 
+	if (force == CHUNK_ALLOC_FORCE_FOR_EXTENT) {
+		from_extent_allocation = true;
+		force = CHUNK_ALLOC_FORCE;
+	}
+
 	/* Don't re-enter if we're already allocating a chunk */
 	if (trans->allocating_chunk)
 		return -ENOSPC;
@@ -3730,9 +3730,17 @@ int btrfs_chunk_alloc(struct btrfs_trans
 	ret_bg = do_chunk_alloc(trans, flags);
 	trans->allocating_chunk = false;
 
-	if (IS_ERR(ret_bg))
+	if (IS_ERR(ret_bg)) {
 		ret = PTR_ERR(ret_bg);
-	else
+	} else if (from_extent_allocation) {
+		/*
+		 * New block group is likely to be used soon. Try to activate
+		 * it now. Failure is OK for now.
+		 */
+		btrfs_zone_activate(ret_bg);
+	}
+
+	if (!ret)
 		btrfs_put_block_group(ret_bg);
 
 	spin_lock(&space_info->lock);
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -35,11 +35,15 @@ enum btrfs_discard_state {
  * the FS with empty chunks
  *
  * CHUNK_ALLOC_FORCE means it must try to allocate one
+ *
+ * CHUNK_ALLOC_FORCE_FOR_EXTENT like CHUNK_ALLOC_FORCE but called from
+ * find_free_extent() that also activaes the zone
  */
 enum btrfs_chunk_alloc_enum {
 	CHUNK_ALLOC_NO_FORCE,
 	CHUNK_ALLOC_LIMITED,
 	CHUNK_ALLOC_FORCE,
+	CHUNK_ALLOC_FORCE_FOR_EXTENT,
 };
 
 struct btrfs_caching_control {
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4087,7 +4087,7 @@ static int find_free_extent_update_loop(
 			}
 
 			ret = btrfs_chunk_alloc(trans, ffe_ctl->flags,
-						CHUNK_ALLOC_FORCE);
+						CHUNK_ALLOC_FORCE_FOR_EXTENT);
 
 			/* Do not bail out on ENOSPC since we can do more. */
 			if (ret == -ENOSPC)


