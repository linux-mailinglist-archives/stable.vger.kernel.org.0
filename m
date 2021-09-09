Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852EC404B7B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242587AbhIILwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240970AbhIILui (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66EA461371;
        Thu,  9 Sep 2021 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187835;
        bh=2sRrcNpAGMXmMfOA1BtLM/J3RPUbKMf8FSHXBSmuVIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GL/Q09awj3CCpRMjnx1E/1iDDelc58Gm17mRprhqHO4/LDFGl+FVGKGkZriON08Zm
         FIJz4dTynDh0tBB4GGwcMWXdc03j6KB1+BlAN4XhMwTjwiAjnFHUskXfUb7pgJiPR0
         ornbrvU9WhxgAmJBrRhwZ+PKnbzaU6274SJ4AQ1tJzPlmHe5FOQzaTYNLBcdafflk+
         o9ifvi6HfNhy1ES6ANolfT6EmnXxfnaL6JuTI0No+yk8Pzgj1EDExzj5I/MzofvN12
         t4/Ji+8bJ+y6s8mSjCEJXc/m1WTAjXhQAFuGRFz7QUrJVia0edHJgy52f+ogK7wloS
         hQp/hrAMEfzug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quanyang Wang <quanyang.wang@windriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 130/252] drm: xlnx: zynqmp: release reset to DP controller before accessing DP registers
Date:   Thu,  9 Sep 2021 07:39:04 -0400
Message-Id: <20210909114106.141462-130-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 82430ca9b913..6f588dc09ba6 100644
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
@@ -1683,9 +1677,13 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
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
@@ -1697,7 +1695,7 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
 
 	ret = zynqmp_dp_phy_init(dp);
 	if (ret)
-		return ret;
+		goto err_reset;
 
 	zynqmp_dp_write(dp, ZYNQMP_DP_TRANSMITTER_ENABLE, 1);
 
@@ -1709,15 +1707,18 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
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
 
@@ -1735,4 +1736,5 @@ void zynqmp_dp_remove(struct zynqmp_dpsub *dpsub)
 	zynqmp_dp_write(dp, ZYNQMP_DP_INT_DS, 0xffffffff);
 
 	zynqmp_dp_phy_exit(dp);
+	zynqmp_dp_reset(dp, true);
 }
-- 
2.30.2

