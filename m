Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B732D4583C3
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 14:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhKUNQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 08:16:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238163AbhKUNQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 08:16:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4724160232;
        Sun, 21 Nov 2021 13:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637500387;
        bh=HMnQYEH8AJCRyXJQrDxWRKNQU7EQjEjmb3uu7R+mHTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+1Bx/rpUggsY2J70ScV+2SJ5Qk24OnBPdWz/tAFHZpZyRkdrc1bIp+TmLTpG/0X2
         hzO3UwLW05w10oHwpBZ7RE1UPVlSL3ZfM6B2JmRy5w2iSPEtboT4BL2cw5e7iCxfnm
         TBL1fH/8Wh5+mtYNZxsm8XCcMwNx4H7aHZD99fa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.14.21
Date:   Sun, 21 Nov 2021 14:13:04 +0100
Message-Id: <163750033117134@kroah.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <1637500331152110@kroah.com>
References: <1637500331152110@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0e14a3a30d07..8b5ba7ee7543 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 14
-SUBLEVEL = 20
+SUBLEVEL = 21
 EXTRAVERSION =
 NAME = Opossums on Parade
 
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
index 285e86593143..599ed79581bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3237,9 +3237,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
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
index 3fd1713f1f62..fce3f3bba714 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -363,28 +363,3 @@ int acpi_platform_notify(struct device *dev, enum kobject_action action)
 	}
 	return 0;
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
index ae9464091f1b..b24513ec3fae 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2560,12 +2560,6 @@ int __init acpi_scan_init(void)
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
index 1f91bd41a29b..b7956c529425 100644
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
@@ -1235,7 +1222,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	}
 
 	if (config->block_size) {
-		error = loop_validate_block_size(config->block_size);
+		error = blk_validate_block_size(config->block_size);
 		if (error)
 			goto out_unlock;
 	}
@@ -1761,7 +1748,7 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
 
-	err = loop_validate_block_size(arg);
+	err = blk_validate_block_size(arg);
 	if (err)
 		return err;
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index bd37d6fb88c2..40814d98a1a4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -434,6 +434,10 @@ static const struct usb_device_id blacklist_table[] = {
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
index 0bba672176b1..7ff89690a976 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -97,8 +97,9 @@ config DRM_DEBUG_DP_MST_TOPOLOGY_REFS
 
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
index 3a9f4f8ad8f9..da5fbfcda433 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -368,18 +368,6 @@ static void free_msi_irqs(struct pci_dev *dev)
 			for (i = 0; i < entry->nvec_used; i++)
 				BUG_ON(irq_has_action(entry->irq + i));
 
-	pci_msi_teardown_msi_irqs(dev);
-
-	list_for_each_entry_safe(entry, tmp, msi_list, list) {
-		if (entry->msi_attrib.is_msix) {
-			if (list_is_last(&entry->list, msi_list))
-				iounmap(entry->mask_base);
-		}
-
-		list_del(&entry->list);
-		free_msi_entry(entry);
-	}
-
 	if (dev->msi_irq_groups) {
 		sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
 		msi_attrs = dev->msi_irq_groups[0]->attrs;
@@ -395,6 +383,18 @@ static void free_msi_irqs(struct pci_dev *dev)
 		kfree(dev->msi_irq_groups);
 		dev->msi_irq_groups = NULL;
 	}
+
+	pci_msi_teardown_msi_irqs(dev);
+
+	list_for_each_entry_safe(entry, tmp, msi_list, list) {
+		if (entry->msi_attrib.is_msix) {
+			if (list_is_last(&entry->list, msi_list))
+				iounmap(entry->mask_base);
+		}
+
+		list_del(&entry->list);
+		free_msi_entry(entry);
+	}
 }
 
 static void pci_intx_for_msi(struct pci_dev *dev, int enable)
@@ -585,6 +585,9 @@ msi_setup_entry(struct pci_dev *dev, int nvec, struct irq_affinity *affd)
 		goto out;
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
+	/* Lies, damned lies, and MSIs */
+	if (dev->dev_flags & PCI_DEV_FLAGS_HAS_MSI_MASKING)
+		control |= PCI_MSI_FLAGS_MASKBIT;
 
 	entry->msi_attrib.is_msix	= 0;
 	entry->msi_attrib.is_64		= !!(control & PCI_MSI_FLAGS_64BIT);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index cef69b71a6f1..d6000202a455 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5760,3 +5760,9 @@ static void apex_pci_fixup_class(struct pci_dev *pdev)
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e7979fe7e4fa..42ed8ccc40e7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -240,6 +240,14 @@ struct request {
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
index acbed2ecf6e8..25acd447c922 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -227,6 +227,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
 	/* Don't use Relaxed Ordering for TLPs directed at this device */
 	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
+	/* Device does honor MSI masking despite saying otherwise */
+	PCI_DEV_FLAGS_HAS_MSI_MASKING = (__force pci_dev_flags_t) (1 << 12),
 };
 
 enum pci_irq_reroute_variant {
diff --git a/init/main.c b/init/main.c
index 90733a916791..5840218c0677 100644
--- a/init/main.c
+++ b/init/main.c
@@ -382,6 +382,7 @@ static char * __init xbc_make_cmdline(const char *key)
 	ret = xbc_snprint_cmdline(new_cmdline, len + 1, root);
 	if (ret < 0 || ret > len) {
 		pr_err("Failed to print extra kernel cmdline.\n");
+		memblock_free(__pa(new_cmdline), len + 1);
 		return NULL;
 	}
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 22c5b1622c22..69f86bc95011 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7141,7 +7141,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 static u64 perf_virt_to_phys(u64 virt)
 {
 	u64 phys_addr = 0;
-	struct page *p = NULL;
 
 	if (!virt)
 		return 0;
@@ -7160,14 +7159,15 @@ static u64 perf_virt_to_phys(u64 virt)
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
