Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9A55948E9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiHOXRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242510AbiHOXOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32A27C19B;
        Mon, 15 Aug 2022 13:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CF4FB80EAD;
        Mon, 15 Aug 2022 20:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF43C433C1;
        Mon, 15 Aug 2022 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593728;
        bh=BemgTh73EFokSEYvo9fSAFZ/Xw3eMO33zGf+eGqVfDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4U/97X/e4oeOk2aJQ+tg9rzACj4zHMjjCakqa5LqNO3TJzbUVP3w+evRXelYsrnD
         x3+PsoAwLUdK5NYxWYk5Cf9bTJq3F6uNuyldaNQItBe+IFpeaTc8V3AecyWcwFLEvo
         NCirdZHVgRNOXMHeIMlhxs1X+oJzn2rwtifwNzU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0997/1095] PCI: qcom: Power on PHY before IPQ8074 DBI register accesses
Date:   Mon, 15 Aug 2022 20:06:36 +0200
Message-Id: <20220815180510.361269733@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit a0e43bb9973b06ce5c666f0901e104e2037c1b34 ]

Currently the Gen2 port in IPQ8074 will cause the system to hang as it
accesses DBI registers in qcom_pcie_init_2_3_3(), and those are only
accesible after phy_power_on().

Move the DBI read/writes to a new qcom_pcie_post_init_2_3_3(), which is
executed after phy_power_on().

Link: https://lore.kernel.org/r/20220623155004.688090-1-robimarko@gmail.com
Fixes: a0fd361db8e5 ("PCI: dwc: Move "dbi", "dbi2", and "addr_space" resource setup into common code")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: stable@vger.kernel.org	# v5.11+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 48 +++++++++++++++-----------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index ab04818f6ed9..340542aab8a5 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1036,9 +1036,7 @@ static int qcom_pcie_init_2_3_3(struct qcom_pcie *pcie)
 	struct qcom_pcie_resources_2_3_3 *res = &pcie->res.v2_3_3;
 	struct dw_pcie *pci = pcie->pci;
 	struct device *dev = pci->dev;
-	u16 offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
 	int i, ret;
-	u32 val;
 
 	for (i = 0; i < ARRAY_SIZE(res->rst); i++) {
 		ret = reset_control_assert(res->rst[i]);
@@ -1095,6 +1093,33 @@ static int qcom_pcie_init_2_3_3(struct qcom_pcie *pcie)
 		goto err_clk_aux;
 	}
 
+	return 0;
+
+err_clk_aux:
+	clk_disable_unprepare(res->ahb_clk);
+err_clk_ahb:
+	clk_disable_unprepare(res->axi_s_clk);
+err_clk_axi_s:
+	clk_disable_unprepare(res->axi_m_clk);
+err_clk_axi_m:
+	clk_disable_unprepare(res->iface);
+err_clk_iface:
+	/*
+	 * Not checking for failure, will anyway return
+	 * the original failure in 'ret'.
+	 */
+	for (i = 0; i < ARRAY_SIZE(res->rst); i++)
+		reset_control_assert(res->rst[i]);
+
+	return ret;
+}
+
+static int qcom_pcie_post_init_2_3_3(struct qcom_pcie *pcie)
+{
+	struct dw_pcie *pci = pcie->pci;
+	u16 offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+	u32 val;
+
 	writel(SLV_ADDR_SPACE_SZ,
 		pcie->parf + PCIE20_v3_PARF_SLV_ADDR_SPACE_SIZE);
 
@@ -1122,24 +1147,6 @@ static int qcom_pcie_init_2_3_3(struct qcom_pcie *pcie)
 		PCI_EXP_DEVCTL2);
 
 	return 0;
-
-err_clk_aux:
-	clk_disable_unprepare(res->ahb_clk);
-err_clk_ahb:
-	clk_disable_unprepare(res->axi_s_clk);
-err_clk_axi_s:
-	clk_disable_unprepare(res->axi_m_clk);
-err_clk_axi_m:
-	clk_disable_unprepare(res->iface);
-err_clk_iface:
-	/*
-	 * Not checking for failure, will anyway return
-	 * the original failure in 'ret'.
-	 */
-	for (i = 0; i < ARRAY_SIZE(res->rst); i++)
-		reset_control_assert(res->rst[i]);
-
-	return ret;
 }
 
 static int qcom_pcie_get_resources_2_7_0(struct qcom_pcie *pcie)
@@ -1465,6 +1472,7 @@ static const struct qcom_pcie_ops ops_2_4_0 = {
 static const struct qcom_pcie_ops ops_2_3_3 = {
 	.get_resources = qcom_pcie_get_resources_2_3_3,
 	.init = qcom_pcie_init_2_3_3,
+	.post_init = qcom_pcie_post_init_2_3_3,
 	.deinit = qcom_pcie_deinit_2_3_3,
 	.ltssm_enable = qcom_pcie_2_3_2_ltssm_enable,
 };
-- 
2.35.1



