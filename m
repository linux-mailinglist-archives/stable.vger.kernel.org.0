Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACECA6FF4
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbfICQ1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbfICQ1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF14238C5;
        Tue,  3 Sep 2019 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528063;
        bh=K2zEh8HBO4tXSDQGVU8dQEtEWMQXYEZ9OIiPIbCR+Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHPLRYM/rzO/oTp06xz4RfAa7Bvye2PMHIjFf8aSHTqK4Ctn0VCVKsyjTklt1q68n
         6EuHIKZp37zrbTKWsQ7Hit2dNKRYfwPMyN0MlqfAiB67XuCilAXXkoSddiH5mwBdA0
         fsnxqnTP5YCM3KmIivIATLAUmfo5hWfYxk1VjBxM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Sasha Levin <sashal@kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 078/167] btrfs: scrub: move scrub_setup_ctx allocation out of device_list_mutex
Date:   Tue,  3 Sep 2019 12:23:50 -0400
Message-Id: <20190903162519.7136-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 0e94c4f45d14cf89d1f40c91b0a8517e791672a7 ]

The scrub context is allocated with GFP_KERNEL and called from
btrfs_scrub_dev under the fs_info::device_list_mutex. This is not safe
regarding reclaim that could try to flush filesystem data in order to
get the memory. And the device_list_mutex is held during superblock
commit, so this would cause a lockup.

Move the alocation and initialization before any changes that require
the mutex.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index efaad3e1b295a..56c4d2236484f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3837,13 +3837,18 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -EINVAL;
 	}
 
+	/* Allocate outside of device_list_mutex */
+	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
+	if (IS_ERR(sctx))
+		return PTR_ERR(sctx);
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free_ctx;
 	}
 
 	if (!is_dev_replace && !readonly &&
@@ -3851,7 +3856,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		btrfs_err_in_rcu(fs_info, "scrub: device %s is not writable",
 				rcu_str_deref(dev->name));
-		return -EROFS;
+		ret = -EROFS;
+		goto out_free_ctx;
 	}
 
 	mutex_lock(&fs_info->scrub_lock);
@@ -3859,7 +3865,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &dev->dev_state)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return -EIO;
+		ret = -EIO;
+		goto out_free_ctx;
 	}
 
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
@@ -3869,7 +3876,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return -EINPROGRESS;
+		ret = -EINPROGRESS;
+		goto out_free_ctx;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 
@@ -3877,16 +3885,9 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (ret) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return ret;
+		goto out_free_ctx;
 	}
 
-	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
-	if (IS_ERR(sctx)) {
-		mutex_unlock(&fs_info->scrub_lock);
-		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(fs_info);
-		return PTR_ERR(sctx);
-	}
 	sctx->readonly = readonly;
 	dev->scrub_ctx = sctx;
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -3939,6 +3940,11 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	scrub_put_ctx(sctx);
 
+	return ret;
+
+out_free_ctx:
+	scrub_free_ctx(sctx);
+
 	return ret;
 }
 
-- 
2.20.1

