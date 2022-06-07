Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8AB5412F0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357375AbiFGTzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358631AbiFGTwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80B834B9F;
        Tue,  7 Jun 2022 11:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B9A560DDA;
        Tue,  7 Jun 2022 18:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7654CC385A5;
        Tue,  7 Jun 2022 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626101;
        bh=Q2EBRsgfT+PTS/7GnCfPNIMf+eKY8QMFmv+If5+/aew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXGz2lWpYDnchshIw2GuWbJn7zq29u8sggbTqgnNQyuuCmblulZD5CubRNCe3XuEd
         J8OGSS+L0vrseXoHVQ2TnQ5byFvlhlVHZsiPe3TfKQzpUp+YRHRVew/suUrctUCxwU
         +z/lRMmfOKIWpHGIj1gFaRpsmm5H1N2TiimWAGgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 207/772] PCI: microchip: Add missing chained_irq_enter()/exit() calls
Date:   Tue,  7 Jun 2022 18:56:39 +0200
Message-Id: <20220607164955.133073038@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 30097efa334a706f9021b9aee6efcddcfa44a78a ]

Two of the chained IRQ handlers miss their
chained_irq_enter()/chained_irq_exit() calls, so add them in to avoid
potentially lost interrupts.

Reported by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/linux-pci/87h76b8nxc.wl-maz@kernel.org
Link: https://lore.kernel.org/r/20220511095504.2273799-1-conor.dooley@microchip.com
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-microchip-host.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/controller/pcie-microchip-host.c b/drivers/pci/controller/pcie-microchip-host.c
index 29d8e81e4181..8175abed0f05 100644
--- a/drivers/pci/controller/pcie-microchip-host.c
+++ b/drivers/pci/controller/pcie-microchip-host.c
@@ -406,6 +406,7 @@ static void mc_pcie_enable_msi(struct mc_pcie *port, void __iomem *base)
 static void mc_handle_msi(struct irq_desc *desc)
 {
 	struct mc_pcie *port = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct device *dev = port->dev;
 	struct mc_msi *msi = &port->msi;
 	void __iomem *bridge_base_addr =
@@ -414,6 +415,8 @@ static void mc_handle_msi(struct irq_desc *desc)
 	u32 bit;
 	int ret;
 
+	chained_irq_enter(chip, desc);
+
 	status = readl_relaxed(bridge_base_addr + ISTATUS_LOCAL);
 	if (status & PM_MSI_INT_MSI_MASK) {
 		status = readl_relaxed(bridge_base_addr + ISTATUS_MSI);
@@ -424,6 +427,8 @@ static void mc_handle_msi(struct irq_desc *desc)
 						    bit);
 		}
 	}
+
+	chained_irq_exit(chip, desc);
 }
 
 static void mc_msi_bottom_irq_ack(struct irq_data *data)
@@ -563,6 +568,7 @@ static int mc_allocate_msi_domains(struct mc_pcie *port)
 static void mc_handle_intx(struct irq_desc *desc)
 {
 	struct mc_pcie *port = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct device *dev = port->dev;
 	void __iomem *bridge_base_addr =
 		port->axi_base_addr + MC_PCIE_BRIDGE_ADDR;
@@ -570,6 +576,8 @@ static void mc_handle_intx(struct irq_desc *desc)
 	u32 bit;
 	int ret;
 
+	chained_irq_enter(chip, desc);
+
 	status = readl_relaxed(bridge_base_addr + ISTATUS_LOCAL);
 	if (status & PM_MSI_INT_INTX_MASK) {
 		status &= PM_MSI_INT_INTX_MASK;
@@ -581,6 +589,8 @@ static void mc_handle_intx(struct irq_desc *desc)
 						    bit);
 		}
 	}
+
+	chained_irq_exit(chip, desc);
 }
 
 static void mc_ack_intx_irq(struct irq_data *data)
-- 
2.35.1



