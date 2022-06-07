Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A64D540ED2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353256AbiFGSyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354125AbiFGSqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DBE11CB69;
        Tue,  7 Jun 2022 11:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E5061804;
        Tue,  7 Jun 2022 18:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C2AC385A5;
        Tue,  7 Jun 2022 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624808;
        bh=HKc5sX/pRWZTZFPOgIiQNX1sw6rMlubjaWF2gfjiHd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yypTw/7nuSYDGL1BJMJTe/jhmFtxW7OtrHUNTJibGM8pcvYQpZ8vrptDC3kXteoOB
         zOISaJjVpV9patfWiva+HbBrau5x61nduYpbVAz7HQ4BdY9JK6uJjz8wUfKOTTnxpF
         HHlOnzPbHfsRFupJmFsEHqEyvCvG3mexlAdRieic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/667] PCI: microchip: Fix potential race in interrupt handling
Date:   Tue,  7 Jun 2022 19:02:06 +0200
Message-Id: <20220607164948.537333108@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daire McNamara <daire.mcnamara@microchip.com>

[ Upstream commit 7013654af694f6e1a2e699a6450ea50d309dd0e5 ]

Clear the MSI bit in ISTATUS_LOCAL register after reading it, but
before reading and handling individual MSI bits from the ISTATUS_MSI
register. This avoids a potential race where new MSI bits may be set
on the ISTATUS_MSI register after it was read and be missed when the
MSI bit in the ISTATUS_LOCAL register is cleared.

ISTATUS_LOCAL is a read/write/clear register; the register's bits
are set when the corresponding interrupt source is activated. Each
source is independent and thus multiple sources may be active
simultaneously. The processor can monitor and clear status
bits. If one or more ISTATUS_LOCAL interrupt sources are active,
the RootPort issues an interrupt towards the processor (on
the AXI domain). Bit 28 of this register reports an MSI has been
received by the RootPort.

ISTATUS_MSI is a read/write/clear register. Bits 31-0 are asserted
when an MSI with message number 31-0 is received by the RootPort.
The processor must monitor and clear these bits.

Effectively, Bit 28 of ISTATUS_LOCAL informs the processor that
an MSI has arrived at the RootPort and ISTATUS_MSI informs the
processor which MSI (in the range 0 - 31) needs handling.

Reported by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/linux-pci/20220127202000.GA126335@bhelgaas/

Link: https://lore.kernel.org/r/20220517141622.145581-1-daire.mcnamara@microchip.com
Fixes: 6f15a9c9f941 ("PCI: microchip: Add Microchip PolarFire PCIe controller driver")
Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-microchip-host.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pcie-microchip-host.c b/drivers/pci/controller/pcie-microchip-host.c
index 329f930d17aa..fa209ad067bf 100644
--- a/drivers/pci/controller/pcie-microchip-host.c
+++ b/drivers/pci/controller/pcie-microchip-host.c
@@ -416,6 +416,7 @@ static void mc_handle_msi(struct irq_desc *desc)
 
 	status = readl_relaxed(bridge_base_addr + ISTATUS_LOCAL);
 	if (status & PM_MSI_INT_MSI_MASK) {
+		writel_relaxed(status & PM_MSI_INT_MSI_MASK, bridge_base_addr + ISTATUS_LOCAL);
 		status = readl_relaxed(bridge_base_addr + ISTATUS_MSI);
 		for_each_set_bit(bit, &status, msi->num_vectors) {
 			ret = generic_handle_domain_irq(msi->dev_domain, bit);
@@ -432,13 +433,8 @@ static void mc_msi_bottom_irq_ack(struct irq_data *data)
 	void __iomem *bridge_base_addr =
 		port->axi_base_addr + MC_PCIE_BRIDGE_ADDR;
 	u32 bitpos = data->hwirq;
-	unsigned long status;
 
 	writel_relaxed(BIT(bitpos), bridge_base_addr + ISTATUS_MSI);
-	status = readl_relaxed(bridge_base_addr + ISTATUS_MSI);
-	if (!status)
-		writel_relaxed(BIT(PM_MSI_INT_MSI_SHIFT),
-			       bridge_base_addr + ISTATUS_LOCAL);
 }
 
 static void mc_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
-- 
2.35.1



