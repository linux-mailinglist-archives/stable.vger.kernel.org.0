Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC26159A092
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352258AbiHSQVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352389AbiHSQUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F0E248;
        Fri, 19 Aug 2022 09:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2180D617A5;
        Fri, 19 Aug 2022 16:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1489BC433D6;
        Fri, 19 Aug 2022 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924901;
        bh=K2CM2tFdnxFMHQXII/3DaGSfjgDDyPL/dtPysxPT0IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3lS0rh1EvF6RUta+/iPCuGo2WSKEP/peBux69c8eiFDDTNxRqP3Qnbx54WkFzYLE
         6ok+NShCGdAnKQDWUhT2PMv0kVtp5kI9bo3EE/zYMAifjUaCiIpBRyzDxjpb+arkKU
         +MLjRheVGpXDpvPTKtdULQjs3JyC5jVrb1/vW1qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/545] PCI: qcom: Set up rev 2.1.0 PARF_PHY before enabling clocks
Date:   Fri, 19 Aug 2022 17:41:30 +0200
Message-Id: <20220819153843.670897718@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 38f897ae3d44900f627cad708a15db498ce2ca31 ]

We currently enable clocks BEFORE we write to PARF_PHY_CTRL reg to enable
clocks and resets. This causes the driver to never set to a ready state
with the error 'Phy link never came up'.

This is caused by the PHY clock getting enabled before setting the required
bits in the PARF regs.

A workaround for this was set but with this new discovery we can drop
the workaround and use a proper solution to the problem by just enabling
the clock only AFTER the PARF_PHY_CTRL bit is set.

This correctly sets up the PCIe link and makes it usable even when a
bootloader leaves the PCIe link in an undefined state.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Link: https://lore.kernel.org/r/20220708222743.27019-1-ansuelsmth@gmail.com
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 1b8b3c12eece..5fbd80908a99 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -320,8 +320,6 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	reset_control_assert(res->ext_reset);
 	reset_control_assert(res->phy_reset);
 
-	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
-
 	ret = regulator_bulk_enable(ARRAY_SIZE(res->supplies), res->supplies);
 	if (ret < 0) {
 		dev_err(dev, "cannot enable regulators\n");
@@ -364,15 +362,15 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		goto err_deassert_axi;
 	}
 
-	ret = clk_bulk_prepare_enable(ARRAY_SIZE(res->clks), res->clks);
-	if (ret)
-		goto err_clks;
-
 	/* enable PCIe clocks and resets */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
 	val &= ~BIT(0);
 	writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
 
+	ret = clk_bulk_prepare_enable(ARRAY_SIZE(res->clks), res->clks);
+	if (ret)
+		goto err_clks;
+
 	if (of_device_is_compatible(node, "qcom,pcie-ipq8064") ||
 	    of_device_is_compatible(node, "qcom,pcie-ipq8064-v2")) {
 		writel(PCS_DEEMPH_TX_DEEMPH_GEN1(24) |
-- 
2.35.1



