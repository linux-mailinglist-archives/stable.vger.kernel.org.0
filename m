Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159FF4F2BD8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343841AbiDEKjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238680AbiDEJci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:32:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B8FDD1;
        Tue,  5 Apr 2022 02:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53635B80DA1;
        Tue,  5 Apr 2022 09:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FDDC385A6;
        Tue,  5 Apr 2022 09:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150371;
        bh=EACh6E1Z5FSI0BZqy8N2FmMwmIwOFfXru6WIJBHEQNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXyv+ik//4hsqejxW68W/GQl6bs8IcJMWCK+tN3RoeFP7fHF8putMci7PpDBlswnW
         nLMLfSqVd/yD5tgqhb75cI0FyQUZAPu908PcatZF3dtEzWPQr8KTVYZ69FmP2ICXHC
         FeP8Xblaqn+7HKiWRELzf+i0T5DXC9+F0VL11XPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 032/913] USB: usb-storage: Fix use of bitfields for hardware data in ene_ub6250.c
Date:   Tue,  5 Apr 2022 09:18:14 +0200
Message-Id: <20220405070340.779763472@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 1892bf90677abcad7f06e897e308f5c3e3618dd4 upstream.

The kernel test robot found a problem with the ene_ub6250 subdriver in
usb-storage: It uses structures containing bitfields to represent
hardware bits in its SD_STATUS, MS_STATUS, and SM_STATUS bytes.  This
is not safe; it presumes a particular bit ordering and it assumes the
compiler will not insert padding, neither of which is guaranteed.

This patch fixes the problem by changing the structures to simple u8
values, with the bitfields replaced by bitmask constants.

CC: <stable@vger.kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YjOcbuU106UpJ/V8@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/ene_ub6250.c |  153 +++++++++++++++++++--------------------
 1 file changed, 75 insertions(+), 78 deletions(-)

--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -237,36 +237,33 @@ static struct us_unusual_dev ene_ub6250_
 #define memstick_logaddr(logadr1, logadr0) ((((u16)(logadr1)) << 8) | (logadr0))
 
 
-struct SD_STATUS {
-	u8    Insert:1;
-	u8    Ready:1;
-	u8    MediaChange:1;
-	u8    IsMMC:1;
-	u8    HiCapacity:1;
-	u8    HiSpeed:1;
-	u8    WtP:1;
-	u8    Reserved:1;
-};
-
-struct MS_STATUS {
-	u8    Insert:1;
-	u8    Ready:1;
-	u8    MediaChange:1;
-	u8    IsMSPro:1;
-	u8    IsMSPHG:1;
-	u8    Reserved1:1;
-	u8    WtP:1;
-	u8    Reserved2:1;
-};
-
-struct SM_STATUS {
-	u8    Insert:1;
-	u8    Ready:1;
-	u8    MediaChange:1;
-	u8    Reserved:3;
-	u8    WtP:1;
-	u8    IsMS:1;
-};
+/* SD_STATUS bits */
+#define SD_Insert	BIT(0)
+#define SD_Ready	BIT(1)
+#define SD_MediaChange	BIT(2)
+#define SD_IsMMC	BIT(3)
+#define SD_HiCapacity	BIT(4)
+#define SD_HiSpeed	BIT(5)
+#define SD_WtP		BIT(6)
+			/* Bit 7 reserved */
+
+/* MS_STATUS bits */
+#define MS_Insert	BIT(0)
+#define MS_Ready	BIT(1)
+#define MS_MediaChange	BIT(2)
+#define MS_IsMSPro	BIT(3)
+#define MS_IsMSPHG	BIT(4)
+			/* Bit 5 reserved */
+#define MS_WtP		BIT(6)
+			/* Bit 7 reserved */
+
+/* SM_STATUS bits */
+#define SM_Insert	BIT(0)
+#define SM_Ready	BIT(1)
+#define SM_MediaChange	BIT(2)
+			/* Bits 3-5 reserved */
+#define SM_WtP		BIT(6)
+#define SM_IsMS		BIT(7)
 
 struct ms_bootblock_cis {
 	u8 bCistplDEVICE[6];    /* 0 */
@@ -437,9 +434,9 @@ struct ene_ub6250_info {
 	u8		*bbuf;
 
 	/* for 6250 code */
-	struct SD_STATUS	SD_Status;
-	struct MS_STATUS	MS_Status;
-	struct SM_STATUS	SM_Status;
+	u8		SD_Status;
+	u8		MS_Status;
+	u8		SM_Status;
 
 	/* ----- SD Control Data ---------------- */
 	/*SD_REGISTER SD_Regs; */
@@ -602,7 +599,7 @@ static int sd_scsi_test_unit_ready(struc
 {
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	if (info->SD_Status.Insert && info->SD_Status.Ready)
+	if ((info->SD_Status & SD_Insert) && (info->SD_Status & SD_Ready))
 		return USB_STOR_TRANSPORT_GOOD;
 	else {
 		ene_sd_init(us);
@@ -622,7 +619,7 @@ static int sd_scsi_mode_sense(struct us_
 		0x0b, 0x00, 0x80, 0x08, 0x00, 0x00,
 		0x71, 0xc0, 0x00, 0x00, 0x02, 0x00 };
 
-	if (info->SD_Status.WtP)
+	if (info->SD_Status & SD_WtP)
 		usb_stor_set_xfer_buf(mediaWP, 12, srb);
 	else
 		usb_stor_set_xfer_buf(mediaNoWP, 12, srb);
@@ -641,9 +638,9 @@ static int sd_scsi_read_capacity(struct
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
 	usb_stor_dbg(us, "sd_scsi_read_capacity\n");
-	if (info->SD_Status.HiCapacity) {
+	if (info->SD_Status & SD_HiCapacity) {
 		bl_len = 0x200;
-		if (info->SD_Status.IsMMC)
+		if (info->SD_Status & SD_IsMMC)
 			bl_num = info->HC_C_SIZE-1;
 		else
 			bl_num = (info->HC_C_SIZE + 1) * 1024 - 1;
@@ -693,7 +690,7 @@ static int sd_scsi_read(struct us_data *
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	if (info->SD_Status.HiCapacity)
+	if (info->SD_Status & SD_HiCapacity)
 		bnByte = bn;
 
 	/* set up the command wrapper */
@@ -733,7 +730,7 @@ static int sd_scsi_write(struct us_data
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	if (info->SD_Status.HiCapacity)
+	if (info->SD_Status & SD_HiCapacity)
 		bnByte = bn;
 
 	/* set up the command wrapper */
@@ -1456,7 +1453,7 @@ static int ms_scsi_test_unit_ready(struc
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)(us->extra);
 
 	/* pr_info("MS_SCSI_Test_Unit_Ready\n"); */
-	if (info->MS_Status.Insert && info->MS_Status.Ready) {
+	if ((info->MS_Status & MS_Insert) && (info->MS_Status & MS_Ready)) {
 		return USB_STOR_TRANSPORT_GOOD;
 	} else {
 		ene_ms_init(us);
@@ -1476,7 +1473,7 @@ static int ms_scsi_mode_sense(struct us_
 		0x0b, 0x00, 0x80, 0x08, 0x00, 0x00,
 		0x71, 0xc0, 0x00, 0x00, 0x02, 0x00 };
 
-	if (info->MS_Status.WtP)
+	if (info->MS_Status & MS_WtP)
 		usb_stor_set_xfer_buf(mediaWP, 12, srb);
 	else
 		usb_stor_set_xfer_buf(mediaNoWP, 12, srb);
@@ -1495,7 +1492,7 @@ static int ms_scsi_read_capacity(struct
 
 	usb_stor_dbg(us, "ms_scsi_read_capacity\n");
 	bl_len = 0x200;
-	if (info->MS_Status.IsMSPro)
+	if (info->MS_Status & MS_IsMSPro)
 		bl_num = info->MSP_TotalBlock - 1;
 	else
 		bl_num = info->MS_Lib.NumberOfLogBlock * info->MS_Lib.blockSize * 2 - 1;
@@ -1650,7 +1647,7 @@ static int ms_scsi_read(struct us_data *
 	if (bn > info->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	if (info->MS_Status.IsMSPro) {
+	if (info->MS_Status & MS_IsMSPro) {
 		result = ene_load_bincode(us, MSP_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD) {
 			usb_stor_dbg(us, "Load MPS RW pattern Fail !!\n");
@@ -1751,7 +1748,7 @@ static int ms_scsi_write(struct us_data
 	if (bn > info->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	if (info->MS_Status.IsMSPro) {
+	if (info->MS_Status & MS_IsMSPro) {
 		result = ene_load_bincode(us, MSP_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD) {
 			pr_info("Load MSP RW pattern Fail !!\n");
@@ -1859,12 +1856,12 @@ static int ene_get_card_status(struct us
 
 	tmpreg = (u16) reg4b;
 	reg4b = *(u32 *)(&buf[0x14]);
-	if (info->SD_Status.HiCapacity && !info->SD_Status.IsMMC)
+	if ((info->SD_Status & SD_HiCapacity) && !(info->SD_Status & SD_IsMMC))
 		info->HC_C_SIZE = (reg4b >> 8) & 0x3fffff;
 
 	info->SD_C_SIZE = ((tmpreg & 0x03) << 10) | (u16)(reg4b >> 22);
 	info->SD_C_SIZE_MULT = (u8)(reg4b >> 7)  & 0x07;
-	if (info->SD_Status.HiCapacity && info->SD_Status.IsMMC)
+	if ((info->SD_Status & SD_HiCapacity) && (info->SD_Status & SD_IsMMC))
 		info->HC_C_SIZE = *(u32 *)(&buf[0x100]);
 
 	if (info->SD_READ_BL_LEN > SD_BLOCK_LEN) {
@@ -2076,6 +2073,7 @@ static int ene_ms_init(struct us_data *u
 	u16 MSP_BlockSize, MSP_UserAreaBlocks;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 	u8 *bbuf = info->bbuf;
+	unsigned int s;
 
 	printk(KERN_INFO "transport --- ENE_MSInit\n");
 
@@ -2100,15 +2098,16 @@ static int ene_ms_init(struct us_data *u
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 	/* the same part to test ENE */
-	info->MS_Status = *(struct MS_STATUS *) bbuf;
+	info->MS_Status = bbuf[0];
 
-	if (info->MS_Status.Insert && info->MS_Status.Ready) {
-		printk(KERN_INFO "Insert     = %x\n", info->MS_Status.Insert);
-		printk(KERN_INFO "Ready      = %x\n", info->MS_Status.Ready);
-		printk(KERN_INFO "IsMSPro    = %x\n", info->MS_Status.IsMSPro);
-		printk(KERN_INFO "IsMSPHG    = %x\n", info->MS_Status.IsMSPHG);
-		printk(KERN_INFO "WtP= %x\n", info->MS_Status.WtP);
-		if (info->MS_Status.IsMSPro) {
+	s = info->MS_Status;
+	if ((s & MS_Insert) && (s & MS_Ready)) {
+		printk(KERN_INFO "Insert     = %x\n", !!(s & MS_Insert));
+		printk(KERN_INFO "Ready      = %x\n", !!(s & MS_Ready));
+		printk(KERN_INFO "IsMSPro    = %x\n", !!(s & MS_IsMSPro));
+		printk(KERN_INFO "IsMSPHG    = %x\n", !!(s & MS_IsMSPHG));
+		printk(KERN_INFO "WtP= %x\n", !!(s & MS_WtP));
+		if (s & MS_IsMSPro) {
 			MSP_BlockSize      = (bbuf[6] << 8) | bbuf[7];
 			MSP_UserAreaBlocks = (bbuf[10] << 8) | bbuf[11];
 			info->MSP_TotalBlock = MSP_BlockSize * MSP_UserAreaBlocks;
@@ -2169,17 +2168,17 @@ static int ene_sd_init(struct us_data *u
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	info->SD_Status =  *(struct SD_STATUS *) bbuf;
-	if (info->SD_Status.Insert && info->SD_Status.Ready) {
-		struct SD_STATUS *s = &info->SD_Status;
+	info->SD_Status = bbuf[0];
+	if ((info->SD_Status & SD_Insert) && (info->SD_Status & SD_Ready)) {
+		unsigned int s = info->SD_Status;
 
 		ene_get_card_status(us, bbuf);
-		usb_stor_dbg(us, "Insert     = %x\n", s->Insert);
-		usb_stor_dbg(us, "Ready      = %x\n", s->Ready);
-		usb_stor_dbg(us, "IsMMC      = %x\n", s->IsMMC);
-		usb_stor_dbg(us, "HiCapacity = %x\n", s->HiCapacity);
-		usb_stor_dbg(us, "HiSpeed    = %x\n", s->HiSpeed);
-		usb_stor_dbg(us, "WtP        = %x\n", s->WtP);
+		usb_stor_dbg(us, "Insert     = %x\n", !!(s & SD_Insert));
+		usb_stor_dbg(us, "Ready      = %x\n", !!(s & SD_Ready));
+		usb_stor_dbg(us, "IsMMC      = %x\n", !!(s & SD_IsMMC));
+		usb_stor_dbg(us, "HiCapacity = %x\n", !!(s & SD_HiCapacity));
+		usb_stor_dbg(us, "HiSpeed    = %x\n", !!(s & SD_HiSpeed));
+		usb_stor_dbg(us, "WtP        = %x\n", !!(s & SD_WtP));
 	} else {
 		usb_stor_dbg(us, "SD Card Not Ready --- %x\n", bbuf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
@@ -2201,14 +2200,14 @@ static int ene_init(struct us_data *us)
 
 	misc_reg03 = bbuf[0];
 	if (misc_reg03 & 0x01) {
-		if (!info->SD_Status.Ready) {
+		if (!(info->SD_Status & SD_Ready)) {
 			result = ene_sd_init(us);
 			if (result != USB_STOR_XFER_GOOD)
 				return USB_STOR_TRANSPORT_ERROR;
 		}
 	}
 	if (misc_reg03 & 0x02) {
-		if (!info->MS_Status.Ready) {
+		if (!(info->MS_Status & MS_Ready)) {
 			result = ene_ms_init(us);
 			if (result != USB_STOR_XFER_GOOD)
 				return USB_STOR_TRANSPORT_ERROR;
@@ -2307,14 +2306,14 @@ static int ene_transport(struct scsi_cmn
 
 	/*US_DEBUG(usb_stor_show_command(us, srb)); */
 	scsi_set_resid(srb, 0);
-	if (unlikely(!(info->SD_Status.Ready || info->MS_Status.Ready)))
+	if (unlikely(!(info->SD_Status & SD_Ready) || (info->MS_Status & MS_Ready)))
 		result = ene_init(us);
 	if (result == USB_STOR_XFER_GOOD) {
 		result = USB_STOR_TRANSPORT_ERROR;
-		if (info->SD_Status.Ready)
+		if (info->SD_Status & SD_Ready)
 			result = sd_scsi_irp(us, srb);
 
-		if (info->MS_Status.Ready)
+		if (info->MS_Status & MS_Ready)
 			result = ms_scsi_irp(us, srb);
 	}
 	return result;
@@ -2378,7 +2377,6 @@ static int ene_ub6250_probe(struct usb_i
 
 static int ene_ub6250_resume(struct usb_interface *iface)
 {
-	u8 tmp = 0;
 	struct us_data *us = usb_get_intfdata(iface);
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)(us->extra);
 
@@ -2390,17 +2388,16 @@ static int ene_ub6250_resume(struct usb_
 	mutex_unlock(&us->dev_mutex);
 
 	info->Power_IsResum = true;
-	/*info->SD_Status.Ready = 0; */
-	info->SD_Status = *(struct SD_STATUS *)&tmp;
-	info->MS_Status = *(struct MS_STATUS *)&tmp;
-	info->SM_Status = *(struct SM_STATUS *)&tmp;
+	/* info->SD_Status &= ~SD_Ready; */
+	info->SD_Status = 0;
+	info->MS_Status = 0;
+	info->SM_Status = 0;
 
 	return 0;
 }
 
 static int ene_ub6250_reset_resume(struct usb_interface *iface)
 {
-	u8 tmp = 0;
 	struct us_data *us = usb_get_intfdata(iface);
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)(us->extra);
 
@@ -2412,10 +2409,10 @@ static int ene_ub6250_reset_resume(struc
 	 * the device
 	 */
 	info->Power_IsResum = true;
-	/*info->SD_Status.Ready = 0; */
-	info->SD_Status = *(struct SD_STATUS *)&tmp;
-	info->MS_Status = *(struct MS_STATUS *)&tmp;
-	info->SM_Status = *(struct SM_STATUS *)&tmp;
+	/* info->SD_Status &= ~SD_Ready; */
+	info->SD_Status = 0;
+	info->MS_Status = 0;
+	info->SM_Status = 0;
 
 	return 0;
 }


