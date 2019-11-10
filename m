Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CF2F66A1
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfKJCm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfKJCm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E41021850;
        Sun, 10 Nov 2019 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353744;
        bh=OrrCHY8Eb1hCpT3SlqZk2rbNYKGd6CpzIxk0LlUp0U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfZw0KTv/PHCE0RNuR+gaBcweveMxJawMT1aCzJ4wNkLL4UUHJwcCx1b0Jz27vd2F
         epPRpXahxjgua48EH9vfVdjV/f6qDYAx7wM1d9ViT60ImCIwssg8FbFyVQa++CgtMu
         5ZpIrciH6dp2c6B0ctFg/R3h+8n2OJxMlbGAj2Lg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 061/191] PCI: portdrv: Initialize service drivers directly
Date:   Sat,  9 Nov 2019 21:38:03 -0500
Message-Id: <20191110024013.29782-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

