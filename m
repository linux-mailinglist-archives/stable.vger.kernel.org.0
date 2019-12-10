Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE61187E2
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 13:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfLJMQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 07:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfLJMQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 07:16:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 758C22073D;
        Tue, 10 Dec 2019 12:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575980206;
        bh=Uc+HmONTN/KIG9LB94gmY6/KtInNZ1ywDkVAEzX7Cwo=;
        h=Subject:To:From:Date:From;
        b=EH/wbZqHLOXq6jMzwpeWEqcB3C6gXLjTDAScLyVcDSgUK8DfrmBLT3kl/opRZlDbb
         4Nx6fBJX0s0r7d+bFkI4SIc5rT436Ue0gNQ1w9xR0jm4uNKu2DYnghY517TaH/zMdU
         2MPQTd6JZOv7MOPs67Rmkfkg1+iYzIoWXfFHl9mk=
Subject: patch "USB: serial: io_edgeport: fix epic endpoint lookup" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 13:16:43 +0100
Message-ID: <1575980203167102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: io_edgeport: fix epic endpoint lookup

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7c5a2df3367a2c4984f1300261345817d95b71f8 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 10 Dec 2019 12:26:01 +0100
Subject: USB: serial: io_edgeport: fix epic endpoint lookup

Make sure to use the current alternate setting when looking up the
endpoints on epic devices to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 6e8cf7751f9f ("USB: add EPIC support to the io_edgeport driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210112601.3561-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 48a439298a68..9690a5f4b9d6 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2901,16 +2901,18 @@ static int edge_startup(struct usb_serial *serial)
 	response = 0;
 
 	if (edge_serial->is_epic) {
+		struct usb_host_interface *alt;
+
+		alt = serial->interface->cur_altsetting;
+
 		/* EPIC thing, set up our interrupt polling now and our read
 		 * urb, so that the device knows it really is connected. */
 		interrupt_in_found = bulk_in_found = bulk_out_found = false;
-		for (i = 0; i < serial->interface->altsetting[0]
-						.desc.bNumEndpoints; ++i) {
+		for (i = 0; i < alt->desc.bNumEndpoints; ++i) {
 			struct usb_endpoint_descriptor *endpoint;
 			int buffer_size;
 
-			endpoint = &serial->interface->altsetting[0].
-							endpoint[i].desc;
+			endpoint = &alt->endpoint[i].desc;
 			buffer_size = usb_endpoint_maxp(endpoint);
 			if (!interrupt_in_found &&
 			    (usb_endpoint_is_int_in(endpoint))) {
-- 
2.24.0


