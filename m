Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C756224F423
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgHXIdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgHXIdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9DAB2075B;
        Mon, 24 Aug 2020 08:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257988;
        bh=QJLhiFmJ71vUErRmLcFAlu87A3wqfJJDi4vY+KMfxTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMMpJEtwAy1kG5h7sqH6fF9OHrzV7VxV1DpbsiNF6iRXnp+Cvw4Ki3Qn02rocxqHq
         YrSfyLMuWBbejGMmOpBn0iDPbVmBP77vt6I5ivfZ5r8CH8YmFufPmgH2eJb5cBaWyb
         FlIX1RXM9/dtvrgdiVIMD95n51pRyKhdvQaEAh8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.8 033/148] s390/pci: fix PF/VF linking on hot plug
Date:   Mon, 24 Aug 2020 10:28:51 +0200
Message-Id: <20200824082415.591014237@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit b97bf44f99155e57088e16974afb1f2d7b5287aa upstream.

Currently there are four places in which a PCI function is scanned
and made available to drivers:
 1. In pci_scan_root_bus() as part of the initial zbus
    creation.
 2. In zpci_bus_add_devices() when registering
    a device in configured state on a zbus that has already been
    scanned.
 3. When a function is already known to zPCI (in reserved/standby state)
    and configuration is triggered through firmware by PEC 0x301.
 4. When a device is already known to zPCI (in standby/reserved state)
    and configuration is triggered from within Linux using
    enable_slot().

The PF/VF linking step and setting of pdev->is_virtfn introduced with
commit e5794cf1a270 ("s390/pci: create links between PFs and VFs") was
only triggered for the second case, which is where VFs created through
sriov_numvfs usually land. However unlike some other platforms but like
POWER VFs can be individually enabled/disabled through
/sys/bus/pci/slots.

Fix this by doing VF setup as part of pcibios_bus_add_device() which is
called in all of the above cases.

Finally to remove the PF/VF links call the common code
pci_iov_remove_virtfn() function to remove linked VFs.
This takes care of the necessary sysfs cleanup.

Fixes: e5794cf1a270 ("s390/pci: create links between PFs and VFs")
Cc: <stable@vger.kernel.org> # 5.8: 2f0230b2f2d5: s390/pci: re-introduce zpci_remove_device()
Cc: <stable@vger.kernel.org> # 5.8
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/pci/pci.c     |    5 ++++-
 arch/s390/pci/pci_bus.c |   27 +++++++++++++++------------
 arch/s390/pci/pci_bus.h |   13 +++++++++++++
 3 files changed, 32 insertions(+), 13 deletions(-)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -678,8 +678,11 @@ void zpci_remove_device(struct zpci_dev
 	struct pci_dev *pdev;
 
 	pdev = pci_get_slot(zbus->bus, zdev->devfn);
-	if (pdev)
+	if (pdev) {
+		if (pdev->is_virtfn)
+			return zpci_remove_virtfn(pdev, zdev->vfn);
 		pci_stop_and_remove_bus_device_locked(pdev);
+	}
 }
 
 int zpci_create_device(struct zpci_dev *zdev)
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -189,6 +189,19 @@ static inline int zpci_bus_setup_virtfn(
 }
 #endif
 
+void pcibios_bus_add_device(struct pci_dev *pdev)
+{
+	struct zpci_dev *zdev = to_zpci(pdev);
+
+	/*
+	 * With pdev->no_vf_scan the common PCI probing code does not
+	 * perform PF/VF linking.
+	 */
+	if (zdev->vfn)
+		zpci_bus_setup_virtfn(zdev->zbus, pdev, zdev->vfn);
+
+}
+
 static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
 {
 	struct pci_bus *bus;
@@ -219,20 +232,10 @@ static int zpci_bus_add_device(struct zp
 	}
 
 	pdev = pci_scan_single_device(bus, zdev->devfn);
-	if (pdev) {
-		if (!zdev->is_physfn) {
-			rc = zpci_bus_setup_virtfn(zbus, pdev, zdev->vfn);
-			if (rc)
-				goto failed_with_pdev;
-		}
+	if (pdev)
 		pci_bus_add_device(pdev);
-	}
-	return 0;
 
-failed_with_pdev:
-	pci_stop_and_remove_bus_device(pdev);
-	pci_dev_put(pdev);
-	return rc;
+	return 0;
 }
 
 static void zpci_bus_add_devices(struct zpci_bus *zbus)
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -29,3 +29,16 @@ static inline struct zpci_dev *get_zdev_
 
 	return (devfn >= ZPCI_FUNCTIONS_PER_BUS) ? NULL : zbus->function[devfn];
 }
+
+#ifdef CONFIG_PCI_IOV
+static inline void zpci_remove_virtfn(struct pci_dev *pdev, int vfn)
+{
+
+	pci_lock_rescan_remove();
+	/* Linux' vfid's start at 0 vfn at 1 */
+	pci_iov_remove_virtfn(pdev->physfn, vfn - 1);
+	pci_unlock_rescan_remove();
+}
+#else /* CONFIG_PCI_IOV */
+static inline void zpci_remove_virtfn(struct pci_dev *pdev, int vfn) {}
+#endif /* CONFIG_PCI_IOV */


