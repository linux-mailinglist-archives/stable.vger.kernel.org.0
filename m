Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564D731A32A
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 18:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhBLQ6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 11:58:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229465AbhBLQ6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 11:58:38 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CGhUjt018378
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 11:57:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=P2URQtyXH9fvyavEGjcEFBI4lkS4wyhwMJE6SGaL7cY=;
 b=XFE+8m6MlI+RExAJ3Uq1bG6X7uHxIeFwFG73zfN3SWaJ/7dBnb5VgIeeN0xMUyZXhGXn
 Rg+B75qA1QIH32VnKjX2Eh3mGd1GVQNS2L1Yu9rMamFJC4TQHDkkjUSAK5R0evVZwvAz
 PThY/g22V74ImJwNPUwpm8zSLjKLAZc0My2fPAQJabfeIW8nMxwSuYY9CyJSUmIycdCO
 qb1EarpT8ve+0t5NIG6W+F8nVGAoyHeAfWOrWyExtoYoVoDWbQZxuxg8iJtBvkSSk3Ux
 G7Katv8/R+D27XMp8QcowuS2yvKEDNn8hYuXkGDcURM5rsHhKmjoYS2QXEZJdp6SnUjo kg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36nwekgdgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 11:57:55 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CGmSbS011648
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:57:54 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 36hjrat0wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:57:54 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CGvrBe9176038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 16:57:53 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F559B206A;
        Fri, 12 Feb 2021 16:57:53 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59419B2064;
        Fri, 12 Feb 2021 16:57:53 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.203.235])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 16:57:53 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     pasic@linux.vnet.ibm.com
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when setting/clearing crypto masks
Date:   Fri, 12 Feb 2021 11:57:46 -0500
Message-Id: <20210212165746.29839-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20210212165746.29839-1-akrowiak@linux.ibm.com>
References: <20210212165746.29839-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_05:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120122
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes a circular locking dependency in the CI introduced by
commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
pointer invalidated"). The lockdep only occurs when starting a Secure
Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
SE guests; however, in order to avoid CI errors, this fix is being
provided.

The circular lockdep was introduced when the masks in the guest's APCB
were taken under the matrix_dev->lock. While the lock is definitely
needed to protect the setting/unsetting of the KVM pointer, it is not
necessarily critical for setting the masks, so this will not be done under
protection of the matrix_dev->lock.

Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 78 +++++++++++++++++++------------
 1 file changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 41fc2e4135fe..bba0f64aa1f7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1028,7 +1028,10 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
  * @kvm: reference to KVM instance
  *
  * Verifies no other mediated matrix device has @kvm and sets a reference to
- * it in @matrix_mdev->kvm.
+ * it in @matrix_mdev->kvm. The matrix_dev->lock must be taken prior to calling
+ * this function; however, the lock will be temporarily released while updating
+ * the guest's APCB to avoid a potential circular lock dependency with other
+ * asynchronous processes.
  *
  * Return 0 if no other mediated matrix device has a reference to @kvm;
  * otherwise, returns an -EPERM.
@@ -1043,10 +1046,19 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 			return -EPERM;
 	}
 
-	matrix_mdev->kvm = kvm;
 	kvm_get_kvm(kvm);
+	matrix_mdev->kvm = kvm;
 	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
 
+	if (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd) {
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_set_masks(kvm,
+					  matrix_mdev->matrix.apm,
+					  matrix_mdev->matrix.aqm,
+					  matrix_mdev->matrix.adm);
+		mutex_lock(&matrix_dev->lock);
+	}
+
 	return 0;
 }
 
@@ -1079,13 +1091,34 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+/**
+ * vfio_ap_mdev_unset_kvm
+ *
+ * @matrix_mdev: a matrix mediated device
+ *
+ * Clears the masks in the guest's APCB as well as the reference to KVM from
+ * @matrix_mdev. The matrix_dev->lock must be taken prior to calling this
+ * function; however, the lock will be temporarily released while updating
+ * the guest's APCB to avoid a potential circular lock dependency with other
+ * asynchronous processes.
+ */
 static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 {
-	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
-	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
-	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
-	kvm_put_kvm(matrix_mdev->kvm);
-	matrix_mdev->kvm = NULL;
+	struct kvm *kvm;
+
+	if (matrix_mdev->kvm) {
+		kvm = matrix_mdev->kvm;
+		kvm_get_kvm(kvm);
+		kvm->arch.crypto.pqap_hook = NULL;
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_clear_masks(kvm);
+		mutex_lock(&matrix_dev->lock);
+		kvm_put_kvm(kvm);
+		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+		if (matrix_mdev->kvm)
+			kvm_put_kvm(matrix_mdev->kvm);
+		matrix_mdev->kvm = NULL;
+	}
 }
 
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
@@ -1097,33 +1130,19 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
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
+	if (!data)
+		vfio_ap_mdev_unset_kvm(matrix_mdev);
+	else
+		ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
 
-	/* If there is no CRYCB pointer, then we can't copy the masks */
-	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
+	if (ret)
 		notify_rc = NOTIFY_DONE;
-		goto notify_done;
-	}
-
-	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
-				  matrix_mdev->matrix.aqm,
-				  matrix_mdev->matrix.adm);
 
-notify_done:
 	mutex_unlock(&matrix_dev->lock);
+
 	return notify_rc;
 }
 
@@ -1258,8 +1277,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
-	if (matrix_mdev->kvm)
-		vfio_ap_mdev_unset_kvm(matrix_mdev);
+	vfio_ap_mdev_unset_kvm(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
-- 
2.21.1

