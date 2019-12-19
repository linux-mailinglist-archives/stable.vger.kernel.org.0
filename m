Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8397F126DA4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbfLSSig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbfLSSif (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:38:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F0C520716;
        Thu, 19 Dec 2019 18:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780715;
        bh=Q6IPlbKphm9Ek82Zr/DSnj+WRQWNrsOn12LL6QQn+jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpNmaAAsqM5KlBV6lELPndJm3JhhzVPRim32y6PIZw227/fF8ZbdFQCxmQa2h5w7e
         0oCtUERRiHw62bWmoIk66xYxaVB46PR2vwPqyroMwMl6cNrqPneMsdkmg+JxJVuaI2
         8CbiCCnolSlPsjWYxd5qQqdSLHy9u4HF1y/uqnbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 088/162] staging: gigaset: add endpoint-type sanity check
Date:   Thu, 19 Dec 2019 19:33:16 +0100
Message-Id: <20191219183213.149856717@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ed9ed5a89acba51b82bdff61144d4e4a4245ec8a upstream.

Add missing endpoint-type sanity checks to probe.

This specifically prevents a warning in USB core on URB submission when
fuzzing USB descriptors.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191202085610.12719-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/isdn/gigaset/usb-gigaset.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -708,6 +708,12 @@ static int gigaset_probe(struct usb_inte
 
 	endpoint = &hostif->endpoint[0].desc;
 
+	if (!usb_endpoint_is_bulk_out(endpoint)) {
+		dev_err(&interface->dev, "missing bulk-out endpoint\n");
+		retval = -ENODEV;
+		goto error;
+	}
+
 	buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 	ucs->bulk_out_size = buffer_size;
 	ucs->bulk_out_epnum = usb_endpoint_num(endpoint);
@@ -727,6 +733,12 @@ static int gigaset_probe(struct usb_inte
 
 	endpoint = &hostif->endpoint[1].desc;
 
+	if (!usb_endpoint_is_int_in(endpoint)) {
+		dev_err(&interface->dev, "missing int-in endpoint\n");
+		retval = -ENODEV;
+		goto error;
+	}
+
 	ucs->busy = 0;
 
 	ucs->read_urb = usb_alloc_urb(0, GFP_KERNEL);


