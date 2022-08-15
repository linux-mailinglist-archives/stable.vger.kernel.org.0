Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD99594B7A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352284AbiHPASs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356573AbiHPARD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:17:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C248A263D;
        Mon, 15 Aug 2022 13:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEA5B61135;
        Mon, 15 Aug 2022 20:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CCFC433D6;
        Mon, 15 Aug 2022 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595467;
        bh=5pNFoN4WOMyki5qA2Bm4cNzOEWj8zNu3HxHNC6RFfe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rImMHcCHKkrITecWreLBVzGvexSkWABdXqSAMYDbDOxwzQYAbxBKnCwQfL+JlVQHH
         PypfCH0BnKuY07Fjp9RTTtQ/jFjOBDhxLLQ5Nu4Xct6R3FiWiorPv047Ox7vygh+8F
         K/BWYQw8sECntKEPtag6PdNv1B+VhdmDQatoYQBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0774/1157] PCI: dwc: Set INCREASE_REGION_SIZE flag based on limit address
Date:   Mon, 15 Aug 2022 20:02:10 +0200
Message-Id: <20220815180510.449594581@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 777e7c3ab73036105e6fc4a67ed950179dbffbab ]

We program the 64-bit ATU limit address (in PCIE_ATU_LIMIT/
PCIE_ATU_UPPER_LIMIT or PCIE_ATU_UNR_LOWER_LIMIT/PCIE_ATU_UNR_UPPER_LIMIT),
but in addition, the PCIE_ATU_INCREASE_REGION_SIZE bit must be set if the
upper 32 bits of the limit address differ from the upper 32 bits of the
base address (see [1,2]).

5b4cf0f65324 ("PCI: dwc: Add upper limit address for outbound iATU") set
PCIE_ATU_INCREASE_REGION_SIZE, but only when the *size* was greater than
4GB.  It did not set it when a smaller region crossed a 4GB boundary, e.g.,
[mem 0x0_f0000000-0x1_0fffffff].

Set PCIE_ATU_INCREASE_REGION_SIZE whenever PCIE_ATU_UPPER_LIMIT is
greater than PCIE_ATU_UPPER_BASE.

[1] DesignWare Cores PCI Express Controller Databook - DWC PCIe Root Port,
    v5.40a, March 2019, fig.3-36, p.175
[2] DesignWare Cores PCI Express Controller Databook - DWC PCIe Root Port,
    v5.40a, March 2019, fig.3-37, p.176

[bhelgaas: commit log]
Fixes: 5b4cf0f65324 ("PCI: dwc: Add upper limit address for outbound iATU")
Link: https://lore.kernel.org/r/20220624143428.8334-5-Sergey.Semin@baikalelectronics.ru
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 84fef21efdbc..347251bf87d0 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -287,8 +287,8 @@ static void dw_pcie_prog_outbound_atu_unroll(struct dw_pcie *pci, u8 func_no,
 	dw_pcie_writel_ob_unroll(pci, index, PCIE_ATU_UNR_UPPER_TARGET,
 				 upper_32_bits(pci_addr));
 	val = type | PCIE_ATU_FUNC_NUM(func_no);
-	val = upper_32_bits(size - 1) ?
-		val | PCIE_ATU_INCREASE_REGION_SIZE : val;
+	if (upper_32_bits(limit_addr) > upper_32_bits(cpu_addr))
+		val |= PCIE_ATU_INCREASE_REGION_SIZE;
 	if (pci->version == 0x490A)
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_ob_unroll(pci, index, PCIE_ATU_UNR_REGION_CTRL1, val);
@@ -315,6 +315,7 @@ static void __dw_pcie_prog_outbound_atu(struct dw_pcie *pci, u8 func_no,
 					u64 pci_addr, u64 size)
 {
 	u32 retries, val;
+	u64 limit_addr;
 
 	if (pci->ops && pci->ops->cpu_addr_fixup)
 		cpu_addr = pci->ops->cpu_addr_fixup(pci, cpu_addr);
@@ -325,6 +326,8 @@ static void __dw_pcie_prog_outbound_atu(struct dw_pcie *pci, u8 func_no,
 		return;
 	}
 
+	limit_addr = cpu_addr + size - 1;
+
 	dw_pcie_writel_dbi(pci, PCIE_ATU_VIEWPORT,
 			   PCIE_ATU_REGION_OUTBOUND | index);
 	dw_pcie_writel_dbi(pci, PCIE_ATU_LOWER_BASE,
@@ -332,17 +335,18 @@ static void __dw_pcie_prog_outbound_atu(struct dw_pcie *pci, u8 func_no,
 	dw_pcie_writel_dbi(pci, PCIE_ATU_UPPER_BASE,
 			   upper_32_bits(cpu_addr));
 	dw_pcie_writel_dbi(pci, PCIE_ATU_LIMIT,
-			   lower_32_bits(cpu_addr + size - 1));
+			   lower_32_bits(limit_addr));
 	if (pci->version >= 0x460A)
 		dw_pcie_writel_dbi(pci, PCIE_ATU_UPPER_LIMIT,
-				   upper_32_bits(cpu_addr + size - 1));
+				   upper_32_bits(limit_addr));
 	dw_pcie_writel_dbi(pci, PCIE_ATU_LOWER_TARGET,
 			   lower_32_bits(pci_addr));
 	dw_pcie_writel_dbi(pci, PCIE_ATU_UPPER_TARGET,
 			   upper_32_bits(pci_addr));
 	val = type | PCIE_ATU_FUNC_NUM(func_no);
-	val = ((upper_32_bits(size - 1)) && (pci->version >= 0x460A)) ?
-		val | PCIE_ATU_INCREASE_REGION_SIZE : val;
+	if (upper_32_bits(limit_addr) > upper_32_bits(cpu_addr) &&
+	    pci->version >= 0x460A)
+		val |= PCIE_ATU_INCREASE_REGION_SIZE;
 	if (pci->version == 0x490A)
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_dbi(pci, PCIE_ATU_CR1, val);
-- 
2.35.1



