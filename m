Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969A05AE696
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbiIFL3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiIFL3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:29:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777244BA77
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1408460C61
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238D2C433D6;
        Tue,  6 Sep 2022 11:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662463752;
        bh=5AsPkxDx/Gc9TSh85HtFpFESSrxr+4f6jN23uyIDdmM=;
        h=Subject:To:Cc:From:Date:From;
        b=m8e5QY6pADWHASr5TfNj5Wl0nUQ+FUYZNgVrRN3vsSgx93tDXXg/BKbs2YwHZEqfu
         k6UESX486msanndS0slk27UXK9ouTTOXN9zRNrdeR2WhIoavyxU8JE3ZkKwGj/Ilbb
         6w7UkkpuAuSzp4VhjtzycB4gVWD1/HLdiPJyv4ME=
Subject: FAILED: patch "[PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO" failed to apply to 5.19-stable tree
To:     pmorel@linux.ibm.com, frankja@linux.ibm.com, lkp@intel.com,
        mjrosato@linux.ibm.com, rdunlap@infradead.org,
        schnelle@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:29:09 +0200
Message-ID: <166246374977251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca922fecda6caa5162409406dc3b663062d75089 Mon Sep 17 00:00:00 2001
From: Pierre Morel <pmorel@linux.ibm.com>
Date: Fri, 19 Aug 2022 14:29:45 +0200
Subject: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO

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

