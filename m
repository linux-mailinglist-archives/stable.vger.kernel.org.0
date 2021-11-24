Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F0145BCFB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245594AbhKXMef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244677AbhKXMc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:32:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51B6D611BF;
        Wed, 24 Nov 2021 12:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756404;
        bh=J7R4Nebviss+8nipBfjO2GZErgKBnu2J7kiCeUlPvL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=te6kb+gLGrIw8GVqdi2ZMXjCmb0vwdV4HCeVFQl1YcKRAQLt9Kyq6IoRBMe4e9hlN
         fuw64R7xxOLp+NiGVIRDOhKepaL7lKDveEHWaGL7i79EoX9PfMJeZ7Fg+UaDnEjPei
         R/zKtToURSVwmBcxAp7N4e6e/2RFWZBgqv3CigWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 067/251] USB: iowarrior: fix control-message timeouts
Date:   Wed, 24 Nov 2021 12:55:09 +0100
Message-Id: <20211124115712.574322277@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 79a4479a17b83310deb0b1a2a274fe5be12d2318 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout define for the five-second
timeout and drop the driver-specific one.

Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Cc: stable@vger.kernel.org      # 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211025115159.4954-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -103,10 +103,6 @@ struct iowarrior {
 /*    globals   */
 /*--------------*/
 
-/*
- *  USB spec identifies 5 second timeouts.
- */
-#define GET_TIMEOUT 5
 #define USB_REQ_GET_REPORT  0x01
 //#if 0
 static int usb_get_report(struct usb_device *dev,
@@ -118,7 +114,7 @@ static int usb_get_report(struct usb_dev
 			       USB_DIR_IN | USB_TYPE_CLASS |
 			       USB_RECIP_INTERFACE, (type << 8) + id,
 			       inter->desc.bInterfaceNumber, buf, size,
-			       GET_TIMEOUT*HZ);
+			       USB_CTRL_GET_TIMEOUT);
 }
 //#endif
 
@@ -133,7 +129,7 @@ static int usb_set_report(struct usb_int
 			       USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			       (type << 8) + id,
 			       intf->cur_altsetting->desc.bInterfaceNumber, buf,
-			       size, HZ);
+			       size, 1000);
 }
 
 /*---------------------*/


