Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62807450C57
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbhKORhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238184AbhKORdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F67A61C12;
        Mon, 15 Nov 2021 17:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996915;
        bh=wjyunv+waJHaFSboT/EdWGo/A92YDe1hWklJWZ+YSE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGSfGXjRsgiQ6X/JjYuDtVnL0LIACovuZKdR4q7G23kD/9pQfl5t01td4nr42X6jl
         BLoshkO8u4o7mIyATFVEsCt+tSgbUg5CaYIE6uwKs63FsfcU3NXl1CjHrN+R0cx6ai
         8erIBXW5VNSHYIQLt+X319RjS/ZEm+OVNdv3q79s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 282/355] phy: qcom-qusb2: Fix a memory leak on probe
Date:   Mon, 15 Nov 2021 18:03:26 +0100
Message-Id: <20211115165322.854661871@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit bf7ffcd0069d30e2e7ba2b827f08c89f471cd1f3 ]

On success nvmem_cell_read() returns a pointer to a dynamically allocated
buffer, and therefore it shall be freed after usage.

The issue is reported by kmemleak:

  # cat /sys/kernel/debug/kmemleak
  unreferenced object 0xffff3b3803e4b280 (size 128):
    comm "kworker/u16:1", pid 107, jiffies 4294892861 (age 94.120s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<000000007739afdc>] __kmalloc+0x27c/0x41c
      [<0000000071c0fbf8>] nvmem_cell_read+0x40/0xe0
      [<00000000e803ef1f>] qusb2_phy_init+0x258/0x5bc
      [<00000000fc81fcfa>] phy_init+0x70/0x110
      [<00000000e3d48a57>] dwc3_core_soft_reset+0x4c/0x234
      [<0000000027d1dbd4>] dwc3_core_init+0x68/0x990
      [<000000001965faf9>] dwc3_probe+0x4f4/0x730
      [<000000002f7617ca>] platform_probe+0x74/0xf0
      [<00000000a2576cac>] really_probe+0xc4/0x470
      [<00000000bc77f2c5>] __driver_probe_device+0x11c/0x190
      [<00000000130db71f>] driver_probe_device+0x48/0x110
      [<0000000019f36c2b>] __device_attach_driver+0xa4/0x140
      [<00000000e5812ff7>]  bus_for_each_drv+0x84/0xe0
      [<00000000f4bac574>] __device_attach+0xe4/0x1c0
      [<00000000d3beb631>] device_initial_probe+0x20/0x30
      [<000000008019b9db>] bus_probe_device+0xa4/0xb0

Fixes: ca04d9d3e1b1 ("phy: qcom-qusb2: New driver for QUSB2 PHY on Qcom chips")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210922233548.2150244-1-vladimir.zapolskiy@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qusb2.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qusb2.c b/drivers/phy/qualcomm/phy-qcom-qusb2.c
index bf94a52d30871..946e9b05f0ae6 100644
--- a/drivers/phy/qualcomm/phy-qcom-qusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-qusb2.c
@@ -432,7 +432,7 @@ static void qusb2_phy_set_tune2_param(struct qusb2_phy *qphy)
 {
 	struct device *dev = &qphy->phy->dev;
 	const struct qusb2_phy_cfg *cfg = qphy->cfg;
-	u8 *val;
+	u8 *val, hstx_trim;
 
 	/* efuse register is optional */
 	if (!qphy->cell)
@@ -446,7 +446,13 @@ static void qusb2_phy_set_tune2_param(struct qusb2_phy *qphy)
 	 * set while configuring the phy.
 	 */
 	val = nvmem_cell_read(qphy->cell, NULL);
-	if (IS_ERR(val) || !val[0]) {
+	if (IS_ERR(val)) {
+		dev_dbg(dev, "failed to read a valid hs-tx trim value\n");
+		return;
+	}
+	hstx_trim = val[0];
+	kfree(val);
+	if (!hstx_trim) {
 		dev_dbg(dev, "failed to read a valid hs-tx trim value\n");
 		return;
 	}
@@ -454,12 +460,10 @@ static void qusb2_phy_set_tune2_param(struct qusb2_phy *qphy)
 	/* Fused TUNE1/2 value is the higher nibble only */
 	if (cfg->update_tune1_with_efuse)
 		qusb2_write_mask(qphy->base, cfg->regs[QUSB2PHY_PORT_TUNE1],
-				 val[0] << HSTX_TRIM_SHIFT,
-				 HSTX_TRIM_MASK);
+				 hstx_trim << HSTX_TRIM_SHIFT, HSTX_TRIM_MASK);
 	else
 		qusb2_write_mask(qphy->base, cfg->regs[QUSB2PHY_PORT_TUNE2],
-				 val[0] << HSTX_TRIM_SHIFT,
-				 HSTX_TRIM_MASK);
+				 hstx_trim << HSTX_TRIM_SHIFT, HSTX_TRIM_MASK);
 }
 
 static int qusb2_phy_set_mode(struct phy *phy,
-- 
2.33.0



