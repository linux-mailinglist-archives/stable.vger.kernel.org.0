Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2702A658CB5
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 13:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiL2MdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 07:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiL2MdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 07:33:24 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444B165EB;
        Thu, 29 Dec 2022 04:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672317203; x=1703853203;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bNbpE4OIGne2tvX2ONyBKUpBuaBYYWTXY86Z1ZMXdyY=;
  b=CscflM5GpbXQUco/+fIWMt1RK1iNtDnw0oo/69g0xXVpPQ726IUDKL2y
   4UGyb3bN1BoX6xhNvmI/UqOauvr2UHnskPmiN3WEPK2P3c9HS+9xXwDRx
   MC0Zkc/tWcrxCrSdzo0fMuu0EgiIPpI5iWI3govitAMAEDMUwocGnX9af
   nEFo7TSrh+nwD+X4l6MruCagXh2mqNGKNhTIjTUnGZwNhgMxSuwch/SJD
   8uL6etaUXUrkQFsWfQmUYFItC7E5LEr8wswO4o2SQGJssfujYWRDRSYOp
   ZPpRHHSBl3Ep0Zt6IDtsBOwx9DD6LqBsRzNj3+HeXiVxMhzZUIciUPLcY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="348243730"
X-IronPort-AV: E=Sophos;i="5.96,284,1665471600"; 
   d="scan'208";a="348243730"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 04:33:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="777683323"
X-IronPort-AV: E=Sophos;i="5.96,284,1665471600"; 
   d="scan'208";a="777683323"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orsmga004.jf.intel.com with ESMTP; 29 Dec 2022 04:33:06 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>, stable@vger.kernel.org,
        =?UTF-8?q?=E6=9F=B3=E8=8F=81=E5=B3=B0?= <liujingfeng@qianxin.com>
Subject: [PATCH v1] KVM: destruct kvm_io_device while unregistering it from kvm_io_bus
Date:   Thu, 29 Dec 2022 20:33:02 +0800
Message-Id: <20221229123302.4083-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Current usage of kvm_io_device requires users to destruct it with an extra
call of kvm_iodevice_destructor after the device gets unregistered from
the kvm_io_bus. This is not necessary and can cause errors if a user
forgot to make the extra call.

Simplify the usage by combining kvm_iodevice_destructor into
kvm_io_bus_unregister_dev. This reduces LOCs a bit for users and can
avoid the leakage of destructing the device explicitly.

The fix was originally provided by Sean Christopherson.
Link: https://lore.kernel.org/lkml/DS0PR11MB6373F27D0EE6CD28C784478BDCEC9@DS0PR11MB6373.namprd11.prod.outlook.com/T/
Fixes: 5d3c4c79384a ("KVM: Stop looking for coalesced MMIO zones if the bus is destroyed")
Cc: stable@vger.kernel.org
Reported-by: 柳菁峰 <liujingfeng@qianxin.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 include/kvm/iodev.h       |  6 ------
 virt/kvm/coalesced_mmio.c |  1 -
 virt/kvm/eventfd.c        |  1 -
 virt/kvm/kvm_main.c       | 24 +++++++++++++++---------
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/kvm/iodev.h b/include/kvm/iodev.h
index d75fc4365746..56619e33251e 100644
--- a/include/kvm/iodev.h
+++ b/include/kvm/iodev.h
@@ -55,10 +55,4 @@ static inline int kvm_iodevice_write(struct kvm_vcpu *vcpu,
 				 : -EOPNOTSUPP;
 }
 
-static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
-{
-	if (dev->ops->destructor)
-		dev->ops->destructor(dev);
-}
-
 #endif /* __KVM_IODEV_H__ */
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0be80c213f7f..d7135a5e76f8 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -195,7 +195,6 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 			 */
 			if (r)
 				break;
-			kvm_iodevice_destructor(&dev->dev);
 		}
 	}
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2a3ed401ce46..1b277afb545b 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -898,7 +898,6 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 		bus = kvm_get_bus(kvm, bus_idx);
 		if (bus)
 			bus->ioeventfd_count--;
-		ioeventfd_release(p);
 		ret = 0;
 		break;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13e88297f999..582757ebdce6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5200,6 +5200,12 @@ static struct notifier_block kvm_reboot_notifier = {
 	.priority = 0,
 };
 
+static void kvm_iodevice_destructor(struct kvm_io_device *dev)
+{
+	if (dev->ops->destructor)
+		dev->ops->destructor(dev);
+}
+
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 {
 	int i;
@@ -5423,7 +5429,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			      struct kvm_io_device *dev)
 {
-	int i, j;
+	int i;
 	struct kvm_io_bus *new_bus, *bus;
 
 	lockdep_assert_held(&kvm->slots_lock);
@@ -5453,18 +5459,18 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
 	synchronize_srcu_expedited(&kvm->srcu);
 
-	/* Destroy the old bus _after_ installing the (null) bus. */
+	/*
+	 * If (null) bus is installed, destroy the old bus, including all the
+	 * attached devices. Otherwise, destroy the caller's device only.
+	 */
 	if (!new_bus) {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
-		for (j = 0; j < bus->dev_count; j++) {
-			if (j == i)
-				continue;
-			kvm_iodevice_destructor(bus->range[j].dev);
-		}
+		kvm_io_bus_destroy(bus);
+		return -ENOMEM;
 	}
 
-	kfree(bus);
-	return new_bus ? 0 : -ENOMEM;
+	kvm_iodevice_destructor(dev);
+	return 0;
 }
 
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-- 
2.27.0

