Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B2AF664F
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfKJCmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:42:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbfKJCmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84EFF21019;
        Sun, 10 Nov 2019 02:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353770;
        bh=ChvYNTCoC5kgVm4lG/S0gWOv6jx+z6gpAQ2QopclRSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFTqGLy3eDUgCnPP4yDpyE/aILkCrACwX0sK7tnUjR5qb7EH4opBGleQo5HF71OFA
         dhBcqMKWliRHGGvVZScNhIw2E+apNQc9LugWI5t4+Wp5VhqNQc0D80rkWzHnC4HtiR
         epJAPCEV25clgDFiWtlwBOsz5D76jUlmHhx9FPFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 081/191] PCI/ERR: Use slot reset if available
Date:   Sat,  9 Nov 2019 21:38:23 -0500
Message-Id: <20191110024013.29782-81-sashal@kernel.org>
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

[ Upstream commit c4eed62a214330908eec11b0dc170d34fa50b412 ]

The secondary bus reset may have link side effects that a hotplug capable
port may incorrectly react to.  Use the slot specific reset for hotplug
ports, fixing the undesirable link down-up handling during error
recovering.

Signed-off-by: Keith Busch <keith.busch@intel.com>
[bhelgaas: fold in
https://lore.kernel.org/linux-pci/20180926152326.14821-1-keith.busch@intel.com
for issue reported by Stephen Rothwell <sfr@canb.auug.org.au>]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c      | 37 +++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h      |  2 ++
 drivers/pci/pcie/aer.c |  2 +-
 drivers/pci/pcie/err.c |  2 +-
 drivers/pci/slot.c     |  1 -
 5 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2baf1f82f8933..c9f51fc24563c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -35,6 +35,8 @@
 #include <linux/aer.h>
 #include "pci.h"
 
+DEFINE_MUTEX(pci_slot_mutex);
+
 const char *pci_power_names[] = {
 	"error", "D0", "D1", "D2", "D3hot", "D3cold", "unknown",
 };
@@ -5191,6 +5193,41 @@ static int pci_bus_reset(struct pci_bus *bus, int probe)
 	return ret;
 }
 
+/**
+ * pci_bus_error_reset - reset the bridge's subordinate bus
+ * @bridge: The parent device that connects to the bus to reset
+ *
+ * This function will first try to reset the slots on this bus if the method is
+ * available. If slot reset fails or is not available, this will fall back to a
+ * secondary bus reset.
+ */
+int pci_bus_error_reset(struct pci_dev *bridge)
+{
+	struct pci_bus *bus = bridge->subordinate;
+	struct pci_slot *slot;
+
+	if (!bus)
+		return -ENOTTY;
+
+	mutex_lock(&pci_slot_mutex);
+	if (list_empty(&bus->slots))
+		goto bus_reset;
+
+	list_for_each_entry(slot, &bus->slots, list)
+		if (pci_probe_reset_slot(slot))
+			goto bus_reset;
+
+	list_for_each_entry(slot, &bus->slots, list)
+		if (pci_slot_reset(slot, 0))
+			goto bus_reset;
+
+	mutex_unlock(&pci_slot_mutex);
+	return 0;
+bus_reset:
+	mutex_unlock(&pci_slot_mutex);
+	return pci_bus_reset(bridge->subordinate, 0);
+}
+
 /**
  * pci_probe_reset_bus - probe whether a PCI bus can be reset
  * @bus: PCI bus to probe
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index ab25752f00d96..e9ede82ee2c25 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -35,6 +35,7 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vmai,
 
 int pci_probe_reset_function(struct pci_dev *dev);
 int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
+int pci_bus_error_reset(struct pci_dev *dev);
 
 /**
  * struct pci_platform_pm_ops - Firmware PM callbacks
@@ -136,6 +137,7 @@ static inline void pci_remove_legacy_files(struct pci_bus *bus) { return; }
 
 /* Lock for read/write access to pci device and bus lists */
 extern struct rw_semaphore pci_bus_sem;
+extern struct mutex pci_slot_mutex;
 
 extern raw_spinlock_t pci_lock;
 
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 5c3ea7254c6ae..1563e22600eca 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1528,7 +1528,7 @@ static pci_ers_result_t aer_root_reset(struct pci_dev *dev)
 	reg32 &= ~ROOT_PORT_INTR_ON_MESG_MASK;
 	pci_write_config_dword(dev, pos + PCI_ERR_ROOT_COMMAND, reg32);
 
-	rc = pci_bridge_secondary_bus_reset(dev);
+	rc = pci_bus_error_reset(dev);
 	pci_printk(KERN_DEBUG, dev, "Root Port link has been reset\n");
 
 	/* Clear Root Error Status */
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 708fd3a0d6466..12c1205e1d804 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -177,7 +177,7 @@ static pci_ers_result_t default_reset_link(struct pci_dev *dev)
 {
 	int rc;
 
-	rc = pci_bridge_secondary_bus_reset(dev);
+	rc = pci_bus_error_reset(dev);
 	pci_printk(KERN_DEBUG, dev, "downstream link has been reset\n");
 	return rc ? PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_RECOVERED;
 }
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index e634229ece895..a32897f83ee51 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -14,7 +14,6 @@
 
 struct kset *pci_slots_kset;
 EXPORT_SYMBOL_GPL(pci_slots_kset);
-static DEFINE_MUTEX(pci_slot_mutex);
 
 static ssize_t pci_slot_attr_show(struct kobject *kobj,
 					struct attribute *attr, char *buf)
-- 
2.20.1

