Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FB03B3CFA
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 09:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFYHEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 03:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhFYHEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 03:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70BE861413;
        Fri, 25 Jun 2021 07:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624604544;
        bh=GWAF0uxhzJ12w10AjVK8uvbhiLiFVusKJLwbsI6QWnc=;
        h=Subject:To:From:Date:From;
        b=Xu4xlzVpd+ui/x2WWx4wVhKSNWtBBFpDuyVgRtMLxS0tNXdN6pKVO3MhYnlnbGIlb
         8swx+4aozTvLXUatrqMccRTNKGDj5mxq7HbtVqlFLDvJA1jT54ov8/UJbloeAqYjxf
         hMtC0JYumeku+/en1XGvGY0dc1W2UEz1xRS7O5gU=
Subject: patch "USB: cdc-acm: blacklist Heimann USB Appset device" added to usb-next
To:     hannu@hrtk.in, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Jun 2021 09:00:58 +0200
Message-ID: <1624604458224196@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


