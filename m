Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB81119B2B6
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389693AbgDAQqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389704AbgDAQqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:46:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 892E52063A;
        Wed,  1 Apr 2020 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759589;
        bh=q8ZsOnGtELYqLjvv1D7JOC+mmwvjB+KAtZ0LjT4MxYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+yDk0SoETHeOPVsI6qHaEzcq01gUoS1jgfnkB+6JrkS3ksKzHuncf+5CR+sKIoF2
         3luZbXgFfOBrKu5xQNd9RU7KBgdmoVMJbhLLrmnZ87LFg5Pcszh33L+2bC7nbapbie
         hpdmU150wlgj2osC9NrKBqVS225J6VfuLELo8JSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 128/148] media: stv06xx: add missing descriptor sanity checks
Date:   Wed,  1 Apr 2020 18:18:40 +0200
Message-Id: <20200401161604.670990661@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 485b06aadb933190f4bc44e006076bc27a23f205 upstream.

Make sure to check that we have two alternate settings and at least one
endpoint before accessing the second altsetting structure and
dereferencing the endpoint arrays.

This specifically avoids dereferencing NULL-pointers or corrupting
memory when a device does not have the expected descriptors.

Note that the sanity checks in stv06xx_start() and pb0100_start() are
not redundant as the driver is mixing looking up altsettings by index
and by number, which may not coincide.

Fixes: 8668d504d72c ("V4L/DVB (12082): gspca_stv06xx: Add support for st6422 bridge and sensor")
Fixes: c0b33bdc5b8d ("[media] gspca-stv06xx: support bandwidth changing")
Cc: stable <stable@vger.kernel.org>     # 2.6.31
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/stv06xx/stv06xx.c        |   19 ++++++++++++++++++-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c |    4 ++++
 2 files changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -289,6 +289,9 @@ static int stv06xx_start(struct gspca_de
 		return -EIO;
 	}
 
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	err = stv06xx_write_bridge(sd, STV_ISO_SIZE_L, packet_size);
 	if (err < 0)
@@ -313,11 +316,21 @@ out:
 
 static int stv06xx_isoc_init(struct gspca_dev *gspca_dev)
 {
+	struct usb_interface_cache *intfc;
 	struct usb_host_interface *alt;
 	struct sd *sd = (struct sd *) gspca_dev;
 
+	intfc = gspca_dev->dev->actconfig->intf_cache[0];
+
+	if (intfc->num_altsetting < 2)
+		return -ENODEV;
+
+	alt = &intfc->altsetting[1];
+
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	/* Start isoc bandwidth "negotiation" at max isoc bandwidth */
-	alt = &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	alt->endpoint[0].desc.wMaxPacketSize =
 		cpu_to_le16(sd->sensor->max_packet_size[gspca_dev->curr_mode]);
 
@@ -330,6 +343,10 @@ static int stv06xx_isoc_nego(struct gspc
 	struct usb_host_interface *alt;
 	struct sd *sd = (struct sd *) gspca_dev;
 
+	/*
+	 * Existence of altsetting and endpoint was verified in
+	 * stv06xx_isoc_init()
+	 */
 	alt = &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	min_packet_size = sd->sensor->min_packet_size[gspca_dev->curr_mode];
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
@@ -194,6 +194,10 @@ static int pb0100_start(struct sd *sd)
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt)
 		return -ENODEV;
+
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 
 	/* If we don't have enough bandwidth use a lower framerate */


