Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD88373E3E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388203AbfGXTmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390409AbfGXTmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:42:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42AAD20665;
        Wed, 24 Jul 2019 19:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997364;
        bh=aKEnaZ7Q19gHsX4lVgdncCYO5iiTFGDI+R4d4ch3Riw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KydtvRasS0UhI8RR1N1baE8p+rGN7EXj9Tu2NmNmxZ7LxIlGnIbRj6MhTVeizVMqL
         zo2ILwDeXd/v34VCjXSrUVYkvvV+7+tt2BKEUXSmoF9z22ELowcanD7OhXcW7KXUk4
         KmRpOnhc6jSRkbC11DRcfslZKpfcKDVhzoHwE1G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Vivek Gautam <vivek.gautam@codeaurora.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.2 411/413] phy: qcom-qmp: Correct READY_STATUS poll break condition
Date:   Wed, 24 Jul 2019 21:21:42 +0200
Message-Id: <20190724191803.918536116@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 885bd765963b42c380db442db7f1c0f2a26076fa upstream.

After issuing a PHY_START request to the QMP, the hardware documentation
states that the software should wait for the PCS_READY_STATUS to become
1.

With the introduction of commit c9b589791fc1 ("phy: qcom: Utilize UFS
reset controller") an additional 1ms delay was introduced between the
start request and the check of the status bit. This greatly increases
the chances for the hardware to actually becoming ready before the
status bit is read.

The result can be seen in that UFS PHY enabling is now reported as a
failure in 10% of the boots on SDM845, which is a clear regression from
the previous rare/occasional failure.

This patch fixes the "break condition" of the poll to check for the
correct state of the status bit.

Unfortunately PCIe on 8996 and 8998 does not specify the mask_pcs_ready
register, which means that the code checks a bit that's always 0. So the
patch also fixes these, in order to not regress these targets.

Fixes: 73d7ec899bd8 ("phy: qcom-qmp: Add msm8998 PCIe QMP PHY support")
Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Cc: stable@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Reviewed-by: Niklas Cassel <niklas.cassel@linaro.org>
Reviewed-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Tested-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/qualcomm/phy-qcom-qmp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -1074,6 +1074,7 @@ static const struct qmp_phy_cfg msm8996_
 
 	.start_ctrl		= PCS_START | PLL_READY_GATE_EN,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
+	.mask_pcs_ready		= PHYSTATUS,
 	.mask_com_pcs_ready	= PCS_READY,
 
 	.has_phy_com_ctrl	= true,
@@ -1253,6 +1254,7 @@ static const struct qmp_phy_cfg msm8998_
 
 	.start_ctrl             = SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
+	.mask_pcs_ready		= PHYSTATUS,
 	.mask_com_pcs_ready	= PCS_READY,
 };
 
@@ -1547,7 +1549,7 @@ static int qcom_qmp_phy_enable(struct ph
 	status = pcs + cfg->regs[QPHY_PCS_READY_STATUS];
 	mask = cfg->mask_pcs_ready;
 
-	ret = readl_poll_timeout(status, val, !(val & mask), 1,
+	ret = readl_poll_timeout(status, val, val & mask, 1,
 				 PHY_INIT_COMPLETE_TIMEOUT);
 	if (ret) {
 		dev_err(qmp->dev, "phy initialization timed-out\n");


