Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF263B2EFE
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhFXMeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 08:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231602AbhFXMdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 08:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36755613B1;
        Thu, 24 Jun 2021 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624537885;
        bh=bt0JaCPfTm/lo/z8VXkujnzTeMbxkpE9bIDrPBdCPiw=;
        h=Subject:To:From:Date:From;
        b=j5yjgtG6+I9fr8k+fcsvQMdnjKPyxeg9MwGRMjD1s4ee7RaWUh7nQExT6GYXSyEfJ
         EPUZS1xMcytb6+dud+xYhf7+LK+/Xzs99PsBKNTCNnbpUt/gTdiaZ96Vn72UWTQ5F2
         PYpDDwuL7UsV77kwPDzZNX+2Rs5cF5TDZb6GJkQA=
Subject: patch "USB: cdc-acm: blacklist Heimann USB Appset device" added to usb-testing
To:     hannu@hrtk.in, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 24 Jun 2021 14:31:23 +0200
Message-ID: <162453788321726@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: cdc-acm: blacklist Heimann USB Appset device

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 4897807753e078655a78de39ed76044d784f3e63 Mon Sep 17 00:00:00 2001
From: Hannu Hartikainen <hannu@hrtk.in>
Date: Tue, 22 Jun 2021 17:14:54 +0300
Subject: USB: cdc-acm: blacklist Heimann USB Appset device

The device (32a7:0000 Heimann Sensor GmbH USB appset demo) claims to be
a CDC-ACM device in its descriptors but in fact is not. If it is run
with echo disabled it returns garbled data, probably due to something
that happens in the TTY layer. And when run with echo enabled (the
default), it will mess up the calibration data of the sensor the first
time any data is sent to the device.

In short, I had a bad time after connecting the sensor and trying to get
it to work. I hope blacklisting it in the cdc-acm driver will save
someone else a bit of trouble.

Signed-off-by: Hannu Hartikainen <hannu@hrtk.in>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210622141454.337948-1-hannu@hrtk.in
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ca7a61190dd9..d50b606d09aa 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1959,6 +1959,11 @@ static const struct usb_device_id acm_ids[] = {
 	.driver_info = IGNORE_DEVICE,
 	},
 
+	/* Exclude Heimann Sensor GmbH USB appset demo */
+	{ USB_DEVICE(0x32a7, 0x0000),
+	.driver_info = IGNORE_DEVICE,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },
-- 
2.32.0


