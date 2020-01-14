Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2C013A63C
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgANKKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729447AbgANKKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:10:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C47224676;
        Tue, 14 Jan 2020 10:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996619;
        bh=+PI48K9XTvgjwsMAYb2zfC9iKKt9NZ6/WaU3LZy+OyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qT9ZOd+wf8mhLszf5Ur/zsM6adobQE3SMHRvYDRsTxf4zU0jdry4qfOMBSb3ktqD9
         fuMYZPA4lsl3euMDe/jyc/ajfsKwkjHbbEF9oSSy6ZUBRwCr1eIRIvpEeaqjv1s7eq
         uuP8EWfbE+RoS2TDMsv8YP62kugM2S+N327LNsME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Roger Whittaker <Roger.Whittaker@suse.com>
Subject: [PATCH 4.14 35/39] USB: Fix: Dont skip endpoint descriptors with maxpacket=0
Date:   Tue, 14 Jan 2020 11:02:09 +0100
Message-Id: <20200114094346.366822834@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
References: <20200114094336.210038037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 2548288b4fb059b2da9ceada172ef763077e8a59 upstream.

It turns out that even though endpoints with a maxpacket length of 0
aren't useful for data transfer, the descriptors do serve other
purposes.  In particular, skipping them will also skip over other
class-specific descriptors for classes such as UVC.  This unexpected
side effect has caused some UVC cameras to stop working.

In addition, the USB spec requires that when isochronous endpoint
descriptors are present in an interface's altsetting 0 (which is true
on some devices), the maxpacket size _must_ be set to 0.  Warning
about such things seems like a bad idea.

This patch updates an earlier commit which would log a warning and
skip these endpoint descriptors.  Now we only log a warning, and we
don't even do that for isochronous endpoints in altsetting 0.

We don't need to worry about preventing endpoints with maxpacket = 0
from ever being used for data transfers; usb_submit_urb() already
checks for this.

Reported-and-tested-by: Roger Whittaker <Roger.Whittaker@suse.com>
Fixes: d482c7bb0541 ("USB: Skip endpoints with 0 maxpacket length")
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://marc.info/?l=linux-usb&m=157790377329882&w=2
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2001061040270.1514-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/config.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -392,12 +392,16 @@ static int usb_parse_endpoint(struct dev
 			endpoint->desc.wMaxPacketSize = cpu_to_le16(8);
 	}
 
-	/* Validate the wMaxPacketSize field */
+	/*
+	 * Validate the wMaxPacketSize field.
+	 * Some devices have isochronous endpoints in altsetting 0;
+	 * the USB-2 spec requires such endpoints to have wMaxPacketSize = 0
+	 * (see the end of section 5.6.3), so don't warn about them.
+	 */
 	maxp = usb_endpoint_maxp(&endpoint->desc);
-	if (maxp == 0) {
-		dev_warn(ddev, "config %d interface %d altsetting %d endpoint 0x%X has wMaxPacketSize 0, skipping\n",
+	if (maxp == 0 && !(usb_endpoint_xfer_isoc(d) && asnum == 0)) {
+		dev_warn(ddev, "config %d interface %d altsetting %d endpoint 0x%X has invalid wMaxPacketSize 0\n",
 		    cfgno, inum, asnum, d->bEndpointAddress);
-		goto skip_to_next_endpoint_or_interface_descriptor;
 	}
 
 	/* Find the highest legal maxpacket size for this endpoint */


