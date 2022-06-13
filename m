Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D841548FD3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383900AbiFMOcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384851AbiFMOaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD4AA7753;
        Mon, 13 Jun 2022 04:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01057612AB;
        Mon, 13 Jun 2022 11:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1198AC34114;
        Mon, 13 Jun 2022 11:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120867;
        bh=ra5SKTL67sGRGZjPWkurUSjGUHswi1Ovj4X4M4AasQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvYR4zHoRUkVTzTjBWlhItYrdmmTL6wVPpxYXSVVgluYdCGQB5xAzAjNkaeal99l9
         Ku1lwyHv7aVeSbJYZwOIqg2VBZwSBZycd6oHNd1aLpgL9+BRUuEfn+Wp3S2fTSq1P+
         ZmiWgmvoF3ShJLQc/Zp2uz0xPiaYZSEOCXCS9HwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 186/298] net/mlx5: Fix mlx5_get_next_dev() peer device matching
Date:   Mon, 13 Jun 2022 12:11:20 +0200
Message-Id: <20220613094930.569466442@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 1c5de097bea31760c3f0467ac0c84ba0dc3525d5 ]

In some use-cases, mlx5 instances will need to search for their peer
device (the other port on the same HCA). For that, mlx5 device matching
mechanism relied on auxiliary_find_device() to search, and used a bad matching
callback function.

This approach has two issues:

1) next_phys_dev() the matching function, assumed all devices are
   of the type mlx5_adev (mlx5 auxiliary device) which is wrong and
   could lead to crashes, this worked for a while, since only lately
   other drivers started registering auxiliary devices.

2) using the auxiliary class bus (auxiliary_find_device) to search for
   mlx5_core_dev devices, who are actually PCIe device instances, is wrong.
   This works since mlx5_core always has at least one mlx5_adev instance
   hanging around in the aux bus.

As suggested by others we can fix 1. by comparing device names prefixes
if they have the string "mlx5_core" in them, which is not a best practice !
but even with that fixed, still 2. needs fixing, we are trying to
match pcie device peers so we should look in the right bus (pci bus),
hence this fix.

The fix:
1) search the pci bus for mlx5 peer devices, instead of the aux bus
2) to validated devices are the same type "mlx5_core_dev" compare if
   they have the same driver, which is bulletproof.

   This wouldn't have worked with the aux bus since the various mlx5 aux
   device types don't share the same driver, even if they share the same device
   wrapper struct (mlx5_adev) "which helped to find the parent device"

Fixes: a925b5e309c9 ("net/mlx5: Register mlx5 devices to auxiliary virtual bus")
Reported-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reported-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 34 +++++++++++++------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 3e750b827a19..c5d7bf662784 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -571,18 +571,32 @@ static int _next_phys_dev(struct mlx5_core_dev *mdev,
 	return 1;
 }
 
+static void *pci_get_other_drvdata(struct device *this, struct device *other)
+{
+	if (this->driver != other->driver)
+		return NULL;
+
+	return pci_get_drvdata(to_pci_dev(other));
+}
+
 static int next_phys_dev(struct device *dev, const void *data)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
+	struct mlx5_core_dev *mdev, *this = (struct mlx5_core_dev *)data;
+
+	mdev = pci_get_other_drvdata(this->device, dev);
+	if (!mdev)
+		return 0;
 
 	return _next_phys_dev(mdev, data);
 }
 
 static int next_phys_dev_lag(struct device *dev, const void *data)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
+	struct mlx5_core_dev *mdev, *this = (struct mlx5_core_dev *)data;
+
+	mdev = pci_get_other_drvdata(this->device, dev);
+	if (!mdev)
+		return 0;
 
 	if (!MLX5_CAP_GEN(mdev, vport_group_manager) ||
 	    !MLX5_CAP_GEN(mdev, lag_master) ||
@@ -595,19 +609,17 @@ static int next_phys_dev_lag(struct device *dev, const void *data)
 static struct mlx5_core_dev *mlx5_get_next_dev(struct mlx5_core_dev *dev,
 					       int (*match)(struct device *dev, const void *data))
 {
-	struct auxiliary_device *adev;
-	struct mlx5_adev *madev;
+	struct device *next;
 
 	if (!mlx5_core_is_pf(dev))
 		return NULL;
 
-	adev = auxiliary_find_device(NULL, dev, match);
-	if (!adev)
+	next = bus_find_device(&pci_bus_type, NULL, dev, match);
+	if (!next)
 		return NULL;
 
-	madev = container_of(adev, struct mlx5_adev, adev);
-	put_device(&adev->dev);
-	return madev->mdev;
+	put_device(next);
+	return pci_get_drvdata(to_pci_dev(next));
 }
 
 /* Must be called with intf_mutex held */
-- 
2.35.1



