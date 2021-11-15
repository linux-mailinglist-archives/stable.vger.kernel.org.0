Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D724527A5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243500AbhKPC3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237035AbhKORQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:16:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D1C63246;
        Mon, 15 Nov 2021 17:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996355;
        bh=iW7bRT3Q5oUIXLn4aRaqSRph6rITcwiUaTSvH7ilcwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlFM7GsJ3/1aaayemzBFMLBe9+/mJHsfe7nxRWWmwgb/t32WyXXh+HrLL+7rARNvq
         HQquYzlYfmxfkTbNSFluniq4IBWS9jgQ4KSvDfOVK+xQQN56xKcCQ3D/IurPQNU+ky
         Q80AAG2WtPRaBxzoAkzgYXlRUnGn66Xesq7VHPXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 110/355] USB: iowarrior: fix control-message timeouts
Date:   Mon, 15 Nov 2021 18:00:34 +0100
Message-Id: <20211115165317.364490410@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
@@ -99,10 +99,6 @@ struct iowarrior {
 /*    globals   */
 /*--------------*/
 
-/*
- *  USB spec identifies 5 second timeouts.
- */
-#define GET_TIMEOUT 5
 #define USB_REQ_GET_REPORT  0x01
 //#if 0
 static int usb_get_report(struct usb_device *dev,
@@ -114,7 +110,7 @@ static int usb_get_report(struct usb_dev
 			       USB_DIR_IN | USB_TYPE_CLASS |
 			       USB_RECIP_INTERFACE, (type << 8) + id,
 			       inter->desc.bInterfaceNumber, buf, size,
-			       GET_TIMEOUT*HZ);
+			       USB_CTRL_GET_TIMEOUT);
 }
 //#endif
 
@@ -129,7 +125,7 @@ static int usb_set_report(struct usb_int
 			       USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			       (type << 8) + id,
 			       intf->cur_altsetting->desc.bInterfaceNumber, buf,
-			       size, HZ);
+			       size, 1000);
 }
 
 /*---------------------*/


