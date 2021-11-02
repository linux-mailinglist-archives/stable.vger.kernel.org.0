Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E42443614
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 19:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhKBS4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 14:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhKBSz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 14:55:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E6F6103C;
        Tue,  2 Nov 2021 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635879204;
        bh=OJi5q6aquBFFOxNNq3mdy+D8t1tioOfSuKF8lMMYsoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyC5jGmkXimVNKIl+RrVaLyDY7wC7EflOwkieTu2SzGfOiKDIXw4SAI6LZ/IVMQlV
         l6W27a81MM8qFlJbPVfNZ26elC1Obi2ojfJW3gQjHyZ61xPgZ4/FxzfRMXpJa8lOlH
         LIE11jICok+tPIVDeXtF3+fPpkUZK861lniKrQsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.291
Date:   Tue,  2 Nov 2021 19:53:17 +0100
Message-Id: <1635879196203168@kroah.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <163587919642151@kroah.com>
References: <163587919642151@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index c9dace8cb59d..62b5a3cfaf4e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 290
+SUBLEVEL = 291
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 2c2b28ee4811..3a4774dfc1f7 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -13,7 +13,7 @@
 # Ensure linker flags are correct
 LDFLAGS		:=
 
-LDFLAGS_vmlinux	:=-p --no-undefined -X --pic-veneer
+LDFLAGS_vmlinux	:= --no-undefined -X --pic-veneer
 ifeq ($(CONFIG_CPU_ENDIAN_BE8),y)
 LDFLAGS_vmlinux	+= --be8
 LDFLAGS_MODULE	+= --be8
diff --git a/arch/arm/boot/bootp/Makefile b/arch/arm/boot/bootp/Makefile
index 5761f0039133..9ee49d50842f 100644
--- a/arch/arm/boot/bootp/Makefile
+++ b/arch/arm/boot/bootp/Makefile
@@ -7,7 +7,7 @@
 
 GCOV_PROFILE	:= n
 
-LDFLAGS_bootp	:=-p --no-undefined -X \
+LDFLAGS_bootp	:= --no-undefined -X \
 		 --defsym initrd_phys=$(INITRD_PHYS) \
 		 --defsym params_phys=$(PARAMS_PHYS) -T
 AFLAGS_initrd.o :=-DINITRD=\"$(INITRD)\"
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 7f167276d4c5..b4631e07b3b6 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -122,8 +122,6 @@ endif
 ifeq ($(CONFIG_CPU_ENDIAN_BE8),y)
 LDFLAGS_vmlinux += --be8
 endif
-# ?
-LDFLAGS_vmlinux += -p
 # Report unresolved symbol references
 LDFLAGS_vmlinux += --no-undefined
 # Delete all temporary local symbols
diff --git a/arch/arm/boot/compressed/decompress.c b/arch/arm/boot/compressed/decompress.c
index a0765e7ed6c7..b0255cbf3b76 100644
--- a/arch/arm/boot/compressed/decompress.c
+++ b/arch/arm/boot/compressed/decompress.c
@@ -46,7 +46,10 @@ extern char * strstr(const char * s1, const char *s2);
 #endif
 
 #ifdef CONFIG_KERNEL_XZ
+/* Prevent KASAN override of string helpers in decompressor */
+#undef memmove
 #define memmove memmove
+#undef memcpy
 #define memcpy memcpy
 #include "../../../../lib/decompress_unxz.c"
 #endif
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 1da55d34f4d6..f1239c52e35d 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -327,6 +327,7 @@ ENTRY(\name\()_cache_fns)
 
 .macro define_tlb_functions name:req, flags_up:req, flags_smp
 	.type	\name\()_tlb_fns, #object
+	.align 2
 ENTRY(\name\()_tlb_fns)
 	.long	\name\()_flush_user_tlb_range
 	.long	\name\()_flush_kern_tlb_range
diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
index c3362ddd6c4c..bc7a5dbaf423 100644
--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -666,7 +666,7 @@ static struct undef_hook kprobes_arm_break_hook = {
 
 #endif /* !CONFIG_THUMB2_KERNEL */
 
-int __init arch_init_kprobes()
+int __init arch_init_kprobes(void)
 {
 	arm_probes_decode_init();
 #ifdef CONFIG_THUMB2_KERNEL
diff --git a/arch/nios2/platform/Kconfig.platform b/arch/nios2/platform/Kconfig.platform
index d3e5df9fb36b..78ffc0bf4ebe 100644
--- a/arch/nios2/platform/Kconfig.platform
+++ b/arch/nios2/platform/Kconfig.platform
@@ -37,6 +37,7 @@ config NIOS2_DTB_PHYS_ADDR
 
 config NIOS2_DTB_SOURCE_BOOL
 	bool "Compile and link device tree into kernel image"
+	depends on !COMPILE_TEST
 	default n
 	help
 	  This allows you to specify a dts (device tree source) file
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 601ea2e9fcf9..509f63891fb0 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -3909,8 +3909,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		break;
 
 	default:
-		dev_err(host->dev, "BUG: invalid board index %u\n", board_idx);
-		return 1;
+		dev_alert(host->dev, "BUG: invalid board index %u\n", board_idx);
+		return -EINVAL;
 	}
 
 	hpriv->hp_flags = hp_flags;
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 56486d92c4e7..f868dda30da0 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -296,14 +296,14 @@ static int regcache_rbtree_insert_to_block(struct regmap *map,
 	if (!blk)
 		return -ENOMEM;
 
+	rbnode->block = blk;
+
 	if (BITS_TO_LONGS(blklen) > BITS_TO_LONGS(rbnode->blklen)) {
 		present = krealloc(rbnode->cache_present,
 				   BITS_TO_LONGS(blklen) * sizeof(*present),
 				   GFP_KERNEL);
-		if (!present) {
-			kfree(blk);
+		if (!present)
 			return -ENOMEM;
-		}
 
 		memset(present + BITS_TO_LONGS(rbnode->blklen), 0,
 		       (BITS_TO_LONGS(blklen) - BITS_TO_LONGS(rbnode->blklen))
@@ -320,7 +320,6 @@ static int regcache_rbtree_insert_to_block(struct regmap *map,
 	}
 
 	/* update the rbnode block, its size and the base register */
-	rbnode->block = blk;
 	rbnode->blklen = blklen;
 	rbnode->base_reg = base_reg;
 	rbnode->cache_present = present;
diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 3a7e835a0033..4ebd9c8e5a47 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -442,6 +442,18 @@ static s8 dw_mci_exynos_get_best_clksmpl(u8 candiates)
 		}
 	}
 
+	/*
+	 * If there is no cadiates value, then it needs to return -EIO.
+	 * If there are candiates values and don't find bset clk sample value,
+	 * then use a first candiates clock sample value.
+	 */
+	for (i = 0; i < iter; i++) {
+		__c = ror8(candiates, i);
+		if ((__c & 0x1) == 0x1) {
+			loc = i;
+			goto out;
+		}
+	}
 out:
 	return loc;
 }
@@ -472,6 +484,8 @@ static int dw_mci_exynos_execute_tuning(struct dw_mci_slot *slot, u32 opcode)
 		priv->tuned_sample = found;
 	} else {
 		ret = -EIO;
+		dev_warn(&mmc->class_dev,
+			"There is no candiates value about clksmpl!\n");
 	}
 
 	return ret;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 42a9720b1a95..e88cca10a983 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1319,6 +1319,12 @@ void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
 			break;
 		case MMC_VDD_32_33:
 		case MMC_VDD_33_34:
+		/*
+		 * 3.4 ~ 3.6V are valid only for those platforms where it's
+		 * known that the voltage range is supported by hardware.
+		 */
+		case MMC_VDD_34_35:
+		case MMC_VDD_35_36:
 			pwr = SDHCI_POWER_330;
 			break;
 		default:
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index c9ea34e34415..69987b9066f6 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -579,7 +579,7 @@ static void check_vub300_port_status(struct vub300_mmc_host *vub300)
 				GET_SYSTEM_PORT_STATUS,
 				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0000, 0x0000, &vub300->system_port_status,
-				sizeof(vub300->system_port_status), HZ);
+				sizeof(vub300->system_port_status), 1000);
 	if (sizeof(vub300->system_port_status) == retval)
 		new_system_port_status(vub300);
 }
@@ -1245,7 +1245,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 						SET_INTERRUPT_PSEUDOCODE,
 						USB_DIR_OUT | USB_TYPE_VENDOR |
 						USB_RECIP_DEVICE, 0x0000, 0x0000,
-						xfer_buffer, xfer_length, HZ);
+						xfer_buffer, xfer_length, 1000);
 			kfree(xfer_buffer);
 			if (retval < 0) {
 				strncpy(vub300->vub_name,
@@ -1292,7 +1292,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 						SET_TRANSFER_PSEUDOCODE,
 						USB_DIR_OUT | USB_TYPE_VENDOR |
 						USB_RECIP_DEVICE, 0x0000, 0x0000,
-						xfer_buffer, xfer_length, HZ);
+						xfer_buffer, xfer_length, 1000);
 			kfree(xfer_buffer);
 			if (retval < 0) {
 				strncpy(vub300->vub_name,
@@ -1998,7 +1998,7 @@ static void __set_clock_speed(struct vub300_mmc_host *vub300, u8 buf[8],
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_CLOCK_SPEED,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				0x00, 0x00, buf, buf_array_size, HZ);
+				0x00, 0x00, buf, buf_array_size, 1000);
 	if (retval != 8) {
 		dev_err(&vub300->udev->dev, "SET_CLOCK_SPEED"
 			" %dkHz failed with retval=%d\n", kHzClock, retval);
@@ -2020,14 +2020,14 @@ static void vub300_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_SD_POWER,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				0x0000, 0x0000, NULL, 0, HZ);
+				0x0000, 0x0000, NULL, 0, 1000);
 		/* must wait for the VUB300 u-proc to boot up */
 		msleep(600);
 	} else if ((ios->power_mode == MMC_POWER_UP) && !vub300->card_powered) {
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_SD_POWER,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				0x0001, 0x0000, NULL, 0, HZ);
+				0x0001, 0x0000, NULL, 0, 1000);
 		msleep(600);
 		vub300->card_powered = 1;
 	} else if (ios->power_mode == MMC_POWER_ON) {
@@ -2290,14 +2290,14 @@ static int vub300_probe(struct usb_interface *interface,
 				GET_HC_INF0,
 				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0000, 0x0000, &vub300->hc_info,
-				sizeof(vub300->hc_info), HZ);
+				sizeof(vub300->hc_info), 1000);
 	if (retval < 0)
 		goto error5;
 	retval =
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				firmware_rom_wait_states, 0x0000, NULL, 0, HZ);
+				firmware_rom_wait_states, 0x0000, NULL, 0, 1000);
 	if (retval < 0)
 		goto error5;
 	dev_info(&vub300->udev->dev,
@@ -2312,7 +2312,7 @@ static int vub300_probe(struct usb_interface *interface,
 				GET_SYSTEM_PORT_STATUS,
 				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0000, 0x0000, &vub300->system_port_status,
-				sizeof(vub300->system_port_status), HZ);
+				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
 		goto error4;
 	} else if (sizeof(vub300->system_port_status) == retval) {
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index d621cf07f3e0..4066fb5a935a 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -274,7 +274,6 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-		put_device(&bus->dev);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 1439863e9061..324e2e15092f 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2956,6 +2956,12 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	dev->maxpacket = usb_maxpacket(dev->udev, dev->pipe_out, 1);
 
+	/* Reject broken descriptors. */
+	if (dev->maxpacket == 0) {
+		ret = -ENODEV;
+		goto out3;
+	}
+
 	/* driver requires remote-wakeup capability during autosuspend. */
 	intf->needs_remote_wakeup = 1;
 
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 5a09aff4155a..d98d50c895b8 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1730,6 +1730,11 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0) {
+		/* that is a broken device */
+		status = -ENODEV;
+		goto out4;
+	}
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))
diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 3ffbed72adf7..3ded31873d11 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -936,11 +936,11 @@ static u64 port100_get_command_type_mask(struct port100 *dev)
 
 	skb = port100_alloc_skb(dev, 0);
 	if (!skb)
-		return -ENOMEM;
+		return 0;
 
 	resp = port100_send_cmd_sync(dev, PORT100_CMD_GET_COMMAND_TYPE, skb);
 	if (IS_ERR(resp))
-		return PTR_ERR(resp);
+		return 0;
 
 	if (resp->len < 8)
 		mask = 0;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index a9ba6f2bb8c8..53bb631ec490 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4337,6 +4337,9 @@ sctp_disposition_t sctp_sf_violation(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (!sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length. */
 	if (!sctp_chunk_length_valid(chunk, sizeof(sctp_chunkhdr_t)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
@@ -6027,6 +6030,7 @@ static struct sctp_packet *sctp_ootb_pkt_new(struct net *net,
 		 * yet.
 		 */
 		switch (chunk->chunk_hdr->type) {
+		case SCTP_CID_INIT:
 		case SCTP_CID_INIT_ACK:
 		{
 			sctp_initack_chunk_t *initack;
