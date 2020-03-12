Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF7B183625
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 17:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgCLQ2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 12:28:25 -0400
Received: from www.linuxtv.org ([130.149.80.248]:45826 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbgCLQ2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 12:28:25 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jCQf6-00CCio-Vn; Thu, 12 Mar 2020 16:26:20 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 12 Mar 2020 16:26:42 +0000
Subject: [git:media_tree/master] media: stv06xx: add missing descriptor sanity checks
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Johan Hovold <johan@kernel.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jCQf6-00CCio-Vn@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: stv06xx: add missing descriptor sanity checks
Author:  Johan Hovold <johan@kernel.org>
Date:    Fri Jan 3 17:35:10 2020 +0100

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

 drivers/media/usb/gspca/stv06xx/stv06xx.c        | 19 ++++++++++++++++++-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c |  4 ++++
 2 files changed, 22 insertions(+), 1 deletion(-)

---

diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index 79653d409951..95673fc0a99c 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -282,6 +282,9 @@ static int stv06xx_start(struct gspca_dev *gspca_dev)
 		return -EIO;
 	}
 
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	err = stv06xx_write_bridge(sd, STV_ISO_SIZE_L, packet_size);
 	if (err < 0)
@@ -306,11 +309,21 @@ out:
 
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
 
@@ -323,6 +336,10 @@ static int stv06xx_isoc_nego(struct gspca_dev *gspca_dev)
 	struct usb_host_interface *alt;
 	struct sd *sd = (struct sd *) gspca_dev;
 
+	/*
+	 * Existence of altsetting and endpoint was verified in
+	 * stv06xx_isoc_init()
+	 */
 	alt = &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	min_packet_size = sd->sensor->min_packet_size[gspca_dev->curr_mode];
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
index 6d1007715ff7..ae382b3b5f7f 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
@@ -185,6 +185,10 @@ static int pb0100_start(struct sd *sd)
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt)
 		return -ENODEV;
+
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 
 	/* If we don't have enough bandwidth use a lower framerate */
