Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C112B61CF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgKQNWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbgKQNWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8512A2463D;
        Tue, 17 Nov 2020 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619361;
        bh=okRt6zooMpvkkF/oOoD9kY1ogXDKcGUoAEDyTMpcRcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRivBx8kDaoH4RdexhNSvXM6JU2RQZuzDaF4883n9DmMrHJNTqiYMNiASkFcg7a+Z
         VVNTdnjCYFmFmeCLjyJlmXoT8tp7XEiV+VkAL8A6gh8DRVMBrG1lHK181pmw1J9Zyi
         +w9EHg5yEGdYzoyqgzSmTj+POlYsPJFJZwI3JJuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/151] PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0
Date:   Tue, 17 Nov 2020 14:03:55 +0100
Message-Id: <20201117122121.653986234@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit d3d4d028afb785e52c55024d779089654f8302e7 ]

Qsdk U-Boot can incorrectly leave the PCIe interface in an undefined
state if bootm command is used instead of bootipq. This is caused by the
not deinit of PCIe when bootm is called. Reset the PCIe before init
anyway to fix this U-Boot bug.

Link: https://lore.kernel.org/r/20200901124955.137-1-ansuelsmth@gmail.com
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 374db5d59cf87..14196c0287a24 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -303,6 +303,9 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 	clk_disable_unprepare(res->core_clk);
 	clk_disable_unprepare(res->aux_clk);
 	clk_disable_unprepare(res->ref_clk);
+
+	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
+
 	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
 }
 
@@ -315,6 +318,16 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	u32 val;
 	int ret;
 
+	/* reset the PCIe interface as uboot can leave it undefined state */
+	reset_control_assert(res->pci_reset);
+	reset_control_assert(res->axi_reset);
+	reset_control_assert(res->ahb_reset);
+	reset_control_assert(res->por_reset);
+	reset_control_assert(res->ext_reset);
+	reset_control_assert(res->phy_reset);
+
+	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(res->supplies), res->supplies);
 	if (ret < 0) {
 		dev_err(dev, "cannot enable regulators\n");
-- 
2.27.0



