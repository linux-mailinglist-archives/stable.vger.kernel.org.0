Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F84B594441
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346843AbiHOWKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345798AbiHOWIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCA430F66;
        Mon, 15 Aug 2022 12:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B72BB81136;
        Mon, 15 Aug 2022 19:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB49C433C1;
        Mon, 15 Aug 2022 19:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592281;
        bh=Eu2Too71nkRvOCWXDlOSR3/DmXmFVsTh3FCCzEj3Lqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpAfMpjXOcEOryS5oSqyddKpa2DMx+6RUEBoMUa5XDNB3flVbIriK8batxx/kC7Q5
         GRnyggE0txKIZuiiqdAy4EBHHUp8fmvOq63G7TePuNP+oRplUWIy8VB+XomX+5Qfgi
         DpT9GO1GM6pN4YKcM12XRnTNuscMCTArk2BjfvjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>, Rob Herring <robh@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0726/1095] PCI: dwc: Always enable CDM check if "snps,enable-cdm-check" exists
Date:   Mon, 15 Aug 2022 20:02:05 +0200
Message-Id: <20220815180459.405688322@linuxfoundation.org>
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

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit ec7b952f453ce7eabe7e1bea584626934d44f668 ]

If the "snps,enable-cdm-check" property exists, we should enable the CDM
check.  But previously dw_pcie_setup() could exit before doing so if the
"num-lanes" property was absent or invalid.

Move the CDM enable earlier so we do it regardless of whether "num-lanes"
is present.

[bhelgaas: commit log]
Fixes: 07f123def73e ("PCI: dwc: Add support to enable CDM register check")
Link: https://lore.kernel.org/r/20220624143428.8334-7-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 347251bf87d0..5848cc520b52 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -740,6 +740,13 @@ void dw_pcie_setup(struct dw_pcie *pci)
 	val |= PORT_LINK_DLL_LINK_EN;
 	dw_pcie_writel_dbi(pci, PCIE_PORT_LINK_CONTROL, val);
 
+	if (of_property_read_bool(np, "snps,enable-cdm-check")) {
+		val = dw_pcie_readl_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS);
+		val |= PCIE_PL_CHK_REG_CHK_REG_CONTINUOUS |
+		       PCIE_PL_CHK_REG_CHK_REG_START;
+		dw_pcie_writel_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS, val);
+	}
+
 	of_property_read_u32(np, "num-lanes", &pci->num_lanes);
 	if (!pci->num_lanes) {
 		dev_dbg(pci->dev, "Using h/w default number of lanes\n");
@@ -786,11 +793,4 @@ void dw_pcie_setup(struct dw_pcie *pci)
 		break;
 	}
 	dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, val);
-
-	if (of_property_read_bool(np, "snps,enable-cdm-check")) {
-		val = dw_pcie_readl_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS);
-		val |= PCIE_PL_CHK_REG_CHK_REG_CONTINUOUS |
-		       PCIE_PL_CHK_REG_CHK_REG_START;
-		dw_pcie_writel_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS, val);
-	}
 }
-- 
2.35.1



