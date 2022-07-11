Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527DD56FD29
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiGKJvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiGKJuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABE3248D4;
        Mon, 11 Jul 2022 02:24:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49F87B80D2C;
        Mon, 11 Jul 2022 09:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E95C34115;
        Mon, 11 Jul 2022 09:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531494;
        bh=Z0FI6AxhInGWtJD1LczNEjiGeOd7WuiQcvBy+zjdl9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIQ5t1pGMBbpx/YLAiWMKTn+cag93ru9wVxZIPYBdcjoti/0n2G4NpYbulbsac1AX
         hybHJJWzu6agpr/NcoAkSanb9X3LOrKxu6CZIiZBhgG4VeWeaqUiQK8jD4GVK72Ux2
         UiPg+IyhYNtzteS68XXqvWaUmfSseRVHUZBrNhPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/230] btrfs: zoned: encapsulate inode locking for zoned relocation
Date:   Mon, 11 Jul 2022 11:06:20 +0200
Message-Id: <20220711090607.582974972@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 869f4cdc73f9378986755030c684c011f0b71517 ]

Encapsulate the inode lock needed for serializing the data relocation
writes on a zoned filesystem into a helper.

This streamlines the code reading flow and hides special casing for
zoned filesystems.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c |  8 ++------
 fs/btrfs/zoned.h     | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6dd375ed6e3d..059bd0753e27 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5139,8 +5139,6 @@ int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	const bool data_reloc = btrfs_is_data_reloc_root(BTRFS_I(inode)->root);
-	const bool zoned = btrfs_is_zoned(BTRFS_I(inode)->root->fs_info);
 	int ret = 0;
 	struct extent_page_data epd = {
 		.bio_ctrl = { 0 },
@@ -5152,11 +5150,9 @@ int extent_writepages(struct address_space *mapping,
 	 * Allow only a single thread to do the reloc work in zoned mode to
 	 * protect the write pointer updates.
 	 */
-	if (data_reloc && zoned)
-		btrfs_inode_lock(inode, 0);
+	btrfs_zoned_data_reloc_lock(BTRFS_I(inode));
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	if (data_reloc && zoned)
-		btrfs_inode_unlock(inode, 0);
+	btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 	ASSERT(ret <= 0);
 	if (ret < 0) {
 		end_write_bio(&epd, ret);
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 813aa3cddc11..d680c3ee918a 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -8,6 +8,7 @@
 #include "volumes.h"
 #include "disk-io.h"
 #include "block-group.h"
+#include "btrfs_inode.h"
 
 /*
  * Block groups with more than this value (percents) of unusable space will be
@@ -324,4 +325,20 @@ static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->treelog_bg_lock);
 }
 
+static inline void btrfs_zoned_data_reloc_lock(struct btrfs_inode *inode)
+{
+	struct btrfs_root *root = inode->root;
+
+	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
+		btrfs_inode_lock(&inode->vfs_inode, 0);
+}
+
+static inline void btrfs_zoned_data_reloc_unlock(struct btrfs_inode *inode)
+{
+	struct btrfs_root *root = inode->root;
+
+	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
+		btrfs_inode_unlock(&inode->vfs_inode, 0);
+}
+
 #endif
-- 
2.35.1



