Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30343F269A
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 08:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhHTGDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 02:03:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:54982 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238265AbhHTGDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 02:03:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="216715446"
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="216715446"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 23:02:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="490213770"
Received: from louislifei-optiplex-7050.sh.intel.com ([10.239.154.151])
  by fmsmga008.fm.intel.com with ESMTP; 19 Aug 2021 23:02:26 -0700
From:   Fei Li <fei1.li@intel.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        fei1.li@intel.com, yu1.wang@intel.com, shuox.liu@gmail.com
Subject: [PATCH 1/3] virt: acrn: Introduce interfaces for MMIO device passthrough
Date:   Fri, 20 Aug 2021 14:03:04 +0800
Message-Id: <20210820060306.10682-2-fei1.li@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820060306.10682-1-fei1.li@intel.com>
References: <20210820060306.10682-1-fei1.li@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuo Liu <shuo.a.liu@intel.com>

MMIO device passthrough enables an OS in a virtual machine to directly
access a MMIO device in the host. It promises almost the native
performance, which is required in performance-critical scenarios of
ACRN.

HSM provides the following ioctls:
  - Assign - ACRN_IOCTL_ASSIGN_MMIODEV
    Pass data struct acrn_mmiodev from userspace to the hypervisor, and
    inform the hypervisor to assign a MMIO device to a User VM.

  - De-assign - ACRN_IOCTL_DEASSIGN_PCIDEV
    Pass data struct acrn_mmiodev from userspace to the hypervisor, and
    inform the hypervisor to de-assign a MMIO device from a User VM.

Signed-off-by: Shuo Liu <shuo.a.liu@intel.com>
Signed-off-by: Fei Li <fei1.li@intel.com>
---
 drivers/virt/acrn/hsm.c       | 25 +++++++++++++++++++++++++
 drivers/virt/acrn/hypercall.h | 26 ++++++++++++++++++++++++++
 include/uapi/linux/acrn.h     | 28 ++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/virt/acrn/hsm.c b/drivers/virt/acrn/hsm.c
index 130e12b8652a..f567ca59d7c2 100644
--- a/drivers/virt/acrn/hsm.c
+++ b/drivers/virt/acrn/hsm.c
@@ -114,6 +114,7 @@ static long acrn_dev_ioctl(struct file *filp, unsigned int cmd,
 	struct acrn_ptdev_irq *irq_info;
 	struct acrn_ioeventfd ioeventfd;
 	struct acrn_vm_memmap memmap;
+	struct acrn_mmiodev *mmiodev;
 	struct acrn_msi_entry *msi;
 	struct acrn_pcidev *pcidev;
 	struct acrn_irqfd irqfd;
@@ -217,6 +218,30 @@ static long acrn_dev_ioctl(struct file *filp, unsigned int cmd,
 
 		ret = acrn_vm_memseg_unmap(vm, &memmap);
 		break;
+	case ACRN_IOCTL_ASSIGN_MMIODEV:
+		mmiodev = memdup_user((void __user *)ioctl_param,
+				      sizeof(struct acrn_mmiodev));
+		if (IS_ERR(mmiodev))
+			return PTR_ERR(mmiodev);
+
+		ret = hcall_assign_mmiodev(vm->vmid, virt_to_phys(mmiodev));
+		if (ret < 0)
+			dev_dbg(acrn_dev.this_device,
+				"Failed to assign MMIO device!\n");
+		kfree(mmiodev);
+		break;
+	case ACRN_IOCTL_DEASSIGN_MMIODEV:
+		mmiodev = memdup_user((void __user *)ioctl_param,
+				      sizeof(struct acrn_mmiodev));
+		if (IS_ERR(mmiodev))
+			return PTR_ERR(mmiodev);
+
+		ret = hcall_deassign_mmiodev(vm->vmid, virt_to_phys(mmiodev));
+		if (ret < 0)
+			dev_dbg(acrn_dev.this_device,
+				"Failed to deassign MMIO device!\n");
+		kfree(mmiodev);
+		break;
 	case ACRN_IOCTL_ASSIGN_PCIDEV:
 		pcidev = memdup_user((void __user *)ioctl_param,
 				     sizeof(struct acrn_pcidev));
diff --git a/drivers/virt/acrn/hypercall.h b/drivers/virt/acrn/hypercall.h
index 0cfad05bd1a9..f0c78e52cebb 100644
--- a/drivers/virt/acrn/hypercall.h
+++ b/drivers/virt/acrn/hypercall.h
@@ -41,6 +41,8 @@
 #define HC_RESET_PTDEV_INTR		_HC_ID(HC_ID, HC_ID_PCI_BASE + 0x04)
 #define HC_ASSIGN_PCIDEV		_HC_ID(HC_ID, HC_ID_PCI_BASE + 0x05)
 #define HC_DEASSIGN_PCIDEV		_HC_ID(HC_ID, HC_ID_PCI_BASE + 0x06)
+#define HC_ASSIGN_MMIODEV		_HC_ID(HC_ID, HC_ID_PCI_BASE + 0x07)
+#define HC_DEASSIGN_MMIODEV		_HC_ID(HC_ID, HC_ID_PCI_BASE + 0x08)
 
 #define HC_ID_PM_BASE			0x80UL
 #define HC_PM_GET_CPU_STATE		_HC_ID(HC_ID, HC_ID_PM_BASE + 0x00)
@@ -194,6 +196,30 @@ static inline long hcall_set_memory_regions(u64 regions_pa)
 	return acrn_hypercall1(HC_VM_SET_MEMORY_REGIONS, regions_pa);
 }
 
+/**
+ * hcall_assign_mmiodev() - Assign a MMIO device to a User VM
+ * @vmid:	User VM ID
+ * @addr:	Service VM GPA of the &struct acrn_mmiodev
+ *
+ * Return: 0 on success, <0 on failure
+ */
+static inline long hcall_assign_mmiodev(u64 vmid, u64 addr)
+{
+	return acrn_hypercall2(HC_ASSIGN_MMIODEV, vmid, addr);
+}
+
+/**
+ * hcall_deassign_mmiodev() - De-assign a PCI device from a User VM
+ * @vmid:	User VM ID
+ * @addr:	Service VM GPA of the &struct acrn_mmiodev
+ *
+ * Return: 0 on success, <0 on failure
+ */
+static inline long hcall_deassign_mmiodev(u64 vmid, u64 addr)
+{
+	return acrn_hypercall2(HC_DEASSIGN_MMIODEV, vmid, addr);
+}
+
 /**
  * hcall_assign_pcidev() - Assign a PCI device to a User VM
  * @vmid:	User VM ID
diff --git a/include/uapi/linux/acrn.h b/include/uapi/linux/acrn.h
index 353b2a2e4536..470036d6b1ac 100644
--- a/include/uapi/linux/acrn.h
+++ b/include/uapi/linux/acrn.h
@@ -396,6 +396,7 @@ struct acrn_ptdev_irq {
 /* Type of PCI device assignment */
 #define ACRN_PTDEV_QUIRK_ASSIGN	(1U << 0)
 
+#define ACRN_MMIODEV_RES_NUM	3
 #define ACRN_PCI_NUM_BARS	6
 /**
  * struct acrn_pcidev - Info for assigning or de-assigning a PCI device
@@ -417,6 +418,29 @@ struct acrn_pcidev {
 	__u32	bar[ACRN_PCI_NUM_BARS];
 };
 
+/**
+ * struct acrn_mmiodev - Info for assigning or de-assigning a MMIO device
+ * @name:			Name of the MMIO device.
+ * @res[].user_vm_pa:		Physical address of User VM of the MMIO region
+ *				for the MMIO device.
+ * @res[].service_vm_pa:	Physical address of Service VM of the MMIO
+ *				region for the MMIO device.
+ * @res[].size:			Size of the MMIO region for the MMIO device.
+ * @res[].mem_type:		Memory type of the MMIO region for the MMIO
+ *				device.
+ *
+ * This structure will be passed to hypervisor directly.
+ */
+struct acrn_mmiodev {
+	__u8	name[8];
+	struct {
+		__u64	user_vm_pa;
+		__u64	service_vm_pa;
+		__u64	size;
+		__u64	mem_type;
+	} res[ACRN_MMIODEV_RES_NUM];
+};
+
 /**
  * struct acrn_msi_entry - Info for injecting a MSI interrupt to a VM
  * @msi_addr:	MSI addr[19:12] with dest vCPU ID
@@ -568,6 +592,10 @@ struct acrn_irqfd {
 	_IOW(ACRN_IOCTL_TYPE, 0x55, struct acrn_pcidev)
 #define ACRN_IOCTL_DEASSIGN_PCIDEV	\
 	_IOW(ACRN_IOCTL_TYPE, 0x56, struct acrn_pcidev)
+#define ACRN_IOCTL_ASSIGN_MMIODEV	\
+	_IOW(ACRN_IOCTL_TYPE, 0x57, struct acrn_mmiodev)
+#define ACRN_IOCTL_DEASSIGN_MMIODEV	\
+	_IOW(ACRN_IOCTL_TYPE, 0x58, struct acrn_mmiodev)
 
 #define ACRN_IOCTL_PM_GET_CPU_STATE	\
 	_IOWR(ACRN_IOCTL_TYPE, 0x60, __u64)
-- 
2.25.1

