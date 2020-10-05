Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47043283848
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgJEOp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbgJEOpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F9FE208C7;
        Mon,  5 Oct 2020 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909108;
        bh=8NIQKJHMWAIowBIsAYsg9ItWVmXVGCyQSOObiLVuX3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3yqktsTKhlT6Qo9LbLzliQJhTDHlN8QZEACj9IABgHkGr61cPrNTAzo6CCBewZpU
         D/V4TdLBtki8HGA3DrhnNSZxIpyqjiboX0rVuomy8NC49lrMSqlyGI5BEbMi4KQmZR
         xxHsuyf1BI0cI6+7IDdJvoyGRR3vZIX8XeIxf8hQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 06/12] btrfs: move btrfs_scratch_superblocks into btrfs_dev_replace_finishing
Date:   Mon,  5 Oct 2020 10:44:54 -0400
Message-Id: <20201005144501.2527477-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144501.2527477-1-sashal@kernel.org>
References: <20201005144501.2527477-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 313b085851c13ca08320372a05a7047ea25d3dd4 ]

We need to move the closing of the src_device out of all the device
replace locking, but we definitely want to zero out the superblock
before we commit the last time to make sure the device is properly
removed.  Handle this by pushing btrfs_scratch_superblocks into
btrfs_dev_replace_finishing, and then later on we'll move the src_device
closing and freeing stuff where we need it to be.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dev-replace.c |  3 +++
 fs/btrfs/volumes.c     | 12 +++---------
 fs/btrfs/volumes.h     |  3 +++
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index db93909b25e08..7cf48aeb6f14e 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -745,6 +745,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* replace the sysfs entry */
 	btrfs_sysfs_remove_devices_dir(fs_info->fs_devices, src_device);
 	btrfs_sysfs_update_devid(tgt_device);
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &src_device->dev_state))
+		btrfs_scratch_superblocks(fs_info, src_device->bdev,
+					  src_device->name->str);
 	btrfs_rm_dev_replace_free_srcdev(src_device);
 
 	/* write back the superblocks */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 956eb0d6bc584..8b5f666a3ea66 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1999,9 +1999,9 @@ static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
 	return num_devices;
 }
 
-static void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
-				      struct block_device *bdev,
-				      const char *device_path)
+void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
+			       struct block_device *bdev,
+			       const char *device_path)
 {
 	struct btrfs_super_block *disk_super;
 	int copy_num;
@@ -2224,12 +2224,6 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_device *srcdev)
 	struct btrfs_fs_info *fs_info = srcdev->fs_info;
 	struct btrfs_fs_devices *fs_devices = srcdev->fs_devices;
 
-	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state)) {
-		/* zero out the old super if it is writable */
-		btrfs_scratch_superblocks(fs_info, srcdev->bdev,
-					  srcdev->name->str);
-	}
-
 	btrfs_close_bdev(srcdev);
 	synchronize_rcu();
 	btrfs_free_device(srcdev);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 75af2334b2e37..83862e27f5663 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -573,6 +573,9 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 					struct btrfs_device *failing_dev);
+void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
+			       struct block_device *bdev,
+			       const char *device_path);
 
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
-- 
2.25.1

