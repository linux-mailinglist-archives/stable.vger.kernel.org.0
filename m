Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E872D4037
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 11:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgLIKnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 05:43:39 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44303 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgLIKnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 05:43:39 -0500
Received: by mail-lj1-f194.google.com with SMTP id m13so1678571ljo.11;
        Wed, 09 Dec 2020 02:43:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2TWyg17NnUW58DhZ5qDtIXMIaRhd3ro9uofVZ6ZkZRA=;
        b=qGqHJG2dUDv9qYNYLZ8rMQKm7CRemE5UsVML7t4qO5WeEPPdjeBekYg7FJovGEJbiQ
         koV5X3AOQY9ZntZ5h/LOQhFydVoqxG/VvpTngFnoayJPo1ipILIk25TJr85nJkAfv/bN
         78BQ/LtaLnvxbeONPQr9Axfm4sIzFhHs0hBvLakqy+t9omr4c/od2mwQafx5UUz+uvzV
         mZqbMT22XbCHbBnvcFH2k5vxLMThdah/t5y7IgwIilPMlWFEznqxccwkqpdNnmZhe32E
         VnWOluZu0SpuSejAQXASFWjaWsHg4T9gRF8uHjVqzmyCXEGFHXMAMYGsMIlOSu16LMaV
         UJPg==
X-Gm-Message-State: AOAM533VJXQdPO62+RuzsqBR5HHXSLBqYljE5XRUSaWHV/w1Z76dkr+O
        TTJXqQ3Nhm58Anwse7SXxK34d5TmzHkaiw==
X-Google-Smtp-Source: ABdhPJxs81CCMiEa13cgz+Qtuz/KDh/fT5zQvZ/1I1ebTywAqcNnz+Gl7TtU/mIiXFrlrX3U6rJjnQ==
X-Received: by 2002:a2e:584:: with SMTP id 126mr815675ljf.485.1607510576374;
        Wed, 09 Dec 2020 02:42:56 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id g15sm129747lfd.42.2020.12.09.02.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 02:42:55 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kmwwZ-0003SH-Q2; Wed, 09 Dec 2020 11:43:36 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] USB: serial: option: add interface-number sanity check to flag handling
Date:   Wed,  9 Dec 2020 11:42:21 +0100
Message-Id: <20201209104221.13223-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <0000000000004c471e05b60312f9@google.com>
References: <0000000000004c471e05b60312f9@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add an interface-number sanity check before testing the device flags to
avoid relying on undefined behaviour when left shifting in case a device
uses an interface number greater than or equal to BITS_PER_LONG (i.e. 64
or 32).

Reported-by: syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com
Fixes: c3a65808f04a ("USB: serial: option: reimplement interface masking")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/option.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 2a3bfd6f867e..c5908c4f2046 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -561,6 +561,9 @@ static void option_instat_callback(struct urb *urb);
 
 /* Device flags */
 
+/* Highest interface number which can be used with NCTRL() and RSVD() */
+#define FLAG_IFNUM_MAX	7
+
 /* Interface does not support modem-control requests */
 #define NCTRL(ifnum)	((BIT(ifnum) & 0xff) << 8)
 
@@ -2089,6 +2092,14 @@ static struct usb_serial_driver * const serial_drivers[] = {
 
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
@@ -2105,7 +2116,7 @@ static int option_probe(struct usb_serial *serial,
 	 * the same class/subclass/protocol as the serial interfaces.  Look at
 	 * the Windows driver .INF files for reserved interface numbers.
 	 */
-	if (device_flags & RSVD(iface_desc->bInterfaceNumber))
+	if (iface_is_reserved(device_flags, iface_desc->bInterfaceNumber))
 		return -ENODEV;
 
 	/*
@@ -2121,6 +2132,14 @@ static int option_probe(struct usb_serial *serial,
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
@@ -2136,7 +2155,7 @@ static int option_attach(struct usb_serial *serial)
 
 	iface_desc = &serial->interface->cur_altsetting->desc;
 
-	if (!(device_flags & NCTRL(iface_desc->bInterfaceNumber)))
+	if (!iface_no_modem_control(device_flags, iface_desc->bInterfaceNumber))
 		data->use_send_setup = 1;
 
 	if (device_flags & ZLP)
-- 
2.26.2

