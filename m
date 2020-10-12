Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC6A28B7F6
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731802AbgJLNsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389760AbgJLNpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B8F22314;
        Mon, 12 Oct 2020 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510317;
        bh=64iZkH//6Etu50zL4X6LwKEv6EOLBImp+ePf3S0fXxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puqk6HCxgXcFp4NVb92ytEomK7R1OUB94VbP2lebezLkYTyGzkeXoKgjgAmERbvuw
         oM+41TsZ//FmU5+6IuOaZJFe0DZl88K4v6NPPphdPCub5lsebNkGCj2XWQZNega6XO
         e+FUJzAgzx0G/WZbEfQvEHyM4JbeDcQ9SsFx7dBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 046/124] btrfs: move btrfs_scratch_superblocks into btrfs_dev_replace_finishing
Date:   Mon, 12 Oct 2020 15:30:50 +0200
Message-Id: <20201012133149.083904543@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index eb86e4b88c73a..26c9da82e6a91 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -783,6 +783,9 @@ error:
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



