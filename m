Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6709C4B4B95
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347543AbiBNKbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348260AbiBNKau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265909BF7C;
        Mon, 14 Feb 2022 01:59:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14237B80DCF;
        Mon, 14 Feb 2022 09:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAE7C340F1;
        Mon, 14 Feb 2022 09:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832747;
        bh=yh+Oo2C0NdYplnno+CZkh/DZsN/Zg/W1MtgKkWir/Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndK5yA4MkOTdInS3Q49wpbr+lDOIN9ivUnbXzjx+vpvzwD+IrHvB0VMpFuTfhdUuy
         EM5Y/48qENX6YUynIs5rK2eQLnzjVGj1/FtmRF+ww7aP6L2WLvSHS3Jx6cvWwLrIdk
         qjJqjxOxWn0aoCX5lZSKZduqiSO7WsYozSu8j27g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joey Corleone <joey.corleone@mail.ru>,
        Sergiu Deitsch <sergiu.deitsch@gmail.com>,
        David Spencer <dspencer577@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 5.16 080/203] Revert "PCI/portdrv: Do not setup up IRQs if there are no users"
Date:   Mon, 14 Feb 2022 10:25:24 +0100
Message-Id: <20220214092512.997663857@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit 075b7d363c675ef7fa03918881caeca3458e2a96 upstream.

This reverts commit 0e8ae5a6ff5952253cd7cc0260df838ab4c21009.

0e8ae5a6ff59 ("PCI/portdrv: Do not setup up IRQs if there are no users")
reduced usage of IRQs when we don't think we need them.  But Joey, Sergiu,
and David reported choppy GUI rendering, systems that became unresponsive
every few seconds, incorrect values reported by cpufreq, and high IRQ 16
CPU usage.

Joey bisected the issues to 0e8ae5a6ff59, so revert it until we figure out
a better solution.

Link: https://lore.kernel.org/r/20220210222717.GA658201@bhelgaas
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215533
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215546
Reported-by: Joey Corleone <joey.corleone@mail.ru>
Reported-by: Sergiu Deitsch <sergiu.deitsch@gmail.com>
Reported-by: David Spencer <dspencer577@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v5.16+
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/portdrv_core.c |   47 ++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -166,6 +166,9 @@ static int pcie_init_service_irqs(struct
 {
 	int ret, i;
 
+	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
+		irqs[i] = -1;
+
 	/*
 	 * If we support PME but can't use MSI/MSI-X for it, we have to
 	 * fall back to INTx or other interrupts, e.g., a system shared
@@ -314,10 +317,8 @@ static int pcie_device_init(struct pci_d
  */
 int pcie_port_device_register(struct pci_dev *dev)
 {
-	int status, capabilities, irq_services, i, nr_service;
-	int irqs[PCIE_PORT_DEVICE_MAXSERVICES] = {
-		[0 ... PCIE_PORT_DEVICE_MAXSERVICES-1] = -1
-	};
+	int status, capabilities, i, nr_service;
+	int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
 
 	/* Enable PCI Express port device */
 	status = pci_enable_device(dev);
@@ -330,32 +331,18 @@ int pcie_port_device_register(struct pci
 		return 0;
 
 	pci_set_master(dev);
-
-	irq_services = 0;
-	if (IS_ENABLED(CONFIG_PCIE_PME))
-		irq_services |= PCIE_PORT_SERVICE_PME;
-	if (IS_ENABLED(CONFIG_PCIEAER))
-		irq_services |= PCIE_PORT_SERVICE_AER;
-	if (IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))
-		irq_services |= PCIE_PORT_SERVICE_HP;
-	if (IS_ENABLED(CONFIG_PCIE_DPC))
-		irq_services |= PCIE_PORT_SERVICE_DPC;
-	irq_services &= capabilities;
-
-	if (irq_services) {
-		/*
-		 * Initialize service IRQs. Don't use service devices that
-		 * require interrupts if there is no way to generate them.
-		 * However, some drivers may have a polling mode (e.g.
-		 * pciehp_poll_mode) that can be used in the absence of IRQs.
-		 * Allow them to determine if that is to be used.
-		 */
-		status = pcie_init_service_irqs(dev, irqs, irq_services);
-		if (status) {
-			irq_services &= PCIE_PORT_SERVICE_HP;
-			if (!irq_services)
-				goto error_disable;
-		}
+	/*
+	 * Initialize service irqs. Don't use service devices that
+	 * require interrupts if there is no way to generate them.
+	 * However, some drivers may have a polling mode (e.g. pciehp_poll_mode)
+	 * that can be used in the absence of irqs.  Allow them to determine
+	 * if that is to be used.
+	 */
+	status = pcie_init_service_irqs(dev, irqs, capabilities);
+	if (status) {
+		capabilities &= PCIE_PORT_SERVICE_HP;
+		if (!capabilities)
+			goto error_disable;
 	}
 
 	/* Allocate child services if any */


