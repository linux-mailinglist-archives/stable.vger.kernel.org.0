Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3182E1E26
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgLWPfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbgLWPep (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED20D23355;
        Wed, 23 Dec 2020 15:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737618;
        bh=tBsx2KdAvoC5HYiI6USyasBd4jn2kMi3TDAdAjnRUV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNMHhPpOslFSAfx63akIz0MpxeoFzBxMYOE7bAC6A0mY4dlq2AjzgSbLXtseMqwpB
         kUiwvVUj7LSbiVzhjfr2/W76dtt0GpvwNCJ9tv1eJma1myJjYT2BGcpXp3cyfss61W
         qWwJMZWobH9HMsA+xs3ROKduh1+XTGu2mm0kCOMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 06/40] USB: serial: option: add interface-number sanity check to flag handling
Date:   Wed, 23 Dec 2020 16:33:07 +0100
Message-Id: <20201223150515.874644556@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
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
 
@@ -2101,6 +2104,14 @@ static struct usb_serial_driver * const
 
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
@@ -2117,7 +2128,7 @@ static int option_probe(struct usb_seria
 	 * the same class/subclass/protocol as the serial interfaces.  Look at
 	 * the Windows driver .INF files for reserved interface numbers.
 	 */
-	if (device_flags & RSVD(iface_desc->bInterfaceNumber))
+	if (iface_is_reserved(device_flags, iface_desc->bInterfaceNumber))
 		return -ENODEV;
 
 	/*
@@ -2133,6 +2144,14 @@ static int option_probe(struct usb_seria
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
@@ -2148,7 +2167,7 @@ static int option_attach(struct usb_seri
 
 	iface_desc = &serial->interface->cur_altsetting->desc;
 
-	if (!(device_flags & NCTRL(iface_desc->bInterfaceNumber)))
+	if (!iface_no_modem_control(device_flags, iface_desc->bInterfaceNumber))
 		data->use_send_setup = 1;
 
 	if (device_flags & ZLP)


