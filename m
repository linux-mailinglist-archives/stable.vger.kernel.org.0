Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BDAF641A
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfKJC5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:57:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbfKJC4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8FAD222C5;
        Sun, 10 Nov 2019 02:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354064;
        bh=UwLXFne5zF+yoIN2n+oORAiSDjx98eG7FobzA3nIJFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxW7dy1KvnMbpzcffg3Bl/Bdf+RfbOiooTki9J17u6JlTJDIpLR8mYCz9DsTKJ9+O
         hgiVTjA4mY02Of6hwWT4hIgMM/2vElqX9HddWY81p6wvltvpSgUbLgQFWMP4mt7bm4
         05W2HCdoW5Lok6qzX5qTjjEIUPEmPBcBonNvBo+U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Gage Eads <gage.eads@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 070/109] vfio/pci: Mask buggy SR-IOV VF INTx support
Date:   Sat,  9 Nov 2019 21:45:02 -0500
Message-Id: <20191110024541.31567-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit db04264fe9bc0f2b62e036629f9afb530324b693 ]

The SR-IOV spec requires that VFs must report zero for the INTx pin
register as VFs are precluded from INTx support.  It's much easier for
the host kernel to understand whether a device is a VF and therefore
whether a non-zero pin register value is bogus than it is to do the
same in userspace.  Override the INTx count for such devices and
virtualize the pin register to provide a consistent view of the device
to the user.

As this is clearly a spec violation, warn about it to support hardware
validation, but also provide a known whitelist as it doesn't do much
good to continue complaining if the hardware vendor doesn't plan to
fix it.

Known devices with this issue: 8086:270c

Tested-by: Gage Eads <gage.eads@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c        |  8 ++++++--
 drivers/vfio/pci/vfio_pci_config.c | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 15b1cd4ef5a77..9bd3e7911af2b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -433,10 +433,14 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
 		u8 pin;
+
+		if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) ||
+		    vdev->nointx || vdev->pdev->is_virtfn)
+			return 0;
+
 		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
-		if (IS_ENABLED(CONFIG_VFIO_PCI_INTX) && !vdev->nointx && pin)
-			return 1;
 
+		return pin ? 1 : 0;
 	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
 		u8 pos;
 		u16 flags;
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 62023b4a373b4..423ea1f98441a 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1611,6 +1611,15 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 	return 0;
 }
 
+/*
+ * Nag about hardware bugs, hopefully to have vendors fix them, but at least
+ * to collect a list of dependencies for the VF INTx pin quirk below.
+ */
+static const struct pci_device_id known_bogus_vf_intx_pin[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x270c) },
+	{}
+};
+
 /*
  * For each device we allocate a pci_config_map that indicates the
  * capability occupying each dword and thus the struct perm_bits we
@@ -1676,6 +1685,24 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 	if (pdev->is_virtfn) {
 		*(__le16 *)&vconfig[PCI_VENDOR_ID] = cpu_to_le16(pdev->vendor);
 		*(__le16 *)&vconfig[PCI_DEVICE_ID] = cpu_to_le16(pdev->device);
+
+		/*
+		 * Per SR-IOV spec rev 1.1, 3.4.1.18 the interrupt pin register
+		 * does not apply to VFs and VFs must implement this register
+		 * as read-only with value zero.  Userspace is not readily able
+		 * to identify whether a device is a VF and thus that the pin
+		 * definition on the device is bogus should it violate this
+		 * requirement.  We already virtualize the pin register for
+		 * other purposes, so we simply need to replace the bogus value
+		 * and consider VFs when we determine INTx IRQ count.
+		 */
+		if (vconfig[PCI_INTERRUPT_PIN] &&
+		    !pci_match_id(known_bogus_vf_intx_pin, pdev))
+			pci_warn(pdev,
+				 "Hardware bug: VF reports bogus INTx pin %d\n",
+				 vconfig[PCI_INTERRUPT_PIN]);
+
+		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
 	}
 
 	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)
-- 
2.20.1

