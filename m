Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204872D81EE
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391839AbgLKWXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:23:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389930AbgLKWXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:23:23 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BBMEYsQ186323;
        Fri, 11 Dec 2020 17:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CvZ6ed3lQl/BG9srwuIEWAY0PIXHO1HWpFDNCxW9pag=;
 b=O1A4+xcyVxSnAEQKiPSe2hlzYeImTzZV3Jin+Qk45dU1NkxeRaECMnXVp0YKXkhqYscY
 M5wJyJSZ1p9ixi9dyWmhmFRmxyZpnJ6xXjbZzcxB9kyJeWl1+acwVBT28fYd+SpN7IE+
 oYiHIZTSAyEI51hCo/ir/lrC5ENNF5hHntacxeef58l3ulZUWU+dNzi+QGUPCji04O9M
 tPaBea4vIIWKalw93NTWFc8QfGT2VT2hnPgszhwSmW6YabLFvCMzj1wIEczGj1gizH78
 Dxa6NJlTZabuTWWnaR1mBOJamt1LvKL7SUkcn1uXpXBcqvLsetH0WfZB2cwNQ43tJbhx ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35chcrg51m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 17:22:27 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BBMGK99191066;
        Fri, 11 Dec 2020 17:22:26 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35chcrg51e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 17:22:26 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BBMCSqr021964;
        Fri, 11 Dec 2020 22:22:25 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3581uaqkf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 22:22:25 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBMMOtp24576384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 22:22:24 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11CEEC605A;
        Fri, 11 Dec 2020 22:22:24 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64776C6057;
        Fri, 11 Dec 2020 22:22:22 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 22:22:22 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v2 2/2] s390/vfio-ap: reverse group notifier actions when KVM pointer invalidated
Date:   Fri, 11 Dec 2020 17:22:11 -0500
Message-Id: <20201211222211.20869-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201211222211.20869-1-akrowiak@linux.ibm.com>
References: <20201211222211.20869-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_09:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 suspectscore=3 phishscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012110145
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The vfio_ap device driver registers a group notifier with VFIO when the
file descriptor for a VFIO mediated device for a KVM guest is opened to
receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
event). When the KVM pointer is set, the vfio_ap driver takes the
following actions:
1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
   of the mediated device.
2. Calls the kvm_get_kvm() function to increment its reference counter.
3. Sets the function pointer to the function that handles interception of
   the instruction that enables/disables interrupt processing.

When the notifier is called to make notification that the KVM pointer has
been set to NULL, the driver should reverse the actions taken when the
KVM pointer was set as well as unplugging the AP devices passed through
to the KVM guest.

Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 40 ++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index c854d7ab2079..1c3c2a0898b9 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1033,8 +1033,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 {
 	struct ap_matrix_mdev *m;
 
-	mutex_lock(&matrix_dev->lock);
-
 	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 		if ((m != matrix_mdev) && (m->kvm == kvm)) {
 			mutex_unlock(&matrix_dev->lock);
@@ -1045,7 +1043,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	matrix_mdev->kvm = kvm;
 	kvm_get_kvm(kvm);
 	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
-	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
@@ -1079,35 +1076,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
+{
+	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
+	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+	kvm_put_kvm(matrix_mdev->kvm);
+	matrix_mdev->kvm = NULL;
+}
+
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 				       unsigned long action, void *data)
 {
-	int ret;
+	int ret, notify_rc = NOTIFY_DONE;
 	struct ap_matrix_mdev *matrix_mdev;
 
 	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
 		return NOTIFY_OK;
 
 	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
+	mutex_lock(&matrix_dev->lock);
 
 	if (!data) {
-		matrix_mdev->kvm = NULL;
-		return NOTIFY_OK;
+		if (matrix_mdev->kvm)
+			vfio_ap_mdev_unset_kvm(matrix_mdev);
+		notify_rc = NOTIFY_OK;
+		goto notify_done;
 	}
 
 	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
 	if (ret)
-		return NOTIFY_DONE;
+		goto notify_done;
 
 	/* If there is no CRYCB pointer, then we can't copy the masks */
 	if (!matrix_mdev->kvm->arch.crypto.crycbd)
-		return NOTIFY_DONE;
+		goto notify_done;
 
 	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
 				  matrix_mdev->matrix.aqm,
 				  matrix_mdev->matrix.adm);
 
-	return NOTIFY_OK;
+notify_done:
+	mutex_unlock(&matrix_dev->lock);
+	return notify_rc;
 }
 
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
@@ -1234,13 +1245,10 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
-	if (matrix_mdev->kvm) {
-		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
-		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
-		vfio_ap_mdev_reset_queues(mdev);
-		kvm_put_kvm(matrix_mdev->kvm);
-		matrix_mdev->kvm = NULL;
-	}
+	if (matrix_mdev->kvm)
+		vfio_ap_mdev_unset_kvm(matrix_mdev);
+	else
+		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
-- 
2.21.1

