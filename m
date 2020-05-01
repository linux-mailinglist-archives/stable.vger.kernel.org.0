Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737B61C1356
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgEAN2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgEAN2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:28:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 751CB24955;
        Fri,  1 May 2020 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339723;
        bh=B2iI/HFmUp9Oes71GLmtrgRO7Akc8im2hnBm7LzEiS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k651I/xEi2TT7BZI9xLJAZk+pfuDjMs8KjCJF+R/kaI7SxEYpAWuh8gEqNWjM9I/Z
         AnIL0jZYcv1LtavhKuCwLeJc81cXX3Gj418gZfaD39Y7Cpsob4MrpcuhHH5ciufCge
         nsSWNmIA9c6e6Vmwf9rxChTX72d3L+YYZ/wK63B8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changming Liu <liu.changm@northeastern.edu>
Subject: [PATCH 4.9 34/80] USB: sisusbvga: Change port variable from signed to unsigned
Date:   Fri,  1 May 2020 15:21:28 +0200
Message-Id: <20200501131524.992361756@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changming Liu <liu.changm@northeastern.edu>

commit 2df7405f79ce1674d73c2786fe1a8727c905d65b upstream.

Change a bunch of arguments of wrapper functions which pass signed
integer to an unsigned integer which might cause undefined behaviors
when sign integer overflow.

Signed-off-by: Changming Liu <liu.changm@northeastern.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/BL0PR06MB45482D71EA822D75A0E60A2EE5D50@BL0PR06MB4548.namprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/sisusbvga/sisusb.c      |   20 ++++++++++----------
 drivers/usb/misc/sisusbvga/sisusb_init.h |   14 +++++++-------
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -1200,18 +1200,18 @@ static int sisusb_read_mem_bulk(struct s
 /* High level: Gfx (indexed) register access */
 
 #ifdef INCL_SISUSB_CON
-int sisusb_setreg(struct sisusb_usb_data *sisusb, int port, u8 data)
+int sisusb_setreg(struct sisusb_usb_data *sisusb, u32 port, u8 data)
 {
 	return sisusb_write_memio_byte(sisusb, SISUSB_TYPE_IO, port, data);
 }
 
-int sisusb_getreg(struct sisusb_usb_data *sisusb, int port, u8 *data)
+int sisusb_getreg(struct sisusb_usb_data *sisusb, u32 port, u8 *data)
 {
 	return sisusb_read_memio_byte(sisusb, SISUSB_TYPE_IO, port, data);
 }
 #endif
 
-int sisusb_setidxreg(struct sisusb_usb_data *sisusb, int port,
+int sisusb_setidxreg(struct sisusb_usb_data *sisusb, u32 port,
 		u8 index, u8 data)
 {
 	int ret;
@@ -1221,7 +1221,7 @@ int sisusb_setidxreg(struct sisusb_usb_d
 	return ret;
 }
 
-int sisusb_getidxreg(struct sisusb_usb_data *sisusb, int port,
+int sisusb_getidxreg(struct sisusb_usb_data *sisusb, u32 port,
 		u8 index, u8 *data)
 {
 	int ret;
@@ -1231,7 +1231,7 @@ int sisusb_getidxreg(struct sisusb_usb_d
 	return ret;
 }
 
-int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, int port, u8 idx,
+int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, u32 port, u8 idx,
 		u8 myand, u8 myor)
 {
 	int ret;
@@ -1246,7 +1246,7 @@ int sisusb_setidxregandor(struct sisusb_
 }
 
 static int sisusb_setidxregmask(struct sisusb_usb_data *sisusb,
-		int port, u8 idx, u8 data, u8 mask)
+		u32 port, u8 idx, u8 data, u8 mask)
 {
 	int ret;
 	u8 tmp;
@@ -1259,13 +1259,13 @@ static int sisusb_setidxregmask(struct s
 	return ret;
 }
 
-int sisusb_setidxregor(struct sisusb_usb_data *sisusb, int port,
+int sisusb_setidxregor(struct sisusb_usb_data *sisusb, u32 port,
 		u8 index, u8 myor)
 {
 	return sisusb_setidxregandor(sisusb, port, index, 0xff, myor);
 }
 
-int sisusb_setidxregand(struct sisusb_usb_data *sisusb, int port,
+int sisusb_setidxregand(struct sisusb_usb_data *sisusb, u32 port,
 		u8 idx, u8 myand)
 {
 	return sisusb_setidxregandor(sisusb, port, idx, myand, 0x00);
@@ -2796,8 +2796,8 @@ static loff_t sisusb_lseek(struct file *
 static int sisusb_handle_command(struct sisusb_usb_data *sisusb,
 		struct sisusb_command *y, unsigned long arg)
 {
-	int	retval, port, length;
-	u32	address;
+	int	retval, length;
+	u32	port, address;
 
 	/* All our commands require the device
 	 * to be initialized.
--- a/drivers/usb/misc/sisusbvga/sisusb_init.h
+++ b/drivers/usb/misc/sisusbvga/sisusb_init.h
@@ -811,17 +811,17 @@ static const struct SiS_VCLKData SiSUSB_
 int SiSUSBSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
 int SiSUSBSetVESAMode(struct SiS_Private *SiS_Pr, unsigned short VModeNo);
 
-extern int sisusb_setreg(struct sisusb_usb_data *sisusb, int port, u8 data);
-extern int sisusb_getreg(struct sisusb_usb_data *sisusb, int port, u8 * data);
-extern int sisusb_setidxreg(struct sisusb_usb_data *sisusb, int port,
+extern int sisusb_setreg(struct sisusb_usb_data *sisusb, u32 port, u8 data);
+extern int sisusb_getreg(struct sisusb_usb_data *sisusb, u32 port, u8 * data);
+extern int sisusb_setidxreg(struct sisusb_usb_data *sisusb, u32 port,
 			    u8 index, u8 data);
-extern int sisusb_getidxreg(struct sisusb_usb_data *sisusb, int port,
+extern int sisusb_getidxreg(struct sisusb_usb_data *sisusb, u32 port,
 			    u8 index, u8 * data);
-extern int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, int port,
+extern int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, u32 port,
 				 u8 idx, u8 myand, u8 myor);
-extern int sisusb_setidxregor(struct sisusb_usb_data *sisusb, int port,
+extern int sisusb_setidxregor(struct sisusb_usb_data *sisusb, u32 port,
 			      u8 index, u8 myor);
-extern int sisusb_setidxregand(struct sisusb_usb_data *sisusb, int port,
+extern int sisusb_setidxregand(struct sisusb_usb_data *sisusb, u32 port,
 			       u8 idx, u8 myand);
 
 void sisusb_delete(struct kref *kref);


