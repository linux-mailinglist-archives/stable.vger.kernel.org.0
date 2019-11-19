Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A91017F7
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfKSFhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfKSFhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:37:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10DA218BA;
        Tue, 19 Nov 2019 05:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141830;
        bh=OrrCHY8Eb1hCpT3SlqZk2rbNYKGd6CpzIxk0LlUp0U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dc4+DDp9c6KiFMzDQad4b/BOEJNvfmnW5gBv+yoyLlbbC9ZpXzvI3pl8/4DYWi3wW
         eAgLHq+KlLvY8yylp8So6vZc9Us7TeRtpeQY5yBPuzIMR8hf/bQ4/fM2yV0FawbuWL
         iMgllWoHcE4IVxTfyWBmEhuba62yCn97lJ1SdVBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 295/422] PCI: portdrv: Initialize service drivers directly
Date:   Tue, 19 Nov 2019 06:18:12 +0100
Message-Id: <20191119051418.107423761@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

[ Upstream commit c29de84149aba5f74e87b6491c13ac7203c12f55 ]

The PCI port driver saves the PCI state after initializing the device with
the applicable service devices.  This was, however, before the service
drivers were even registered because PCI probe happens before the
device_initcall initialized those service drivers.  The config space state
that the services set up were not being saved.  The end result would cause
PCI devices to not react to events that the drivers think they did if the
PCI state ever needed to be restored.

Fix this by changing the service drivers from using the init calls to
having the portdrv driver calling the services directly.  This will get the
state saved as desired, while making the relationship between the port
driver and the services under it more explicit in the code.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_core.c |  3 +--
 drivers/pci/pcie/aer.c            |  3 +--
 drivers/pci/pcie/dpc.c            |  3 +--
 drivers/pci/pcie/pme.c            |  3 +--
 drivers/pci/pcie/portdrv.h        | 24 ++++++++++++++++++++++++
 drivers/pci/pcie/portdrv_pci.c    |  9 +++++++++
 6 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index ec48c9433ae50..518c46f8e63b7 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -348,7 +348,7 @@ static struct pcie_port_service_driver hpdriver_portdrv = {
 #endif	/* PM */
 };
 
-static int __init pcied_init(void)
+int __init pcie_hp_init(void)
 {
 	int retval = 0;
 
@@ -359,4 +359,3 @@ static int __init pcied_init(void)
 
 	return retval;
 }
-device_initcall(pcied_init);
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 83180edd6ed47..637d638f73da5 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1569,10 +1569,9 @@ static struct pcie_port_service_driver aerdriver = {
  *
  * Invoked when AER root service driver is loaded.
  */
-static int __init aer_service_init(void)
+int __init pcie_aer_init(void)
 {
 	if (!pci_aer_available() || aer_acpi_firmware_first())
 		return -ENXIO;
 	return pcie_port_service_register(&aerdriver);
 }
-device_initcall(aer_service_init);
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index 1908dd2978d3c..118b5bcae42ea 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -307,8 +307,7 @@ static struct pcie_port_service_driver dpcdriver = {
 	.reset_link	= dpc_reset_link,
 };
 
-static int __init dpc_service_init(void)
+int __init pcie_dpc_init(void)
 {
 	return pcie_port_service_register(&dpcdriver);
 }
-device_initcall(dpc_service_init);
diff --git a/drivers/pci/pcie/pme.c b/drivers/pci/pcie/pme.c
index 6ac17f0c40775..54d593d10396f 100644
--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -455,8 +455,7 @@ static struct pcie_port_service_driver pcie_pme_driver = {
 /**
  * pcie_pme_service_init - Register the PCIe PME service driver.
  */
-static int __init pcie_pme_service_init(void)
+int __init pcie_pme_init(void)
 {
 	return pcie_port_service_register(&pcie_pme_driver);
 }
-device_initcall(pcie_pme_service_init);
diff --git a/drivers/pci/pcie/portdrv.h b/drivers/pci/pcie/portdrv.h
index d59afa42fc14b..2498b2d340095 100644
--- a/drivers/pci/pcie/portdrv.h
+++ b/drivers/pci/pcie/portdrv.h
@@ -23,6 +23,30 @@
 
 #define PCIE_PORT_DEVICE_MAXSERVICES   4
 
+#ifdef CONFIG_PCIEAER
+int pcie_aer_init(void);
+#else
+static inline int pcie_aer_init(void) { return 0; }
+#endif
+
+#ifdef CONFIG_HOTPLUG_PCI_PCIE
+int pcie_hp_init(void);
+#else
+static inline int pcie_hp_init(void) { return 0; }
+#endif
+
+#ifdef CONFIG_PCIE_PME
+int pcie_pme_init(void);
+#else
+static inline int pcie_pme_init(void) { return 0; }
+#endif
+
+#ifdef CONFIG_PCIE_DPC
+int pcie_dpc_init(void);
+#else
+static inline int pcie_dpc_init(void) { return 0; }
+#endif
+
 /* Port Type */
 #define PCIE_ANY_PORT			(~0)
 
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index eef22dc29140c..23a5a0c2c3fe9 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -226,11 +226,20 @@ static const struct dmi_system_id pcie_portdrv_dmi_table[] __initconst = {
 	 {}
 };
 
+static void __init pcie_init_services(void)
+{
+	pcie_aer_init();
+	pcie_pme_init();
+	pcie_dpc_init();
+	pcie_hp_init();
+}
+
 static int __init pcie_portdrv_init(void)
 {
 	if (pcie_ports_disabled)
 		return -EACCES;
 
+	pcie_init_services();
 	dmi_check_system(pcie_portdrv_dmi_table);
 
 	return pci_register_driver(&pcie_portdriver);
-- 
2.20.1



