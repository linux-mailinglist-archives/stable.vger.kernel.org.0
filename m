Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11915261A2E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgIHScJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731364AbgIHQJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B8C32417A;
        Tue,  8 Sep 2020 15:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580167;
        bh=emSPZ9Igo1I57Y7i75m3CHBt6z7SZOgYhBhO6bVw/6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7y51iI5XAoCmYHaTnW78ZS9wn+W3riMvjE1tfAQYwGi9nQRBbsSL+n7b4a9+WjDL
         6j68yB3LEy9G7ubVuKLtYVAPJEtysjW35lT6MlYhKE8lzsJ6/pHfDPh0vOUneoZ0WJ
         CjgTN9NOxeJtYmAv7G5BRmwjCrld9fAQUDPgBVyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ajay Kaher <akaher@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/88] vfio-pci: Invalidate mmaps and block MMIO access on disabled memory
Date:   Tue,  8 Sep 2020 17:25:58 +0200
Message-Id: <20200908152223.982377606@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit abafbc551fddede3e0a08dee1dcde08fc0eb8476 upstream.

Accessing the disabled memory space of a PCI device would typically
result in a master abort response on conventional PCI, or an
unsupported request on PCI express.  The user would generally see
these as a -1 response for the read return data and the write would be
silently discarded, possibly with an uncorrected, non-fatal AER error
triggered on the host.  Some systems however take it upon themselves
to bring down the entire system when they see something that might
indicate a loss of data, such as this discarded write to a disabled
memory space.

To avoid this, we want to try to block the user from accessing memory
spaces while they're disabled.  We start with a semaphore around the
memory enable bit, where writers modify the memory enable state and
must be serialized, while readers make use of the memory region and
can access in parallel.  Writers include both direct manipulation via
the command register, as well as any reset path where the internal
mechanics of the reset may both explicitly and implicitly disable
memory access, and manipulation of the MSI-X configuration, where the
MSI-X vector table resides in MMIO space of the device.  Readers
include the read and write file ops to access the vfio device fd
offsets as well as memory mapped access.  In the latter case, we make
use of our new vma list support to zap, or invalidate, those memory
mappings in order to force them to be faulted back in on access.

Our semaphore usage will stall user access to MMIO spaces across
internal operations like reset, but the user might experience new
behavior when trying to access the MMIO space while disabled via the
PCI command register.  Access via read or write while disabled will
return -EIO and access via memory maps will result in a SIGBUS.  This
is expected to be compatible with known use cases and potentially
provides better error handling capabilities than present in the
hardware, while avoiding the more readily accessible and severe
platform error responses that might otherwise occur.

Fixes: CVE-2020-12888
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[Ajay: Regenerated the patch for v4.19]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c         | 291 ++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_config.c  |  36 +++-
 drivers/vfio/pci/vfio_pci_intrs.c   |  14 ++
 drivers/vfio/pci/vfio_pci_private.h |   9 +
 drivers/vfio/pci/vfio_pci_rdwr.c    |  24 ++-
 5 files changed, 331 insertions(+), 43 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 3cd596023c2bb..9f72a6ee13b53 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -29,6 +29,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
+#include <linux/sched/mm.h>
 
 #include "vfio_pci_private.h"
 
@@ -181,6 +182,7 @@ no_mmap:
 
 static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
 static void vfio_pci_disable(struct vfio_pci_device *vdev);
+static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -623,6 +625,12 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 	return 0;
 }
 
+struct vfio_devices {
+	struct vfio_device **devices;
+	int cur_index;
+	int max_index;
+};
+
 static long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
@@ -696,7 +704,7 @@ static long vfio_pci_ioctl(void *device_data,
 		{
 			void __iomem *io;
 			size_t size;
-			u16 orig_cmd;
+			u16 cmd;
 
 			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 			info.flags = 0;
@@ -716,10 +724,7 @@ static long vfio_pci_ioctl(void *device_data,
 			 * Is it really there?  Enable memory decode for
 			 * implicit access in pci_map_rom().
 			 */
-			pci_read_config_word(pdev, PCI_COMMAND, &orig_cmd);
-			pci_write_config_word(pdev, PCI_COMMAND,
-					      orig_cmd | PCI_COMMAND_MEMORY);
-
+			cmd = vfio_pci_memory_lock_and_enable(vdev);
 			io = pci_map_rom(pdev, &size);
 			if (io) {
 				info.flags = VFIO_REGION_INFO_FLAG_READ;
@@ -727,8 +732,8 @@ static long vfio_pci_ioctl(void *device_data,
 			} else {
 				info.size = 0;
 			}
+			vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-			pci_write_config_word(pdev, PCI_COMMAND, orig_cmd);
 			break;
 		}
 		case VFIO_PCI_VGA_REGION_INDEX:
@@ -865,8 +870,16 @@ static long vfio_pci_ioctl(void *device_data,
 		return ret;
 
 	} else if (cmd == VFIO_DEVICE_RESET) {
-		return vdev->reset_works ?
-			pci_try_reset_function(vdev->pdev) : -EINVAL;
+		int ret;
+
+		if (!vdev->reset_works)
+			return -EINVAL;
+
+		vfio_pci_zap_and_down_write_memory_lock(vdev);
+		ret = pci_try_reset_function(vdev->pdev);
+		up_write(&vdev->memory_lock);
+
+		return ret;
 
 	} else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
 		struct vfio_pci_hot_reset_info hdr;
@@ -946,8 +959,9 @@ reset_info_exit:
 		int32_t *group_fds;
 		struct vfio_pci_group_entry *groups;
 		struct vfio_pci_group_info info;
+		struct vfio_devices devs = { .cur_index = 0 };
 		bool slot = false;
-		int i, count = 0, ret = 0;
+		int i, group_idx, mem_idx = 0, count = 0, ret = 0;
 
 		minsz = offsetofend(struct vfio_pci_hot_reset, count);
 
@@ -999,9 +1013,9 @@ reset_info_exit:
 		 * user interface and store the group and iommu ID.  This
 		 * ensures the group is held across the reset.
 		 */
-		for (i = 0; i < hdr.count; i++) {
+		for (group_idx = 0; group_idx < hdr.count; group_idx++) {
 			struct vfio_group *group;
-			struct fd f = fdget(group_fds[i]);
+			struct fd f = fdget(group_fds[group_idx]);
 			if (!f.file) {
 				ret = -EBADF;
 				break;
@@ -1014,8 +1028,9 @@ reset_info_exit:
 				break;
 			}
 
-			groups[i].group = group;
-			groups[i].id = vfio_external_user_iommu_id(group);
+			groups[group_idx].group = group;
+			groups[group_idx].id =
+					vfio_external_user_iommu_id(group);
 		}
 
 		kfree(group_fds);
@@ -1034,13 +1049,63 @@ reset_info_exit:
 		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
 						    vfio_pci_validate_devs,
 						    &info, slot);
-		if (!ret)
-			/* User has access, do the reset */
-			ret = pci_reset_bus(vdev->pdev);
+		if (ret)
+			goto hot_reset_release;
+
+		devs.max_index = count;
+		devs.devices = kcalloc(count, sizeof(struct vfio_device *),
+				       GFP_KERNEL);
+		if (!devs.devices) {
+			ret = -ENOMEM;
+			goto hot_reset_release;
+		}
+
+		/*
+		 * We need to get memory_lock for each device, but devices
+		 * can share mmap_sem, therefore we need to zap and hold
+		 * the vma_lock for each device, and only then get each
+		 * memory_lock.
+		 */
+		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
+					    vfio_pci_try_zap_and_vma_lock_cb,
+					    &devs, slot);
+		if (ret)
+			goto hot_reset_release;
+
+		for (; mem_idx < devs.cur_index; mem_idx++) {
+			struct vfio_pci_device *tmp;
+
+			tmp = vfio_device_data(devs.devices[mem_idx]);
+
+			ret = down_write_trylock(&tmp->memory_lock);
+			if (!ret) {
+				ret = -EBUSY;
+				goto hot_reset_release;
+			}
+			mutex_unlock(&tmp->vma_lock);
+		}
+
+		/* User has access, do the reset */
+		ret = pci_reset_bus(vdev->pdev);
 
 hot_reset_release:
-		for (i--; i >= 0; i--)
-			vfio_group_put_external_user(groups[i].group);
+		for (i = 0; i < devs.cur_index; i++) {
+			struct vfio_device *device;
+			struct vfio_pci_device *tmp;
+
+			device = devs.devices[i];
+			tmp = vfio_device_data(device);
+
+			if (i < mem_idx)
+				up_write(&tmp->memory_lock);
+			else
+				mutex_unlock(&tmp->vma_lock);
+			vfio_device_put(device);
+		}
+		kfree(devs.devices);
+
+		for (group_idx--; group_idx >= 0; group_idx--)
+			vfio_group_put_external_user(groups[group_idx].group);
 
 		kfree(groups);
 		return ret;
@@ -1121,8 +1186,126 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
 
-static int vfio_pci_add_vma(struct vfio_pci_device *vdev,
-			    struct vm_area_struct *vma)
+/* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
+static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
+{
+	struct vfio_pci_mmap_vma *mmap_vma, *tmp;
+
+	/*
+	 * Lock ordering:
+	 * vma_lock is nested under mmap_sem for vm_ops callback paths.
+	 * The memory_lock semaphore is used by both code paths calling
+	 * into this function to zap vmas and the vm_ops.fault callback
+	 * to protect the memory enable state of the device.
+	 *
+	 * When zapping vmas we need to maintain the mmap_sem => vma_lock
+	 * ordering, which requires using vma_lock to walk vma_list to
+	 * acquire an mm, then dropping vma_lock to get the mmap_sem and
+	 * reacquiring vma_lock.  This logic is derived from similar
+	 * requirements in uverbs_user_mmap_disassociate().
+	 *
+	 * mmap_sem must always be the top-level lock when it is taken.
+	 * Therefore we can only hold the memory_lock write lock when
+	 * vma_list is empty, as we'd need to take mmap_sem to clear
+	 * entries.  vma_list can only be guaranteed empty when holding
+	 * vma_lock, thus memory_lock is nested under vma_lock.
+	 *
+	 * This enables the vm_ops.fault callback to acquire vma_lock,
+	 * followed by memory_lock read lock, while already holding
+	 * mmap_sem without risk of deadlock.
+	 */
+	while (1) {
+		struct mm_struct *mm = NULL;
+
+		if (try) {
+			if (!mutex_trylock(&vdev->vma_lock))
+				return 0;
+		} else {
+			mutex_lock(&vdev->vma_lock);
+		}
+		while (!list_empty(&vdev->vma_list)) {
+			mmap_vma = list_first_entry(&vdev->vma_list,
+						    struct vfio_pci_mmap_vma,
+						    vma_next);
+			mm = mmap_vma->vma->vm_mm;
+			if (mmget_not_zero(mm))
+				break;
+
+			list_del(&mmap_vma->vma_next);
+			kfree(mmap_vma);
+			mm = NULL;
+		}
+		if (!mm)
+			return 1;
+		mutex_unlock(&vdev->vma_lock);
+
+		if (try) {
+			if (!down_read_trylock(&mm->mmap_sem)) {
+				mmput(mm);
+				return 0;
+			}
+		} else {
+			down_read(&mm->mmap_sem);
+		}
+		if (mmget_still_valid(mm)) {
+			if (try) {
+				if (!mutex_trylock(&vdev->vma_lock)) {
+					up_read(&mm->mmap_sem);
+					mmput(mm);
+					return 0;
+				}
+			} else {
+				mutex_lock(&vdev->vma_lock);
+			}
+			list_for_each_entry_safe(mmap_vma, tmp,
+						 &vdev->vma_list, vma_next) {
+				struct vm_area_struct *vma = mmap_vma->vma;
+
+				if (vma->vm_mm != mm)
+					continue;
+
+				list_del(&mmap_vma->vma_next);
+				kfree(mmap_vma);
+
+				zap_vma_ptes(vma, vma->vm_start,
+					     vma->vm_end - vma->vm_start);
+			}
+			mutex_unlock(&vdev->vma_lock);
+		}
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+	}
+}
+
+void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device *vdev)
+{
+	vfio_pci_zap_and_vma_lock(vdev, false);
+	down_write(&vdev->memory_lock);
+	mutex_unlock(&vdev->vma_lock);
+}
+
+u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev)
+{
+	u16 cmd;
+
+	down_write(&vdev->memory_lock);
+	pci_read_config_word(vdev->pdev, PCI_COMMAND, &cmd);
+	if (!(cmd & PCI_COMMAND_MEMORY))
+		pci_write_config_word(vdev->pdev, PCI_COMMAND,
+				      cmd | PCI_COMMAND_MEMORY);
+
+	return cmd;
+}
+
+void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
+{
+	pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);
+	up_write(&vdev->memory_lock);
+}
+
+/* Caller holds vma_lock */
+static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
+			      struct vm_area_struct *vma)
 {
 	struct vfio_pci_mmap_vma *mmap_vma;
 
@@ -1131,10 +1314,7 @@ static int vfio_pci_add_vma(struct vfio_pci_device *vdev,
 		return -ENOMEM;
 
 	mmap_vma->vma = vma;
-
-	mutex_lock(&vdev->vma_lock);
 	list_add(&mmap_vma->vma_next, &vdev->vma_list);
-	mutex_unlock(&vdev->vma_lock);
 
 	return 0;
 }
@@ -1168,15 +1348,32 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_device *vdev = vma->vm_private_data;
+	vm_fault_t ret = VM_FAULT_NOPAGE;
+
+	mutex_lock(&vdev->vma_lock);
+	down_read(&vdev->memory_lock);
+
+	if (!__vfio_pci_memory_enabled(vdev)) {
+		ret = VM_FAULT_SIGBUS;
+		mutex_unlock(&vdev->vma_lock);
+		goto up_out;
+	}
+
+	if (__vfio_pci_add_vma(vdev, vma)) {
+		ret = VM_FAULT_OOM;
+		mutex_unlock(&vdev->vma_lock);
+		goto up_out;
+	}
 
-	if (vfio_pci_add_vma(vdev, vma))
-		return VM_FAULT_OOM;
+	mutex_unlock(&vdev->vma_lock);
 
 	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
-		return VM_FAULT_SIGBUS;
+		ret = VM_FAULT_SIGBUS;
 
-	return VM_FAULT_NOPAGE;
+up_out:
+	up_read(&vdev->memory_lock);
+	return ret;
 }
 
 static const struct vm_operations_struct vfio_pci_mmap_ops = {
@@ -1315,6 +1512,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
+	init_rwsem(&vdev->memory_lock);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret) {
@@ -1410,12 +1608,6 @@ static struct pci_driver vfio_pci_driver = {
 	.err_handler	= &vfio_err_handlers,
 };
 
-struct vfio_devices {
-	struct vfio_device **devices;
-	int cur_index;
-	int max_index;
-};
-
 static int vfio_pci_get_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
@@ -1437,6 +1629,39 @@ static int vfio_pci_get_devs(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
+static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
+{
+	struct vfio_devices *devs = data;
+	struct vfio_device *device;
+	struct vfio_pci_device *vdev;
+
+	if (devs->cur_index == devs->max_index)
+		return -ENOSPC;
+
+	device = vfio_device_get_from_dev(&pdev->dev);
+	if (!device)
+		return -EINVAL;
+
+	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+		vfio_device_put(device);
+		return -EBUSY;
+	}
+
+	vdev = vfio_device_data(device);
+
+	/*
+	 * Locking multiple devices is prone to deadlock, runaway and
+	 * unwind if we hit contention.
+	 */
+	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
+		vfio_device_put(device);
+		return -EBUSY;
+	}
+
+	devs->devices[devs->cur_index++] = device;
+	return 0;
+}
+
 /*
  * Attempt to do a bus/slot reset if there are devices affected by a reset for
  * this device that are needs_reset and all of the affected devices are unused
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 36bc8f104e42e..4fe71fbce1942 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -398,6 +398,14 @@ static inline void p_setd(struct perm_bits *p, int off, u32 virt, u32 write)
 	*(__le32 *)(&p->write[off]) = cpu_to_le32(write);
 }
 
+/* Caller should hold memory_lock semaphore */
+bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
+{
+	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
+
+	return cmd & PCI_COMMAND_MEMORY;
+}
+
 /*
  * Restore the *real* BARs after we detect a FLR or backdoor reset.
  * (backdoor = some device specific technique that we didn't catch)
@@ -558,13 +566,18 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 
 		new_cmd = le32_to_cpu(val);
 
+		phys_io = !!(phys_cmd & PCI_COMMAND_IO);
+		virt_io = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_IO);
+		new_io = !!(new_cmd & PCI_COMMAND_IO);
+
 		phys_mem = !!(phys_cmd & PCI_COMMAND_MEMORY);
 		virt_mem = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_MEMORY);
 		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
 
-		phys_io = !!(phys_cmd & PCI_COMMAND_IO);
-		virt_io = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_IO);
-		new_io = !!(new_cmd & PCI_COMMAND_IO);
+		if (!new_mem)
+			vfio_pci_zap_and_down_write_memory_lock(vdev);
+		else
+			down_write(&vdev->memory_lock);
 
 		/*
 		 * If the user is writing mem/io enable (new_mem/io) and we
@@ -581,8 +594,11 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 	}
 
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
-	if (count < 0)
+	if (count < 0) {
+		if (offset == PCI_COMMAND)
+			up_write(&vdev->memory_lock);
 		return count;
+	}
 
 	/*
 	 * Save current memory/io enable bits in vconfig to allow for
@@ -593,6 +609,8 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 
 		*virt_cmd &= cpu_to_le16(~mask);
 		*virt_cmd |= cpu_to_le16(new_cmd & mask);
+
+		up_write(&vdev->memory_lock);
 	}
 
 	/* Emulate INTx disable */
@@ -830,8 +848,11 @@ static int vfio_exp_config_write(struct vfio_pci_device *vdev, int pos,
 						 pos - offset + PCI_EXP_DEVCAP,
 						 &cap);
 
-		if (!ret && (cap & PCI_EXP_DEVCAP_FLR))
+		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
+			vfio_pci_zap_and_down_write_memory_lock(vdev);
 			pci_try_reset_function(vdev->pdev);
+			up_write(&vdev->memory_lock);
+		}
 	}
 
 	/*
@@ -909,8 +930,11 @@ static int vfio_af_config_write(struct vfio_pci_device *vdev, int pos,
 						pos - offset + PCI_AF_CAP,
 						&cap);
 
-		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP))
+		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
+			vfio_pci_zap_and_down_write_memory_lock(vdev);
 			pci_try_reset_function(vdev->pdev);
+			up_write(&vdev->memory_lock);
+		}
 	}
 
 	return count;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 94594dc63c417..bdfdd506bc588 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -252,6 +252,7 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
 	int ret;
+	u16 cmd;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
@@ -261,13 +262,16 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 		return -ENOMEM;
 
 	/* return the number of supported vectors if we can't get all: */
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	ret = pci_alloc_irq_vectors(pdev, 1, nvec, flag);
 	if (ret < nvec) {
 		if (ret > 0)
 			pci_free_irq_vectors(pdev);
+		vfio_pci_memory_unlock_and_restore(vdev, cmd);
 		kfree(vdev->ctx);
 		return ret;
 	}
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
 	vdev->num_ctx = nvec;
 	vdev->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
@@ -290,6 +294,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	struct pci_dev *pdev = vdev->pdev;
 	struct eventfd_ctx *trigger;
 	int irq, ret;
+	u16 cmd;
 
 	if (vector < 0 || vector >= vdev->num_ctx)
 		return -EINVAL;
@@ -298,7 +303,11 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 
 	if (vdev->ctx[vector].trigger) {
 		irq_bypass_unregister_producer(&vdev->ctx[vector].producer);
+
+		cmd = vfio_pci_memory_lock_and_enable(vdev);
 		free_irq(irq, vdev->ctx[vector].trigger);
+		vfio_pci_memory_unlock_and_restore(vdev, cmd);
+
 		kfree(vdev->ctx[vector].name);
 		eventfd_ctx_put(vdev->ctx[vector].trigger);
 		vdev->ctx[vector].trigger = NULL;
@@ -326,6 +335,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	 * such a reset it would be unsuccessful. To avoid this, restore the
 	 * cached value of the message prior to enabling.
 	 */
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	if (msix) {
 		struct msi_msg msg;
 
@@ -335,6 +345,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 
 	ret = request_irq(irq, vfio_msihandler, 0,
 			  vdev->ctx[vector].name, trigger);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 	if (ret) {
 		kfree(vdev->ctx[vector].name);
 		eventfd_ctx_put(trigger);
@@ -379,6 +390,7 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int i;
+	u16 cmd;
 
 	for (i = 0; i < vdev->num_ctx; i++) {
 		vfio_virqfd_disable(&vdev->ctx[i].unmask);
@@ -387,7 +399,9 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 
 	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
 
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	pci_free_irq_vectors(pdev);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
 	/*
 	 * Both disable paths above use pci_intx_for_msi() to clear DisINTx
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 9743c934199d6..17d2bae5b013c 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -118,6 +118,7 @@ struct vfio_pci_device {
 	struct list_head	ioeventfds_list;
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
+	struct rw_semaphore	memory_lock;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
@@ -156,6 +157,14 @@ extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 					unsigned int type, unsigned int subtype,
 					const struct vfio_pci_regops *ops,
 					size_t size, u32 flags, void *data);
+
+extern bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev);
+extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device
+						    *vdev);
+extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev);
+extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev,
+					       u16 cmd);
+
 #ifdef CONFIG_VFIO_PCI_IGD
 extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
 #else
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a6029d0a55244..3d0ec2bbe131f 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -165,6 +165,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 	size_t x_start = 0, x_end = 0;
 	resource_size_t end;
 	void __iomem *io;
+	struct resource *res = &vdev->pdev->resource[bar];
 	ssize_t done;
 
 	if (pci_resource_start(pdev, bar))
@@ -180,6 +181,14 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 
 	count = min(count, (size_t)(end - pos));
 
+	if (res->flags & IORESOURCE_MEM) {
+		down_read(&vdev->memory_lock);
+		if (!__vfio_pci_memory_enabled(vdev)) {
+			up_read(&vdev->memory_lock);
+			return -EIO;
+		}
+	}
+
 	if (bar == PCI_ROM_RESOURCE) {
 		/*
 		 * The ROM can fill less space than the BAR, so we start the
@@ -187,13 +196,17 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 		 * filling large ROM BARs much faster.
 		 */
 		io = pci_map_rom(pdev, &x_start);
-		if (!io)
-			return -ENOMEM;
+		if (!io) {
+			done = -ENOMEM;
+			goto out;
+		}
 		x_end = end;
 	} else {
 		int ret = vfio_pci_setup_barmap(vdev, bar);
-		if (ret)
-			return ret;
+		if (ret) {
+			done = ret;
+			goto out;
+		}
 
 		io = vdev->barmap[bar];
 	}
@@ -210,6 +223,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 
 	if (bar == PCI_ROM_RESOURCE)
 		pci_unmap_rom(pdev, io);
+out:
+	if (res->flags & IORESOURCE_MEM)
+		up_read(&vdev->memory_lock);
 
 	return done;
 }
-- 
2.25.1



