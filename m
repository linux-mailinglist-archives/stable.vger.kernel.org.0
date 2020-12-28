Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAAF2E6638
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388455AbgL1NXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387639AbgL1NXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24E67206ED;
        Mon, 28 Dec 2020 13:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161778;
        bh=dh1QcVDrB5waoPZzSjsgOaEidFcBQFFUDRUV/K0lodc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRO6Eir/ySRsrN3LXUaF1Yx6ctvXKTc8xmOYX3Aa4Vuwc+JgGW+BnafwcilEQ5KyU
         T7maddC5d6ZPGYZs1KdVJqdssc3iOOh+CnpCAowvPA/HYry3V6F1hAVFO0K/rhONeg
         ZsVTo/0JLPFcFsrdt0fZavrV7LJBOmbeA38UAAzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 078/346] USB: serial: option: add interface-number sanity check to flag handling
Date:   Mon, 28 Dec 2020 13:46:37 +0100
Message-Id: <20201228124923.571043745@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
 
@@ -2100,6 +2103,14 @@ static struct usb_serial_driver * const
 
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
@@ -2116,7 +2127,7 @@ static int option_probe(struct usb_seria
 	 * the same class/subclass/protocol as the serial interfaces.  Look at
 	 * the Windows driver .INF files for reserved interface numbers.
 	 */
-	if (device_flags & RSVD(iface_desc->bInterfaceNumber))
+	if (iface_is_reserved(device_flags, iface_desc->bInterfaceNumber))
 		return -ENODEV;
 
 	/*
@@ -2132,6 +2143,14 @@ static int option_probe(struct usb_seria
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
@@ -2147,7 +2166,7 @@ static int option_attach(struct usb_seri
 
 	iface_desc = &serial->interface->cur_altsetting->desc;
 
-	if (!(device_flags & NCTRL(iface_desc->bInterfaceNumber)))
+	if (!iface_no_modem_control(device_flags, iface_desc->bInterfaceNumber))
 		data->use_send_setup = 1;
 
 	if (device_flags & ZLP)


