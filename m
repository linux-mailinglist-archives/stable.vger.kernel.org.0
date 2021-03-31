Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8F5344101
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhCVM36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhCVM3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AE8F6198E;
        Mon, 22 Mar 2021 12:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416193;
        bh=W61Iv9fzStpU4pWw0XNw7huQGzpR0gnjl9elH9Zq9No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0belnZVsJPA3WuDU24mtvdpuVbl7wcipZumgcs7inJIeisQaAlrfILTkskhxRh5M
         T9YwPMuoLqTAyo8O9eEwzXZdhfvX9I3Z7K9KqhAyCusKk3V8sOhJvhfD4p8aY9dAmD
         6sJjrr6usDE9W3RkK1wTY+IQWVX0DH/Mpuksd7ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.11 015/120] s390/pci: fix leak of PCI device structure
Date:   Mon, 22 Mar 2021 13:26:38 +0100
Message-Id: <20210322121930.173763816@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 0b13525c20febcfecccf6fc1db5969727401317d upstream.

In commit 05bc1be6db4b2 ("s390/pci: create zPCI bus") we removed the
pci_dev_put() call matching the earlier pci_get_slot() done as part of
__zpci_event_availability(). This was based on the wrong understanding
that the device_put() done as part of pci_destroy_device() would counter
the pci_get_slot() when it only counters the initial reference. This
same understanding and existing bad example also lead to not doing
a pci_dev_put() in zpci_remove_device().

Since releasing the PCI devices, unlike releasing the PCI slot, does not
print any debug message for testing I added one in pci_release_dev().
This revealed that we are indeed leaking the PCI device on PCI
hotunplug. Further testing also revealed another missing pci_dev_put() in
disable_slot().

Fix this by adding the missing pci_dev_put() in disable_slot() and fix
zpci_remove_device() with the correct pci_dev_put() calls. Also instead
of calling pci_get_slot() in __zpci_event_availability() to determine if
a PCI device is registered and then doing the same again in
zpci_remove_device() do this once in zpci_remove_device() which makes
sure that the pdev in __zpci_event_availability() is only used for the
result of pci_scan_single_device() which does not need a reference count
decremnt as its ownership goes to the PCI bus.

Also move the check if zdev->zbus->bus is set into zpci_remove_device()
since it may be that we're removing a device with devfn != 0 which never
had a PCI bus. So we can still set the pdev->error_state to indicate
that the device is not usable anymore, add a flag to set the error state.

Fixes: 05bc1be6db4b2 ("s390/pci: create zPCI bus")
Cc: <stable@vger.kernel.org> # 5.8+: e1bff843cde6 s390/pci: remove superfluous zdev->zbus check
Cc: <stable@vger.kernel.org> # 5.8+: ba764dd703fe s390/pci: refactor zpci_create_device()
Cc: <stable@vger.kernel.org> # 5.8+
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pci.h        |    2 +-
 arch/s390/pci/pci.c                |   28 ++++++++++++++++++++++++----
 arch/s390/pci/pci_event.c          |   18 ++++++------------
 drivers/pci/hotplug/s390_pci_hpc.c |    3 ++-
 4 files changed, 33 insertions(+), 18 deletions(-)

--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -202,7 +202,7 @@ extern unsigned int s390_pci_no_rid;
 ----------------------------------------------------------------------------- */
 /* Base stuff */
 int zpci_create_device(u32 fid, u32 fh, enum zpci_state state);
-void zpci_remove_device(struct zpci_dev *zdev);
+void zpci_remove_device(struct zpci_dev *zdev, bool set_error);
 int zpci_enable_device(struct zpci_dev *);
 int zpci_disable_device(struct zpci_dev *);
 int zpci_register_ioat(struct zpci_dev *, u8, u64, u64, u64);
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -682,16 +682,36 @@ int zpci_disable_device(struct zpci_dev
 }
 EXPORT_SYMBOL_GPL(zpci_disable_device);
 
-void zpci_remove_device(struct zpci_dev *zdev)
+/* zpci_remove_device - Removes the given zdev from the PCI core
+ * @zdev: the zdev to be removed from the PCI core
+ * @set_error: if true the device's error state is set to permanent failure
+ *
+ * Sets a zPCI device to a configured but offline state; the zPCI
+ * device is still accessible through its hotplug slot and the zPCI
+ * API but is removed from the common code PCI bus, making it
+ * no longer available to drivers.
+ */
+void zpci_remove_device(struct zpci_dev *zdev, bool set_error)
 {
 	struct zpci_bus *zbus = zdev->zbus;
 	struct pci_dev *pdev;
 
+	if (!zdev->zbus->bus)
+		return;
+
 	pdev = pci_get_slot(zbus->bus, zdev->devfn);
 	if (pdev) {
-		if (pdev->is_virtfn)
-			return zpci_iov_remove_virtfn(pdev, zdev->vfn);
+		if (set_error)
+			pdev->error_state = pci_channel_io_perm_failure;
+		if (pdev->is_virtfn) {
+			zpci_iov_remove_virtfn(pdev, zdev->vfn);
+			/* balance pci_get_slot */
+			pci_dev_put(pdev);
+			return;
+		}
 		pci_stop_and_remove_bus_device_locked(pdev);
+		/* balance pci_get_slot */
+		pci_dev_put(pdev);
 	}
 }
 
@@ -765,7 +785,7 @@ void zpci_release_device(struct kref *kr
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
 
 	if (zdev->zbus->bus)
-		zpci_remove_device(zdev);
+		zpci_remove_device(zdev, false);
 
 	switch (zdev->state) {
 	case ZPCI_FN_STATE_ONLINE:
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -76,13 +76,10 @@ void zpci_event_error(void *data)
 static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 {
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
-	struct pci_dev *pdev = NULL;
 	enum zpci_state state;
+	struct pci_dev *pdev;
 	int ret;
 
-	if (zdev && zdev->zbus->bus)
-		pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
-
 	zpci_err("avail CCDF:\n");
 	zpci_err_hex(ccdf, sizeof(*ccdf));
 
@@ -124,8 +121,7 @@ static void __zpci_event_availability(st
 	case 0x0303: /* Deconfiguration requested */
 		if (!zdev)
 			break;
-		if (pdev)
-			zpci_remove_device(zdev);
+		zpci_remove_device(zdev, false);
 
 		ret = zpci_disable_device(zdev);
 		if (ret)
@@ -140,12 +136,10 @@ static void __zpci_event_availability(st
 	case 0x0304: /* Configured -> Standby|Reserved */
 		if (!zdev)
 			break;
-		if (pdev) {
-			/* Give the driver a hint that the function is
-			 * already unusable. */
-			pdev->error_state = pci_channel_io_perm_failure;
-			zpci_remove_device(zdev);
-		}
+		/* Give the driver a hint that the function is
+		 * already unusable.
+		 */
+		zpci_remove_device(zdev, true);
 
 		zdev->fh = ccdf->fh;
 		zpci_disable_device(zdev);
--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -93,8 +93,9 @@ static int disable_slot(struct hotplug_s
 		pci_dev_put(pdev);
 		return -EBUSY;
 	}
+	pci_dev_put(pdev);
 
-	zpci_remove_device(zdev);
+	zpci_remove_device(zdev, false);
 
 	rc = zpci_disable_device(zdev);
 	if (rc)


