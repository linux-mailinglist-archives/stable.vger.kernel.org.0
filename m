Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D43121817
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbfLPSCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbfLPSCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:02:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E506E207FF;
        Mon, 16 Dec 2019 18:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519333;
        bh=e2UyM+TXay0wzQ4sGvv+pApzuAUzU5AJTyWnsr4Udis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVDDyBjPjS3Wkgu2dGWEp/F5zboq6DOg8WuFz6f6+1QRU5YzlhI17fEee2QYgJ8A0
         tb0jCp2vYtQovJpNPZKS1HfEjGsKOxWkRRdQ8y4K1MRHkyOWNjQrjRBb/ud0Ma3Y5a
         W8KjewWTx1c2PbVC/dSjbAawj95oT2sSLi6zNH4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 024/140] USB: serial: io_edgeport: fix epic endpoint lookup
Date:   Mon, 16 Dec 2019 18:48:12 +0100
Message-Id: <20191216174756.811284228@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 7c5a2df3367a2c4984f1300261345817d95b71f8 upstream.

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
 drivers/usb/serial/io_edgeport.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2919,16 +2919,18 @@ static int edge_startup(struct usb_seria
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


