Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47CE1BC83A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgD1Sal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbgD1Sak (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:30:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC05D217D8;
        Tue, 28 Apr 2020 18:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098639;
        bh=gYpCN2E60RoWYWQQNwY8vf9911kUG5TcfdItDCLSNYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnYHpu+mbqoXMy+9+S1lvlR2ecaDnJ7wgilC5+9sxdGV5dampv40iHJl7olG+BrUb
         1yRoR1/l7sqyAKy4bcl3QssTWglwjBrnv3t3y5xr5Wno8vk4y1aT9j0RwamNU020xA
         zo8JeWl9XP7ngPrMlsje2uYYRCQqrwd3iQBcJkMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changming Liu <liu.changm@northeastern.edu>
Subject: [PATCH 5.6 090/167] USB: sisusbvga: Change port variable from signed to unsigned
Date:   Tue, 28 Apr 2020 20:24:26 +0200
Message-Id: <20200428182236.372518894@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -1199,18 +1199,18 @@ static int sisusb_read_mem_bulk(struct s
 /* High level: Gfx (indexed) register access */
 
 #ifdef CONFIG_USB_SISUSBVGA_CON
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
@@ -1220,7 +1220,7 @@ int sisusb_setidxreg(struct sisusb_usb_d
 	return ret;
 }
 
-int sisusb_getidxreg(struct sisusb_usb_data *sisusb, int port,
+int sisusb_getidxreg(struct sisusb_usb_data *sisusb, u32 port,
 		u8 index, u8 *data)
 {
 	int ret;
@@ -1230,7 +1230,7 @@ int sisusb_getidxreg(struct sisusb_usb_d
 	return ret;
 }
 
-int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, int port, u8 idx,
+int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, u32 port, u8 idx,
 		u8 myand, u8 myor)
 {
 	int ret;
@@ -1245,7 +1245,7 @@ int sisusb_setidxregandor(struct sisusb_
 }
 
 static int sisusb_setidxregmask(struct sisusb_usb_data *sisusb,
-		int port, u8 idx, u8 data, u8 mask)
+		u32 port, u8 idx, u8 data, u8 mask)
 {
 	int ret;
 	u8 tmp;
@@ -1258,13 +1258,13 @@ static int sisusb_setidxregmask(struct s
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
@@ -2785,8 +2785,8 @@ static loff_t sisusb_lseek(struct file *
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
@@ -812,17 +812,17 @@ static const struct SiS_VCLKData SiSUSB_
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


