Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6534363DA
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhJUOQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 10:16:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8358 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230436AbhJUOQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 10:16:04 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEBLUm003611
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 10:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JzEV1xv2G75f0nofAxAXHxenJTgrisqC6Yax/iZU0H8=;
 b=mnKG2O+nYFkVorRaB3Qf0mIrl3RhAxR3hbd3nPXYFGQPFaEa+mKOO04BRDIdIQVtcS9m
 /nh3XmnC+REZ8LIeKR4NxKsZDNc5Ag9thpnzN1w/YvKyKj1vdy4zFPmfZEFnMuyxsQ7D
 ImhOUnrXijHwwpSGuvER7xjws7Ore7IAvoEdV4CY49B3f1ZZl3oDEeQM3S18OH8+HgeX
 FWJr1Pu5qO2UFld0JekQcoqs30l70O+IRSkTeSVkwaY9y3lRtnkT/hYxpL6p4+Lwmv1k
 sqEJIwRMmt6ju8Be4y4LK4IMLdM2NubmAbwrz2dVGDvfxrhfxelDPHXrRk/A4OpC3cjc BA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bu50vq7em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 10:13:47 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LE9kg8032550
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 14:13:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0kftqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 14:13:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LEDgS61966680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:13:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 889F8AE056;
        Thu, 21 Oct 2021 14:13:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70C7DAE063;
        Thu, 21 Oct 2021 14:13:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 14:13:42 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 5.14 2/2] s390/pci: fix zpci_zdev_put() on reserve
Date:   Thu, 21 Oct 2021 16:13:41 +0200
Message-Id: <20211021141341.344756-3-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211021141341.344756-1-schnelle@linux.ibm.com>
References: <20211021141341.344756-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BtQ8TOT1a8H9jSWwt5ZwEdwGSJ9n7Dtt
X-Proofpoint-GUID: BtQ8TOT1a8H9jSWwt5ZwEdwGSJ9n7Dtt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 mlxlogscore=970 malwarescore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/s390/include/asm/pci.h        |  2 ++
 arch/s390/pci/pci.c                | 45 ++++++++++++++++++++++++++----
 arch/s390/pci/pci_event.c          |  4 +--
 drivers/pci/hotplug/s390_pci_hpc.c |  9 +-----
 4 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 5509b224c2ec..abe4d45c2f47 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -207,6 +207,8 @@ int zpci_enable_device(struct zpci_dev *);
 int zpci_disable_device(struct zpci_dev *);
 int zpci_scan_configured_device(struct zpci_dev *zdev, u32 fh);
 int zpci_deconfigure_device(struct zpci_dev *zdev);
+void zpci_device_reserved(struct zpci_dev *zdev);
+bool zpci_is_device_configured(struct zpci_dev *zdev);
 
 int zpci_register_ioat(struct zpci_dev *, u8, u64, u64, u64);
 int zpci_unregister_ioat(struct zpci_dev *, u8);
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 5e234cb2ad7b..d7ef98218c80 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -92,7 +92,7 @@ void zpci_remove_reserved_devices(void)
 	spin_unlock(&zpci_list_lock);
 
 	list_for_each_entry_safe(zdev, tmp, &remove, entry)
-		zpci_zdev_put(zdev);
+		zpci_device_reserved(zdev);
 }
 
 int pci_domain_nr(struct pci_bus *bus)
@@ -744,6 +744,14 @@ struct zpci_dev *zpci_create_device(u32 fid, u32 fh, enum zpci_state state)
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
@@ -810,6 +818,31 @@ int zpci_deconfigure_device(struct zpci_dev *zdev)
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
@@ -829,6 +862,12 @@ void zpci_release_device(struct kref *kref)
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
@@ -837,10 +876,6 @@ void zpci_release_device(struct kref *kref)
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
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index cd447b96b4b1..9b26617ca1c5 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -137,7 +137,7 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 			/* The 0x0304 event may immediately reserve the device */
 			if (!clp_get_state(zdev->fid, &state) &&
 			    state == ZPCI_FN_STATE_RESERVED) {
-				zpci_zdev_put(zdev);
+				zpci_device_reserved(zdev);
 			}
 		}
 		break;
@@ -148,7 +148,7 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 	case 0x0308: /* Standby -> Reserved */
 		if (!zdev)
 			break;
-		zpci_zdev_put(zdev);
+		zpci_device_reserved(zdev);
 		break;
 	default:
 		break;
diff --git a/drivers/pci/hotplug/s390_pci_hpc.c b/drivers/pci/hotplug/s390_pci_hpc.c
index 014868752cd4..dcefdb42ac46 100644
--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -62,14 +62,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
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
 
-- 
2.25.1

