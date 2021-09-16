Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8454C40E42A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244789AbhIPQz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244035AbhIPQxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D06C561A8C;
        Thu, 16 Sep 2021 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809780;
        bh=o2FipU2T4oBNLWJncdRN5X/QBl6xzwY3qSkx4eTQtaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFAMzldZlwS1IO37kzO/ehxN1LyRBro8Ai5teBtw8SyoSoBuHmHYXma90L4Gyoju+
         T50AQEHBZC9/U6Rr8Ez4ftQblE7bwrufNPtPaS1lQfriPdTw6ZG4Ha/WrTs9R81hhZ
         uGydWYMIfTzZkasevlavgwCePFbSo07GKBRLwyMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 249/380] drm: xlnx: zynqmp: release reset to DP controller before accessing DP registers
Date:   Thu, 16 Sep 2021 18:00:06 +0200
Message-Id: <20210916155812.551515062@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit a338619bd76011035d462f0f9e8b2f24d7fe5a1e ]

When insmod zynqmp-dpsub.ko after rmmod it, system will hang with the
error log as below:

root@xilinx-zynqmp:~# insmod zynqmp-dpsub.ko
[   88.391289] [drm] Initialized zynqmp-dpsub 1.0.0 20130509 for fd4a0000.display on minor 0
[   88.529906] Console: switching to colour frame buffer device 128x48
[   88.549402] zynqmp-dpsub fd4a0000.display: [drm] fb0: zynqmp-dpsubdrm frame buffer device
[   88.571624] zynqmp-dpsub fd4a0000.display: ZynqMP DisplayPort Subsystem driver probed
root@xilinx-zynqmp:~# rmmod zynqmp_dpsub
[   94.023404] Console: switching to colour dummy device 80x25
root@xilinx-zynqmp:~# insmod zynqmp-dpsub.ko
	<hang here>

This is because that in zynqmp_dp_probe it tries to access some DP
registers while the DP controller is still in the reset state. When
running "rmmod zynqmp_dpsub", zynqmp_dp_reset(dp, true) in
zynqmp_dp_phy_exit is called to force the DP controller into the reset
state. Then insmod will call zynqmp_dp_probe to program the DP registers,
but at this moment the DP controller hasn't been brought out of the reset
state yet since the function zynqmp_dp_reset(dp, false) is called later and
this will result the system hang.

Releasing the reset to DP controller before any read/write operation to it
will fix this issue. And for symmetry, move zynqmp_dp_reset() call from
zynqmp_dp_phy_exit() to zynqmp_dp_remove().

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dp.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dp.c b/drivers/gpu/drm/xlnx/zynqmp_dp.c
index 59d1fb017da0..13811332b349 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
@@ -402,10 +402,6 @@ static int zynqmp_dp_phy_init(struct zynqmp_dp *dp)
 		}
 	}
 
-	ret = zynqmp_dp_reset(dp, false);
-	if (ret < 0)
-		return ret;
-
 	zynqmp_dp_clr(dp, ZYNQMP_DP_PHY_RESET, ZYNQMP_DP_PHY_RESET_ALL_RESET);
 
 	/*
@@ -441,8 +437,6 @@ static void zynqmp_dp_phy_exit(struct zynqmp_dp *dp)
 				ret);
 	}
 
-	zynqmp_dp_reset(dp, true);
-
 	for (i = 0; i < dp->num_lanes; i++) {
 		ret = phy_exit(dp->phy[i]);
 		if (ret)
@@ -1682,9 +1676,13 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
 		return PTR_ERR(dp->reset);
 	}
 
+	ret = zynqmp_dp_reset(dp, false);
+	if (ret < 0)
+		return ret;
+
 	ret = zynqmp_dp_phy_probe(dp);
 	if (ret)
-		return ret;
+		goto err_reset;
 
 	/* Initialize the hardware. */
 	zynqmp_dp_write(dp, ZYNQMP_DP_TX_PHY_POWER_DOWN,
@@ -1696,7 +1694,7 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
 
 	ret = zynqmp_dp_phy_init(dp);
 	if (ret)
-		return ret;
+		goto err_reset;
 
 	zynqmp_dp_write(dp, ZYNQMP_DP_TRANSMITTER_ENABLE, 1);
 
@@ -1708,15 +1706,18 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
 					zynqmp_dp_irq_handler, IRQF_ONESHOT,
 					dev_name(dp->dev), dp);
 	if (ret < 0)
-		goto error;
+		goto err_phy_exit;
 
 	dev_dbg(dp->dev, "ZynqMP DisplayPort Tx probed with %u lanes\n",
 		dp->num_lanes);
 
 	return 0;
 
-error:
+err_phy_exit:
 	zynqmp_dp_phy_exit(dp);
+err_reset:
+	zynqmp_dp_reset(dp, true);
+
 	return ret;
 }
 
@@ -1734,4 +1735,5 @@ void zynqmp_dp_remove(struct zynqmp_dpsub *dpsub)
 	zynqmp_dp_write(dp, ZYNQMP_DP_INT_DS, 0xffffffff);
 
 	zynqmp_dp_phy_exit(dp);
+	zynqmp_dp_reset(dp, true);
 }
-- 
2.30.2



