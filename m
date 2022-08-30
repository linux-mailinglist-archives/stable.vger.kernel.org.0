Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B335A5E3E
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 10:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiH3Ifg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 04:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiH3Ife (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 04:35:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3965F106;
        Tue, 30 Aug 2022 01:35:32 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27U8VZYt001076;
        Tue, 30 Aug 2022 08:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=WqQLkjzr0HJeUTOhd1CEtkid254pLDvm0+MMQBwQ0WI=;
 b=o5bw6F+eYolKOJyr0+bLK+TJ3gdmpKXttud7EbMD//PpVYZUtKJy5RGXVOrxs47IFTqY
 nHAF1LyeE9iXgWCiHXPQbO9E27CWfI+NQNUEIDDUHFNR+wQyjek8kyx0vTYYc3aEUzV7
 HNN76xRtmqxv2f6tsK13xNTl0MRu0AHgS0/lTLKc0eC0nlag6g11zSenLFH1aJHI1AOn
 voGmHhq7cyBsX2mm+6jkqTsXGcX2sBCjye463UoOSnHGK9gCrfCkuA4pe+K59FdwbHjy
 V4iekrqQfLgfjADnFBoLSBaPMo3EGhN2P2DMTK6wqOl0meuiwVnd1vR6LF9WYQgdYs4U PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9f47g9vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:35:26 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27U8WS3p011703;
        Tue, 30 Aug 2022 08:35:26 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9f47g9tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:35:26 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27U8KNS3007057;
        Tue, 30 Aug 2022 08:35:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3j7aw8tgtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:35:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27U8ZKBh40108478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 08:35:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9922142042;
        Tue, 30 Aug 2022 08:35:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F9244203F;
        Tue, 30 Aug 2022 08:35:20 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.56.39])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 08:35:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 1/1] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
Date:   Tue, 30 Aug 2022 10:32:50 +0200
Message-Id: <20220830083250.25720-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220830083250.25720-1-frankja@linux.ibm.com>
References: <20220830083250.25720-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rEHS46lkyQXEkpKnSSo0JmyuAKJ8KG2V
X-Proofpoint-GUID: 8AhpHC252Bvw0HWd_vVh9uA97NwWhaeo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=921 bulkscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208300041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

We have a cross dependency between KVM and VFIO when using
s390 vfio_pci_zdev extensions for PCI passthrough
To be able to keep both subsystem modular we add a registering
hook inside the S390 core code.

This fixes a build problem when VFIO is built-in and KVM is built
as a module.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop interpretive execution")
Cc: <stable@vger.kernel.org>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Link: https://lore.kernel.org/r/20220819122945.9309-1-pmorel@linux.ibm.com
Message-Id: <20220819122945.9309-1-pmorel@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
 arch/s390/kvm/pci.c              | 12 ++++++++----
 arch/s390/pci/Makefile           |  2 +-
 arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
 drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
 5 files changed, 32 insertions(+), 18 deletions(-)
 create mode 100644 arch/s390/pci/pci_kvm_hook.c

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index f39092e0ceaa..b1e98a9ed152 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1038,16 +1038,11 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
 
-#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
-int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
-void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
-#else
-static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
-					    struct kvm *kvm)
-{
-	return -EPERM;
-}
-static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
-#endif
+struct zpci_kvm_hook {
+	int (*kvm_register)(void *opaque, struct kvm *kvm);
+	void (*kvm_unregister)(void *opaque);
+};
+
+extern struct zpci_kvm_hook zpci_kvm_hook;
 
 #endif
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 4946fb7757d6..bb8c335d17b9 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -431,8 +431,9 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
  * available, enable them and let userspace indicate whether or not they will
  * be used (specify SHM bit to disable).
  */
-int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
+static int kvm_s390_pci_register_kvm(void *opaque, struct kvm *kvm)
 {
+	struct zpci_dev *zdev = opaque;
 	int rc;
 
 	if (!zdev)
@@ -510,10 +511,10 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
 	kvm_put_kvm(kvm);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
 
-void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
+static void kvm_s390_pci_unregister_kvm(void *opaque)
 {
+	struct zpci_dev *zdev = opaque;
 	struct kvm *kvm;
 
 	if (!zdev)
@@ -566,7 +567,6 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
 
 	kvm_put_kvm(kvm);
 }
-EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
 
 void kvm_s390_pci_init_list(struct kvm *kvm)
 {
@@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
 
 	spin_lock_init(&aift->gait_lock);
 	mutex_init(&aift->aift_lock);
+	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
+	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
 
 	return 0;
 }
@@ -685,6 +687,8 @@ int kvm_s390_pci_init(void)
 void kvm_s390_pci_exit(void)
 {
 	mutex_destroy(&aift->aift_lock);
+	zpci_kvm_hook.kvm_register = NULL;
+	zpci_kvm_hook.kvm_unregister = NULL;
 
 	kfree(aift);
 }
diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
index bf557a1b789c..5ae31ca9dd44 100644
--- a/arch/s390/pci/Makefile
+++ b/arch/s390/pci/Makefile
@@ -5,5 +5,5 @@
 
 obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
 			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
-			   pci_bus.o
+			   pci_bus.o pci_kvm_hook.o
 obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
new file mode 100644
index 000000000000..ff34baf50a3e
--- /dev/null
+++ b/arch/s390/pci/pci_kvm_hook.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VFIO ZPCI devices support
+ *
+ * Copyright (C) IBM Corp. 2022.  All rights reserved.
+ *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
+ */
+#include <linux/kvm_host.h>
+
+struct zpci_kvm_hook zpci_kvm_hook;
+EXPORT_SYMBOL_GPL(zpci_kvm_hook);
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index e163aa9f6144..0cbdcd14f1c8 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -151,7 +151,10 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
 	if (!vdev->vdev.kvm)
 		return 0;
 
-	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
+	if (zpci_kvm_hook.kvm_register)
+		return zpci_kvm_hook.kvm_register(zdev, vdev->vdev.kvm);
+
+	return -ENOENT;
 }
 
 void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
@@ -161,5 +164,6 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
 	if (!zdev || !vdev->vdev.kvm)
 		return;
 
-	kvm_s390_pci_unregister_kvm(zdev);
+	if (zpci_kvm_hook.kvm_unregister)
+		zpci_kvm_hook.kvm_unregister(zdev);
 }
-- 
2.34.3

