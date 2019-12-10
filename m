Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A7118635
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfLJL0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:26:23 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36546 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbfLJL0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:26:23 -0500
Received: by mail-lf1-f68.google.com with SMTP id n12so13421832lfe.3;
        Tue, 10 Dec 2019 03:26:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vd4nd1Up2bQ7tpU0JXm2a/RtBZNBipYvR1ZZpNdym4w=;
        b=a9cEIIKLHw8Nzg8/YHBnEWizU/S4GkSiGBm7x+V6GYAXTGv2R7X0EB/ERWf04BswXC
         OE7lpfEoO9jXf4LfA3DA+REi2Ew/MB6PH2TR6/WDHa+3JiRF2YoY4osFhHxGe8xDpji3
         xx9jgBg/S6t9YCmfqhBcjBNXTynhLq6qYLj8bgfV/C/7XVCxPaDC32R+aY7pI+8RF1/t
         ueXSxNO4oytmIa3vM09jUbFHxoyoLbuYTdFt27xoxoUUKZpMa7PbgfE83djGBCxFtOul
         exkElJfBkJU49so0HtbUtbG5Of8r1H0qxn/Jcfjj4mNlCxPQBIDOpBCGj5csESY8X37H
         /IbA==
X-Gm-Message-State: APjAAAWIinDiwoHEHEdMm7WgL82ix73kUsepgz3ZNNrYj+fxgvgI/3Md
        FTeBN6esilzWM8AKjPKY6Xg=
X-Google-Smtp-Source: APXvYqw61tI0RVbb+poLLhSndu5+FNHIJU4U3zCufXWLVUrSKyQBIPhU4AtxWwjAaaVsNFt2zVW9Cw==
X-Received: by 2002:ac2:57cc:: with SMTP id k12mr4594540lfo.36.1575977181055;
        Tue, 10 Dec 2019 03:26:21 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id y7sm1392094lfe.7.2019.12.10.03.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:26:20 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedem-0000wf-S2; Tue, 10 Dec 2019 12:26:20 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 4/4] USB: serial: io_edgeport: fix epic endpoint lookup
Date:   Tue, 10 Dec 2019 12:26:01 +0100
Message-Id: <20191210112601.3561-5-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210112601.3561-1-johan@kernel.org>
References: <20191210112601.3561-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to use the current alternate setting when looking up the
endpoints on epic devices to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 6e8cf7751f9f ("USB: add EPIC support to the io_edgeport driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
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

