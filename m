Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C798BA702D
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbfICQhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730681AbfICQ0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1C95238CD;
        Tue,  3 Sep 2019 16:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527999;
        bh=CtmaAsWwoZNRqt4zv2q01+SAMp6zV/HtcJVWUSCftAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ic2JiOQPcqIEQEZ0YjDuEQUMveZhrfqz6n9swfKlx4pCr76LmWUVAPcvzFWmezygT
         0EKoBEU5HBRo3PVh0TN4Em6gcYoZAqyQxiMVYuJR+HuNR1TPAt/iKabTt82qAFedtI
         R2wOadfLF+tsvOfgKB4Nh4cyLUqMkyNuqQYHOo8E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 047/167] btrfs: Use real device structure to verify dev extent
Date:   Tue,  3 Sep 2019 12:23:19 -0400
Message-Id: <20190903162519.7136-47-sashal@kernel.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 1b3922a8bc74231f9a767d1be6d9a061a4d4eeab ]

[BUG]
Linux v5.0-rc1 will fail fstests/btrfs/163 with the following kernel
message:

  BTRFS error (device dm-6): dev extent devid 1 physical offset 13631488 len 8388608 is beyond device boundary 0
  BTRFS error (device dm-6): failed to verify dev extents against chunks: -117
  BTRFS error (device dm-6): open_ctree failed

[CAUSE]
Commit cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent
mapping check") introduced strict check on dev extents.

We use btrfs_find_device() with dev uuid and fs uuid set to NULL, and
only dependent on @devid to find the real device.

For seed devices, we call clone_fs_devices() in open_seed_devices() to
allow us search seed devices directly.

However clone_fs_devices() just populates devices with devid and dev
uuid, without populating other essential members, like disk_total_bytes.

This makes any device returned by btrfs_find_device(fs_info, devid,
NULL, NULL) is just a dummy, with 0 disk_total_bytes, and any dev
extents on the seed device will not pass the device boundary check.

[FIX]
This patch will try to verify the device returned by btrfs_find_device()
and if it's a dummy then re-search in seed devices.

Fixes: cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent mapping check")
CC: stable@vger.kernel.org # 4.19+
Reported-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c20708bfae561..a8297e7489d98 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7469,6 +7469,18 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 		ret = -EUCLEAN;
 		goto out;
 	}
+
+	/* It's possible this device is a dummy for seed device */
+	if (dev->disk_total_bytes == 0) {
+		dev = find_device(fs_info->fs_devices->seed, devid, NULL);
+		if (!dev) {
+			btrfs_err(fs_info, "failed to find seed devid %llu",
+				  devid);
+			ret = -EUCLEAN;
+			goto out;
+		}
+	}
+
 	if (physical_offset + physical_len > dev->disk_total_bytes) {
 		btrfs_err(fs_info,
 "dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
-- 
2.20.1

