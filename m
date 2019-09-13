Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC16FB2100
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391140AbfIMNbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388745AbfIMNPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:25 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F5A208C2;
        Fri, 13 Sep 2019 13:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380525;
        bh=QuVe6d5LdFxeyz/vanqYXnbMCvw8HZFJkhzvjfWyPao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDj+Axa9+WD6K+VNkp3wBb75mscCKNiiwR9+8EFhixgfplmCtnkTcaPJZlb+bYaxN
         TT8dwVXqfmGJFWauKKGeI74pNrMDHWOMMgyapgtiIYwkmFqAQ9DUpPx+oZ0JInoHe1
         pSMC/wo0gKTbc5BA0PgZjNvDV1KdMR4Bk7UOQSok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/190] btrfs: Use real device structure to verify dev extent
Date:   Fri, 13 Sep 2019 14:05:29 +0100
Message-Id: <20190913130605.491752937@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



