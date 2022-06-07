Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D08253A72F
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354000AbiFAN67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354007AbiFAN6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:58:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704298CCF7;
        Wed,  1 Jun 2022 06:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BBE6B81806;
        Wed,  1 Jun 2022 13:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBB2C385B8;
        Wed,  1 Jun 2022 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091722;
        bh=Q2EBRsgfT+PTS/7GnCfPNIMf+eKY8QMFmv+If5+/aew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPGOcDBrmtPkOyFFBAqT+QoCG6sM91xQmGq0ZYx9KvQcCz6RlZYoNAfvoJLlwc3oC
         9u8zeC2Ev/7/nWX1/LMV83yjLLCvyRM9oXcJ835zSvfZ4Zog+EhhjFiyoIkN3XxNuf
         oTRw4+QJNzW/5q9ICW+XcjoYD12o/sWxFGm3G5roOsc5a8AG/Uk05UNSx3Za8OdY91
         5DqNBkM70c7sBQtRNyxB21NVlJ1ywOsbNlAvfsXo0VXH3KP3u2AtqY9jpgXUiVR7HS
         XzSOFcuayqciMlR563bn3YICFLrViV2uZNTK5hkn+W/ZYGCNbwMJ9S0exe0HlXrtd9
         duGBA9Smwwdmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, daire.mcnamara@microchip.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 28/48] PCI: microchip: Add missing chained_irq_enter()/exit() calls
Date:   Wed,  1 Jun 2022 09:54:01 -0400
Message-Id: <20220601135421.2003328-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

