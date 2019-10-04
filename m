Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F419CB6AC
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 10:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfJDIyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 04:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfJDIyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 04:54:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EF8421848;
        Fri,  4 Oct 2019 08:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570179242;
        bh=zcCQ1iSEr/w6ybhw+D+s2B9VV9KZHVtlX8pQ20N0ikw=;
        h=Subject:To:From:Date:From;
        b=xrop5995BPLef8+pFzYFRxD/xseW5gOK2fJ5j5w3pEIoib7SVx5JJTNb2LCvO/1j5
         2YSM4qeRHrU6UrvLRpRBvMNvEid7lNal81i1g/YKHuyblsffVj0HhJD1C/dRA/49CT
         vT5ZYGnA1MV01N6CiT6exY291uUhD37fuyvXBSAA=
Subject: patch "USB: rio500: Remove Rio 500 kernel driver" added to usb-linus
To:     hadess@hadess.net, gregkh@linuxfoundation.org, miquel@df.uba.ar,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 10:53:59 +0200
Message-ID: <1570179239132179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: rio500: Remove Rio 500 kernel driver

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 015664d15270a112c2371d812f03f7c579b35a73 Mon Sep 17 00:00:00 2001
From: Bastien Nocera <hadess@hadess.net>
Date: Mon, 23 Sep 2019 18:18:43 +0200
Subject: USB: rio500: Remove Rio 500 kernel driver

The Rio500 kernel driver has not been used by Rio500 owners since 2001
not long after the rio500 project added support for a user-space USB stack
through the very first versions of usbdevfs and then libusb.

Support for the kernel driver was removed from the upstream utilities
in 2008:
https://gitlab.freedesktop.org/hadess/rio500/commit/943f624ab721eb8281c287650fcc9e2026f6f5db

Cc: Cesar Miquel <miquel@df.uba.ar>
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/6251c17584d220472ce882a3d9c199c401a51a71.camel@hadess.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/usb/rio.rst          | 109 ------
 MAINTAINERS                        |   7 -
 arch/arm/configs/badge4_defconfig  |   1 -
 arch/arm/configs/corgi_defconfig   |   1 -
 arch/arm/configs/pxa_defconfig     |   1 -
 arch/arm/configs/s3c2410_defconfig |   1 -
 arch/arm/configs/spitz_defconfig   |   1 -
 arch/mips/configs/mtx1_defconfig   |   1 -
 arch/mips/configs/rm200_defconfig  |   1 -
 drivers/usb/misc/Kconfig           |  10 -
 drivers/usb/misc/Makefile          |   1 -
 drivers/usb/misc/rio500.c          | 554 -----------------------------
 drivers/usb/misc/rio500_usb.h      |  20 --
 13 files changed, 708 deletions(-)
 delete mode 100644 Documentation/usb/rio.rst
 delete mode 100644 drivers/usb/misc/rio500.c
 delete mode 100644 drivers/usb/misc/rio500_usb.h

diff --git a/Documentation/usb/rio.rst b/Documentation/usb/rio.rst
deleted file mode 100644
index ea73475471db..000000000000
--- a/Documentation/usb/rio.rst
+++ /dev/null
@@ -1,109 +0,0 @@
-﻿============
-Diamonds Rio
-============
-
-Copyright (C) 1999, 2000 Bruce Tenison
-
-Portions Copyright (C) 1999, 2000 David Nelson
-
-Thanks to David Nelson for guidance and the usage of the scanner.txt
-and scanner.c files to model our driver and this informative file.
-
-Mar. 2, 2000
-
-Changes
-=======
-
-- Initial Revision
-
-
-Overview
-========
-
-This README will address issues regarding how to configure the kernel
-to access a RIO 500 mp3 player.
-Before I explain how to use this to access the Rio500 please be warned:
-
-.. warning::
-
-   Please note that this software is still under development.  The authors
-   are in no way responsible for any damage that may occur, no matter how
-   inconsequential.
-
-It seems that the Rio has a problem when sending .mp3 with low batteries.
-I suggest when the batteries are low and you want to transfer stuff that you
-replace it with a fresh one. In my case, what happened is I lost two 16kb
-blocks (they are no longer usable to store information to it). But I don't
-know if that's normal or not; it could simply be a problem with the flash
-memory.
-
-In an extreme case, I left my Rio playing overnight and the batteries wore
-down to nothing and appear to have corrupted the flash memory. My RIO
-needed to be replaced as a result.  Diamond tech support is aware of the
-problem.  Do NOT allow your batteries to wear down to nothing before
-changing them.  It appears RIO 500 firmware does not handle low battery
-power well at all.
-
-On systems with OHCI controllers, the kernel OHCI code appears to have
-power on problems with some chipsets.  If you are having problems
-connecting to your RIO 500, try turning it on first and then plugging it
-into the USB cable.
-
-Contact Information
--------------------
-
-   The main page for the project is hosted at sourceforge.net in the following
-   URL: <http://rio500.sourceforge.net>. You can also go to the project's
-   sourceforge home page at: <http://sourceforge.net/projects/rio500/>.
-   There is also a mailing list: rio500-users@lists.sourceforge.net
-
-Authors
--------
-
-Most of the code was written by Cesar Miquel <miquel@df.uba.ar>. Keith
-Clayton <kclayton@jps.net> is incharge of the PPC port and making sure
-things work there. Bruce Tenison <btenison@dibbs.net> is adding support
-for .fon files and also does testing. The program will mostly sure be
-re-written and Pete Ikusz along with the rest will re-design it. I would
-also like to thank Tri Nguyen <tmn_3022000@hotmail.com> who provided use
-with some important information regarding the communication with the Rio.
-
-Additional Information and userspace tools
-
-	http://rio500.sourceforge.net/
-
-
-Requirements
-============
-
-A host with a USB port running a Linux kernel with RIO 500 support enabled.
-
-The driver is a module called rio500, which should be automatically loaded
-as you plug in your device. If that fails you can manually load it with
-
-  modprobe rio500
-
-Udev should automatically create a device node as soon as plug in your device.
-If that fails, you can manually add a device for the USB rio500::
-
-  mknod /dev/usb/rio500 c 180 64
-
-In that case, set appropriate permissions for /dev/usb/rio500 (don't forget
-about group and world permissions).  Both read and write permissions are
-required for proper operation.
-
-That's it.  The Rio500 Utils at: http://rio500.sourceforge.net should
-be able to access the rio500.
-
-Limits
-======
-
-You can use only a single rio500 device at a time with your computer.
-
-Bugs
-====
-
-If you encounter any problems feel free to drop me an email.
-
-Bruce Tenison
-btenison@dibbs.net
diff --git a/MAINTAINERS b/MAINTAINERS
index 296de2b51c83..3bcf493f3f8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16762,13 +16762,6 @@ W:	http://www.linux-usb.org/usbnet
 S:	Maintained
 F:	drivers/net/usb/dm9601.c
 
-USB DIAMOND RIO500 DRIVER
-M:	Cesar Miquel <miquel@df.uba.ar>
-L:	rio500-users@lists.sourceforge.net
-W:	http://rio500.sourceforge.net
-S:	Maintained
-F:	drivers/usb/misc/rio500*
-
 USB EHCI DRIVER
 M:	Alan Stern <stern@rowland.harvard.edu>
 L:	linux-usb@vger.kernel.org
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_defconfig
index 5ae5b5228467..ef484c4cfd1a 100644
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -91,7 +91,6 @@ CONFIG_USB_SERIAL_PL2303=m
 CONFIG_USB_SERIAL_CYBERJACK=m
 CONFIG_USB_SERIAL_XIRCOM=m
 CONFIG_USB_SERIAL_OMNINET=m
-CONFIG_USB_RIO500=m
 CONFIG_EXT2_FS=m
 CONFIG_EXT3_FS=m
 CONFIG_MSDOS_FS=y
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index e4f6442588e7..4fec2ec379ad 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -195,7 +195,6 @@ CONFIG_USB_SERIAL_XIRCOM=m
 CONFIG_USB_SERIAL_OMNINET=m
 CONFIG_USB_EMI62=m
 CONFIG_USB_EMI26=m
-CONFIG_USB_RIO500=m
 CONFIG_USB_LEGOTOWER=m
 CONFIG_USB_LCD=m
 CONFIG_USB_CYTHERM=m
diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index 787c3f9be414..b817c57f05f1 100644
--- a/arch/arm/configs/pxa_defconfig
+++ b/arch/arm/configs/pxa_defconfig
@@ -581,7 +581,6 @@ CONFIG_USB_SERIAL_XIRCOM=m
 CONFIG_USB_SERIAL_OMNINET=m
 CONFIG_USB_EMI62=m
 CONFIG_USB_EMI26=m
-CONFIG_USB_RIO500=m
 CONFIG_USB_LEGOTOWER=m
 CONFIG_USB_LCD=m
 CONFIG_USB_CYTHERM=m
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 95b5a4ffddea..73ed73a8785a 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -327,7 +327,6 @@ CONFIG_USB_EMI62=m
 CONFIG_USB_EMI26=m
 CONFIG_USB_ADUTUX=m
 CONFIG_USB_SEVSEG=m
-CONFIG_USB_RIO500=m
 CONFIG_USB_LEGOTOWER=m
 CONFIG_USB_LCD=m
 CONFIG_USB_CYPRESS_CY7C63=m
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index 4fb51d665abb..a1cdbfa064c5 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -189,7 +189,6 @@ CONFIG_USB_SERIAL_XIRCOM=m
 CONFIG_USB_SERIAL_OMNINET=m
 CONFIG_USB_EMI62=m
 CONFIG_USB_EMI26=m
-CONFIG_USB_RIO500=m
 CONFIG_USB_LEGOTOWER=m
 CONFIG_USB_LCD=m
 CONFIG_USB_CYTHERM=m
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 16bef819fe98..914af125a7fa 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -571,7 +571,6 @@ CONFIG_USB_SERIAL_OMNINET=m
 CONFIG_USB_EMI62=m
 CONFIG_USB_EMI26=m
 CONFIG_USB_ADUTUX=m
-CONFIG_USB_RIO500=m
 CONFIG_USB_LEGOTOWER=m
 CONFIG_USB_LCD=m
 CONFIG_USB_CYPRESS_CY7C63=m
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 8762e75f5d5f..2c7adea7638f 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -314,7 +314,6 @@ CONFIG_USB_SERIAL_SAFE_PADDED=y
 CONFIG_USB_SERIAL_CYBERJACK=m
 CONFIG_USB_SERIAL_XIRCOM=m
 CONFIG_USB_SERIAL_OMNINET=m
-CONFIG_USB_RIO500=m
 CONFIG_USB_LEGOTOWER=m
 CONFIG_USB_LCD=m
 CONFIG_USB_CYTHERM=m
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index bdae62b2ffe0..9bce583aada3 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -47,16 +47,6 @@ config USB_SEVSEG
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbsevseg.
 
-config USB_RIO500
-	tristate "USB Diamond Rio500 support"
-	help
-	  Say Y here if you want to connect a USB Rio500 mp3 player to your
-	  computer's USB port. Please read <file:Documentation/usb/rio.rst>
-	  for more information.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called rio500.
-
 config USB_LEGOTOWER
 	tristate "USB Lego Infrared Tower support"
 	help
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 109f54f5b9aa..0d416eb624bb 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_USB_ISIGHTFW)		+= isight_firmware.o
 obj-$(CONFIG_USB_LCD)			+= usblcd.o
 obj-$(CONFIG_USB_LD)			+= ldusb.o
 obj-$(CONFIG_USB_LEGOTOWER)		+= legousbtower.o
-obj-$(CONFIG_USB_RIO500)		+= rio500.o
 obj-$(CONFIG_USB_TEST)			+= usbtest.o
 obj-$(CONFIG_USB_EHSET_TEST_FIXTURE)    += ehset.o
 obj-$(CONFIG_USB_TRANCEVIBRATOR)	+= trancevibrator.o
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
deleted file mode 100644
index 30cae5e1954d..000000000000
--- a/drivers/usb/misc/rio500.c
+++ /dev/null
@@ -1,554 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/* -*- linux-c -*- */
-
-/* 
- * Driver for USB Rio 500
- *
- * Cesar Miquel (miquel@df.uba.ar)
- * 
- * based on hp_scanner.c by David E. Nelson (dnelson@jump.net)
- *
- * Based upon mouse.c (Brad Keryan) and printer.c (Michael Gee).
- *
- * Changelog:
- * 30/05/2003  replaced lock/unlock kernel with up/down
- *             Daniele Bellucci  bellucda@tiscali.it
- * */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/signal.h>
-#include <linux/sched/signal.h>
-#include <linux/mutex.h>
-#include <linux/errno.h>
-#include <linux/random.h>
-#include <linux/poll.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/usb.h>
-#include <linux/wait.h>
-
-#include "rio500_usb.h"
-
-#define DRIVER_AUTHOR "Cesar Miquel <miquel@df.uba.ar>"
-#define DRIVER_DESC "USB Rio 500 driver"
-
-#define RIO_MINOR	64
-
-/* stall/wait timeout for rio */
-#define NAK_TIMEOUT (HZ)
-
-#define IBUF_SIZE 0x1000
-
-/* Size of the rio buffer */
-#define OBUF_SIZE 0x10000
-
-struct rio_usb_data {
-        struct usb_device *rio_dev;     /* init: probe_rio */
-        unsigned int ifnum;             /* Interface number of the USB device */
-        int isopen;                     /* nz if open */
-        int present;                    /* Device is present on the bus */
-        char *obuf, *ibuf;              /* transfer buffers */
-        char bulk_in_ep, bulk_out_ep;   /* Endpoint assignments */
-        wait_queue_head_t wait_q;       /* for timeouts */
-};
-
-static DEFINE_MUTEX(rio500_mutex);
-static struct rio_usb_data rio_instance;
-
-static int open_rio(struct inode *inode, struct file *file)
-{
-	struct rio_usb_data *rio = &rio_instance;
-
-	/* against disconnect() */
-	mutex_lock(&rio500_mutex);
-
-	if (rio->isopen || !rio->present) {
-		mutex_unlock(&rio500_mutex);
-		return -EBUSY;
-	}
-	rio->isopen = 1;
-
-	init_waitqueue_head(&rio->wait_q);
-
-
-	dev_info(&rio->rio_dev->dev, "Rio opened.\n");
-	mutex_unlock(&rio500_mutex);
-
-	return 0;
-}
-
-static int close_rio(struct inode *inode, struct file *file)
-{
-	struct rio_usb_data *rio = &rio_instance;
-
-	/* against disconnect() */
-	mutex_lock(&rio500_mutex);
-
-	rio->isopen = 0;
-	if (!rio->present) {
-		/* cleanup has been delayed */
-		kfree(rio->ibuf);
-		kfree(rio->obuf);
-		rio->ibuf = NULL;
-		rio->obuf = NULL;
-	} else {
-		dev_info(&rio->rio_dev->dev, "Rio closed.\n");
-	}
-	mutex_unlock(&rio500_mutex);
-	return 0;
-}
-
-static long ioctl_rio(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct RioCommand rio_cmd;
-	struct rio_usb_data *rio = &rio_instance;
-	void __user *data;
-	unsigned char *buffer;
-	int result, requesttype;
-	int retries;
-	int retval=0;
-
-	mutex_lock(&rio500_mutex);
-        /* Sanity check to make sure rio is connected, powered, etc */
-        if (rio->present == 0 || rio->rio_dev == NULL) {
-		retval = -ENODEV;
-		goto err_out;
-	}
-
-	switch (cmd) {
-	case RIO_RECV_COMMAND:
-		data = (void __user *) arg;
-		if (data == NULL)
-			break;
-		if (copy_from_user(&rio_cmd, data, sizeof(struct RioCommand))) {
-			retval = -EFAULT;
-			goto err_out;
-		}
-		if (rio_cmd.length < 0 || rio_cmd.length > PAGE_SIZE) {
-			retval = -EINVAL;
-			goto err_out;
-		}
-		buffer = (unsigned char *) __get_free_page(GFP_KERNEL);
-		if (buffer == NULL) {
-			retval = -ENOMEM;
-			goto err_out;
-		}
-		if (copy_from_user(buffer, rio_cmd.buffer, rio_cmd.length)) {
-			retval = -EFAULT;
-			free_page((unsigned long) buffer);
-			goto err_out;
-		}
-
-		requesttype = rio_cmd.requesttype | USB_DIR_IN |
-		    USB_TYPE_VENDOR | USB_RECIP_DEVICE;
-		dev_dbg(&rio->rio_dev->dev,
-			"sending command:reqtype=%0x req=%0x value=%0x index=%0x len=%0x\n",
-			requesttype, rio_cmd.request, rio_cmd.value,
-			rio_cmd.index, rio_cmd.length);
-		/* Send rio control message */
-		retries = 3;
-		while (retries) {
-			result = usb_control_msg(rio->rio_dev,
-						 usb_rcvctrlpipe(rio-> rio_dev, 0),
-						 rio_cmd.request,
-						 requesttype,
-						 rio_cmd.value,
-						 rio_cmd.index, buffer,
-						 rio_cmd.length,
-						 jiffies_to_msecs(rio_cmd.timeout));
-			if (result == -ETIMEDOUT)
-				retries--;
-			else if (result < 0) {
-				dev_err(&rio->rio_dev->dev,
-					"Error executing ioctrl. code = %d\n",
-					result);
-				retries = 0;
-			} else {
-				dev_dbg(&rio->rio_dev->dev,
-					"Executed ioctl. Result = %d (data=%02x)\n",
-					result, buffer[0]);
-				if (copy_to_user(rio_cmd.buffer, buffer,
-						 rio_cmd.length)) {
-					free_page((unsigned long) buffer);
-					retval = -EFAULT;
-					goto err_out;
-				}
-				retries = 0;
-			}
-
-			/* rio_cmd.buffer contains a raw stream of single byte
-			   data which has been returned from rio.  Data is
-			   interpreted at application level.  For data that
-			   will be cast to data types longer than 1 byte, data
-			   will be little_endian and will potentially need to
-			   be swapped at the app level */
-
-		}
-		free_page((unsigned long) buffer);
-		break;
-
-	case RIO_SEND_COMMAND:
-		data = (void __user *) arg;
-		if (data == NULL)
-			break;
-		if (copy_from_user(&rio_cmd, data, sizeof(struct RioCommand))) {
-			retval = -EFAULT;
-			goto err_out;
-		}
-		if (rio_cmd.length < 0 || rio_cmd.length > PAGE_SIZE) {
-			retval = -EINVAL;
-			goto err_out;
-		}
-		buffer = (unsigned char *) __get_free_page(GFP_KERNEL);
-		if (buffer == NULL) {
-			retval = -ENOMEM;
-			goto err_out;
-		}
-		if (copy_from_user(buffer, rio_cmd.buffer, rio_cmd.length)) {
-			free_page((unsigned long)buffer);
-			retval = -EFAULT;
-			goto err_out;
-		}
-
-		requesttype = rio_cmd.requesttype | USB_DIR_OUT |
-		    USB_TYPE_VENDOR | USB_RECIP_DEVICE;
-		dev_dbg(&rio->rio_dev->dev,
-			"sending command: reqtype=%0x req=%0x value=%0x index=%0x len=%0x\n",
-			requesttype, rio_cmd.request, rio_cmd.value,
-			rio_cmd.index, rio_cmd.length);
-		/* Send rio control message */
-		retries = 3;
-		while (retries) {
-			result = usb_control_msg(rio->rio_dev,
-						 usb_sndctrlpipe(rio-> rio_dev, 0),
-						 rio_cmd.request,
-						 requesttype,
-						 rio_cmd.value,
-						 rio_cmd.index, buffer,
-						 rio_cmd.length,
-						 jiffies_to_msecs(rio_cmd.timeout));
-			if (result == -ETIMEDOUT)
-				retries--;
-			else if (result < 0) {
-				dev_err(&rio->rio_dev->dev,
-					"Error executing ioctrl. code = %d\n",
-					result);
-				retries = 0;
-			} else {
-				dev_dbg(&rio->rio_dev->dev,
-					"Executed ioctl. Result = %d\n", result);
-				retries = 0;
-
-			}
-
-		}
-		free_page((unsigned long) buffer);
-		break;
-
-	default:
-		retval = -ENOTTY;
-		break;
-	}
-
-
-err_out:
-	mutex_unlock(&rio500_mutex);
-	return retval;
-}
-
-static ssize_t
-write_rio(struct file *file, const char __user *buffer,
-	  size_t count, loff_t * ppos)
-{
-	DEFINE_WAIT(wait);
-	struct rio_usb_data *rio = &rio_instance;
-
-	unsigned long copy_size;
-	unsigned long bytes_written = 0;
-	unsigned int partial;
-
-	int result = 0;
-	int maxretry;
-	int errn = 0;
-	int intr;
-
-	intr = mutex_lock_interruptible(&rio500_mutex);
-	if (intr)
-		return -EINTR;
-        /* Sanity check to make sure rio is connected, powered, etc */
-        if (rio->present == 0 || rio->rio_dev == NULL) {
-		mutex_unlock(&rio500_mutex);
-		return -ENODEV;
-	}
-
-
-
-	do {
-		unsigned long thistime;
-		char *obuf = rio->obuf;
-
-		thistime = copy_size =
-		    (count >= OBUF_SIZE) ? OBUF_SIZE : count;
-		if (copy_from_user(rio->obuf, buffer, copy_size)) {
-			errn = -EFAULT;
-			goto error;
-		}
-		maxretry = 5;
-		while (thistime) {
-			if (!rio->rio_dev) {
-				errn = -ENODEV;
-				goto error;
-			}
-			if (signal_pending(current)) {
-				mutex_unlock(&rio500_mutex);
-				return bytes_written ? bytes_written : -EINTR;
-			}
-
-			result = usb_bulk_msg(rio->rio_dev,
-					 usb_sndbulkpipe(rio->rio_dev, 2),
-					 obuf, thistime, &partial, 5000);
-
-			dev_dbg(&rio->rio_dev->dev,
-				"write stats: result:%d thistime:%lu partial:%u\n",
-				result, thistime, partial);
-
-			if (result == -ETIMEDOUT) {	/* NAK - so hold for a while */
-				if (!maxretry--) {
-					errn = -ETIME;
-					goto error;
-				}
-				prepare_to_wait(&rio->wait_q, &wait, TASK_INTERRUPTIBLE);
-				schedule_timeout(NAK_TIMEOUT);
-				finish_wait(&rio->wait_q, &wait);
-				continue;
-			} else if (!result && partial) {
-				obuf += partial;
-				thistime -= partial;
-			} else
-				break;
-		}
-		if (result) {
-			dev_err(&rio->rio_dev->dev, "Write Whoops - %x\n",
-				result);
-			errn = -EIO;
-			goto error;
-		}
-		bytes_written += copy_size;
-		count -= copy_size;
-		buffer += copy_size;
-	} while (count > 0);
-
-	mutex_unlock(&rio500_mutex);
-
-	return bytes_written ? bytes_written : -EIO;
-
-error:
-	mutex_unlock(&rio500_mutex);
-	return errn;
-}
-
-static ssize_t
-read_rio(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
-{
-	DEFINE_WAIT(wait);
-	struct rio_usb_data *rio = &rio_instance;
-	ssize_t read_count;
-	unsigned int partial;
-	int this_read;
-	int result;
-	int maxretry = 10;
-	char *ibuf;
-	int intr;
-
-	intr = mutex_lock_interruptible(&rio500_mutex);
-	if (intr)
-		return -EINTR;
-	/* Sanity check to make sure rio is connected, powered, etc */
-        if (rio->present == 0 || rio->rio_dev == NULL) {
-		mutex_unlock(&rio500_mutex);
-		return -ENODEV;
-	}
-
-	ibuf = rio->ibuf;
-
-	read_count = 0;
-
-
-	while (count > 0) {
-		if (signal_pending(current)) {
-			mutex_unlock(&rio500_mutex);
-			return read_count ? read_count : -EINTR;
-		}
-		if (!rio->rio_dev) {
-			mutex_unlock(&rio500_mutex);
-			return -ENODEV;
-		}
-		this_read = (count >= IBUF_SIZE) ? IBUF_SIZE : count;
-
-		result = usb_bulk_msg(rio->rio_dev,
-				      usb_rcvbulkpipe(rio->rio_dev, 1),
-				      ibuf, this_read, &partial,
-				      8000);
-
-		dev_dbg(&rio->rio_dev->dev,
-			"read stats: result:%d this_read:%u partial:%u\n",
-			result, this_read, partial);
-
-		if (partial) {
-			count = this_read = partial;
-		} else if (result == -ETIMEDOUT || result == 15) {	/* FIXME: 15 ??? */
-			if (!maxretry--) {
-				mutex_unlock(&rio500_mutex);
-				dev_err(&rio->rio_dev->dev,
-					"read_rio: maxretry timeout\n");
-				return -ETIME;
-			}
-			prepare_to_wait(&rio->wait_q, &wait, TASK_INTERRUPTIBLE);
-			schedule_timeout(NAK_TIMEOUT);
-			finish_wait(&rio->wait_q, &wait);
-			continue;
-		} else if (result != -EREMOTEIO) {
-			mutex_unlock(&rio500_mutex);
-			dev_err(&rio->rio_dev->dev,
-				"Read Whoops - result:%d partial:%u this_read:%u\n",
-				result, partial, this_read);
-			return -EIO;
-		} else {
-			mutex_unlock(&rio500_mutex);
-			return (0);
-		}
-
-		if (this_read) {
-			if (copy_to_user(buffer, ibuf, this_read)) {
-				mutex_unlock(&rio500_mutex);
-				return -EFAULT;
-			}
-			count -= this_read;
-			read_count += this_read;
-			buffer += this_read;
-		}
-	}
-	mutex_unlock(&rio500_mutex);
-	return read_count;
-}
-
-static const struct file_operations usb_rio_fops = {
-	.owner =	THIS_MODULE,
-	.read =		read_rio,
-	.write =	write_rio,
-	.unlocked_ioctl = ioctl_rio,
-	.open =		open_rio,
-	.release =	close_rio,
-	.llseek =	noop_llseek,
-};
-
-static struct usb_class_driver usb_rio_class = {
-	.name =		"rio500%d",
-	.fops =		&usb_rio_fops,
-	.minor_base =	RIO_MINOR,
-};
-
-static int probe_rio(struct usb_interface *intf,
-		     const struct usb_device_id *id)
-{
-	struct usb_device *dev = interface_to_usbdev(intf);
-	struct rio_usb_data *rio = &rio_instance;
-	int retval = -ENOMEM;
-	char *ibuf, *obuf;
-
-	if (rio->present) {
-		dev_info(&intf->dev, "Second USB Rio at address %d refused\n", dev->devnum);
-		return -EBUSY;
-	}
-	dev_info(&intf->dev, "USB Rio found at address %d\n", dev->devnum);
-
-	obuf = kmalloc(OBUF_SIZE, GFP_KERNEL);
-	if (!obuf) {
-		dev_err(&dev->dev,
-			"probe_rio: Not enough memory for the output buffer\n");
-		goto err_obuf;
-	}
-	dev_dbg(&intf->dev, "obuf address: %p\n", obuf);
-
-	ibuf = kmalloc(IBUF_SIZE, GFP_KERNEL);
-	if (!ibuf) {
-		dev_err(&dev->dev,
-			"probe_rio: Not enough memory for the input buffer\n");
-		goto err_ibuf;
-	}
-	dev_dbg(&intf->dev, "ibuf address: %p\n", ibuf);
-
-	mutex_lock(&rio500_mutex);
-	rio->rio_dev = dev;
-	rio->ibuf = ibuf;
-	rio->obuf = obuf;
-	rio->present = 1;
-	mutex_unlock(&rio500_mutex);
-
-	retval = usb_register_dev(intf, &usb_rio_class);
-	if (retval) {
-		dev_err(&dev->dev,
-			"Not able to get a minor for this device.\n");
-		goto err_register;
-	}
-
-	usb_set_intfdata(intf, rio);
-	return retval;
-
- err_register:
-	mutex_lock(&rio500_mutex);
-	rio->present = 0;
-	mutex_unlock(&rio500_mutex);
- err_ibuf:
-	kfree(obuf);
- err_obuf:
-	return retval;
-}
-
-static void disconnect_rio(struct usb_interface *intf)
-{
-	struct rio_usb_data *rio = usb_get_intfdata (intf);
-
-	usb_set_intfdata (intf, NULL);
-	if (rio) {
-		usb_deregister_dev(intf, &usb_rio_class);
-
-		mutex_lock(&rio500_mutex);
-		if (rio->isopen) {
-			rio->isopen = 0;
-			/* better let it finish - the release will do whats needed */
-			rio->rio_dev = NULL;
-			mutex_unlock(&rio500_mutex);
-			return;
-		}
-		kfree(rio->ibuf);
-		kfree(rio->obuf);
-
-		dev_info(&intf->dev, "USB Rio disconnected.\n");
-
-		rio->present = 0;
-		mutex_unlock(&rio500_mutex);
-	}
-}
-
-static const struct usb_device_id rio_table[] = {
-	{ USB_DEVICE(0x0841, 1) }, 		/* Rio 500 */
-	{ }					/* Terminating entry */
-};
-
-MODULE_DEVICE_TABLE (usb, rio_table);
-
-static struct usb_driver rio_driver = {
-	.name =		"rio500",
-	.probe =	probe_rio,
-	.disconnect =	disconnect_rio,
-	.id_table =	rio_table,
-};
-
-module_usb_driver(rio_driver);
-
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
-MODULE_LICENSE("GPL");
-
diff --git a/drivers/usb/misc/rio500_usb.h b/drivers/usb/misc/rio500_usb.h
deleted file mode 100644
index 6db7a5863496..000000000000
--- a/drivers/usb/misc/rio500_usb.h
+++ /dev/null
@@ -1,20 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*  ----------------------------------------------------------------------
-    Copyright (C) 2000  Cesar Miquel  (miquel@df.uba.ar)
-    ---------------------------------------------------------------------- */
-
-#define RIO_SEND_COMMAND			0x1
-#define RIO_RECV_COMMAND			0x2
-
-#define RIO_DIR_OUT               	        0x0
-#define RIO_DIR_IN				0x1
-
-struct RioCommand {
-	short length;
-	int request;
-	int requesttype;
-	int value;
-	int index;
-	void __user *buffer;
-	int timeout;
-};
-- 
2.23.0


