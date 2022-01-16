Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B2148FBA4
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 09:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiAPI3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 03:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiAPI3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 03:29:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB821C061574;
        Sun, 16 Jan 2022 00:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32E86B80CC5;
        Sun, 16 Jan 2022 08:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17959C36AE7;
        Sun, 16 Jan 2022 08:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642321748;
        bh=NrwqWpK1Js0mZTwvtOPfpWxb6P4g0S1D1HlrmtJrYoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKm1CwLHul7KV7/3HHBX0ySE8yqsxW/pdW05wgB3YBtGAFieqUN9gLKLYxB/GyoeP
         wyeouX4K3R4tsb5UgSLZmiDDrZJ3NN7gY3HvxUqtenK3hO+RNngDHpwEiL66dJhyqi
         xx/DrbwSr+bmCBPuA8pEaz0OohcD9+JOFMfi65lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.15
Date:   Sun, 16 Jan 2022 09:28:57 +0100
Message-Id: <164232173759153@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <16423217374154@kroah.com>
References: <16423217374154@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index a469670e7675..aed26e228dde 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 14
+SUBLEVEL = 15
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/exynos4210-i9100.dts b/arch/arm/boot/dts/exynos4210-i9100.dts
index 55922176807e..5f5d9b135736 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -827,7 +827,7 @@ bluetooth {
 		compatible = "brcm,bcm4330-bt";
 
 		shutdown-gpios = <&gpl0 4 GPIO_ACTIVE_HIGH>;
-		reset-gpios = <&gpl1 0 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpl1 0 GPIO_ACTIVE_LOW>;
 		device-wakeup-gpios = <&gpx3 1 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpx2 6 GPIO_ACTIVE_HIGH>;
 	};
diff --git a/arch/s390/kernel/machine_kexec_file.c b/arch/s390/kernel/machine_kexec_file.c
index 76cd09879eaf..a81d6c43b9b6 100644
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -312,6 +312,10 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 		addr = section->sh_addr + relas[i].r_offset;
 
 		r_type = ELF64_R_TYPE(relas[i].r_info);
+
+		if (r_type == R_390_PLT32DBL)
+			r_type = R_390_PC32DBL;
+
 		ret = arch_kexec_do_relocs(r_type, loc, val, addr);
 		if (ret) {
 			pr_err("Unknown rela relocation: %d\n", r_type);
diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 5a321b4076aa..cab93935cc7f 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -628,6 +628,9 @@ static int bfusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	data->bulk_out_ep   = bulk_out_ep->desc.bEndpointAddress;
 	data->bulk_pkt_size = le16_to_cpu(bulk_out_ep->desc.wMaxPacketSize);
 
+	if (!data->bulk_pkt_size)
+		goto done;
+
 	rwlock_init(&data->lock);
 
 	data->reassembly = NULL;
diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e4182acee488..d9ceca7a7935 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/dmi.h>
 #include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -343,6 +344,52 @@ static struct sk_buff *btbcm_read_usb_product(struct hci_dev *hdev)
 	return skb;
 }
 
+static const struct dmi_system_id disable_broken_read_transmit_power[] = {
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,1"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,2"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
+		},
+	},
+	{ }
+};
+
 static int btbcm_read_info(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
@@ -363,6 +410,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
 	kfree_skb(skb);
 
+	/* Read DMI and disable broken Read LE Min/Max Tx Power */
+	if (dmi_first_match(disable_broken_read_transmit_power))
+		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
+
 	return 0;
 }
 
diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index f1705b46fc88..525be2e1fbb2 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2193,8 +2193,15 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	 * As a workaround, send HCI Reset command first which will reset the
 	 * number of completed commands and allow normal command processing
 	 * from now on.
+	 *
+	 * Regarding the INTEL_BROKEN_SHUTDOWN_LED flag, these devices maybe
+	 * in the SW_RFKILL ON state as a workaround of fixing LED issue during
+	 * the shutdown() procedure, and once the device is in SW_RFKILL ON
+	 * state, the only way to exit out of it is sending the HCI_Reset
+	 * command.
 	 */
-	if (btintel_test_flag(hdev, INTEL_BROKEN_INITIAL_NCMD)) {
+	if (btintel_test_flag(hdev, INTEL_BROKEN_INITIAL_NCMD) ||
+	    btintel_test_flag(hdev, INTEL_BROKEN_SHUTDOWN_LED)) {
 		skb = __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL,
 				     HCI_INIT_TIMEOUT);
 		if (IS_ERR(skb)) {
@@ -2263,12 +2270,6 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 				set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 					&hdev->quirks);
 
-			/* These devices have an issue with LED which doesn't
-			 * go off immediately during shutdown. Set the flag
-			 * here to send the LED OFF command during shutdown.
-			 */
-			btintel_set_flag(hdev, INTEL_BROKEN_LED);
-
 			err = btintel_legacy_rom_setup(hdev, &ver);
 			break;
 		case 0x0b:      /* SfP */
@@ -2399,9 +2400,10 @@ static int btintel_shutdown_combined(struct hci_dev *hdev)
 
 	/* Some platforms have an issue with BT LED when the interface is
 	 * down or BT radio is turned off, which takes 5 seconds to BT LED
-	 * goes off. This command turns off the BT LED immediately.
+	 * goes off. As a workaround, sends HCI_Intel_SW_RFKILL to put the
+	 * device in the RFKILL ON state which turns off the BT LED immediately.
 	 */
-	if (btintel_test_flag(hdev, INTEL_BROKEN_LED)) {
+	if (btintel_test_flag(hdev, INTEL_BROKEN_SHUTDOWN_LED)) {
 		skb = __hci_cmd_sync(hdev, 0xfc3f, 0, NULL, HCI_INIT_TIMEOUT);
 		if (IS_ERR(skb)) {
 			ret = PTR_ERR(skb);
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index aa64072bbe68..704e3b7bcb77 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -145,7 +145,7 @@ enum {
 	INTEL_FIRMWARE_FAILED,
 	INTEL_BOOTING,
 	INTEL_BROKEN_INITIAL_NCMD,
-	INTEL_BROKEN_LED,
+	INTEL_BROKEN_SHUTDOWN_LED,
 	INTEL_ROM_LEGACY,
 
 	__INTEL_NUM_FLAGS,
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 79d0db542da3..fa44828562d3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -59,6 +59,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_WIDEBAND_SPEECH	0x400000
 #define BTUSB_VALID_LE_STATES   0x800000
 #define BTUSB_QCA_WCN6855	0x1000000
+#define BTUSB_INTEL_BROKEN_SHUTDOWN_LED	0x2000000
 #define BTUSB_INTEL_BROKEN_INITIAL_NCMD 0x4000000
 
 static const struct usb_device_id btusb_table[] = {
@@ -295,6 +296,24 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0cf3, 0xe600), .driver_info = BTUSB_QCA_WCN6855 |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0cc), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0d6), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0e3), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9309), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9409), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0d0), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = BTUSB_BCM92035 },
@@ -365,10 +384,13 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x8087, 0x0033), .driver_info = BTUSB_INTEL_COMBINED },
 	{ USB_DEVICE(0x8087, 0x07da), .driver_info = BTUSB_CSR },
 	{ USB_DEVICE(0x8087, 0x07dc), .driver_info = BTUSB_INTEL_COMBINED |
-						     BTUSB_INTEL_BROKEN_INITIAL_NCMD },
-	{ USB_DEVICE(0x8087, 0x0a2a), .driver_info = BTUSB_INTEL_COMBINED },
+						     BTUSB_INTEL_BROKEN_INITIAL_NCMD |
+						     BTUSB_INTEL_BROKEN_SHUTDOWN_LED },
+	{ USB_DEVICE(0x8087, 0x0a2a), .driver_info = BTUSB_INTEL_COMBINED |
+						     BTUSB_INTEL_BROKEN_SHUTDOWN_LED },
 	{ USB_DEVICE(0x8087, 0x0a2b), .driver_info = BTUSB_INTEL_COMBINED },
-	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL_COMBINED },
+	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL_COMBINED |
+						     BTUSB_INTEL_BROKEN_SHUTDOWN_LED },
 	{ USB_DEVICE(0x8087, 0x0aaa), .driver_info = BTUSB_INTEL_COMBINED },
 
 	/* Other Intel Bluetooth devices */
@@ -384,6 +406,14 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Realtek 8852AE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xc852), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0x385a), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0x4852), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x04c5, 0x165c), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
@@ -410,10 +440,21 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3563), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x13d3, 0x3564), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 	{ USB_DEVICE(0x0489, 0xe0cd), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
 
+	/* MediaTek MT7922A Bluetooth devices */
+	{ USB_DEVICE(0x0489, 0xe0d8), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0d9), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+
 	/* Additional Realtek 8723AE Bluetooth devices */
 	{ USB_DEVICE(0x0930, 0x021d), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3394), .driver_info = BTUSB_REALTEK },
@@ -455,10 +496,6 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x04ca, 0x4005), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	/* Bluetooth component of Realtek 8852AE device */
-	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
-
 	{ USB_DEVICE(0x04c5, 0x161f), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x18ef), .driver_info = BTUSB_REALTEK |
@@ -2221,6 +2258,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 		skb = bt_skb_alloc(HCI_WMT_MAX_EVENT_SIZE, GFP_ATOMIC);
 		if (!skb) {
 			hdev->stat.err_rx++;
+			kfree(urb->setup_packet);
 			return;
 		}
 
@@ -2241,6 +2279,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 			data->evt_skb = skb_clone(skb, GFP_ATOMIC);
 			if (!data->evt_skb) {
 				kfree_skb(skb);
+				kfree(urb->setup_packet);
 				return;
 			}
 		}
@@ -2249,6 +2288,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 		if (err < 0) {
 			kfree_skb(data->evt_skb);
 			data->evt_skb = NULL;
+			kfree(urb->setup_packet);
 			return;
 		}
 
@@ -2259,6 +2299,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 			wake_up_bit(&data->flags,
 				    BTUSB_TX_WAIT_VND_EVT);
 		}
+		kfree(urb->setup_packet);
 		return;
 	} else if (urb->status == -ENOENT) {
 		/* Avoid suspend failed when usb_kill_urb */
@@ -2279,6 +2320,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 	usb_anchor_urb(urb, &data->ctrl_anchor);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
+		kfree(urb->setup_packet);
 		/* -EPERM: urb is being killed;
 		 * -ENODEV: device got disconnected
 		 */
@@ -2808,6 +2850,7 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 	case 0x7668:
 		fwname = FIRMWARE_MT7668;
 		break;
+	case 0x7922:
 	case 0x7961:
 		snprintf(fw_bin_name, sizeof(fw_bin_name),
 			"mediatek/BT_RAM_CODE_MT%04x_1_%x_hdr.bin",
@@ -2832,6 +2875,7 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 		}
 
 		hci_set_msft_opcode(hdev, 0xFD30);
+		hci_set_aosp_capable(hdev);
 		goto done;
 	default:
 		bt_dev_err(hdev, "Unsupported hardware variant (%08x)",
@@ -3812,6 +3856,9 @@ static int btusb_probe(struct usb_interface *intf,
 
 		if (id->driver_info & BTUSB_INTEL_BROKEN_INITIAL_NCMD)
 			btintel_set_flag(hdev, INTEL_BROKEN_INITIAL_NCMD);
+
+		if (id->driver_info & BTUSB_INTEL_BROKEN_SHUTDOWN_LED)
+			btintel_set_flag(hdev, INTEL_BROKEN_SHUTDOWN_LED);
 	}
 
 	if (id->driver_info & BTUSB_MARVELL)
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 605969ed0f96..7470ee24db2f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -461,6 +461,7 @@ static struct crng_state primary_crng = {
  * its value (from 0->1->2).
  */
 static int crng_init = 0;
+static bool crng_need_final_init = false;
 #define crng_ready() (likely(crng_init > 1))
 static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
@@ -828,6 +829,36 @@ static void __init crng_initialize_primary(struct crng_state *crng)
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
+static void crng_finalize_init(struct crng_state *crng)
+{
+	if (crng != &primary_crng || crng_init >= 2)
+		return;
+	if (!system_wq) {
+		/* We can't call numa_crng_init until we have workqueues,
+		 * so mark this for processing later. */
+		crng_need_final_init = true;
+		return;
+	}
+
+	invalidate_batched_entropy();
+	numa_crng_init();
+	crng_init = 2;
+	process_random_ready_list();
+	wake_up_interruptible(&crng_init_wait);
+	kill_fasync(&fasync, SIGIO, POLL_IN);
+	pr_notice("crng init done\n");
+	if (unseeded_warning.missed) {
+		pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
+			  unseeded_warning.missed);
+		unseeded_warning.missed = 0;
+	}
+	if (urandom_warning.missed) {
+		pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
+			  urandom_warning.missed);
+		urandom_warning.missed = 0;
+	}
+}
+
 #ifdef CONFIG_NUMA
 static void do_numa_crng_init(struct work_struct *work)
 {
@@ -843,8 +874,8 @@ static void do_numa_crng_init(struct work_struct *work)
 		crng_initialize_secondary(crng);
 		pool[i] = crng;
 	}
-	mb();
-	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+	/* pairs with READ_ONCE() in select_crng() */
+	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
 		for_each_node(i)
 			kfree(pool[i]);
 		kfree(pool);
@@ -857,8 +888,26 @@ static void numa_crng_init(void)
 {
 	schedule_work(&numa_crng_init_work);
 }
+
+static struct crng_state *select_crng(void)
+{
+	struct crng_state **pool;
+	int nid = numa_node_id();
+
+	/* pairs with cmpxchg_release() in do_numa_crng_init() */
+	pool = READ_ONCE(crng_node_pool);
+	if (pool && pool[nid])
+		return pool[nid];
+
+	return &primary_crng;
+}
 #else
 static void numa_crng_init(void) {}
+
+static struct crng_state *select_crng(void)
+{
+	return &primary_crng;
+}
 #endif
 
 /*
@@ -962,38 +1011,23 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 		crng->state[i+4] ^= buf.key[i] ^ rv;
 	}
 	memzero_explicit(&buf, sizeof(buf));
-	crng->init_time = jiffies;
+	WRITE_ONCE(crng->init_time, jiffies);
 	spin_unlock_irqrestore(&crng->lock, flags);
-	if (crng == &primary_crng && crng_init < 2) {
-		invalidate_batched_entropy();
-		numa_crng_init();
-		crng_init = 2;
-		process_random_ready_list();
-		wake_up_interruptible(&crng_init_wait);
-		kill_fasync(&fasync, SIGIO, POLL_IN);
-		pr_notice("crng init done\n");
-		if (unseeded_warning.missed) {
-			pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
-				  unseeded_warning.missed);
-			unseeded_warning.missed = 0;
-		}
-		if (urandom_warning.missed) {
-			pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
-				  urandom_warning.missed);
-			urandom_warning.missed = 0;
-		}
-	}
+	crng_finalize_init(crng);
 }
 
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA_BLOCK_SIZE])
 {
-	unsigned long v, flags;
-
-	if (crng_ready() &&
-	    (time_after(crng_global_init_time, crng->init_time) ||
-	     time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL)))
-		crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
+	unsigned long v, flags, init_time;
+
+	if (crng_ready()) {
+		init_time = READ_ONCE(crng->init_time);
+		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
+		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
+			crng_reseed(crng, crng == &primary_crng ?
+				    &input_pool : NULL);
+	}
 	spin_lock_irqsave(&crng->lock, flags);
 	if (arch_get_random_long(&v))
 		crng->state[14] ^= v;
@@ -1005,15 +1039,7 @@ static void _extract_crng(struct crng_state *crng,
 
 static void extract_crng(__u8 out[CHACHA_BLOCK_SIZE])
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_extract_crng(crng, out);
+	_extract_crng(select_crng(), out);
 }
 
 /*
@@ -1042,15 +1068,7 @@ static void _crng_backtrack_protect(struct crng_state *crng,
 
 static void crng_backtrack_protect(__u8 tmp[CHACHA_BLOCK_SIZE], int used)
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_crng_backtrack_protect(crng, tmp, used);
+	_crng_backtrack_protect(select_crng(), tmp, used);
 }
 
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
@@ -1775,6 +1793,8 @@ static void __init init_std_data(struct entropy_store *r)
 int __init rand_initialize(void)
 {
 	init_std_data(&input_pool);
+	if (crng_need_final_init)
+		crng_finalize_init(&primary_crng);
 	crng_initialize_primary(&primary_crng);
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {
@@ -1949,7 +1969,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		if (crng_init < 2)
 			return -ENODATA;
 		crng_reseed(&primary_crng, &input_pool);
-		crng_global_init_time = jiffies - 1;
+		WRITE_ONCE(crng_global_init_time, jiffies - 1);
 		return 0;
 	default:
 		return -EINVAL;
@@ -2283,7 +2303,8 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			!system_wq || kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index a725792d5248..7f0964645d0c 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3063,9 +3063,9 @@ static void snb_wm_latency_quirk(struct drm_i915_private *dev_priv)
 	 * The BIOS provided WM memory latency values are often
 	 * inadequate for high resolution displays. Adjust them.
 	 */
-	changed = ilk_increase_wm_latency(dev_priv, dev_priv->wm.pri_latency, 12) |
-		ilk_increase_wm_latency(dev_priv, dev_priv->wm.spr_latency, 12) |
-		ilk_increase_wm_latency(dev_priv, dev_priv->wm.cur_latency, 12);
+	changed = ilk_increase_wm_latency(dev_priv, dev_priv->wm.pri_latency, 12);
+	changed |= ilk_increase_wm_latency(dev_priv, dev_priv->wm.spr_latency, 12);
+	changed |= ilk_increase_wm_latency(dev_priv, dev_priv->wm.cur_latency, 12);
 
 	if (!changed)
 		return;
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index c4bc67024534..9a791d8ef200 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2194,7 +2194,6 @@ int uvc_register_video_device(struct uvc_device *dev,
 			      const struct v4l2_file_operations *fops,
 			      const struct v4l2_ioctl_ops *ioctl_ops)
 {
-	const char *name;
 	int ret;
 
 	/* Initialize the video buffers queue. */
@@ -2223,20 +2222,16 @@ int uvc_register_video_device(struct uvc_device *dev,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	default:
 		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-		name = "Video Capture";
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
-		name = "Video Output";
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
-		name = "Metadata";
 		break;
 	}
 
-	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
-		 stream->header.bTerminalLink);
+	strscpy(vdev->name, dev->name, sizeof(vdev->name));
 
 	/*
 	 * Set the driver data before calling video_register_device, otherwise
diff --git a/drivers/mfd/intel-lpss-acpi.c b/drivers/mfd/intel-lpss-acpi.c
index 3f1d976eb67c..f2ea6540a01e 100644
--- a/drivers/mfd/intel-lpss-acpi.c
+++ b/drivers/mfd/intel-lpss-acpi.c
@@ -136,6 +136,7 @@ static int intel_lpss_acpi_probe(struct platform_device *pdev)
 {
 	struct intel_lpss_platform_info *info;
 	const struct acpi_device_id *id;
+	int ret;
 
 	id = acpi_match_device(intel_lpss_acpi_ids, &pdev->dev);
 	if (!id)
@@ -149,10 +150,14 @@ static int intel_lpss_acpi_probe(struct platform_device *pdev)
 	info->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	info->irq = platform_get_irq(pdev, 0);
 
+	ret = intel_lpss_probe(&pdev->dev, info);
+	if (ret)
+		return ret;
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	return intel_lpss_probe(&pdev->dev, info);
+	return 0;
 }
 
 static int intel_lpss_acpi_remove(struct platform_device *pdev)
diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index d0f2edfe296c..c2b26ada104d 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1951,6 +1951,7 @@ static const struct pci_device_id pci_ids[] = {
 	SDHCI_PCI_DEVICE(INTEL, JSL_SD,    intel_byt_sd),
 	SDHCI_PCI_DEVICE(INTEL, LKF_EMMC,  intel_glk_emmc),
 	SDHCI_PCI_DEVICE(INTEL, LKF_SD,    intel_byt_sd),
+	SDHCI_PCI_DEVICE(INTEL, ADL_EMMC,  intel_glk_emmc),
 	SDHCI_PCI_DEVICE(O2, 8120,     o2),
 	SDHCI_PCI_DEVICE(O2, 8220,     o2),
 	SDHCI_PCI_DEVICE(O2, 8221,     o2),
diff --git a/drivers/mmc/host/sdhci-pci.h b/drivers/mmc/host/sdhci-pci.h
index 8f90c4163bb5..dcd99d5057ee 100644
--- a/drivers/mmc/host/sdhci-pci.h
+++ b/drivers/mmc/host/sdhci-pci.h
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_JSL_SD	0x4df8
 #define PCI_DEVICE_ID_INTEL_LKF_EMMC	0x98c4
 #define PCI_DEVICE_ID_INTEL_LKF_SD	0x98f8
+#define PCI_DEVICE_ID_INTEL_ADL_EMMC	0x54c4
 
 #define PCI_DEVICE_ID_SYSKONNECT_8000	0x8000
 #define PCI_DEVICE_ID_VIA_95D0		0x95d0
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 5e892bef46b0..8dcdd5162ecf 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -321,7 +321,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 
 	/* device reports out of range channel id */
 	if (hf->channel >= GS_MAX_INTF)
-		goto resubmit_urb;
+		goto device_detach;
 
 	dev = usbcan->canch[hf->channel];
 
@@ -406,6 +406,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 
 	/* USB failure take down all interfaces */
 	if (rc == -ENODEV) {
+ device_detach:
 		for (rc = 0; rc < GS_MAX_INTF; rc++) {
 			if (usbcan->canch[rc])
 				netif_device_detach(usbcan->canch[rc]->netdev);
@@ -507,6 +508,8 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 
 	hf->echo_id = idx;
 	hf->channel = dev->channel;
+	hf->flags = 0;
+	hf->reserved = 0;
 
 	cf = (struct can_frame *)skb->data;
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2acdb8ad6c71..ecbc09cbe259 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -342,7 +342,6 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 		 */
 		use_napi = rcu_access_pointer(rq->napi) &&
 			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
-		skb_record_rx_queue(skb, rxq);
 	}
 
 	skb_tx_timestamp(skb);
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 99c0b81e496b..c22ec921b2e9 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2051,7 +2051,7 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
 	void *ptr;
 	int i, ret, len;
 	u32 *tmp_ptr;
-	u8 extraie_len_with_pad = 0;
+	u16 extraie_len_with_pad = 0;
 	struct hint_short_ssid *s_ssid = NULL;
 	struct hint_bssid *hint_bssid = NULL;
 
@@ -2070,7 +2070,7 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
 		len += sizeof(*bssid) * params->num_bssid;
 
 	len += TLV_HDR_SIZE;
-	if (params->extraie.len)
+	if (params->extraie.len && params->extraie.len <= 0xFFFF)
 		extraie_len_with_pad =
 			roundup(params->extraie.len, sizeof(u32));
 	len += extraie_len_with_pad;
@@ -2177,7 +2177,7 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
 		      FIELD_PREP(WMI_TLV_LEN, len);
 	ptr += TLV_HDR_SIZE;
 
-	if (params->extraie.len)
+	if (extraie_len_with_pad)
 		memcpy(ptr, params->extraie.ptr,
 		       params->extraie.len);
 
diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 13f8cf70b9ae..41a2a026f156 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -106,6 +106,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
 		},
 	},
+	{
+		.ident = "Microsoft Surface Go 3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
+		},
+	},
 	{ }
 };
 
diff --git a/drivers/staging/greybus/audio_topology.c b/drivers/staging/greybus/audio_topology.c
index 1e613d42d823..7f7d558b76d0 100644
--- a/drivers/staging/greybus/audio_topology.c
+++ b/drivers/staging/greybus/audio_topology.c
@@ -974,6 +974,44 @@ static int gbaudio_widget_event(struct snd_soc_dapm_widget *w,
 	return ret;
 }
 
+static const struct snd_soc_dapm_widget gbaudio_widgets[] = {
+	[snd_soc_dapm_spk]	= SND_SOC_DAPM_SPK(NULL, gbcodec_event_spk),
+	[snd_soc_dapm_hp]	= SND_SOC_DAPM_HP(NULL, gbcodec_event_hp),
+	[snd_soc_dapm_mic]	= SND_SOC_DAPM_MIC(NULL, gbcodec_event_int_mic),
+	[snd_soc_dapm_output]	= SND_SOC_DAPM_OUTPUT(NULL),
+	[snd_soc_dapm_input]	= SND_SOC_DAPM_INPUT(NULL),
+	[snd_soc_dapm_switch]	= SND_SOC_DAPM_SWITCH_E(NULL, SND_SOC_NOPM,
+					0, 0, NULL,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_pga]	= SND_SOC_DAPM_PGA_E(NULL, SND_SOC_NOPM,
+					0, 0, NULL, 0,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_mixer]	= SND_SOC_DAPM_MIXER_E(NULL, SND_SOC_NOPM,
+					0, 0, NULL, 0,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_mux]	= SND_SOC_DAPM_MUX_E(NULL, SND_SOC_NOPM,
+					0, 0, NULL,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_aif_in]	= SND_SOC_DAPM_AIF_IN_E(NULL, NULL, 0,
+					SND_SOC_NOPM, 0, 0,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_aif_out]	= SND_SOC_DAPM_AIF_OUT_E(NULL, NULL, 0,
+					SND_SOC_NOPM, 0, 0,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+};
+
 static int gbaudio_tplg_create_widget(struct gbaudio_module_info *module,
 				      struct snd_soc_dapm_widget *dw,
 				      struct gb_audio_widget *w, int *w_size)
@@ -1052,77 +1090,37 @@ static int gbaudio_tplg_create_widget(struct gbaudio_module_info *module,
 
 	switch (w->type) {
 	case snd_soc_dapm_spk:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_SPK(w->name, gbcodec_event_spk);
+		*dw = gbaudio_widgets[w->type];
 		module->op_devices |= GBAUDIO_DEVICE_OUT_SPEAKER;
 		break;
 	case snd_soc_dapm_hp:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_HP(w->name, gbcodec_event_hp);
+		*dw = gbaudio_widgets[w->type];
 		module->op_devices |= (GBAUDIO_DEVICE_OUT_WIRED_HEADSET
 					| GBAUDIO_DEVICE_OUT_WIRED_HEADPHONE);
 		module->ip_devices |= GBAUDIO_DEVICE_IN_WIRED_HEADSET;
 		break;
 	case snd_soc_dapm_mic:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_MIC(w->name, gbcodec_event_int_mic);
+		*dw = gbaudio_widgets[w->type];
 		module->ip_devices |= GBAUDIO_DEVICE_IN_BUILTIN_MIC;
 		break;
 	case snd_soc_dapm_output:
-		*dw = (struct snd_soc_dapm_widget)SND_SOC_DAPM_OUTPUT(w->name);
-		break;
 	case snd_soc_dapm_input:
-		*dw = (struct snd_soc_dapm_widget)SND_SOC_DAPM_INPUT(w->name);
-		break;
 	case snd_soc_dapm_switch:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_SWITCH_E(w->name, SND_SOC_NOPM, 0, 0,
-					      widget_kctls,
-					      gbaudio_widget_event,
-					      SND_SOC_DAPM_PRE_PMU |
-					      SND_SOC_DAPM_POST_PMD);
-		break;
 	case snd_soc_dapm_pga:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_PGA_E(w->name, SND_SOC_NOPM, 0, 0, NULL, 0,
-					   gbaudio_widget_event,
-					   SND_SOC_DAPM_PRE_PMU |
-					   SND_SOC_DAPM_POST_PMD);
-		break;
 	case snd_soc_dapm_mixer:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_MIXER_E(w->name, SND_SOC_NOPM, 0, 0, NULL,
-					     0, gbaudio_widget_event,
-					     SND_SOC_DAPM_PRE_PMU |
-					     SND_SOC_DAPM_POST_PMD);
-		break;
 	case snd_soc_dapm_mux:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_MUX_E(w->name, SND_SOC_NOPM, 0, 0,
-					   widget_kctls, gbaudio_widget_event,
-					   SND_SOC_DAPM_PRE_PMU |
-					   SND_SOC_DAPM_POST_PMD);
+		*dw = gbaudio_widgets[w->type];
 		break;
 	case snd_soc_dapm_aif_in:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_AIF_IN_E(w->name, w->sname, 0,
-					      SND_SOC_NOPM,
-					      0, 0, gbaudio_widget_event,
-					      SND_SOC_DAPM_PRE_PMU |
-					      SND_SOC_DAPM_POST_PMD);
-		break;
 	case snd_soc_dapm_aif_out:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_AIF_OUT_E(w->name, w->sname, 0,
-					       SND_SOC_NOPM,
-					       0, 0, gbaudio_widget_event,
-					       SND_SOC_DAPM_PRE_PMU |
-					       SND_SOC_DAPM_POST_PMD);
+		*dw = gbaudio_widgets[w->type];
+		dw->sname = w->sname;
 		break;
 	default:
 		ret = -EINVAL;
 		goto error;
 	}
+	dw->name = w->name;
 
 	dev_dbg(module->dev, "%s: widget of type %d created\n", dw->name,
 		dw->id);
diff --git a/drivers/staging/r8188eu/core/rtw_led.c b/drivers/staging/r8188eu/core/rtw_led.c
index b33e34cce12e..f9a8cdd9a168 100644
--- a/drivers/staging/r8188eu/core/rtw_led.c
+++ b/drivers/staging/r8188eu/core/rtw_led.c
@@ -74,6 +74,7 @@ void DeInitLed871x(struct LED_871x *pLed)
 	_cancel_workitem_sync(&pLed->BlinkWorkItem);
 	_cancel_timer_ex(&pLed->BlinkTimer);
 	ResetLedStatus(pLed);
+	SwLedOff(pLed->padapter, pLed);
 }
 
 /*  */
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 8c8524679ba3..0d869b5e309c 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3778,18 +3778,18 @@ static void hfa384x_usb_throttlefn(struct timer_list *t)
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
 
-	/*
-	 * We need to check BOTH the RX and the TX throttle controls,
-	 * so we use the bitwise OR instead of the logical OR.
-	 */
 	pr_debug("flags=0x%lx\n", hw->usb_flags);
-	if (!hw->wlandev->hwremoved &&
-	    ((test_and_clear_bit(THROTTLE_RX, &hw->usb_flags) &&
-	      !test_and_set_bit(WORK_RX_RESUME, &hw->usb_flags)) |
-	     (test_and_clear_bit(THROTTLE_TX, &hw->usb_flags) &&
-	      !test_and_set_bit(WORK_TX_RESUME, &hw->usb_flags))
-	    )) {
-		schedule_work(&hw->usb_work);
+	if (!hw->wlandev->hwremoved) {
+		bool rx_throttle = test_and_clear_bit(THROTTLE_RX, &hw->usb_flags) &&
+				   !test_and_set_bit(WORK_RX_RESUME, &hw->usb_flags);
+		bool tx_throttle = test_and_clear_bit(THROTTLE_TX, &hw->usb_flags) &&
+				   !test_and_set_bit(WORK_TX_RESUME, &hw->usb_flags);
+		/*
+		 * We need to check BOTH the RX and the TX throttle controls,
+		 * so we use the bitwise OR instead of the logical OR.
+		 */
+		if (rx_throttle | tx_throttle)
+			schedule_work(&hw->usb_work);
 	}
 
 	spin_unlock_irqrestore(&hw->ctlxq.lock, flags);
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 00d35fe1fef0..16bab9826127 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -753,6 +753,7 @@ void usb_hcd_poll_rh_status(struct usb_hcd *hcd)
 {
 	struct urb	*urb;
 	int		length;
+	int		status;
 	unsigned long	flags;
 	char		buffer[6];	/* Any root hubs with > 31 ports? */
 
@@ -770,11 +771,17 @@ void usb_hcd_poll_rh_status(struct usb_hcd *hcd)
 		if (urb) {
 			clear_bit(HCD_FLAG_POLL_PENDING, &hcd->flags);
 			hcd->status_urb = NULL;
+			if (urb->transfer_buffer_length >= length) {
+				status = 0;
+			} else {
+				status = -EOVERFLOW;
+				length = urb->transfer_buffer_length;
+			}
 			urb->actual_length = length;
 			memcpy(urb->transfer_buffer, buffer, length);
 
 			usb_hcd_unlink_urb_from_ep(hcd, urb);
-			usb_hcd_giveback_urb(hcd, urb, 0);
+			usb_hcd_giveback_urb(hcd, urb, status);
 		} else {
 			length = 0;
 			set_bit(HCD_FLAG_POLL_PENDING, &hcd->flags);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 00070a8a6507..3bc4a86c3d0a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1225,7 +1225,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 			 */
 			if (portchange || (hub_is_superspeed(hub->hdev) &&
 						port_resumed))
-				set_bit(port1, hub->change_bits);
+				set_bit(port1, hub->event_bits);
 
 		} else if (udev->persist_enabled) {
 #ifdef CONFIG_PM
diff --git a/fs/file.c b/fs/file.c
index ad4a8bf3cf10..97d212a9b814 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -841,28 +841,68 @@ void do_close_on_exec(struct files_struct *files)
 	spin_unlock(&files->file_lock);
 }
 
-static struct file *__fget_files(struct files_struct *files, unsigned int fd,
-				 fmode_t mask, unsigned int refs)
+static inline struct file *__fget_files_rcu(struct files_struct *files,
+	unsigned int fd, fmode_t mask, unsigned int refs)
 {
-	struct file *file;
+	for (;;) {
+		struct file *file;
+		struct fdtable *fdt = rcu_dereference_raw(files->fdt);
+		struct file __rcu **fdentry;
 
-	rcu_read_lock();
-loop:
-	file = files_lookup_fd_rcu(files, fd);
-	if (file) {
-		/* File object ref couldn't be taken.
-		 * dup2() atomicity guarantee is the reason
-		 * we loop to catch the new file (or NULL pointer)
+		if (unlikely(fd >= fdt->max_fds))
+			return NULL;
+
+		fdentry = fdt->fd + array_index_nospec(fd, fdt->max_fds);
+		file = rcu_dereference_raw(*fdentry);
+		if (unlikely(!file))
+			return NULL;
+
+		if (unlikely(file->f_mode & mask))
+			return NULL;
+
+		/*
+		 * Ok, we have a file pointer. However, because we do
+		 * this all locklessly under RCU, we may be racing with
+		 * that file being closed.
+		 *
+		 * Such a race can take two forms:
+		 *
+		 *  (a) the file ref already went down to zero,
+		 *      and get_file_rcu_many() fails. Just try
+		 *      again:
 		 */
-		if (file->f_mode & mask)
-			file = NULL;
-		else if (!get_file_rcu_many(file, refs))
-			goto loop;
-		else if (files_lookup_fd_raw(files, fd) != file) {
+		if (unlikely(!get_file_rcu_many(file, refs)))
+			continue;
+
+		/*
+		 *  (b) the file table entry has changed under us.
+		 *       Note that we don't need to re-check the 'fdt->fd'
+		 *       pointer having changed, because it always goes
+		 *       hand-in-hand with 'fdt'.
+		 *
+		 * If so, we need to put our refs and try again.
+		 */
+		if (unlikely(rcu_dereference_raw(files->fdt) != fdt) ||
+		    unlikely(rcu_dereference_raw(*fdentry) != file)) {
 			fput_many(file, refs);
-			goto loop;
+			continue;
 		}
+
+		/*
+		 * Ok, we have a ref to the file, and checked that it
+		 * still exists.
+		 */
+		return file;
 	}
+}
+
+static struct file *__fget_files(struct files_struct *files, unsigned int fd,
+				 fmode_t mask, unsigned int refs)
+{
+	struct file *file;
+
+	rcu_read_lock();
+	file = __fget_files_rcu(files, fd, mask, refs);
 	rcu_read_unlock();
 
 	return file;
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index b80415011dcd..9ce46cb8564d 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -246,6 +246,15 @@ enum {
 	 * HCI after resume.
 	 */
 	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
+
+	/*
+	 * When this quirk is set, LE tx power is not queried on startup
+	 * and the min/max tx power values default to HCI_TX_POWER_INVALID.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
 };
 
 /* HCI device flags */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 93c3a332e853..b84e63d62b8a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7039,16 +7039,16 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		fallthrough;
 	case PTR_TO_PACKET_END:
 	case PTR_TO_SOCKET:
-	case PTR_TO_SOCKET_OR_NULL:
 	case PTR_TO_SOCK_COMMON:
-	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
-	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+reject:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
 	default:
+		if (reg_type_may_be_null(ptr_reg->type))
+			goto reject;
 		break;
 	}
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 76988f39ed5a..3f4d27668576 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -867,8 +867,17 @@ void wq_worker_running(struct task_struct *task)
 
 	if (!worker->sleeping)
 		return;
+
+	/*
+	 * If preempted by unbind_workers() between the WORKER_NOT_RUNNING check
+	 * and the nr_running increment below, we may ruin the nr_running reset
+	 * and leave with an unexpected pool->nr_running == 1 on the newly unbound
+	 * pool. Protect against such race.
+	 */
+	preempt_disable();
 	if (!(worker->flags & WORKER_NOT_RUNNING))
 		atomic_inc(&worker->pool->nr_running);
+	preempt_enable();
 	worker->sleeping = 0;
 }
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8a47a3017d61..325db9c4c610 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -742,7 +742,8 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
 			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
 		}
 
-		if (hdev->commands[38] & 0x80) {
+		if ((hdev->commands[38] & 0x80) &&
+		    !test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
 			/* Read LE Min/Max Tx Power*/
 			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
 				    0, NULL);
diff --git a/net/can/isotp.c b/net/can/isotp.c
index df6968b28bf4..02cbcb2ecf0d 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -119,8 +119,8 @@ enum {
 };
 
 struct tpcon {
-	int idx;
-	int len;
+	unsigned int idx;
+	unsigned int len;
 	u32 state;
 	u8 bs;
 	u8 sn;
