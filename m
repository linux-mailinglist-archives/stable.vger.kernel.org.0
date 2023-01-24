Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F94679A5C
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbjAXNq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbjAXNpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:45:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8937247EDA;
        Tue, 24 Jan 2023 05:44:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BBC06117D;
        Tue, 24 Jan 2023 13:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CCCC433D2;
        Tue, 24 Jan 2023 13:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567801;
        bh=0K5stELeHERXjhv2dWvOORmeQAJeCAaHKpjVpiGwT5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIuS2f4Gca3PtmUqFwpF4doG445eV+8eQzUd8QpEIYz5yeOUusCUvVEXsWXNprg74
         LPVSe/R2t9p4Tx3irNOTl6Vr6e7WshV/LeGsAt8HlQ96vDhgyNUkQFlIY3uzVG6uZs
         0ZjQgxbldKRzYlqu6/q55+N9/86SkS+PVb9lVukHAW2GpCZwmtHQMWqPwivz0kB1WK
         nNOrVOzWVsFcaSFdR2oMaKJz5kUTB/rZOdl9E4kDPfni+l4Am0YDIfxo6UYOYxVOrs
         5RM07nr3k5IXz/wQATQ4Sr7TJonOy7Ta4hVDlyjz1gcz890LQBpBfHHvY4PH08r846
         hcNusaW7waFzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/14] btrfs: factor out scratching of one regular super block
Date:   Tue, 24 Jan 2023 08:42:52 -0500
Message-Id: <20230124134257.637523-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134257.637523-1-sashal@kernel.org>
References: <20230124134257.637523-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0e0078f72be81bbb2a02b229fd2cec8ad63e4fb1 ]

btrfs_scratch_superblocks open codes scratching super block of a
non-zoned super block.  Split the code to read, zero and write the
superblock for regular devices into a separate helper.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 51 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f01549b8c7c5..1f236604dffd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2060,42 +2060,43 @@ static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
 	return num_devices;
 }
 
+static void btrfs_scratch_superblock(struct btrfs_fs_info *fs_info,
+				     struct block_device *bdev, int copy_num)
+{
+	struct btrfs_super_block *disk_super;
+	struct page *page;
+	int ret;
+
+	disk_super = btrfs_read_dev_one_super(bdev, copy_num, false);
+	if (IS_ERR(disk_super))
+		return;
+
+	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
+	page = virt_to_page(disk_super);
+	set_page_dirty(page);
+	lock_page(page);
+	/* write_on_page() unlocks the page */
+	ret = write_one_page(page);
+	if (ret)
+		btrfs_warn(fs_info, "error clearing superblock number %d (%d)",
+			copy_num, ret);
+	btrfs_release_disk_super(disk_super);
+}
+
 void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
 			       struct block_device *bdev,
 			       const char *device_path)
 {
-	struct btrfs_super_block *disk_super;
 	int copy_num;
 
 	if (!bdev)
 		return;
 
 	for (copy_num = 0; copy_num < BTRFS_SUPER_MIRROR_MAX; copy_num++) {
-		struct page *page;
-		int ret;
-
-		disk_super = btrfs_read_dev_one_super(bdev, copy_num, false);
-		if (IS_ERR(disk_super))
-			continue;
-
-		if (bdev_is_zoned(bdev)) {
+		if (bdev_is_zoned(bdev))
 			btrfs_reset_sb_log_zones(bdev, copy_num);
-			continue;
-		}
-
-		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-
-		page = virt_to_page(disk_super);
-		set_page_dirty(page);
-		lock_page(page);
-		/* write_on_page() unlocks the page */
-		ret = write_one_page(page);
-		if (ret)
-			btrfs_warn(fs_info,
-				"error clearing superblock number %d (%d)",
-				copy_num, ret);
-		btrfs_release_disk_super(disk_super);
-
+		else
+			btrfs_scratch_superblock(fs_info, bdev, copy_num);
 	}
 
 	/* Notify udev that device has changed */
-- 
2.39.0

