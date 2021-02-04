Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBC530CB9C
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhBBTag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233516AbhBBN6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:58:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4F7C64FF2;
        Tue,  2 Feb 2021 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273568;
        bh=LYxCb/j+zeQHA2ZQuGO/9xHkPZSjL9+AE/V4jtfy5Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B52+NKkmoYNqv+CY+nzlMPg1hr9++NajqNwJfGN/78yigtN8FRv9sB/Bfl3RW8ffU
         F6S0EZ7pkr9zsnhuN83+SmDLBasPAkYyRTBg6FllGHSdgjb0dvguSZsHSQbsVwyFLL
         U1wuyfEUNQL5+pG8LCXUiVmossI+qmNFn+/LSgTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 12/61] s390/vfio-ap: No need to disable IRQ after queue reset
Date:   Tue,  2 Feb 2021 14:37:50 +0100
Message-Id: <20210202132946.997794587@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

commit 6c12a6384e0c0b96debd88b24028e58f2ebd417b upstream.

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
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: ec89b55e3bce ("s390: ap: implement PAPQ AQIC interception in kernel")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/crypto/vfio_ap_drv.c     |    6 --
 drivers/s390/crypto/vfio_ap_ops.c     |  100 +++++++++++++++++++++-------------
 drivers/s390/crypto/vfio_ap_private.h |   12 ++--
 3 files changed, 69 insertions(+), 49 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -71,15 +71,11 @@ static int vfio_ap_queue_dev_probe(struc
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
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -25,6 +25,7 @@
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
+static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 
 static int match_apqn(struct device *dev, const void *data)
 {
@@ -49,20 +50,15 @@ static struct vfio_ap_queue *vfio_ap_get
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
@@ -119,13 +115,18 @@ static void vfio_ap_wait_for_irqclear(in
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
@@ -144,7 +145,7 @@ static void vfio_ap_free_aqic_resources(
  * Returns if ap_aqic function failed with invalid, deconfigured or
  * checkstopped AP.
  */
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
+static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 {
 	struct ap_qirq_ctrl aqic_gisa = {};
 	struct ap_queue_status status;
@@ -1114,48 +1115,70 @@ static int vfio_ap_mdev_group_notifier(s
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
@@ -1163,13 +1186,15 @@ static int vfio_ap_mdev_reset_queues(str
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
@@ -1177,7 +1202,6 @@ static int vfio_ap_mdev_reset_queues(str
 			 */
 			if (ret)
 				rc = ret;
-			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
 		}
 	}
 
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


