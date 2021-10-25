Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673CC439546
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhJYLyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229704AbhJYLyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E59D660F46;
        Mon, 25 Oct 2021 11:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162744;
        bh=erij8O9V4iK0XPCjra19lOi8jI0hAW7huw4GIocOO80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmrkYYdbW1Jow2nv08jTazOX7hxL1Q2oXGeKM3c9xoRJTYO9hiiJwb8bUpGhCJwOG
         GSqKfm7AGpABcRHGuVzYDWopnnyMSBhI3cZSkpK/UT3GiuCOMpIPZdUADXyBaq5yuo
         GPrgnGa7i8gAYzg57GzB7QRogeaYb1W/FO7xdKy7OTk0m9Tf66VCdZHndreHnz7u9H
         z8gOSwEqQ3brNmeW23uKEgi2VJmXMkg+yReaPMfX+519eLgVB31Gwok2WexGyvV+AK
         byayhiqpSO9LtO+SaEkistLM5qtp6Q+EYqh6OZJsW9R0ESsomlkWmOGkCmUzHxCifO
         NYUylBkfR1lYA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyWN-0001Io-Rh; Mon, 25 Oct 2021 13:52:07 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] USB: iowarrior: fix control-message timeouts
Date:   Mon, 25 Oct 2021 13:51:59 +0200
Message-Id: <20211025115159.4954-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025115159.4954-1-johan@kernel.org>
References: <20211025115159.4954-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout define for the five-second
timeout and drop the driver-specific one.

Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Cc: stable@vger.kernel.org      # 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/iowarrior.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index efbd317f2f25..988a8c02e7e2 100644
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
@@ -114,7 +110,7 @@ static int usb_get_report(struct usb_device *dev,
 			       USB_DIR_IN | USB_TYPE_CLASS |
 			       USB_RECIP_INTERFACE, (type << 8) + id,
 			       inter->desc.bInterfaceNumber, buf, size,
-			       GET_TIMEOUT*HZ);
+			       USB_CTRL_GET_TIMEOUT);
 }
 //#endif
 
@@ -129,7 +125,7 @@ static int usb_set_report(struct usb_interface *intf, unsigned char type,
 			       USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			       (type << 8) + id,
 			       intf->cur_altsetting->desc.bInterfaceNumber, buf,
-			       size, HZ);
+			       size, 1000);
 }
 
 /*---------------------*/
-- 
2.32.0

