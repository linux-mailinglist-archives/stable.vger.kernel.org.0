Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDDB422872
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhJENwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235277AbhJENwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A381C615E4;
        Tue,  5 Oct 2021 13:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441834;
        bh=nBNq1iiRCmYgxsysgE+AMrKeqVOvgcTNU2C7rZIx78k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiZRIElkbpd2aYpmO/apATAfS6RI2IeybVJerOhkHfh4G3E0oC1yUQDvFx0Dho4Ek
         QB4X7sOPrSr07ReIwtUmDfEk+tPA6ljtVMbLCcdVelymWV/HXx7RBGiM6rWAvDUDnz
         WBJU69j+XWb+HaKiEpOBWGIkJHNacRY9IusbrRtdWMuVz+CyJBLRJA5IsNmtHfgIA7
         zt+mwJCyWJ2WqpD4Dgz6/M8e2mVpjIOCChhh5JFvSncNPpkxlezYw2bCBxuLrOW1p/
         b24VnggDSUaU+16dIruQiXB9m95GWVJZ+c/P2wOkAj3b/eHdBWh/uufkiYxICpMStN
         aKhEcbb8PPYfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 07/40] interconnect: qcom: sdm660: Add missing a2noc qos clocks
Date:   Tue,  5 Oct 2021 09:49:46 -0400
Message-Id: <20211005135020.214291-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 13404ac8882f5225af07545215f4975a564c3740 ]

It adds the missing a2noc clocks required for QoS registers programming
per downstream kernel[1].  Otherwise, qcom_icc_noc_set_qos_priority()
call on mas_ufs or mas_usb_hs node will simply result in a hardware hang
on SDM660 SoC.

[1] https://source.codeaurora.org/quic/la/kernel/msm-4.4/tree/arch/arm/boot/dts/qcom/sdm660-bus.dtsi?h=LA.UM.8.2.r1-04800-sdm660.0#n43

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210824043435.23190-3-shawn.guo@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sdm660.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/interconnect/qcom/sdm660.c b/drivers/interconnect/qcom/sdm660.c
index 632dbdd21915..4b2b8c8bac2a 100644
--- a/drivers/interconnect/qcom/sdm660.c
+++ b/drivers/interconnect/qcom/sdm660.c
@@ -173,6 +173,16 @@ static const struct clk_bulk_data bus_mm_clocks[] = {
 	{ .id = "iface" },
 };
 
+static const struct clk_bulk_data bus_a2noc_clocks[] = {
+	{ .id = "bus" },
+	{ .id = "bus_a" },
+	{ .id = "ipa" },
+	{ .id = "ufs_axi" },
+	{ .id = "aggre2_ufs_axi" },
+	{ .id = "aggre2_usb3_axi" },
+	{ .id = "cfg_noc_usb2_axi" },
+};
+
 /**
  * struct qcom_icc_provider - Qualcomm specific interconnect provider
  * @provider: generic interconnect provider
@@ -810,6 +820,10 @@ static int qnoc_probe(struct platform_device *pdev)
 		qp->bus_clks = devm_kmemdup(dev, bus_mm_clocks,
 					    sizeof(bus_mm_clocks), GFP_KERNEL);
 		qp->num_clks = ARRAY_SIZE(bus_mm_clocks);
+	} else if (of_device_is_compatible(dev->of_node, "qcom,sdm660-a2noc")) {
+		qp->bus_clks = devm_kmemdup(dev, bus_a2noc_clocks,
+					    sizeof(bus_a2noc_clocks), GFP_KERNEL);
+		qp->num_clks = ARRAY_SIZE(bus_a2noc_clocks);
 	} else {
 		if (of_device_is_compatible(dev->of_node, "qcom,sdm660-bimc"))
 			qp->is_bimc_node = true;
-- 
2.33.0

