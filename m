Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5089365346D
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbiLUQzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiLUQzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:55:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDDC24F25;
        Wed, 21 Dec 2022 08:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2256CB81BD8;
        Wed, 21 Dec 2022 16:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724D2C433EF;
        Wed, 21 Dec 2022 16:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671641711;
        bh=iYcKbAaTAqHKG7RBaLmKLWVEVvcPq0GExMONM335krk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNHpbV8cXbQykBCFoeJ1Ze+92DoGV4PBXdFagcU6fA5XjD6KtOwp520uwOyyBCxWJ
         4JVSRVY1B6ATIZDdfbJsi7pI55FTT1wbg2pWB+sL+QpavENXRIsDdMDXKAzYPleEFL
         HCAZY8Tafx/rxuNiuwtJei1bf2PvrJp3PbnSztkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.161
Date:   Wed, 21 Dec 2022 17:55:02 +0100
Message-Id: <167164170231107@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <167164170215084@kroah.com>
References: <167164170215084@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 6f7dae2f1a4e..68f8efa0cc30 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 160
+SUBLEVEL = 161
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 70a693f8f034..2001566be3f5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1150,7 +1150,9 @@
 #define USB_DEVICE_ID_SYNAPTICS_DELL_K12A	0x2819
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012	0x2968
 #define USB_DEVICE_ID_SYNAPTICS_TP_V103	0x5710
+#define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002	0x73f4
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
+#define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017	0x73f6
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
 
 #define USB_VENDOR_ID_TEXAS_INSTRUMENTS	0x2047
diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 742c052b0110..b8cce9c196d8 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -18,10 +18,21 @@ static __u8 *ite_report_fixup(struct hid_device *hdev, __u8 *rdesc, unsigned int
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
 	if (quirks & QUIRK_TOUCHPAD_ON_OFF_REPORT) {
+		/* For Acer Aspire Switch 10 SW5-012 keyboard-dock */
 		if (*rsize == 188 && rdesc[162] == 0x81 && rdesc[163] == 0x02) {
-			hid_info(hdev, "Fixing up ITE keyboard report descriptor\n");
+			hid_info(hdev, "Fixing up Acer Sw5-012 ITE keyboard report descriptor\n");
 			rdesc[163] = HID_MAIN_ITEM_RELATIVE;
 		}
+		/* For Acer One S1002/S1003 keyboard-dock */
+		if (*rsize == 188 && rdesc[185] == 0x81 && rdesc[186] == 0x02) {
+			hid_info(hdev, "Fixing up Acer S1002/S1003 ITE keyboard report descriptor\n");
+			rdesc[186] = HID_MAIN_ITEM_RELATIVE;
+		}
+		/* For Acer Aspire Switch 10E (SW3-016) keyboard-dock */
+		if (*rsize == 210 && rdesc[184] == 0x81 && rdesc[185] == 0x02) {
+			hid_info(hdev, "Fixing up Acer Aspire Switch 10E (SW3-016) ITE keyboard report descriptor\n");
+			rdesc[185] = HID_MAIN_ITEM_RELATIVE;
+		}
 	}
 
 	return rdesc;
@@ -103,7 +114,18 @@ static const struct hid_device_id ite_devices[] = {
 	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_SYNAPTICS,
-		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003) },
+		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
+	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
+	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);
diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 4edb24195704..e4811d37ca77 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -172,6 +172,7 @@ static int uclogic_probe(struct hid_device *hdev,
 	 * than the pen, so use QUIRK_MULTI_INPUT for all tablets.
 	 */
 	hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+	hdev->quirks |= HID_QUIRK_HIDINPUT_FORCE;
 
 	/* Allocate and assign driver data */
 	drvdata = devm_kzalloc(&hdev->dev, sizeof(*drvdata), GFP_KERNEL);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 327196d15a6a..f24f1a8ec2fb 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7416,7 +7416,7 @@ static void igb_vf_reset_msg(struct igb_adapter *adapter, u32 vf)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	unsigned char *vf_mac = adapter->vf_data[vf].vf_mac_addresses;
-	u32 reg, msgbuf[3];
+	u32 reg, msgbuf[3] = {};
 	u8 *addr = (u8 *)(&msgbuf[1]);
 
 	/* process all the same items cleared in a function level reset */
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index a1c77cc00416..498e5c8013ef 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -208,7 +208,7 @@ static __net_init int loopback_net_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	dev = alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
+	dev = alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
 	if (!dev)
 		goto out;
 
diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index fecdba85ab27..5d39aff263f0 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -213,8 +213,9 @@ uvc_function_ep0_complete(struct usb_ep *ep, struct usb_request *req)
 
 		memset(&v4l2_event, 0, sizeof(v4l2_event));
 		v4l2_event.type = UVC_EVENT_DATA;
-		uvc_event->data.length = req->actual;
-		memcpy(&uvc_event->data.data, req->buf, req->actual);
+		uvc_event->data.length = min_t(unsigned int, req->actual,
+			sizeof(uvc_event->data.data));
+		memcpy(&uvc_event->data.data, req->buf, uvc_event->data.length);
 		v4l2_event_queue(&uvc->vdev, &v4l2_event);
 	}
 }
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 0ee11a937011..9168b492c02b 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI		0x51ed
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI	0x54ed
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -242,7 +243,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_MISSING_CAS;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
+	    (pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI))
 		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 6b5ba6180c30..8a4a0d4dbc13 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -199,6 +199,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ USB_DEVICE(0x17A8, 0x0001) }, /* Kamstrup Optical Eye/3-wire */
 	{ USB_DEVICE(0x17A8, 0x0005) }, /* Kamstrup M-Bus Master MultiPort 250D */
+	{ USB_DEVICE(0x17A8, 0x0011) }, /* Kamstrup 444 MHz RF sniffer */
+	{ USB_DEVICE(0x17A8, 0x0013) }, /* Kamstrup 870 MHz RF sniffer */
 	{ USB_DEVICE(0x17A8, 0x0101) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Int Ant) */
 	{ USB_DEVICE(0x17A8, 0x0102) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Ext Ant) */
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 0c7eacc630e0..11fe49543f26 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -130,9 +130,6 @@ static u8 const clock_table[] = { F81232_CLK_1_846_MHZ, F81232_CLK_14_77_MHZ,
 
 static int calc_baud_divisor(speed_t baudrate, speed_t clockrate)
 {
-	if (!baudrate)
-		return 0;
-
 	return DIV_ROUND_CLOSEST(clockrate, baudrate);
 }
 
@@ -523,9 +520,14 @@ static void f81232_set_baudrate(struct tty_struct *tty,
 	speed_t baud_list[] = { baudrate, old_baudrate, F81232_DEF_BAUDRATE };
 
 	for (i = 0; i < ARRAY_SIZE(baud_list); ++i) {
-		idx = f81232_find_clk(baud_list[i]);
+		baudrate = baud_list[i];
+		if (baudrate == 0) {
+			tty_encode_baud_rate(tty, 0, 0);
+			return;
+		}
+
+		idx = f81232_find_clk(baudrate);
 		if (idx >= 0) {
-			baudrate = baud_list[i];
 			tty_encode_baud_rate(tty, baudrate, baudrate);
 			break;
 		}
diff --git a/drivers/usb/serial/f81534.c b/drivers/usb/serial/f81534.c
index 5661fd03e545..e952be683c63 100644
--- a/drivers/usb/serial/f81534.c
+++ b/drivers/usb/serial/f81534.c
@@ -538,9 +538,6 @@ static int f81534_submit_writer(struct usb_serial_port *port, gfp_t mem_flags)
 
 static u32 f81534_calc_baud_divisor(u32 baudrate, u32 clockrate)
 {
-	if (!baudrate)
-		return 0;
-
 	/* Round to nearest divisor */
 	return DIV_ROUND_CLOSEST(clockrate, baudrate);
 }
@@ -570,9 +567,14 @@ static int f81534_set_port_config(struct usb_serial_port *port,
 	u32 baud_list[] = {baudrate, old_baudrate, F81534_DEFAULT_BAUD_RATE};
 
 	for (i = 0; i < ARRAY_SIZE(baud_list); ++i) {
-		idx = f81534_find_clk(baud_list[i]);
+		baudrate = baud_list[i];
+		if (baudrate == 0) {
+			tty_encode_baud_rate(tty, 0, 0);
+			return 0;
+		}
+
+		idx = f81534_find_clk(baudrate);
 		if (idx >= 0) {
-			baudrate = baud_list[i];
 			tty_encode_baud_rate(tty, baudrate, baudrate);
 			break;
 		}
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 537ef276c78f..5636b8f52216 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -255,6 +255,7 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_EP06			0x0306
 #define QUECTEL_PRODUCT_EM05G			0x030a
 #define QUECTEL_PRODUCT_EM060K			0x030b
+#define QUECTEL_PRODUCT_EM05G_SG		0x0311
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
 #define QUECTEL_PRODUCT_RM520N			0x0801
@@ -1160,6 +1161,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0, 0) },
 	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G, 0xff),
 	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_SG, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM060K, 0xff, 0x00, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM060K, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM060K, 0xff, 0xff, 0x40) },
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index d32b836f6ca7..e94a18bb7f99 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -438,6 +438,12 @@ static int udf_get_block(struct inode *inode, sector_t block,
 		iinfo->i_next_alloc_goal++;
 	}
 
+	/*
+	 * Block beyond EOF and prealloc extents? Just discard preallocation
+	 * as it is not useful and complicates things.
+	 */
+	if (((loff_t)block) << inode->i_blkbits > iinfo->i_lenExtents)
+		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
 	if (!phys)
@@ -487,8 +493,6 @@ static int udf_do_extend_file(struct inode *inode,
 	uint32_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
-	struct kernel_lb_addr prealloc_loc = {};
-	uint32_t prealloc_len = 0;
 	struct udf_inode_info *iinfo;
 	int err;
 
@@ -509,19 +513,6 @@ static int udf_do_extend_file(struct inode *inode,
 			~(sb->s_blocksize - 1);
 	}
 
-	/* Last extent are just preallocated blocks? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
-						EXT_NOT_RECORDED_ALLOCATED) {
-		/* Save the extent so that we can reattach it to the end */
-		prealloc_loc = last_ext->extLocation;
-		prealloc_len = last_ext->extLength;
-		/* Mark the extent as a hole */
-		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
-		last_ext->extLocation.logicalBlockNum = 0;
-		last_ext->extLocation.partitionReferenceNum = 0;
-	}
-
 	/* Can we merge with the previous extent? */
 	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
 					EXT_NOT_RECORDED_NOT_ALLOCATED) {
@@ -549,7 +540,7 @@ static int udf_do_extend_file(struct inode *inode,
 		 * more extents, we may need to enter possible following
 		 * empty indirect extent.
 		 */
-		if (new_block_bytes || prealloc_len)
+		if (new_block_bytes)
 			udf_next_aext(inode, last_pos, &tmploc, &tmplen, 0);
 	}
 
@@ -583,17 +574,6 @@ static int udf_do_extend_file(struct inode *inode,
 	}
 
 out:
-	/* Do we have some preallocated blocks saved? */
-	if (prealloc_len) {
-		err = udf_add_aext(inode, last_pos, &prealloc_loc,
-				   prealloc_len, 1);
-		if (err)
-			return err;
-		last_ext->extLocation = prealloc_loc;
-		last_ext->extLength = prealloc_len;
-		count++;
-	}
-
 	/* last_pos should point to the last written extent... */
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		last_pos->offset -= sizeof(struct short_ad);
@@ -609,13 +589,17 @@ static int udf_do_extend_file(struct inode *inode,
 static void udf_do_extend_final_block(struct inode *inode,
 				      struct extent_position *last_pos,
 				      struct kernel_long_ad *last_ext,
-				      uint32_t final_block_len)
+				      uint32_t new_elen)
 {
-	struct super_block *sb = inode->i_sb;
 	uint32_t added_bytes;
 
-	added_bytes = final_block_len -
-		      (last_ext->extLength & (sb->s_blocksize - 1));
+	/*
+	 * Extent already large enough? It may be already rounded up to block
+	 * size...
+	 */
+	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
+		return;
+	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
@@ -632,12 +616,12 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
 	sector_t first_block = newsize >> sb->s_blocksize_bits, offset;
-	unsigned long partial_final_block;
+	loff_t new_elen;
 	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	struct kernel_long_ad extent;
 	int err = 0;
-	int within_final_block;
+	bool within_last_ext;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(struct short_ad);
@@ -646,8 +630,17 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 	else
 		BUG();
 
+	/*
+	 * When creating hole in file, just don't bother with preserving
+	 * preallocation. It likely won't be very useful anyway.
+	 */
+	udf_discard_prealloc(inode);
+
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
-	within_final_block = (etype != -1);
+	within_last_ext = (etype != -1);
+	/* We don't expect extents past EOF... */
+	WARN_ON_ONCE(within_last_ext &&
+		     elen > ((loff_t)offset + 1) << inode->i_blkbits);
 
 	if ((!epos.bh && epos.offset == udf_file_entry_alloc_offset(inode)) ||
 	    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
@@ -663,19 +656,17 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 		extent.extLength |= etype << 30;
 	}
 
-	partial_final_block = newsize & (sb->s_blocksize - 1);
+	new_elen = ((loff_t)offset << inode->i_blkbits) |
+					(newsize & (sb->s_blocksize - 1));
 
 	/* File has extent covering the new size (could happen when extending
 	 * inside a block)?
 	 */
-	if (within_final_block) {
+	if (within_last_ext) {
 		/* Extending file within the last file block */
-		udf_do_extend_final_block(inode, &epos, &extent,
-					  partial_final_block);
+		udf_do_extend_final_block(inode, &epos, &extent, new_elen);
 	} else {
-		loff_t add = ((loff_t)offset << sb->s_blocksize_bits) |
-			     partial_final_block;
-		err = udf_do_extend_file(inode, &epos, &extent, add);
+		err = udf_do_extend_file(inode, &epos, &extent, new_elen);
 	}
 
 	if (err < 0)
@@ -776,10 +767,11 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 		goto out_free;
 	}
 
-	/* Are we beyond EOF? */
+	/* Are we beyond EOF and preallocated extent? */
 	if (etype == -1) {
 		int ret;
 		loff_t hole_len;
+
 		isBeyondEOF = true;
 		if (count) {
 			if (c)
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 532cda99644e..036ebd892b85 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -120,60 +120,42 @@ void udf_truncate_tail_extent(struct inode *inode)
 
 void udf_discard_prealloc(struct inode *inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
+	struct extent_position prev_epos = {};
 	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
-	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	int bsize = 1 << inode->i_blkbits;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
-	    inode->i_size == iinfo->i_lenExtents)
+	    ALIGN(inode->i_size, bsize) == ALIGN(iinfo->i_lenExtents, bsize))
 		return;
 
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(struct short_ad);
-	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(struct long_ad);
-	else
-		adsize = 0;
-
 	epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
-	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
-		etype = netype;
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
+		brelse(prev_epos.bh);
+		prev_epos = epos;
+		if (prev_epos.bh)
+			get_bh(prev_epos.bh);
+
+		etype = udf_next_aext(inode, &epos, &eloc, &elen, 1);
 		lbcount += elen;
 	}
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-		epos.offset -= adsize;
 		lbcount -= elen;
-		extent_trunc(inode, &epos, &eloc, etype, elen, 0);
-		if (!epos.bh) {
-			iinfo->i_lenAlloc =
-				epos.offset -
-				udf_file_entry_alloc_offset(inode);
-			mark_inode_dirty(inode);
-		} else {
-			struct allocExtDesc *aed =
-				(struct allocExtDesc *)(epos.bh->b_data);
-			aed->lengthAllocDescs =
-				cpu_to_le32(epos.offset -
-					    sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
-				udf_update_tag(epos.bh->b_data, epos.offset);
-			else
-				udf_update_tag(epos.bh->b_data,
-					       sizeof(struct allocExtDesc));
-			mark_buffer_dirty_inode(epos.bh, inode);
-		}
+		udf_delete_aext(inode, prev_epos);
+		udf_free_blocks(inode->i_sb, inode, &eloc, 0,
+				DIV_ROUND_UP(elen, 1 << inode->i_blkbits));
 	}
 	/* This inode entry is in-memory only and thus we don't have to mark
 	 * the inode dirty */
 	iinfo->i_lenExtents = lbcount;
 	brelse(epos.bh);
+	brelse(prev_epos.bh);
 }
 
 static void udf_update_alloc_ext_desc(struct inode *inode,
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index c5e4d2b8cb0b..cf56582d298a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4449,7 +4449,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 	chan->ident = cmd->ident;
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP, len, rsp);
-	chan->num_conf_rsp++;
+	if (chan->num_conf_rsp < L2CAP_CONF_MAX_CONF_RSP)
+		chan->num_conf_rsp++;
 
 	/* Reset config buffer. */
 	chan->conf_len = 0;
