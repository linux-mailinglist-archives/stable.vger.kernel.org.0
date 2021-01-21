Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9A12FE3CD
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 08:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbhAUHVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 02:21:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23472 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727315AbhAUHVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 02:21:11 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L73L2M143105;
        Thu, 21 Jan 2021 02:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=wS5GBDEocZ11XduwRcOrqMr8dN0POeiBwMSExeOtEio=;
 b=ckOqnqFdrmQ0Dt9iHEsgmSl1Gzrx6jAHvvigRcwND3AzaIuCMM/0dsieBl3PNk1r1DDW
 ehEL1UbM+oLa+KGVaTYwwpkneV0Z2SPFS7hXC6ybn/KtPu5vL8MZgz4yhci5Rr0qX02u
 I+p41DCXGsJA8+rmYKZkS3MS1rF+hnY8f9uG0YZhwnURYruk++T3/9ZjW6AMZa/B8uKY
 1Wmw6xvTPAAatNyc1ZYkzrSgcyY3/0xVaMSkM+4qmDeiBwz+uKAvA75IAioACI2l8tmM
 YEcYHfI0Qp0nLVcVc8ZDA0WacnkNy6OiwUej0sNKaw7IY0SC81SpxUw7bpSgvqpW5TDm 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3674kgrv1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 02:20:24 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L73O53143172;
        Thu, 21 Jan 2021 02:20:23 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3674kgrv18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 02:20:23 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L7IsDh023437;
        Thu, 21 Jan 2021 07:20:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwsd8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 07:20:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L7KIBJ38011306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 07:20:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9701111C06C;
        Thu, 21 Jan 2021 07:20:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1946B11C04A;
        Thu, 21 Jan 2021 07:20:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 07:20:18 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, stable@vger.kernel.org,
        Pierre Morel <pmorel@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com
Subject: [PATCH 1/1] s390/vfio-ap: No need to disable IRQ after queue reset
Date:   Thu, 21 Jan 2021 08:20:08 +0100
Message-Id: <20210121072008.76523-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_03:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210035
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

The queues assigned to a matrix mediated device are currently reset when:

* The VFIO_DEVICE_RESET ioctl is invoked
* The mdev fd is closed by userspace (QEMU)
* The mdev is removed from sysfs.

Immediately after the reset of a queue, a call is made to disable
interrupts for the queue. This is entirely unnecessary because the reset of
a queue disables interrupts, so this will be removed.

Furthermore, vfio_ap_irq_disable() does an unconditional PQAP/AQIC which
can result in a specification exception (when the corresponding facility
is not available), so this is actually a bugfix.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
[pasic@linux.ibm.com: minor rework before merging]
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: ec89b55e3bce ("s390: ap: implement PAPQ AQIC interception in kernel")
Cc: <stable@vger.kernel.org>

---

Since it turned out disabling the interrupts via PQAP/AQIC is not only
unnecesary but also buggy, we decided to put this patch, which
used to be apart of the series https://lkml.org/lkml/2020/12/22/757 on the fast
lane.

If the backports turn out to be a bother, which I hope won't be the case
not, I am happy to help with those.

---
 drivers/s390/crypto/vfio_ap_drv.c     |   6 +-
 drivers/s390/crypto/vfio_ap_ops.c     | 100 ++++++++++++++++----------
 drivers/s390/crypto/vfio_ap_private.h |  12 ++--
 3 files changed, 69 insertions(+), 49 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index be2520cc010b..7dc72cb718b0 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -71,15 +71,11 @@ static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
 static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 {
 	struct vfio_ap_queue *q;
-	int apid, apqi;
 
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&apdev->device);
+	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
-	apid = AP_QID_CARD(q->apqn);
-	apqi = AP_QID_QUEUE(q->apqn);
-	vfio_ap_mdev_reset_queue(apid, apqi, 1);
-	vfio_ap_irq_disable(q);
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..7ceb6c433b3b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -25,6 +25,7 @@
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
+static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 
 static int match_apqn(struct device *dev, const void *data)
 {
@@ -49,20 +50,15 @@ static struct vfio_ap_queue *vfio_ap_get_queue(
 					int apqn)
 {
 	struct vfio_ap_queue *q;
-	struct device *dev;
 
 	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
 		return NULL;
 	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
 		return NULL;
 
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (!dev)
-		return NULL;
-	q = dev_get_drvdata(dev);
-	q->matrix_mdev = matrix_mdev;
-	put_device(dev);
+	q = vfio_ap_find_queue(apqn);
+	if (q)
+		q->matrix_mdev = matrix_mdev;
 
 	return q;
 }
@@ -119,13 +115,18 @@ static void vfio_ap_wait_for_irqclear(int apqn)
  */
 static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
 {
-	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
+	if (!q)
+		return;
+	if (q->saved_isc != VFIO_AP_ISC_INVALID &&
+	    !WARN_ON(!(q->matrix_mdev && q->matrix_mdev->kvm))) {
 		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
-	if (q->saved_pfn && q->matrix_mdev)
+		q->saved_isc = VFIO_AP_ISC_INVALID;
+	}
+	if (q->saved_pfn && !WARN_ON(!q->matrix_mdev)) {
 		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
 				 &q->saved_pfn, 1);
-	q->saved_pfn = 0;
-	q->saved_isc = VFIO_AP_ISC_INVALID;
+		q->saved_pfn = 0;
+	}
 }
 
 /**
@@ -144,7 +145,7 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
  * Returns if ap_aqic function failed with invalid, deconfigured or
  * checkstopped AP.
  */
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
+static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 {
 	struct ap_qirq_ctrl aqic_gisa = {};
 	struct ap_queue_status status;
@@ -1114,48 +1115,70 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static void vfio_ap_irq_disable_apqn(int apqn)
+static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 {
 	struct device *dev;
-	struct vfio_ap_queue *q;
+	struct vfio_ap_queue *q = NULL;
 
 	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
 				 &apqn, match_apqn);
 	if (dev) {
 		q = dev_get_drvdata(dev);
-		vfio_ap_irq_disable(q);
 		put_device(dev);
 	}
+
+	return q;
 }
 
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
+int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 			     unsigned int retry)
 {
 	struct ap_queue_status status;
+	int ret;
 	int retry2 = 2;
-	int apqn = AP_MKQID(apid, apqi);
 
-	do {
-		status = ap_zapq(apqn);
-		switch (status.response_code) {
-		case AP_RESPONSE_NORMAL:
-			while (!status.queue_empty && retry2--) {
-				msleep(20);
-				status = ap_tapq(apqn, NULL);
-			}
-			WARN_ON_ONCE(retry2 <= 0);
-			return 0;
-		case AP_RESPONSE_RESET_IN_PROGRESS:
-		case AP_RESPONSE_BUSY:
+	if (!q)
+		return 0;
+
+retry_zapq:
+	status = ap_zapq(q->apqn);
+	switch (status.response_code) {
+	case AP_RESPONSE_NORMAL:
+		ret = 0;
+		break;
+	case AP_RESPONSE_RESET_IN_PROGRESS:
+		if (retry--) {
 			msleep(20);
-			break;
-		default:
-			/* things are really broken, give up */
-			return -EIO;
+			goto retry_zapq;
 		}
-	} while (retry--);
+		ret = -EBUSY;
+		break;
+	case AP_RESPONSE_Q_NOT_AVAIL:
+	case AP_RESPONSE_DECONFIGURED:
+	case AP_RESPONSE_CHECKSTOPPED:
+		WARN_ON_ONCE(status.irq_enabled);
+		ret = -EBUSY;
+		goto free_resources;
+	default:
+		/* things are really broken, give up */
+		WARN(true, "PQAP/ZAPQ completed with invalid rc (%x)\n",
+		     status.response_code);
+		return -EIO;
+	}
+
+	/* wait for the reset to take effect */
+	while (retry2--) {
+		if (status.queue_empty && !status.irq_enabled)
+			break;
+		msleep(20);
+		status = ap_tapq(q->apqn, NULL);
+	}
+	WARN_ON_ONCE(retry2 <= 0);
 
-	return -EBUSY;
+free_resources:
+	vfio_ap_free_aqic_resources(q);
+
+	return ret;
 }
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
@@ -1163,13 +1186,15 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 	int ret;
 	int rc = 0;
 	unsigned long apid, apqi;
+	struct vfio_ap_queue *q;
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
 			     matrix_mdev->matrix.apm_max + 1) {
 		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
 				     matrix_mdev->matrix.aqm_max + 1) {
-			ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
+			q = vfio_ap_find_queue(AP_MKQID(apid, apqi));
+			ret = vfio_ap_mdev_reset_queue(q, 1);
 			/*
 			 * Regardless whether a queue turns out to be busy, or
 			 * is not operational, we need to continue resetting
@@ -1177,7 +1202,6 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 			 */
 			if (ret)
 				rc = ret;
-			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
 		}
 	}
 
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index f46dde56b464..28e9d9989768 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -88,11 +88,6 @@ struct ap_matrix_mdev {
 	struct mdev_device *mdev;
 };
 
-extern int vfio_ap_mdev_register(void);
-extern void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry);
-
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
 	unsigned long saved_pfn;
@@ -100,5 +95,10 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 };
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
+
+int vfio_ap_mdev_register(void);
+void vfio_ap_mdev_unregister(void);
+int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
+			     unsigned int retry);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */

base-commit: 9791581c049c10929e97098374dd1716a81fefcc
-- 
2.17.1

