Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0CC43A346
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbhJYT5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237792AbhJYTzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B9E6128B;
        Mon, 25 Oct 2021 19:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191173;
        bh=tAo/38RwFtllXSV+2LKdqFpzuytjdSULH+TVJG7h+AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mlv5Iz3TPXs88uH3ZCKXP9eE5dzG7KYJVNkw83TamD6xRaFeeL/IiZUW+Xa5UNMFi
         FJ8hhrJXQ7XIKfK4JWYD0k3O6GN262rBCkJyjuIzuNK7Su1hl4DIay4FxdaVr9/l2e
         3D4mm+F5iTiBLCyvXU4zwxNRrjYnMG7x4ac4M+QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.14 163/169] s390/pci: fix zpci_zdev_put() on reserve
Date:   Mon, 25 Oct 2021 21:15:44 +0200
Message-Id: <20211025191038.094323581@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit a46044a92add6a400f4dada7b943b30221f7cc80 upstream.

Since commit 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
the reference count of a zpci_dev is incremented between
pcibios_add_device() and pcibios_release_device() which was supposed to
prevent the zpci_dev from being freed while the common PCI code has
access to it. It was missed however that the handling of zPCI
availability events assumed that once zpci_zdev_put() was called no
later availability event would still see the device. With the previously
mentioned commit however this assumption no longer holds and we must
make sure that we only drop the initial long-lived reference the zPCI
subsystem holds exactly once.

Do so by introducing a zpci_device_reserved() function that handles when
a device is reserved. Here we make sure the zpci_dev will not be
considered for further events by removing it from the zpci_list.

This also means that the device actually stays in the
ZPCI_FN_STATE_RESERVED state between the time we know it has been
reserved and the final reference going away. We thus need to consider it
a real state instead of just a conceptual state after the removal. The
final cleanup of PCI resources, removal from zbus, and destruction of
the IOMMU stays in zpci_release_device() to make sure holders of the
reference do see valid data until the release.

Fixes: 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pci.h        |    2 +
 arch/s390/pci/pci.c                |   45 ++++++++++++++++++++++++++++++++-----
 arch/s390/pci/pci_event.c          |    4 +--
 drivers/pci/hotplug/s390_pci_hpc.c |    9 -------
 4 files changed, 45 insertions(+), 15 deletions(-)

--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -207,6 +207,8 @@ int zpci_enable_device(struct zpci_dev *
 int zpci_disable_device(struct zpci_dev *);
 int zpci_scan_configured_device(struct zpci_dev *zdev, u32 fh);
 int zpci_deconfigure_device(struct zpci_dev *zdev);
+void zpci_device_reserved(struct zpci_dev *zdev);
+bool zpci_is_device_configured(struct zpci_dev *zdev);
 
 int zpci_register_ioat(struct zpci_dev *, u8, u64, u64, u64);
 int zpci_unregister_ioat(struct zpci_dev *, u8);
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -92,7 +92,7 @@ void zpci_remove_reserved_devices(void)
 	spin_unlock(&zpci_list_lock);
 
 	list_for_each_entry_safe(zdev, tmp, &remove, entry)
-		zpci_zdev_put(zdev);
+		zpci_device_reserved(zdev);
 }
 
 int pci_domain_nr(struct pci_bus *bus)
@@ -744,6 +744,14 @@ error:
 	return ERR_PTR(rc);
 }
 
+bool zpci_is_device_configured(struct zpci_dev *zdev)
+{
+	enum zpci_state state = zdev->state;
+
+	return state != ZPCI_FN_STATE_RESERVED &&
+		state != ZPCI_FN_STATE_STANDBY;
+}
+
 /**
  * zpci_scan_configured_device() - Scan a freshly configured zpci_dev
  * @zdev: The zpci_dev to be configured
@@ -810,6 +818,31 @@ int zpci_deconfigure_device(struct zpci_
 	return 0;
 }
 
+/**
+ * zpci_device_reserved() - Mark device as resverved
+ * @zdev: the zpci_dev that was reserved
+ *
+ * Handle the case that a given zPCI function was reserved by another system.
+ * After a call to this function the zpci_dev can not be found via
+ * get_zdev_by_fid() anymore but may still be accessible via existing
+ * references though it will not be functional anymore.
+ */
+void zpci_device_reserved(struct zpci_dev *zdev)
+{
+	if (zdev->has_hp_slot)
+		zpci_exit_slot(zdev);
+	/*
+	 * Remove device from zpci_list as it is going away. This also
+	 * makes sure we ignore subsequent zPCI events for this device.
+	 */
+	spin_lock(&zpci_list_lock);
+	list_del(&zdev->entry);
+	spin_unlock(&zpci_list_lock);
+	zdev->state = ZPCI_FN_STATE_RESERVED;
+	zpci_dbg(3, "rsv fid:%x\n", zdev->fid);
+	zpci_zdev_put(zdev);
+}
+
 void zpci_release_device(struct kref *kref)
 {
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
@@ -829,6 +862,12 @@ void zpci_release_device(struct kref *kr
 	case ZPCI_FN_STATE_STANDBY:
 		if (zdev->has_hp_slot)
 			zpci_exit_slot(zdev);
+		spin_lock(&zpci_list_lock);
+		list_del(&zdev->entry);
+		spin_unlock(&zpci_list_lock);
+		zpci_dbg(3, "rsv fid:%x\n", zdev->fid);
+		fallthrough;
+	case ZPCI_FN_STATE_RESERVED:
 		if (zdev->has_resources)
 			zpci_cleanup_bus_resources(zdev);
 		zpci_bus_device_unregister(zdev);
@@ -837,10 +876,6 @@ void zpci_release_device(struct kref *kr
 	default:
 		break;
 	}
-
-	spin_lock(&zpci_list_lock);
-	list_del(&zdev->entry);
-	spin_unlock(&zpci_list_lock);
 	zpci_dbg(3, "rem fid:%x\n", zdev->fid);
 	kfree(zdev);
 }
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -137,7 +137,7 @@ static void __zpci_event_availability(st
 			/* The 0x0304 event may immediately reserve the device */
 			if (!clp_get_state(zdev->fid, &state) &&
 			    state == ZPCI_FN_STATE_RESERVED) {
-				zpci_zdev_put(zdev);
+				zpci_device_reserved(zdev);
 			}
 		}
 		break;
@@ -148,7 +148,7 @@ static void __zpci_event_availability(st
 	case 0x0308: /* Standby -> Reserved */
 		if (!zdev)
 			break;
-		zpci_zdev_put(zdev);
+		zpci_device_reserved(zdev);
 		break;
 	default:
 		break;
--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -62,14 +62,7 @@ static int get_power_status(struct hotpl
 	struct zpci_dev *zdev = container_of(hotplug_slot, struct zpci_dev,
 					     hotplug_slot);
 
-	switch (zdev->state) {
-	case ZPCI_FN_STATE_STANDBY:
-		*value = 0;
-		break;
-	default:
-		*value = 1;
-		break;
-	}
+	*value = zpci_is_device_configured(zdev) ? 1 : 0;
 	return 0;
 }
 


