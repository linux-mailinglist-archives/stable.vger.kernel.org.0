Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4866799DF
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbjAXNmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbjAXNmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:42:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E8945F68;
        Tue, 24 Jan 2023 05:42:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02B63611E6;
        Tue, 24 Jan 2023 13:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39AFC433A7;
        Tue, 24 Jan 2023 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567725;
        bh=tinwDjVXJonAf/XEW4QsF0at+vcDfimwkCBKXz9sxCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCdqN13bzTuTWv7QbT2pBLUBDPXQazBM3Oc//Sy8Yrh2FspL0WwMsEBzSsyRThrCH
         3LMGwN6Fa74cY8GWimEIbAwDgPe1s0bqQfQ1l6S3pFN7l3Yx9MNDxhI8qxtBA2JTwb
         rMS3wl6VmBl8oPjWEd8hEioDWk5PEnEXHvm7e9+rOhZMXVLemlAQwlpX72bd8tcSN1
         2YKjMIZfxYPCIQb5kiyqHNZZbW3tGa+QhI427+dzC4bl47/zGz+ylW/hmxUCGdEseU
         8L2DeePB4NLQ4McDy8HmmJls0m5r4fTzNOnEAskQTV3IDasFdtHD63SQWmjEHL1gMF
         rq++ElMs5GWmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 15/35] btrfs: stop using write_one_page in btrfs_scratch_superblock
Date:   Tue, 24 Jan 2023 08:41:11 -0500
Message-Id: <20230124134131.637036-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
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

[ Upstream commit 26ecf243e407be54807ad67210f7e83b9fad71ea ]

write_one_page is an awkward interface that expects the page locked and
->writepage to be implemented.  Replace that by zeroing the signature
bytes and synchronize the block device page using the proper bdev
helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8fd14dc7f667..36bb664a25a2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2021,23 +2021,22 @@ static void btrfs_scratch_superblock(struct btrfs_fs_info *fs_info,
 				     struct block_device *bdev, int copy_num)
 {
 	struct btrfs_super_block *disk_super;
-	struct page *page;
+	const size_t len = sizeof(disk_super->magic);
+	const u64 bytenr = btrfs_sb_offset(copy_num);
 	int ret;
 
-	disk_super = btrfs_read_dev_one_super(bdev, copy_num, false);
+	disk_super = btrfs_read_disk_super(bdev, bytenr, bytenr);
 	if (IS_ERR(disk_super))
 		return;
 
-	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-	page = virt_to_page(disk_super);
-	set_page_dirty(page);
-	lock_page(page);
-	/* write_on_page() unlocks the page */
-	ret = write_one_page(page);
+	memset(&disk_super->magic, 0, len);
+	folio_mark_dirty(virt_to_folio(disk_super));
+	btrfs_release_disk_super(disk_super);
+
+	ret = sync_blockdev_range(bdev, bytenr, bytenr + len - 1);
 	if (ret)
 		btrfs_warn(fs_info, "error clearing superblock number %d (%d)",
 			copy_num, ret);
-	btrfs_release_disk_super(disk_super);
 }
 
 void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
-- 
2.39.0

