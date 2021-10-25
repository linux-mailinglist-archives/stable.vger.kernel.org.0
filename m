Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B603F4391E7
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 11:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhJYJC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 05:02:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33166 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232153AbhJYJCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 05:02:54 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P850k0016290
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 05:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=C2B7p6zkd+DFcDQG3rtlnO1FqJTa3+HJlQw9WwtfLLw=;
 b=WywbaqlmQUldzyPwqjiKqv+UyNqB+PjHX2VPza72Sd+DzF4HJvSLc4eiyR4I6FbfSmHX
 0KhutpU32aP7mmkhhUS4UG5TeWFVwMsY5/NwZu7urLZoyPXEyOaGBmzvvBLFp0Dd5ZBL
 c+tbJBWXCID4L8iJ5TRyNUAjcSsqjNwWcr/TTr9NMJ91VoC2eGY6fWGDkwVTysIykDCH
 y+mZYvH7KDAMI5a3F9R978z2LQRaDbH5xnbH9NAUA/I+bzEFa/4X0W1rDjNHIb510ilq
 7cDyl7dOALLSVACKIyR76UOjX/fE4t8uFr+9HPEq0s3n3j620slZx8h2TlZNez3IMhYB ww== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvyuyvvmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 05:00:32 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P8wlx9015603
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 09:00:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3bva1929tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 09:00:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P8sLXg57410004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 08:54:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7D3A42056;
        Mon, 25 Oct 2021 09:00:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97F1F4203F;
        Mon, 25 Oct 2021 09:00:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:00:26 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 5.10 1/1] s390/pci: fix zpci_zdev_put() on reserve
Date:   Mon, 25 Oct 2021 11:00:26 +0200
Message-Id: <20211025090026.3392254-2-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025090026.3392254-1-schnelle@linux.ibm.com>
References: <20211025090026.3392254-1-schnelle@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: siABMJXOb1meDQ_AJoYam7q7JpQc-7qw
X-Proofpoint-ORIG-GUID: siABMJXOb1meDQ_AJoYam7q7JpQc-7qw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=997 suspectscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250050
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
Link: https://lore.kernel.org/r/20211012093425.2247924-1-schnelle@linux.ibm.com
---
 arch/s390/include/asm/pci.h        |  3 ++
 arch/s390/pci/pci.c                | 45 ++++++++++++++++++++++++++----
 arch/s390/pci/pci_event.c          |  4 +--
 drivers/pci/hotplug/s390_pci_hpc.c |  9 +-----
 4 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index a75d94a9bcb2..1226971533fe 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -205,6 +205,9 @@ int zpci_create_device(u32 fid, u32 fh, enum zpci_state state);
 void zpci_remove_device(struct zpci_dev *zdev, bool set_error);
 int zpci_enable_device(struct zpci_dev *);
 int zpci_disable_device(struct zpci_dev *);
+void zpci_device_reserved(struct zpci_dev *zdev);
+bool zpci_is_device_configured(struct zpci_dev *zdev);
+
 int zpci_register_ioat(struct zpci_dev *, u8, u64, u64, u64);
 int zpci_unregister_ioat(struct zpci_dev *, u8);
 void zpci_remove_reserved_devices(void);
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index f5ddbc625c1a..e14e4a3a647a 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -92,7 +92,7 @@ void zpci_remove_reserved_devices(void)
 	spin_unlock(&zpci_list_lock);
 
 	list_for_each_entry_safe(zdev, tmp, &remove, entry)
-		zpci_zdev_put(zdev);
+		zpci_device_reserved(zdev);
 }
 
 int pci_domain_nr(struct pci_bus *bus)
@@ -787,6 +787,39 @@ int zpci_create_device(u32 fid, u32 fh, enum zpci_state state)
 	return rc;
 }
 
+bool zpci_is_device_configured(struct zpci_dev *zdev)
+{
+	enum zpci_state state = zdev->state;
+
+	return state != ZPCI_FN_STATE_RESERVED &&
+		state != ZPCI_FN_STATE_STANDBY;
+}
+
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
@@ -802,6 +835,12 @@ void zpci_release_device(struct kref *kref)
 	case ZPCI_FN_STATE_STANDBY:
 		if (zdev->has_hp_slot)
 			zpci_exit_slot(zdev);
+		spin_lock(&zpci_list_lock);
+		list_del(&zdev->entry);
+		spin_unlock(&zpci_list_lock);
+		zpci_dbg(3, "rsv fid:%x\n", zdev->fid);
+		fallthrough;
+	case ZPCI_FN_STATE_RESERVED:
 		zpci_cleanup_bus_resources(zdev);
 		zpci_bus_device_unregister(zdev);
 		zpci_destroy_iommu(zdev);
@@ -809,10 +848,6 @@ void zpci_release_device(struct kref *kref)
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
index ac0c65cdd69d..b7cfde7e80a8 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -146,7 +146,7 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 		zdev->state = ZPCI_FN_STATE_STANDBY;
 		if (!clp_get_state(ccdf->fid, &state) &&
 		    state == ZPCI_FN_STATE_RESERVED) {
-			zpci_zdev_put(zdev);
+			zpci_device_reserved(zdev);
 		}
 		break;
 	case 0x0306: /* 0x308 or 0x302 for multiple devices */
@@ -156,7 +156,7 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 	case 0x0308: /* Standby -> Reserved */
 		if (!zdev)
 			break;
-		zpci_zdev_put(zdev);
+		zpci_device_reserved(zdev);
 		break;
 	default:
 		break;
diff --git a/drivers/pci/hotplug/s390_pci_hpc.c b/drivers/pci/hotplug/s390_pci_hpc.c
index a047c421debe..93174f503464 100644
--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -109,14 +109,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
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

