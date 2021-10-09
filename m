Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E06427A91
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 15:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhJIN2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 09:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233652AbhJIN2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 09:28:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F1D660F70;
        Sat,  9 Oct 2021 13:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633785997;
        bh=rgjse+G6Fcvi16PrnucqV09ojroiBR1C0VKUHh0164M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbZgVwuJRWMdeWYXk7rIle48SJjUiVZOUJJ0uKiD6/leYAXjN3pbHCgzKoue8BM0X
         et94TgGVlS3x1WktFrxiMV0OMxR7WCD8ncRo4pJHOM4Q3G5SzCXCJZf9ADUqLOmJKp
         lloWw8KX1vBjE21ywqGcsU5v0h5wHS612Q+162gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.152
Date:   Sat,  9 Oct 2021 15:26:29 +0200
Message-Id: <163378598924089@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <1633785989129248@kroah.com>
References: <1633785989129248@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4eeb72027815..ffcdc36c56f5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 151
+SUBLEVEL = 152
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/arch/sparc/lib/iomap.c b/arch/sparc/lib/iomap.c
index c9da9f139694..f3a8cd491ce0 100644
--- a/arch/sparc/lib/iomap.c
+++ b/arch/sparc/lib/iomap.c
@@ -19,8 +19,10 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
+#ifdef CONFIG_PCI
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	/* nothing to do */
 }
 EXPORT_SYMBOL(pci_iounmap);
+#endif
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index e622158f5659..00bccb4d1772 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2108,6 +2108,7 @@ static int x86_pmu_event_init(struct perf_event *event)
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
+		event->destroy = NULL;
 	}
 
 	if (READ_ONCE(x86_pmu.attr_rdpmc) &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1a0eebdcf64..0aaf40be956f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1239,6 +1239,13 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
+	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
+	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
+	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
+	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
+	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5c354c7aff94..7c6c05fd5dfc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2252,6 +2252,25 @@ static void ata_dev_config_ncq_prio(struct ata_device *dev)
 
 }
 
+static bool ata_dev_check_adapter(struct ata_device *dev,
+				  unsigned short vendor_id)
+{
+	struct pci_dev *pcidev = NULL;
+	struct device *parent_dev = NULL;
+
+	for (parent_dev = dev->tdev.parent; parent_dev != NULL;
+	     parent_dev = parent_dev->parent) {
+		if (dev_is_pci(parent_dev)) {
+			pcidev = to_pci_dev(parent_dev);
+			if (pcidev->vendor == vendor_id)
+				return true;
+			break;
+		}
+	}
+
+	return false;
+}
+
 static int ata_dev_config_ncq(struct ata_device *dev,
 			       char *desc, size_t desc_sz)
 {
@@ -2268,6 +2287,13 @@ static int ata_dev_config_ncq(struct ata_device *dev,
 		snprintf(desc, desc_sz, "NCQ (not used)");
 		return 0;
 	}
+
+	if (dev->horkage & ATA_HORKAGE_NO_NCQ_ON_ATI &&
+	    ata_dev_check_adapter(dev, PCI_VENDOR_ID_ATI)) {
+		snprintf(desc, desc_sz, "NCQ (not used)");
+		return 0;
+	}
+
 	if (ap->flags & ATA_FLAG_NCQ) {
 		hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE);
 		dev->flags |= ATA_DFLAG_NCQ;
@@ -4557,9 +4583,11 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 860*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
-						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NO_NCQ_ON_ATI, },
 	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
-						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NO_NCQ_ON_ATI, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 
@@ -6916,6 +6944,8 @@ static int __init ata_parse_force_one(char **cur,
 		{ "ncq",	.horkage_off	= ATA_HORKAGE_NONCQ },
 		{ "noncqtrim",	.horkage_on	= ATA_HORKAGE_NO_NCQ_TRIM },
 		{ "ncqtrim",	.horkage_off	= ATA_HORKAGE_NO_NCQ_TRIM },
+		{ "noncqati",	.horkage_on	= ATA_HORKAGE_NO_NCQ_ON_ATI },
+		{ "ncqati",	.horkage_off	= ATA_HORKAGE_NO_NCQ_ON_ATI },
 		{ "dump_id",	.horkage_on	= ATA_HORKAGE_DUMP_ID },
 		{ "pio0",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 0) },
 		{ "pio1",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 1) },
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index c1d345c3cab3..b2dd293fc87e 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -180,6 +180,16 @@ static int mdio_remove(struct device *dev)
 	return 0;
 }
 
+static void mdio_shutdown(struct device *dev)
+{
+	struct mdio_device *mdiodev = to_mdio_device(dev);
+	struct device_driver *drv = mdiodev->dev.driver;
+	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
+
+	if (mdiodrv->shutdown)
+		mdiodrv->shutdown(mdiodev);
+}
+
 /**
  * mdio_driver_register - register an mdio_driver with the MDIO layer
  * @new_driver: new mdio_driver to register
@@ -194,6 +204,7 @@ int mdio_driver_register(struct mdio_driver *drv)
 	mdiodrv->driver.bus = &mdio_bus_type;
 	mdiodrv->driver.probe = mdio_probe;
 	mdiodrv->driver.remove = mdio_remove;
+	mdiodrv->driver.shutdown = mdio_shutdown;
 
 	retval = driver_register(&mdiodrv->driver);
 	if (retval) {
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index c213f2b81269..995566a2785f 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -492,7 +492,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 				 * the header's copy failed, and they are
 				 * sharing a slot, send an error
 				 */
-				if (i == 0 && sharedslot)
+				if (i == 0 && !first_shinfo && sharedslot)
 					xenvif_idx_release(queue, pending_idx,
 							   XEN_NETIF_RSP_ERROR);
 				else
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f55249766d22..152b48605152 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3345,15 +3345,16 @@ static int sd_probe(struct device *dev)
 	}
 
 	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = dev;
+	sdkp->dev.parent = get_device(dev);
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
 	error = device_add(&sdkp->dev);
-	if (error)
-		goto out_free_index;
+	if (error) {
+		put_device(&sdkp->dev);
+		goto out;
+	}
 
-	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
 	gd->major = sd_major((index & 0xf0) >> 4);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..43e682297fd5 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,9 +87,16 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
+	unsigned int retries = SES_RETRIES;
+	struct scsi_sense_hdr sshdr;
+
+	do {
+		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+				       &sshdr, SES_TIMEOUT, 1, NULL);
+	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
+		 (sshdr.sense_key == NOT_READY ||
+		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (unlikely(ret))
 		return ret;
 
@@ -121,9 +128,16 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
+	struct scsi_sense_hdr sshdr;
+	unsigned int retries = SES_RETRIES;
+
+	do {
+		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
+					  &sshdr, SES_TIMEOUT, 1, NULL);
+	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
+		 (sshdr.sense_key == NOT_READY ||
+		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-				  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index f29fbadb0548..78329d0e9af0 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5074,6 +5074,10 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg)
 	hcd->has_tt = 1;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		retval = -EINVAL;
+		goto error1;
+	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index e0cc55164505..abac81a2e694 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -48,10 +48,9 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 	if (block_group >= sbi->s_groups_count) {
-		ext2_error (sb, "ext2_get_group_desc",
-			    "block_group >= groups_count - "
-			    "block_group = %d, groups_count = %lu",
-			    block_group, sbi->s_groups_count);
+		WARN(1, "block_group >= groups_count - "
+		     "block_group = %d, groups_count = %lu",
+		     block_group, sbi->s_groups_count);
 
 		return NULL;
 	}
@@ -59,10 +58,9 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 	group_desc = block_group >> EXT2_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT2_DESC_PER_BLOCK(sb) - 1);
 	if (!sbi->s_group_desc[group_desc]) {
-		ext2_error (sb, "ext2_get_group_desc",
-			    "Group descriptor not loaded - "
-			    "block_group = %d, group_desc = %lu, desc = %lu",
-			     block_group, group_desc, offset);
+		WARN(1, "Group descriptor not loaded - "
+		     "block_group = %d, group_desc = %lu, desc = %lu",
+		      block_group, group_desc, offset);
 		return NULL;
 	}
 
diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 4a258065188e..670e97dd67f0 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -173,14 +173,10 @@ int nfsd_reply_cache_init(struct nfsd_net *nn)
 	if (status)
 		goto out_nomem;
 
-	nn->drc_hashtbl = kcalloc(hashsize,
-				sizeof(*nn->drc_hashtbl), GFP_KERNEL);
-	if (!nn->drc_hashtbl) {
-		nn->drc_hashtbl = vzalloc(array_size(hashsize,
-						 sizeof(*nn->drc_hashtbl)));
-		if (!nn->drc_hashtbl)
-			goto out_shrinker;
-	}
+	nn->drc_hashtbl = kvzalloc(array_size(hashsize,
+				sizeof(*nn->drc_hashtbl)), GFP_KERNEL);
+	if (!nn->drc_hashtbl)
+		goto out_shrinker;
 
 	for (i = 0; i < hashsize; i++) {
 		INIT_LIST_HEAD(&nn->drc_hashtbl[i].lru_head);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3c3d8d6b1618..3d5adbaf8214 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -423,6 +423,7 @@ enum {
 	ATA_HORKAGE_NOTRIM	= (1 << 24),	/* don't use TRIM */
 	ATA_HORKAGE_MAX_SEC_1024 = (1 << 25),	/* Limit max sects to 1024 */
 	ATA_HORKAGE_MAX_TRIM_128M = (1 << 26),	/* Limit max trim size to 128M */
+	ATA_HORKAGE_NO_NCQ_ON_ATI = (1 << 27),	/* Disable NCQ on ATI chipset */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index a7604248777b..0f1f784de80e 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -64,6 +64,9 @@ struct mdio_driver {
 
 	/* Clears up any memory if needed */
 	void (*remove)(struct mdio_device *mdiodev);
+
+	/* Quiesces the device on system shutdown, turns off interrupts etc */
+	void (*shutdown)(struct mdio_device *mdiodev);
 };
 #define to_mdio_driver(d)						\
 	container_of(to_mdio_common_driver(d), struct mdio_driver, mdiodrv)
diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
index 00bb97d76000..2cbc09aad7f6 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -82,7 +82,8 @@ int get_warnings_count(void)
 	FILE *f;
 
 	f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
-	fscanf(f, "%d", &warnings);
+	if (fscanf(f, "%d", &warnings) < 1)
+		warnings = 0;
 	fclose(f);
 
 	return warnings;
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 67386aa3f31d..8794ce382bf5 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -48,6 +48,7 @@ ARCH		?= $(SUBARCH)
 # When local build is done, headers are installed in the default
 # INSTALL_HDR_PATH usr/include.
 .PHONY: khdr
+.NOTPARALLEL:
 khdr:
 ifndef KSFT_KHDR_INSTALL_DONE
 ifeq (1,$(DEFAULT_INSTALL_HDR_PATH))
diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index ee8208b2f946..69c3ead25313 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -265,12 +265,6 @@ static int find_testdev(const char *name, const struct stat *sb, int flag)
 	}
 
 	entry->ifnum = ifnum;
-
-	/* FIXME update USBDEVFS_CONNECTINFO so it tells about high speed etc */
-
-	fprintf(stderr, "%s speed\t%s\t%u\n",
-		speed(entry->speed), entry->name, entry->ifnum);
-
 	entry->next = testdevs;
 	testdevs = entry;
 	return 0;
@@ -299,6 +293,14 @@ static void *handle_testdev (void *arg)
 		return 0;
 	}
 
+	status  =  ioctl(fd, USBDEVFS_GET_SPEED, NULL);
+	if (status < 0)
+		fprintf(stderr, "USBDEVFS_GET_SPEED failed %d\n", status);
+	else
+		dev->speed = status;
+	fprintf(stderr, "%s speed\t%s\t%u\n",
+			speed(dev->speed), dev->name, dev->ifnum);
+
 restart:
 	for (i = 0; i < TEST_CASES; i++) {
 		if (dev->test != -1 && dev->test != i)
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 58c0eab71bca..d2e836b2d16b 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -1329,7 +1329,7 @@ int main(int argc, char *argv[])
 	if (opt_list && opt_list_mapcnt)
 		kpagecount_fd = checked_open(PROC_KPAGECOUNT, O_RDONLY);
 
-	if (opt_mark_idle && opt_file)
+	if (opt_mark_idle)
 		page_idle_fd = checked_open(SYS_KERNEL_MM_PAGE_IDLE, O_RDWR);
 
 	if (opt_list && opt_pid)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 77f84cbca740..f31976010622 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2470,15 +2470,19 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 
 static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 {
-	unsigned int old, val, shrink;
+	unsigned int old, val, shrink, grow_start;
 
 	old = val = vcpu->halt_poll_ns;
 	shrink = READ_ONCE(halt_poll_ns_shrink);
+	grow_start = READ_ONCE(halt_poll_ns_grow_start);
 	if (shrink == 0)
 		val = 0;
 	else
 		val /= shrink;
 
+	if (val < grow_start)
+		val = 0;
+
 	vcpu->halt_poll_ns = val;
 	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
 }
