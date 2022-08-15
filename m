Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C181593707
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344101AbiHOTTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344671AbiHOTRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A05054C84;
        Mon, 15 Aug 2022 11:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EEC3B81088;
        Mon, 15 Aug 2022 18:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7D6C433D6;
        Mon, 15 Aug 2022 18:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588710;
        bh=pVRim+6E89HAx+8iXj8cTuxT/+QM7V//8BQlXrCmF1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snI6ZeNC6F+Gl5DoKZ/EV8uICRjWuifyU3eE057U6vtByJuTNvylnIpFrYWRbUk8+
         GvJA08Ps7Oj9QOBs4IbL+KHHU4FUZAjy1xfZFDpbwqkIUuC9p4ywY76x8QiOX94q82
         mag98wBUnMk/VdOAtPEJ8u9YbQa+1CRQlx5jzGo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 460/779] PCI: dwc: Add unroll iATU space support to dw_pcie_disable_atu()
Date:   Mon, 15 Aug 2022 20:01:44 +0200
Message-Id: <20220815180356.947745102@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit d1cf738f2b65a5640234e1da90a68d3523fbed83 ]

dw_pcie_disable_atu() was introduced by f8aed6ec624f ("PCI: dwc:
designware: Add EP mode support") and supported only the viewport version
of the iATU CSRs.

DW PCIe IP cores v4.80a and newer also support unrolled iATU/eDMA space.
Callers of dw_pcie_disable_atu(), including pci_epc_ops.clear_bar(),
pci_epc_ops.unmap_addr(), and dw_pcie_setup_rc(), don't work correctly when
it is enabled.

Add dw_pcie_disable_atu() support for controllers with unrolled iATU CSRs
enabled.

[bhelgaas: commit log]
Fixes: f8aed6ec624f ("PCI: dwc: designware: Add EP mode support")
Link: https://lore.kernel.org/r/20220624143428.8334-3-Sergey.Semin@baikalelectronics.ru
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 3254f60d1713..ff74ddf2cc35 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -491,7 +491,7 @@ int dw_pcie_prog_inbound_atu(struct dw_pcie *pci, u8 func_no, int index,
 void dw_pcie_disable_atu(struct dw_pcie *pci, int index,
 			 enum dw_pcie_region_type type)
 {
-	int region;
+	u32 region;
 
 	switch (type) {
 	case DW_PCIE_REGION_INBOUND:
@@ -504,8 +504,18 @@ void dw_pcie_disable_atu(struct dw_pcie *pci, int index,
 		return;
 	}
 
-	dw_pcie_writel_dbi(pci, PCIE_ATU_VIEWPORT, region | index);
-	dw_pcie_writel_dbi(pci, PCIE_ATU_CR2, ~(u32)PCIE_ATU_ENABLE);
+	if (pci->iatu_unroll_enabled) {
+		if (region == PCIE_ATU_REGION_INBOUND) {
+			dw_pcie_writel_ib_unroll(pci, index, PCIE_ATU_UNR_REGION_CTRL2,
+						 ~(u32)PCIE_ATU_ENABLE);
+		} else {
+			dw_pcie_writel_ob_unroll(pci, index, PCIE_ATU_UNR_REGION_CTRL2,
+						 ~(u32)PCIE_ATU_ENABLE);
+		}
+	} else {
+		dw_pcie_writel_dbi(pci, PCIE_ATU_VIEWPORT, region | index);
+		dw_pcie_writel_dbi(pci, PCIE_ATU_CR2, ~(u32)PCIE_ATU_ENABLE);
+	}
 }
 
 int dw_pcie_wait_for_link(struct dw_pcie *pci)
-- 
2.35.1



