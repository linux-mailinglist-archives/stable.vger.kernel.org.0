Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3E8490D30
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241697AbiAQRBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbiAQRAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:00:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC26EC06175F;
        Mon, 17 Jan 2022 09:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EEA2611C6;
        Mon, 17 Jan 2022 17:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF52BC36AE3;
        Mon, 17 Jan 2022 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438827;
        bh=NqR7yKJSns1WI91EqrzghJUPndY75hkCqkC8BO4I9k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4wm9NDIDbswv0cW+zBTKvaQSrpTypW8Yi7pycn7Sy18MzafU2Nk4II9nr4p56buZ
         f1TTiFl5NDGr8jsMnYqz8OLleBYgIN2lEaso3mD+RMrt3SMd5ZyDfnJVdB7k8UQ6si
         aHrmDxMx9SRbcmBdCyWJYFGonWZBPR7D1Qyrxb6gjPfS8AFXi9k1q/VnRRQJeBCZMx
         yOlqxWvvouMWLruvdQdGBk9kuRiWH5AlaTeCWNw41jYnIhTKdUHVQiKBIBnzeiFxgV
         EMdoltz+cHVmkXhYWdPWnZzs3JMdm4UbGQvCcgjPxCiPnh4gwSlZknRY3/JHPZ21O/
         dT1loM0nVjw9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, Nishanth Menon <nm@ti.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 36/52] PCI/MSI: Decouple MSI[-X] disable from pcim_release()
Date:   Mon, 17 Jan 2022 11:58:37 -0500
Message-Id: <20220117165853.1470420-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 3f35d2cf9fbc656db82579d849cc69c373b1ad0d ]

The MSI core will introduce runtime allocation of MSI related data. This
data will be devres managed and has to be set up before enabling
PCI/MSI[-X]. This would introduce an ordering issue vs. pcim_release().

The setup order is:

   pcim_enable_device()
	devres_alloc(pcim_release...);
	...
	pci_irq_alloc()
	  msi_setup_device_data()
	     devres_alloc(msi_device_data_release, ...)

and once the device is released these release functions are invoked in the
opposite order:

    msi_device_data_release()
    ...
    pcim_release()
       pci_disable_msi[x]()

which is obviously wrong, because pci_disable_msi[x]() requires the MSI
data to be available to tear down the MSI[-X] interrupts.

Remove the MSI[-X] teardown from pcim_release() and add an explicit action
to be installed on the attempt of enabling PCI/MSI[-X].

This allows the MSI core data allocation to be ordered correctly in a
subsequent step.

Reported-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Tested-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/87tuf9rdoj.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/msi.c   | 33 +++++++++++++++++++++++++++++++++
 drivers/pci/pci.c   |  5 -----
 include/linux/pci.h |  3 ++-
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d84cf30bb2790..1093f099846eb 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -461,6 +461,31 @@ void pci_restore_msi_state(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_restore_msi_state);
 
+static void pcim_msi_release(void *pcidev)
+{
+	struct pci_dev *dev = pcidev;
+
+	dev->is_msi_managed = false;
+	pci_free_irq_vectors(dev);
+}
+
+/*
+ * Needs to be separate from pcim_release to prevent an ordering problem
+ * vs. msi_device_data_release() in the MSI core code.
+ */
+static int pcim_setup_msi_release(struct pci_dev *dev)
+{
+	int ret;
+
+	if (!pci_is_managed(dev) || dev->is_msi_managed)
+		return 0;
+
+	ret = devm_add_action(&dev->dev, pcim_msi_release, dev);
+	if (!ret)
+		dev->is_msi_managed = true;
+	return ret;
+}
+
 static struct msi_desc *
 msi_setup_entry(struct pci_dev *dev, int nvec, struct irq_affinity *affd)
 {
@@ -1029,6 +1054,10 @@ static int __pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec,
 	if (nvec > maxvec)
 		nvec = maxvec;
 
+	rc = pcim_setup_msi_release(dev);
+	if (rc)
+		return rc;
+
 	for (;;) {
 		if (affd) {
 			nvec = irq_calc_affinity_vectors(minvec, nvec, affd);
@@ -1072,6 +1101,10 @@ static int __pci_enable_msix_range(struct pci_dev *dev,
 	if (WARN_ON_ONCE(dev->msix_enabled))
 		return -EINVAL;
 
+	rc = pcim_setup_msi_release(dev);
+	if (rc)
+		return rc;
+
 	for (;;) {
 		if (affd) {
 			nvec = irq_calc_affinity_vectors(minvec, nvec, affd);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3d2fb394986a4..f3f606c232a8a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2024,11 +2024,6 @@ static void pcim_release(struct device *gendev, void *res)
 	struct pci_devres *this = res;
 	int i;
 
-	if (dev->msi_enabled)
-		pci_disable_msi(dev);
-	if (dev->msix_enabled)
-		pci_disable_msix(dev);
-
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
 		if (this->region_mask & (1 << i))
 			pci_release_region(dev, i);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 18a75c8e615cd..e26000404e3c3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -425,7 +425,8 @@ struct pci_dev {
 	unsigned int	ats_enabled:1;		/* Address Translation Svc */
 	unsigned int	pasid_enabled:1;	/* Process Address Space ID */
 	unsigned int	pri_enabled:1;		/* Page Request Interface */
-	unsigned int	is_managed:1;
+	unsigned int	is_managed:1;		/* Managed via devres */
+	unsigned int	is_msi_managed:1;	/* MSI release via devres installed */
 	unsigned int	needs_freset:1;		/* Requires fundamental reset */
 	unsigned int	state_saved:1;
 	unsigned int	is_physfn:1;
-- 
2.34.1

