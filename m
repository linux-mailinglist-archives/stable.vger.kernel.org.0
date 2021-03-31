Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27A734925B
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhCYMr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:47:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230415AbhCYMq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 08:46:56 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PCX0SY064871;
        Thu, 25 Mar 2021 08:46:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yE/tgn8TsGGWfwZvscViVckPGKQ+BXrVjLXWphq5lls=;
 b=GKqKERtxS9u0mOmH91YGxVc/6yftJAQY3D2QvnGY+zWG1xKN49dWWAWcf+5m1DGKSmaD
 MkDIpAKEZ0O8te0kkvxk+H7b3tvIN9IHsxrNA9v4M9JKrgv9q9YI67Koq/5wkN6ucNXH
 gCL3ZVKF0RVAU7+BbPbxy4m62I22Uic8dUqwbf9kF3O3cqDL9a85bfK1CzC1u3+N9H9O
 1T9Kt0l7Hxm/PXQKA4/iIlluFap5qVyEWFLeWPsEG6qXBSjf+PSmyqeD7+2JkbBZ3F7O
 hidVfuLv0AYolEktoJzuOVnrf/NysDEodPSCo5x6mgiD3ND13BErc5AiH52rmk7Gzp/5 TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37grmv3xc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 08:46:54 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PCYaJi073449;
        Thu, 25 Mar 2021 08:46:54 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37grmv3xbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 08:46:54 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PCRRuc030591;
        Thu, 25 Mar 2021 12:46:52 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 37d9dadnjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:46:52 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PCkpvU30343534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 12:46:51 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72BC1136051;
        Thu, 25 Mar 2021 12:46:51 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C5BC136055;
        Thu, 25 Mar 2021 12:46:50 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.150.254])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 12:46:49 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v5 1/1] s390/vfio-ap: fix circular lockdep when setting/clearing crypto masks
Date:   Thu, 25 Mar 2021 08:46:40 -0400
Message-Id: <20210325124640.23995-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210325124640.23995-1-akrowiak@linux.ibm.com>
References: <20210325124640.23995-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_03:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250093
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes a lockdep splat introduced by commit f21916ec4826
("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated").
The lockdep splat only occurs when starting a Secure Execution guest.
Crypto virtualization (vfio_ap) is not yet supported for SE guests;
however, in order to avoid this problem when support becomes available,
this fix is being provided.

The circular locking dependency was introduced when the setting of the
masks in the guest's APCB was executed while holding the matrix_dev->lock.
While the lock is definitely needed to protect the setting/unsetting of the
matrix_mdev->kvm pointer, it is not necessarily critical for setting the
masks; so, the matrix_dev->lock will be released while the masks are being
set or cleared.

Keep in mind, however, that another process that takes the matrix_dev->lock
can get control while the masks in the guest's APCB are being set or
cleared as a result of the driver being notified that the KVM pointer
has been set or unset. This could result in invalid access to the
matrix_mdev->kvm pointer by the intervening process. To avoid this
scenario, two new fields are being added to the ap_matrix_mdev struct:

struct ap_matrix_mdev {
	...
	bool kvm_busy;
	wait_queue_head_t wait_for_kvm;
   ...
};

The functions that handle notification that the KVM pointer value has
been set or cleared will set the kvm_busy flag to true until they are done
processing at which time they will set it to false and wake up the tasks on
the matrix_mdev->wait_for_kvm wait queue. Functions that require
access to matrix_mdev->kvm will sleep on the wait queue until they are
awakened at which time they can safely access the matrix_mdev->kvm
field.

Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 309 ++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 215 insertions(+), 96 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 1ffdd411201c..7deb0f9bb9ee 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -294,6 +294,19 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
 				   struct ap_matrix_mdev, pqap_hook);
 
+	/*
+	 * If the KVM pointer is in the process of being set, wait until the
+	 * process has completed.
+	 */
+	wait_event_cmd(matrix_mdev->wait_for_kvm,
+		       matrix_mdev->kvm_busy == false,
+		       mutex_unlock(&matrix_dev->lock),
+		       mutex_lock(&matrix_dev->lock));
+
+	/* If the there is no guest using the mdev, there is nothing to do */
+	if (!matrix_mdev->kvm)
+		goto out_unlock;
+
 	q = vfio_ap_get_queue(matrix_mdev, apqn);
 	if (!q)
 		goto out_unlock;
@@ -337,6 +350,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
+	init_waitqueue_head(&matrix_mdev->wait_for_kvm);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
 	matrix_mdev->pqap_hook.owner = THIS_MODULE;
@@ -351,17 +365,23 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	if (matrix_mdev->kvm)
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of control domain.
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		mutex_unlock(&matrix_dev->lock);
 		return -EBUSY;
+	}
 
-	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_reset_queues(mdev);
 	list_del(&matrix_mdev->node);
-	mutex_unlock(&matrix_dev->lock);
-
 	kfree(matrix_mdev);
 	mdev_set_drvdata(mdev, NULL);
 	atomic_inc(&matrix_dev->available_instances);
+	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
@@ -606,24 +626,31 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of adapter
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
-		return ret;
+		goto done;
 
-	if (apid > matrix_mdev->matrix.apm_max)
-		return -ENODEV;
+	if (apid > matrix_mdev->matrix.apm_max) {
+		ret = -ENODEV;
+		goto done;
+	}
 
 	/*
 	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
 	 * number (APID). The bits in the mask, from most significant to least
 	 * significant bit, correspond to APIDs 0-255.
 	 */
-	mutex_lock(&matrix_dev->lock);
-
 	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
 	if (ret)
 		goto done;
@@ -672,22 +699,31 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of adapter
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
-		return ret;
+		goto done;
 
-	if (apid > matrix_mdev->matrix.apm_max)
-		return -ENODEV;
+	if (apid > matrix_mdev->matrix.apm_max) {
+		ret = -ENODEV;
+		goto done;
+	}
 
-	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	ret = count;
+done:
 	mutex_unlock(&matrix_dev->lock);
-
-	return count;
+	return ret;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
 
@@ -753,17 +789,24 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * assignment of domain
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
-		return ret;
-	if (apqi > max_apqi)
-		return -ENODEV;
-
-	mutex_lock(&matrix_dev->lock);
+		goto done;
+	if (apqi > max_apqi) {
+		ret = -ENODEV;
+		goto done;
+	}
 
 	ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
 	if (ret)
@@ -814,22 +857,32 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of domain
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
-		return ret;
+		goto done;
 
-	if (apqi > matrix_mdev->matrix.aqm_max)
-		return -ENODEV;
+	if (apqi > matrix_mdev->matrix.aqm_max) {
+		ret = -ENODEV;
+		goto done;
+	}
 
-	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
-	mutex_unlock(&matrix_dev->lock);
+	ret = count;
 
-	return count;
+done:
+	mutex_unlock(&matrix_dev->lock);
+	return ret;
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
@@ -858,27 +911,36 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * assignment of control domain.
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
-		return ret;
+		goto done;
 
-	if (id > matrix_mdev->matrix.adm_max)
-		return -ENODEV;
+	if (id > matrix_mdev->matrix.adm_max) {
+		ret = -ENODEV;
+		goto done;
+	}
 
 	/* Set the bit in the ADM (bitmask) corresponding to the AP control
 	 * domain number (id). The bits in the mask, from most significant to
 	 * least significant, correspond to IDs 0 up to the one less than the
 	 * number of control domains that can be assigned.
 	 */
-	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	ret = count;
+done:
 	mutex_unlock(&matrix_dev->lock);
-
-	return count;
+	return ret;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
@@ -908,21 +970,30 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of control domain.
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
-		return ret;
-	if (domid > max_domid)
-		return -ENODEV;
+		goto done;
+	if (domid > max_domid) {
+		ret = -ENODEV;
+		goto done;
+	}
 
-	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	ret = count;
+done:
 	mutex_unlock(&matrix_dev->lock);
-
-	return count;
+	return ret;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
 
@@ -1027,8 +1098,15 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
  * @matrix_mdev: a mediated matrix device
  * @kvm: reference to KVM instance
  *
- * Verifies no other mediated matrix device has @kvm and sets a reference to
- * it in @matrix_mdev->kvm.
+ * Sets all data for @matrix_mdev that are needed to manage AP resources
+ * for the guest whose state is represented by @kvm.
+ *
+ * Note: The matrix_dev->lock must be taken prior to calling
+ * this function; however, the lock will be temporarily released while the
+ * guest's AP configuration is set to avoid a potential lockdep splat.
+ * The kvm->lock is taken to set the guest's AP configuration which, under
+ * certain circumstances, will result in a circular lock dependency if this is
+ * done under the @matrix_mdev->lock.
  *
  * Return 0 if no other mediated matrix device has a reference to @kvm;
  * otherwise, returns an -EPERM.
@@ -1038,14 +1116,25 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 {
 	struct ap_matrix_mdev *m;
 
-	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
-		if ((m != matrix_mdev) && (m->kvm == kvm))
-			return -EPERM;
-	}
+	if (kvm->arch.crypto.crycbd) {
+		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
+			if ((m != matrix_mdev) && (m->kvm == kvm))
+				return -EPERM;
+		}
 
-	matrix_mdev->kvm = kvm;
-	kvm_get_kvm(kvm);
-	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
+		kvm_get_kvm(kvm);
+		matrix_mdev->kvm_busy = true;
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_set_masks(kvm,
+					  matrix_mdev->matrix.apm,
+					  matrix_mdev->matrix.aqm,
+					  matrix_mdev->matrix.adm);
+		mutex_lock(&matrix_dev->lock);
+		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
+		matrix_mdev->kvm = kvm;
+		matrix_mdev->kvm_busy = false;
+		wake_up_all(&matrix_mdev->wait_for_kvm);
+	}
 
 	return 0;
 }
@@ -1079,51 +1168,65 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+/**
+ * vfio_ap_mdev_unset_kvm
+ *
+ * @matrix_mdev: a matrix mediated device
+ *
+ * Performs clean-up of resources no longer needed by @matrix_mdev.
+ *
+ * Note: The matrix_dev->lock must be taken prior to calling
+ * this function; however, the lock will be temporarily released while the
+ * guest's AP configuration is cleared to avoid a potential lockdep splat.
+ * The kvm->lock is taken to clear the guest's AP configuration which, under
+ * certain circumstances, will result in a circular lock dependency if this is
+ * done under the @matrix_mdev->lock.
+ *
+ */
 static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 {
-	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
-	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
-	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
-	kvm_put_kvm(matrix_mdev->kvm);
-	matrix_mdev->kvm = NULL;
+	/*
+	 * If the KVM pointer is in the process of being set, wait until the
+	 * process has completed.
+	 */
+	wait_event_cmd(matrix_mdev->wait_for_kvm,
+		       matrix_mdev->kvm_busy == false,
+		       mutex_unlock(&matrix_dev->lock),
+		       mutex_lock(&matrix_dev->lock));
+
+	if (matrix_mdev->kvm) {
+		matrix_mdev->kvm_busy = true;
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		mutex_lock(&matrix_dev->lock);
+		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
+		kvm_put_kvm(matrix_mdev->kvm);
+		matrix_mdev->kvm = NULL;
+		matrix_mdev->kvm_busy = false;
+		wake_up_all(&matrix_mdev->wait_for_kvm);
+	}
 }
 
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 				       unsigned long action, void *data)
 {
-	int ret, notify_rc = NOTIFY_OK;
+	int notify_rc = NOTIFY_OK;
 	struct ap_matrix_mdev *matrix_mdev;
 
 	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
 		return NOTIFY_OK;
 
-	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
 	mutex_lock(&matrix_dev->lock);
+	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
 
-	if (!data) {
-		if (matrix_mdev->kvm)
-			vfio_ap_mdev_unset_kvm(matrix_mdev);
-		goto notify_done;
-	}
-
-	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
-	if (ret) {
-		notify_rc = NOTIFY_DONE;
-		goto notify_done;
-	}
-
-	/* If there is no CRYCB pointer, then we can't copy the masks */
-	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
+	if (!data)
+		vfio_ap_mdev_unset_kvm(matrix_mdev);
+	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
 		notify_rc = NOTIFY_DONE;
-		goto notify_done;
-	}
 
-	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
-				  matrix_mdev->matrix.aqm,
-				  matrix_mdev->matrix.adm);
-
-notify_done:
 	mutex_unlock(&matrix_dev->lock);
+
 	return notify_rc;
 }
 
@@ -1258,8 +1361,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
-	if (matrix_mdev->kvm)
-		vfio_ap_mdev_unset_kvm(matrix_mdev);
+	vfio_ap_mdev_unset_kvm(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
@@ -1293,6 +1395,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 				    unsigned int cmd, unsigned long arg)
 {
 	int ret;
+	struct ap_matrix_mdev *matrix_mdev;
 
 	mutex_lock(&matrix_dev->lock);
 	switch (cmd) {
@@ -1300,7 +1403,21 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
-		ret = vfio_ap_mdev_reset_queues(mdev);
+		matrix_mdev = mdev_get_drvdata(mdev);
+		WARN(!matrix_mdev, "Driver data missing from mdev!!");
+
+		if (matrix_mdev) {
+			/*
+			 * If the KVM pointer is in the process of being set, wait until
+			 * the process has completed.
+			 */
+			wait_event_cmd(matrix_mdev->wait_for_kvm,
+				       matrix_mdev->kvm_busy == false,
+				       mutex_unlock(&matrix_dev->lock),
+				       mutex_lock(&matrix_dev->lock));
+
+			ret = vfio_ap_mdev_reset_queues(mdev);
+		}
 		break;
 	default:
 		ret = -EOPNOTSUPP;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 28e9d9989768..f82a6396acae 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -83,6 +83,8 @@ struct ap_matrix_mdev {
 	struct ap_matrix matrix;
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
+	bool kvm_busy;
+	wait_queue_head_t wait_for_kvm;
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
-- 
2.21.3

