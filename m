Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4577A101543
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfKSFmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfKSFmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E3B021939;
        Tue, 19 Nov 2019 05:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142132;
        bh=mGjPsR67NsH8i4TW2u6yaW2jdVFRvrQWuhjdjIqqxIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ar/2B6nyO3Ejj/HBcGWJLfZrLf55mhVaYUhacaXgIfUgdEWRG+ZLFYQxBgTXRu8dV
         PWw3fX7fhGuM4TvRrRfpbqRxI/8RkPXGeMLLLrfEilqewk6WrZ7qE1VWN2c4F8TCIM
         /2wu0kOxWcvfGwxvmB8BCZSn6lr8D5S9xYvfuZw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gage Eads <gage.eads@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 359/422] vfio/pci: Mask buggy SR-IOV VF INTx support
Date:   Tue, 19 Nov 2019 06:19:16 +0100
Message-Id: <20191119051422.279151732@linuxfoundation.org>
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
index a92c2868d9021..0a6eb53e79fbf 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -443,10 +443,14 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
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



