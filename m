Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470BA2E6888
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgL1NAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbgL1NAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2FE9208D5;
        Mon, 28 Dec 2020 12:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160391;
        bh=qR99icXdOK7HuB957VYZGa+83XTQNyl3hqtIOgs/ch4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJsIB5Yraq0xiSOncBHRgBFDh3gBd0b/drN5u2MTv3N4S1hKcNH8oHZwozPUsWr3W
         EPgV7Cmt/oPfo6Cdj71Muiw7l0lVu25+fjr/E3mZZNqeUM8UO5npmHtoxTNzVAbCRJ
         9FWNLXP7nyv/K16qzuv3dF6sCo1WK1EMdry2WiCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 036/175] USB: serial: option: add interface-number sanity check to flag handling
Date:   Mon, 28 Dec 2020 13:48:09 +0100
Message-Id: <20201228124854.993702994@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a251963f76fa0226d0fdf0c4f989496f18d9ae7f upstream.

Add an interface-number sanity check before testing the device flags to
avoid relying on undefined behaviour when left shifting in case a device
uses an interface number greater than or equal to BITS_PER_LONG (i.e. 64
or 32).

Reported-by: syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com
Fixes: c3a65808f04a ("USB: serial: option: reimplement interface masking")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -563,6 +563,9 @@ static void option_instat_callback(struc
 
 /* Device flags */
 
+/* Highest interface number which can be used with NCTRL() and RSVD() */
+#define FLAG_IFNUM_MAX	7
+
 /* Interface does not support modem-control requests */
 #define NCTRL(ifnum)	((BIT(ifnum) & 0xff) << 8)
 
@@ -2086,6 +2089,14 @@ static struct usb_serial_driver * const
 
 module_usb_serial_driver(serial_drivers, option_ids);
 
+static bool iface_is_reserved(unsigned long device_flags, u8 ifnum)
+{
+	if (ifnum > FLAG_IFNUM_MAX)
+		return false;
+
+	return device_flags & RSVD(ifnum);
+}
+
 static int option_probe(struct usb_serial *serial,
 			const struct usb_device_id *id)
 {
@@ -2103,7 +2114,7 @@ static int option_probe(struct usb_seria
 	 * the same class/subclass/protocol as the serial interfaces.  Look at
 	 * the Windows driver .INF files for reserved interface numbers.
 	 */
-	if (device_flags & RSVD(iface_desc->bInterfaceNumber))
+	if (iface_is_reserved(device_flags, iface_desc->bInterfaceNumber))
 		return -ENODEV;
 	/*
 	 * Don't bind network interface on Samsung GT-B3730, it is handled by
@@ -2120,6 +2131,14 @@ static int option_probe(struct usb_seria
 	return 0;
 }
 
+static bool iface_no_modem_control(unsigned long device_flags, u8 ifnum)
+{
+	if (ifnum > FLAG_IFNUM_MAX)
+		return false;
+
+	return device_flags & NCTRL(ifnum);
+}
+
 static int option_attach(struct usb_serial *serial)
 {
 	struct usb_interface_descriptor *iface_desc;
@@ -2135,7 +2154,7 @@ static int option_attach(struct usb_seri
 
 	iface_desc = &serial->interface->cur_altsetting->desc;
 
-	if (!(device_flags & NCTRL(iface_desc->bInterfaceNumber)))
+	if (!iface_no_modem_control(device_flags, iface_desc->bInterfaceNumber))
 		data->use_send_setup = 1;
 
 	if (device_flags & ZLP)


