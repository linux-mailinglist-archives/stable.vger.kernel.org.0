Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08421B5C8A
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgDWN0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgDWN0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:26:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C714C2084D;
        Thu, 23 Apr 2020 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587648396;
        bh=ZJ+mmsVznZTdul6YQsMbuPcvrNKYWkmi0lrtCWMLZQs=;
        h=Subject:To:From:Date:From;
        b=bnGTq3KLrgdznFK0jHfBAziU8B0cIaQdbWikpoPy/poeF9nYiCPm4WbAutOApbn5H
         E0sVIgocnV2PjAbNkx9lgs+MyQjQ57do5gtosiiH6j8VwcefertmP9FSBlDxG0qQqD
         ZPnyi2Mb/gcMj78eo8bvg/zGbRcyJyVnjYe7Tq0E=
Subject: patch "USB: sisusbvga: Change port variable from signed to unsigned" added to usb-linus
To:     liu.changm@northeastern.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 15:26:34 +0200
Message-ID: <158764839477184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: sisusbvga: Change port variable from signed to unsigned

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2df7405f79ce1674d73c2786fe1a8727c905d65b Mon Sep 17 00:00:00 2001
From: Changming Liu <liu.changm@northeastern.edu>
Date: Mon, 20 Apr 2020 23:41:25 -0400
Subject: USB: sisusbvga: Change port variable from signed to unsigned

Change a bunch of arguments of wrapper functions which pass signed
integer to an unsigned integer which might cause undefined behaviors
when sign integer overflow.

Signed-off-by: Changming Liu <liu.changm@northeastern.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/BL0PR06MB45482D71EA822D75A0E60A2EE5D50@BL0PR06MB4548.namprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/sisusbvga/sisusb.c      | 20 ++++++++++----------
 drivers/usb/misc/sisusbvga/sisusb_init.h | 14 +++++++-------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 2ab9600d0898..fc8a5da4a07c 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -1199,18 +1199,18 @@ static int sisusb_read_mem_bulk(struct sisusb_usb_data *sisusb, u32 addr,
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
@@ -1220,7 +1220,7 @@ int sisusb_setidxreg(struct sisusb_usb_data *sisusb, int port,
 	return ret;
 }
 
-int sisusb_getidxreg(struct sisusb_usb_data *sisusb, int port,
+int sisusb_getidxreg(struct sisusb_usb_data *sisusb, u32 port,
 		u8 index, u8 *data)
 {
 	int ret;
@@ -1230,7 +1230,7 @@ int sisusb_getidxreg(struct sisusb_usb_data *sisusb, int port,
 	return ret;
 }
 
-int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, int port, u8 idx,
+int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, u32 port, u8 idx,
 		u8 myand, u8 myor)
 {
 	int ret;
@@ -1245,7 +1245,7 @@ int sisusb_setidxregandor(struct sisusb_usb_data *sisusb, int port, u8 idx,
 }
 
 static int sisusb_setidxregmask(struct sisusb_usb_data *sisusb,
-		int port, u8 idx, u8 data, u8 mask)
+		u32 port, u8 idx, u8 data, u8 mask)
 {
 	int ret;
 	u8 tmp;
@@ -1258,13 +1258,13 @@ static int sisusb_setidxregmask(struct sisusb_usb_data *sisusb,
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
@@ -2785,8 +2785,8 @@ static loff_t sisusb_lseek(struct file *file, loff_t offset, int orig)
 static int sisusb_handle_command(struct sisusb_usb_data *sisusb,
 		struct sisusb_command *y, unsigned long arg)
 {
-	int	retval, port, length;
-	u32	address;
+	int	retval, length;
+	u32	port, address;
 
 	/* All our commands require the device
 	 * to be initialized.
diff --git a/drivers/usb/misc/sisusbvga/sisusb_init.h b/drivers/usb/misc/sisusbvga/sisusb_init.h
index 1782c759c4ad..ace09985dae4 100644
--- a/drivers/usb/misc/sisusbvga/sisusb_init.h
+++ b/drivers/usb/misc/sisusbvga/sisusb_init.h
@@ -812,17 +812,17 @@ static const struct SiS_VCLKData SiSUSB_VCLKData[] = {
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
-- 
2.26.2


