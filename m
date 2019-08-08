Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DE4869ED
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405395AbfHHTK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405398AbfHHTK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:10:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 453E3214C6;
        Thu,  8 Aug 2019 19:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291457;
        bh=3utsidPywQwbBISYQFaw+ixCRRG1nbJWVSopK7tycjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0Y/f3W5v0hDYyENxZE8BWccY4kLYE2dYhOaq6bewe1Xx8VkGaTpi7BQagupqqn9u
         W5w3ubdc9Ok45NwrOxVOwdX9Y/8z7SmSwJiKEUdcMmoiglD+rFnsrcA8CaVR98HtAO
         lhkA5PEb+RbAriDen6FlWDFzm3SHv7Mzedd29/l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 21/33] NFC: nfcmrvl: fix gpio-handling regression
Date:   Thu,  8 Aug 2019 21:05:28 +0200
Message-Id: <20190808190454.661075725@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit c3953a3c2d3175d2f9f0304c9a1ba89e7743c5e4 ]

Fix two reset-gpio sanity checks which were never converted to use
gpio_is_valid(), and make sure to use -EINVAL to indicate a missing
reset line also for the UART-driver module parameter and for the USB
driver.

This specifically prevents the UART and USB drivers from incidentally
trying to request and use gpio 0, and also avoids triggering a WARN() in
gpio_to_desc() during probe when no valid reset line has been specified.

Fixes: e33a3f84f88f ("NFC: nfcmrvl: allow gpio 0 for reset signalling")
Reported-by: syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com
Tested-by: syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/nfcmrvl/main.c |    4 ++--
 drivers/nfc/nfcmrvl/uart.c |    4 ++--
 drivers/nfc/nfcmrvl/usb.c  |    1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -244,7 +244,7 @@ void nfcmrvl_chip_reset(struct nfcmrvl_p
 	/* Reset possible fault of previous session */
 	clear_bit(NFCMRVL_PHY_ERROR, &priv->flags);
 
-	if (priv->config.reset_n_io) {
+	if (gpio_is_valid(priv->config.reset_n_io)) {
 		nfc_info(priv->dev, "reset the chip\n");
 		gpio_set_value(priv->config.reset_n_io, 0);
 		usleep_range(5000, 10000);
@@ -255,7 +255,7 @@ void nfcmrvl_chip_reset(struct nfcmrvl_p
 
 void nfcmrvl_chip_halt(struct nfcmrvl_private *priv)
 {
-	if (priv->config.reset_n_io)
+	if (gpio_is_valid(priv->config.reset_n_io))
 		gpio_set_value(priv->config.reset_n_io, 0);
 }
 
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -26,7 +26,7 @@
 static unsigned int hci_muxed;
 static unsigned int flow_control;
 static unsigned int break_control;
-static unsigned int reset_n_io;
+static int reset_n_io = -EINVAL;
 
 /*
 ** NFCMRVL NCI OPS
@@ -231,5 +231,5 @@ MODULE_PARM_DESC(break_control, "Tell if
 module_param(hci_muxed, uint, 0);
 MODULE_PARM_DESC(hci_muxed, "Tell if transport is muxed in HCI one.");
 
-module_param(reset_n_io, uint, 0);
+module_param(reset_n_io, int, 0);
 MODULE_PARM_DESC(reset_n_io, "GPIO that is wired to RESET_N signal.");
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -304,6 +304,7 @@ static int nfcmrvl_probe(struct usb_inte
 
 	/* No configuration for USB */
 	memset(&config, 0, sizeof(config));
+	config.reset_n_io = -EINVAL;
 
 	nfc_info(&udev->dev, "intf %p id %p\n", intf, id);
 


