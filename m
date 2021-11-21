Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E564583C0
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 14:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhKUNPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 08:15:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238106AbhKUNPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 08:15:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAA2A60E75;
        Sun, 21 Nov 2021 13:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637500335;
        bh=xa5PUu1aezw3CuKvL1DZs4G5e98ruRYGS/tjY8GUSoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDXF7MIk1nO2ShlTit/aV48JGomoDzjnq4+2Rj+EssGyEiW61h3y1DrmeB9lRiXsq
         0cYiyEKV4LyknU8PCx7RXiJ27sc74p+AYBmKt+WUbdUT3l8a+HXgKyK1VWFfWapK4g
         upEQnJ8ppZ2WUgw9CJDaJqF+wb8jvW/lyDtfwc5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.4
Date:   Sun, 21 Nov 2021 14:11:58 +0100
Message-Id: <1637500318164191@kroah.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <163750031819276@kroah.com>
References: <163750031819276@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 79eeb13c0973..759e68a02cf0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 3
+SUBLEVEL = 4
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 2716e58b498b..437c8d31f390 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1835,7 +1835,7 @@ syscall_restore:
 
 	/* Are we being ptraced? */
 	LDREG	TI_FLAGS-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r19
-	ldi	_TIF_SYSCALL_TRACE_MASK,%r2
+	ldi	_TIF_SINGLESTEP|_TIF_BLOCKSTEP,%r2
 	and,COND(=)	%r19,%r2,%r0
 	b,n	syscall_restore_rfi
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3de93d4bf16b..c48e2b5729c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3242,9 +3242,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 			     "xor %1, %1\n"
 			     "2:\n"
 			     _ASM_EXTABLE_UA(1b, 2b)
-			     : "+r" (st_preempted),
-			       "+&r" (err)
-			     : "m" (st->preempted));
+			     : "+q" (st_preempted),
+			       "+&r" (err),
+			       "+m" (st->preempted));
 		if (err)
 			goto out;
 
diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 1cfafa254e3d..7a33a6d985f8 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -340,28 +340,3 @@ void acpi_device_notify_remove(struct device *dev)
 
 	acpi_unbind_one(dev);
 }
-
-int acpi_dev_turn_off_if_unused(struct device *dev, void *not_used)
-{
-	struct acpi_device *adev = to_acpi_device(dev);
-
-	/*
-	 * Skip device objects with device IDs, because they may be in use even
-	 * if they are not companions of any physical device objects.
-	 */
-	if (adev->pnp.type.hardware_id)
-		return 0;
-
-	mutex_lock(&adev->physical_node_lock);
-
-	/*
-	 * Device objects without device IDs are not in use if they have no
-	 * corresponding physical device objects.
-	 */
-	if (list_empty(&adev->physical_node_list))
-		acpi_device_set_power(adev, ACPI_STATE_D3_COLD);
-
-	mutex_unlock(&adev->physical_node_lock);
-
-	return 0;
-}
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 8fbdc172864b..d91b560e8867 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -117,7 +117,6 @@ bool acpi_device_is_battery(struct acpi_device *adev);
 bool acpi_device_is_first_physical_node(struct acpi_device *adev,
 					const struct device *dev);
 int acpi_bus_register_early_device(int type);
-int acpi_dev_turn_off_if_unused(struct device *dev, void *not_used);
 
 /* --------------------------------------------------------------------------
                      Device Matching and Notification
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 770b82483d74..5b54c80b9d32 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2559,12 +2559,6 @@ int __init acpi_scan_init(void)
 		}
 	}
 
-	/*
-	 * Make sure that power management resources are not blocked by ACPI
-	 * device objects with no users.
-	 */
-	bus_for_each_dev(&acpi_bus_type, NULL, NULL, acpi_dev_turn_off_if_unused);
-
 	acpi_turn_off_unused_power_resources();
 
 	acpi_scan_initialized = true;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 7bf4686af774..dfc72a1f6500 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -272,19 +272,6 @@ static void __loop_update_dio(struct loop_device *lo, bool dio)
 		blk_mq_unfreeze_queue(lo->lo_queue);
 }
 
-/**
- * loop_validate_block_size() - validates the passed in block size
- * @bsize: size to validate
- */
-static int
-loop_validate_block_size(unsigned short bsize)
-{
-	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
-		return -EINVAL;
-
-	return 0;
-}
-
 /**
  * loop_set_size() - sets device size and notifies userspace
  * @lo: struct loop_device to set the size for
@@ -1236,7 +1223,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	}
 
 	if (config->block_size) {
-		error = loop_validate_block_size(config->block_size);
+		error = blk_validate_block_size(config->block_size);
 		if (error)
 			goto out_unlock;
 	}
@@ -1759,7 +1746,7 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
 
-	err = loop_validate_block_size(arg);
+	err = blk_validate_block_size(arg);
 	if (err)
 		return err;
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 60d2fce59a71..79d0db542da3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -433,6 +433,10 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
+	/* Additional Realtek 8761B Bluetooth devices */
+	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Additional Realtek 8761BU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
 	  					     BTUSB_WIDEBAND_SPEECH },
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 6ae4269118af..cea777ae7fb9 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -102,8 +102,9 @@ config DRM_DEBUG_DP_MST_TOPOLOGY_REFS
 
 config DRM_FBDEV_EMULATION
 	bool "Enable legacy fbdev support for your modesetting driver"
-	depends on DRM_KMS_HELPER
-	depends on FB=y || FB=DRM_KMS_HELPER
+	depends on DRM
+	depends on FB
+	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index ea6371eb9b25..e2dedfa9072d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -477,6 +477,9 @@ msi_setup_entry(struct pci_dev *dev, int nvec, struct irq_affinity *affd)
 		goto out;
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
+	/* Lies, damned lies, and MSIs */
+	if (dev->dev_flags & PCI_DEV_FLAGS_HAS_MSI_MASKING)
+		control |= PCI_MSI_FLAGS_MASKBIT;
 
 	entry->msi_attrib.is_msix	= 0;
 	entry->msi_attrib.is_64		= !!(control & PCI_MSI_FLAGS_64BIT);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6c957124f84d..208fa03acdda 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5796,3 +5796,9 @@ static void apex_pci_fixup_class(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_CLASS_HEADER(0x1ac1, 0x089a,
 			       PCI_CLASS_NOT_DEFINED, 8, apex_pci_fixup_class);
+
+static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
+{
+	pdev->dev_flags |= PCI_DEV_FLAGS_HAS_MSI_MASKING;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0ab8, nvidia_ion_ahci_fixup);
diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 6379f26a335f..9233f7e74454 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -89,7 +89,7 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->ops->get_temp)
+	if (!data->ops || !data->ops->get_temp)
 		return -EINVAL;
 
 	return data->ops->get_temp(data->sensor_data, temp);
@@ -186,6 +186,9 @@ static int of_thermal_set_emul_temp(struct thermal_zone_device *tz,
 {
 	struct __thermal_zone *data = tz->devdata;
 
+	if (!data->ops || !data->ops->set_emul_temp)
+		return -EINVAL;
+
 	return data->ops->set_emul_temp(data->sensor_data, temp);
 }
 
@@ -194,7 +197,7 @@ static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->ops->get_trend)
+	if (!data->ops || !data->ops->get_trend)
 		return -EINVAL;
 
 	return data->ops->get_trend(data->sensor_data, trip, trend);
@@ -301,7 +304,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
 	if (trip >= data->ntrips || trip < 0)
 		return -EDOM;
 
-	if (data->ops->set_trip_temp) {
+	if (data->ops && data->ops->set_trip_temp) {
 		int ret;
 
 		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a3b830b8410a..a53ebc52bd51 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -902,6 +902,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	spin_unlock(&cluster->refill_lock);
 
 	btrfs_clear_treelog_bg(block_group);
+	btrfs_clear_data_reloc_bg(block_group);
 
 	path = btrfs_alloc_path();
 	if (!path) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c0cebcf745ce..ae06ad559353 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1017,6 +1017,13 @@ struct btrfs_fs_info {
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
 
+	/*
+	 * Start of the dedicated data relocation block group, protected by
+	 * relocation_bg_lock.
+	 */
+	spinlock_t relocation_bg_lock;
+	u64 data_reloc_bg;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
@@ -3842,6 +3849,11 @@ static inline bool btrfs_is_zoned(const struct btrfs_fs_info *fs_info)
 	return fs_info->zoned != 0;
 }
 
+static inline bool btrfs_is_data_reloc_root(const struct btrfs_root *root)
+{
+	return root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID;
+}
+
 /*
  * We use page status Private2 to indicate there is an ordered extent with
  * unfinished IO.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6965ed081346..e00c4c1f622f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1500,7 +1500,7 @@ static int btrfs_init_fs_root(struct btrfs_root *root, dev_t anon_dev)
 		goto fail;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID &&
-	    root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
+	    !btrfs_is_data_reloc_root(root)) {
 		set_bit(BTRFS_ROOT_SHAREABLE, &root->state);
 		btrfs_check_and_init_root_item(&root->root_item);
 	}
@@ -2883,6 +2883,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	spin_lock_init(&fs_info->buffer_lock);
 	spin_lock_init(&fs_info->unused_bgs_lock);
 	spin_lock_init(&fs_info->treelog_bg_lock);
+	spin_lock_init(&fs_info->relocation_bg_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->unused_bg_unpin_mutex);
 	mutex_init(&fs_info->reclaim_bgs_lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0ab456cb4bf8..87c23c5c0f26 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2376,7 +2376,7 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
 
 out:
 	btrfs_free_path(path);
-	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+	if (btrfs_is_data_reloc_root(root))
 		WARN_ON(ret > 0);
 	return ret;
 }
@@ -3495,6 +3495,9 @@ struct find_free_extent_ctl {
 	/* Allocation is called for tree-log */
 	bool for_treelog;
 
+	/* Allocation is called for data relocation */
+	bool for_data_reloc;
+
 	/* RAID index, converted from flags */
 	int index;
 
@@ -3756,6 +3759,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	u64 avail;
 	u64 bytenr = block_group->start;
 	u64 log_bytenr;
+	u64 data_reloc_bytenr;
 	int ret = 0;
 	bool skip;
 
@@ -3773,13 +3777,31 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	if (skip)
 		return 1;
 
+	/*
+	 * Do not allow non-relocation blocks in the dedicated relocation block
+	 * group, and vice versa.
+	 */
+	spin_lock(&fs_info->relocation_bg_lock);
+	data_reloc_bytenr = fs_info->data_reloc_bg;
+	if (data_reloc_bytenr &&
+	    ((ffe_ctl->for_data_reloc && bytenr != data_reloc_bytenr) ||
+	     (!ffe_ctl->for_data_reloc && bytenr == data_reloc_bytenr)))
+		skip = true;
+	spin_unlock(&fs_info->relocation_bg_lock);
+	if (skip)
+		return 1;
+
 	spin_lock(&space_info->lock);
 	spin_lock(&block_group->lock);
 	spin_lock(&fs_info->treelog_bg_lock);
+	spin_lock(&fs_info->relocation_bg_lock);
 
 	ASSERT(!ffe_ctl->for_treelog ||
 	       block_group->start == fs_info->treelog_bg ||
 	       fs_info->treelog_bg == 0);
+	ASSERT(!ffe_ctl->for_data_reloc ||
+	       block_group->start == fs_info->data_reloc_bg ||
+	       fs_info->data_reloc_bg == 0);
 
 	if (block_group->ro) {
 		ret = 1;
@@ -3796,6 +3818,16 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 		goto out;
 	}
 
+	/*
+	 * Do not allow currently used block group to be the data relocation
+	 * dedicated block group.
+	 */
+	if (ffe_ctl->for_data_reloc && !fs_info->data_reloc_bg &&
+	    (block_group->used || block_group->reserved)) {
+		ret = 1;
+		goto out;
+	}
+
 	avail = block_group->length - block_group->alloc_offset;
 	if (avail < num_bytes) {
 		if (ffe_ctl->max_extent_size < avail) {
@@ -3813,6 +3845,9 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	if (ffe_ctl->for_treelog && !fs_info->treelog_bg)
 		fs_info->treelog_bg = block_group->start;
 
+	if (ffe_ctl->for_data_reloc && !fs_info->data_reloc_bg)
+		fs_info->data_reloc_bg = block_group->start;
+
 	ffe_ctl->found_offset = start + block_group->alloc_offset;
 	block_group->alloc_offset += num_bytes;
 	spin_lock(&ctl->tree_lock);
@@ -3829,6 +3864,9 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 out:
 	if (ret && ffe_ctl->for_treelog)
 		fs_info->treelog_bg = 0;
+	if (ret && ffe_ctl->for_data_reloc)
+		fs_info->data_reloc_bg = 0;
+	spin_unlock(&fs_info->relocation_bg_lock);
 	spin_unlock(&fs_info->treelog_bg_lock);
 	spin_unlock(&block_group->lock);
 	spin_unlock(&space_info->lock);
@@ -4085,6 +4123,12 @@ static int prepare_allocation(struct btrfs_fs_info *fs_info,
 				ffe_ctl->hint_byte = fs_info->treelog_bg;
 			spin_unlock(&fs_info->treelog_bg_lock);
 		}
+		if (ffe_ctl->for_data_reloc) {
+			spin_lock(&fs_info->relocation_bg_lock);
+			if (fs_info->data_reloc_bg)
+				ffe_ctl->hint_byte = fs_info->data_reloc_bg;
+			spin_unlock(&fs_info->relocation_bg_lock);
+		}
 		return 0;
 	default:
 		BUG();
@@ -4129,6 +4173,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 	struct btrfs_space_info *space_info;
 	bool full_search = false;
 	bool for_treelog = (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
+	bool for_data_reloc = (btrfs_is_data_reloc_root(root) &&
+				       flags & BTRFS_BLOCK_GROUP_DATA);
 
 	WARN_ON(num_bytes < fs_info->sectorsize);
 
@@ -4143,6 +4189,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 	ffe_ctl.found_offset = 0;
 	ffe_ctl.hint_byte = hint_byte_orig;
 	ffe_ctl.for_treelog = for_treelog;
+	ffe_ctl.for_data_reloc = for_data_reloc;
 	ffe_ctl.policy = BTRFS_EXTENT_ALLOC_CLUSTERED;
 
 	/* For clustered allocation */
@@ -4220,6 +4267,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		if (unlikely(block_group->ro)) {
 			if (for_treelog)
 				btrfs_clear_treelog_bg(block_group);
+			if (ffe_ctl.for_data_reloc)
+				btrfs_clear_data_reloc_bg(block_group);
 			continue;
 		}
 
@@ -4408,6 +4457,7 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	u64 flags;
 	int ret;
 	bool for_treelog = (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
+	bool for_data_reloc = (btrfs_is_data_reloc_root(root) && is_data);
 
 	flags = get_alloc_profile_by_root(root, is_data);
 again:
@@ -4431,8 +4481,8 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 
 			sinfo = btrfs_find_space_info(fs_info, flags);
 			btrfs_err(fs_info,
-			"allocation failed flags %llu, wanted %llu tree-log %d",
-				  flags, num_bytes, for_treelog);
+	"allocation failed flags %llu, wanted %llu tree-log %d, relocation: %d",
+				  flags, num_bytes, for_treelog, for_data_reloc);
 			if (sinfo)
 				btrfs_dump_space_info(fs_info, sinfo,
 						      num_bytes, 1);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index aaddd7225348..a40fb9c74dda 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5120,6 +5120,9 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
+	struct inode *inode = mapping->host;
+	const bool data_reloc = btrfs_is_data_reloc_root(BTRFS_I(inode)->root);
+	const bool zoned = btrfs_is_zoned(BTRFS_I(inode)->root->fs_info);
 	int ret = 0;
 	struct extent_page_data epd = {
 		.bio_ctrl = { 0 },
@@ -5127,7 +5130,15 @@ int extent_writepages(struct address_space *mapping,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
 
+	/*
+	 * Allow only a single thread to do the reloc work in zoned mode to
+	 * protect the write pointer updates.
+	 */
+	if (data_reloc && zoned)
+		btrfs_inode_lock(inode, 0);
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
+	if (data_reloc && zoned)
+		btrfs_inode_unlock(inode, 0);
 	ASSERT(ret <= 0);
 	if (ret < 0) {
 		end_write_bio(&epd, ret);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7c096ab9bb5e..61b4651f008d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1151,7 +1151,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	 * fails during the stage where it updates the bytenr of file extent
 	 * items.
 	 */
-	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+	if (btrfs_is_data_reloc_root(root))
 		min_alloc_size = num_bytes;
 	else
 		min_alloc_size = fs_info->sectorsize;
@@ -1187,8 +1187,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		if (ret)
 			goto out_drop_extent_cache;
 
-		if (root->root_key.objectid ==
-		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
+		if (btrfs_is_data_reloc_root(root)) {
 			ret = btrfs_reloc_clone_csums(inode, start,
 						      cur_alloc_size);
 			/*
@@ -1504,8 +1503,7 @@ static int fallback_to_cow(struct btrfs_inode *inode, struct page *locked_page,
 			   int *page_started, unsigned long *nr_written)
 {
 	const bool is_space_ino = btrfs_is_free_space_inode(inode);
-	const bool is_reloc_ino = (inode->root->root_key.objectid ==
-				   BTRFS_DATA_RELOC_TREE_OBJECTID);
+	const bool is_reloc_ino = btrfs_is_data_reloc_root(inode->root);
 	const u64 range_bytes = end + 1 - start;
 	struct extent_io_tree *io_tree = &inode->io_tree;
 	u64 range_start = start;
@@ -1867,8 +1865,7 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 			btrfs_dec_nocow_writers(fs_info, disk_bytenr);
 		nocow = false;
 
-		if (root->root_key.objectid ==
-		    BTRFS_DATA_RELOC_TREE_OBJECTID)
+		if (btrfs_is_data_reloc_root(root))
 			/*
 			 * Error handled later, as we must prevent
 			 * extent_clear_unlock_delalloc() in error handler
@@ -1948,7 +1945,15 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 	const bool zoned = btrfs_is_zoned(inode->root->fs_info);
 
 	if (should_nocow(inode, start, end)) {
-		ASSERT(!zoned);
+		/*
+		 * Normally on a zoned device we're only doing COW writes, but
+		 * in case of relocation on a zoned filesystem we have taken
+		 * precaution, that we're only writing sequentially. It's safe
+		 * to use run_delalloc_nocow() here, like for  regular
+		 * preallocated inodes.
+		 */
+		ASSERT(!zoned ||
+		       (zoned && btrfs_is_data_reloc_root(inode->root)));
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, nr_written);
 	} else if (!inode_can_compress(inode) ||
@@ -2207,7 +2212,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 		if (btrfs_is_testing(fs_info))
 			return;
 
-		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		if (!btrfs_is_data_reloc_root(root) &&
 		    do_list && !(state->state & EXTENT_NORESERVE) &&
 		    (*bits & EXTENT_CLEAR_DATA_RESV))
 			btrfs_free_reserved_data_space_noquota(fs_info, len);
@@ -2532,7 +2537,7 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
 		goto mapit;
 	} else if (async && !skip_sum) {
 		/* csum items have already been cloned */
-		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+		if (btrfs_is_data_reloc_root(root))
 			goto mapit;
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(inode, bio, mirror_num, bio_flags,
@@ -3304,7 +3309,7 @@ unsigned int btrfs_verify_data_csum(struct btrfs_io_bio *io_bio, u32 bio_offset,
 		u64 file_offset = pg_off + page_offset(page);
 		int ret;
 
-		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		if (btrfs_is_data_reloc_root(root) &&
 		    test_range_bit(io_tree, file_offset,
 				   file_offset + sectorsize - 1,
 				   EXTENT_NODATASUM, 1, NULL)) {
@@ -4005,7 +4010,7 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	 * without delay
 	 */
 	if (!btrfs_is_free_space_inode(inode)
-	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
+	    && !btrfs_is_data_reloc_root(root)
 	    && !test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
 		btrfs_update_root_times(trans, root);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 914d403b4415..d81bee621d37 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2852,31 +2852,6 @@ static noinline_for_stack int prealloc_file_extent_cluster(
 	if (ret)
 		return ret;
 
-	/*
-	 * On a zoned filesystem, we cannot preallocate the file region.
-	 * Instead, we dirty and fiemap_write the region.
-	 */
-	if (btrfs_is_zoned(inode->root->fs_info)) {
-		struct btrfs_root *root = inode->root;
-		struct btrfs_trans_handle *trans;
-
-		end = cluster->end - offset + 1;
-		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
-
-		inode->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
-		i_size_write(&inode->vfs_inode, end);
-		ret = btrfs_update_inode(trans, root, inode);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			btrfs_end_transaction(trans);
-			return ret;
-		}
-
-		return btrfs_end_transaction(trans);
-	}
-
 	btrfs_inode_lock(&inode->vfs_inode, 0);
 	for (nr = 0; nr < cluster->nr; nr++) {
 		start = cluster->boundary[nr] - offset;
@@ -3084,7 +3059,6 @@ static int relocate_one_page(struct inode *inode, struct file_ra_state *ra,
 static int relocate_file_extent_cluster(struct inode *inode,
 					struct file_extent_cluster *cluster)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 offset = BTRFS_I(inode)->index_cnt;
 	unsigned long index;
 	unsigned long last_index;
@@ -3114,8 +3088,6 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	for (index = (cluster->start - offset) >> PAGE_SHIFT;
 	     index <= last_index && !ret; index++)
 		ret = relocate_one_page(inode, ra, cluster, &cluster_nr, index);
-	if (btrfs_is_zoned(fs_info) && !ret)
-		ret = btrfs_wait_ordered_range(inode, 0, (u64)-1);
 	if (ret == 0)
 		WARN_ON(cluster_nr != cluster->nr);
 out:
@@ -3770,12 +3742,8 @@ static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_inode_item *item;
 	struct extent_buffer *leaf;
-	u64 flags = BTRFS_INODE_NOCOMPRESS | BTRFS_INODE_PREALLOC;
 	int ret;
 
-	if (btrfs_is_zoned(trans->fs_info))
-		flags &= ~BTRFS_INODE_PREALLOC;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -3790,7 +3758,8 @@ static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_generation(leaf, item, 1);
 	btrfs_set_inode_size(leaf, item, 0);
 	btrfs_set_inode_mode(leaf, item, S_IFREG | 0600);
-	btrfs_set_inode_flags(leaf, item, flags);
+	btrfs_set_inode_flags(leaf, item, BTRFS_INODE_NOCOMPRESS |
+					  BTRFS_INODE_PREALLOC);
 	btrfs_mark_buffer_dirty(leaf);
 out:
 	btrfs_free_path(path);
@@ -4386,8 +4355,7 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 	if (!rc)
 		return 0;
 
-	BUG_ON(rc->stage == UPDATE_DATA_PTRS &&
-	       root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID);
+	BUG_ON(rc->stage == UPDATE_DATA_PTRS && btrfs_is_data_reloc_root(root));
 
 	level = btrfs_header_level(buf);
 	if (btrfs_header_generation(buf) <=
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 47af1ab3bf12..5672c24a2d58 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1304,6 +1304,17 @@ bool btrfs_use_zone_append(struct btrfs_inode *inode, u64 start)
 	if (!is_data_inode(&inode->vfs_inode))
 		return false;
 
+	/*
+	 * Using REQ_OP_ZONE_APPNED for relocation can break assumptions on the
+	 * extent layout the relocation code has.
+	 * Furthermore we have set aside own block-group from which only the
+	 * relocation "process" can allocate and make sure only one process at a
+	 * time can add pages to an extent that gets relocated, so it's safe to
+	 * use regular REQ_OP_WRITE for this special case.
+	 */
+	if (btrfs_is_data_reloc_root(inode->root))
+		return false;
+
 	cache = btrfs_lookup_block_group(fs_info, start);
 	ASSERT(cache);
 	if (!cache)
@@ -1530,3 +1541,13 @@ struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 
 	return device;
 }
+
+void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	spin_lock(&fs_info->relocation_bg_lock);
+	if (fs_info->data_reloc_bg == bg->start)
+		fs_info->data_reloc_bg = 0;
+	spin_unlock(&fs_info->relocation_bg_lock);
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 4b299705bb12..70b3be517599 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -66,6 +66,7 @@ int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
 struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 					    u64 logical, u64 length);
+void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -199,6 +200,8 @@ static inline struct btrfs_device *btrfs_zoned_get_device(
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 683aee365420..0a9fdcbbab83 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -235,6 +235,14 @@ struct request {
 	void *end_io_data;
 };
 
+static inline int blk_validate_block_size(unsigned int bsize)
+{
+	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
+		return -EINVAL;
+
+	return 0;
+}
+
 static inline bool blk_op_is_passthrough(unsigned int op)
 {
 	op &= REQ_OP_MASK;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cd8aa6fce204..152a4d74f87f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -233,6 +233,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
 	/* Don't use Relaxed Ordering for TLPs directed at this device */
 	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
+	/* Device does honor MSI masking despite saying otherwise */
+	PCI_DEV_FLAGS_HAS_MSI_MASKING = (__force pci_dev_flags_t) (1 << 12),
 };
 
 enum pci_irq_reroute_variant {
diff --git a/include/linux/string.h b/include/linux/string.h
index 5e96d656be7a..d68097b4f600 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -262,23 +262,8 @@ void __write_overflow(void) __compiletime_error("detected write beyond size of o
 #include <linux/fortify-string.h>
 #endif
 
-/**
- * memcpy_and_pad - Copy one buffer to another with padding
- * @dest: Where to copy to
- * @dest_len: The destination buffer size
- * @src: Where to copy from
- * @count: The number of bytes to copy
- * @pad: Character to use for padding if space is left in destination.
- */
-static inline void memcpy_and_pad(void *dest, size_t dest_len,
-				  const void *src, size_t count, int pad)
-{
-	if (dest_len > count) {
-		memcpy(dest, src, count);
-		memset(dest + count, pad,  dest_len - count);
-	} else
-		memcpy(dest, src, dest_len);
-}
+void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
+		    int pad);
 
 /**
  * str_has_prefix - Test if a string has a given prefix
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f23ca260307f..7162b600e7ea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7154,7 +7154,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 static u64 perf_virt_to_phys(u64 virt)
 {
 	u64 phys_addr = 0;
-	struct page *p = NULL;
 
 	if (!virt)
 		return 0;
@@ -7173,14 +7172,15 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * If failed, leave phys_addr as 0.
 		 */
 		if (current->mm != NULL) {
+			struct page *p;
+
 			pagefault_disable();
-			if (get_user_page_fast_only(virt, 0, &p))
+			if (get_user_page_fast_only(virt, 0, &p)) {
 				phys_addr = page_to_phys(p) + virt % PAGE_SIZE;
+				put_page(p);
+			}
 			pagefault_enable();
 		}
-
-		if (p)
-			put_page(p);
 	}
 
 	return phys_addr;
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 3806a52ce697..2ddc10bd9add 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -696,3 +696,23 @@ void kfree_strarray(char **array, size_t n)
 	kfree(array);
 }
 EXPORT_SYMBOL_GPL(kfree_strarray);
+
+/**
+ * memcpy_and_pad - Copy one buffer to another with padding
+ * @dest: Where to copy to
+ * @dest_len: The destination buffer size
+ * @src: Where to copy from
+ * @count: The number of bytes to copy
+ * @pad: Character to use for padding if space is left in destination.
+ */
+void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
+		    int pad)
+{
+	if (dest_len > count) {
+		memcpy(dest, src, count);
+		memset(dest + count, pad,  dest_len - count);
+	} else {
+		memcpy(dest, src, dest_len);
+	}
+}
+EXPORT_SYMBOL(memcpy_and_pad);
diff --git a/security/Kconfig b/security/Kconfig
index 0ced7fd33e4d..fe6c0395fa02 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -191,6 +191,9 @@ config HARDENED_USERCOPY_PAGESPAN
 config FORTIFY_SOURCE
 	bool "Harden common str/mem functions against buffer overflows"
 	depends on ARCH_HAS_FORTIFY_SOURCE
+	# https://bugs.llvm.org/show_bug.cgi?id=50322
+	# https://bugs.llvm.org/show_bug.cgi?id=41459
+	depends on !CC_IS_CLANG
 	help
 	  Detect overflows of buffers in common string and memory functions
 	  where the compiler can determine and validate the buffer sizes.
