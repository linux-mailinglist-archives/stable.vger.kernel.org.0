Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CFE1B67C1
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgDWXJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:09:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50912 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728657AbgDWXG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004yp-E1; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvh-00E72j-Nc; Fri, 24 Apr 2020 00:06:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Fri, 24 Apr 2020 00:07:36 +0100
Message-ID: <lsq.1587683028.485506508@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 229/245] media: xirlink_cit: add missing descriptor
 sanity checks
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit a246b4d547708f33ff4d4b9a7a5dbac741dc89d8 upstream.

Make sure to check that we have two alternate settings and at least one
endpoint before accessing the second altsetting structure and
dereferencing the endpoint arrays.

This specifically avoids dereferencing NULL-pointers or corrupting
memory when a device does not have the expected descriptors.

Note that the sanity check in cit_get_packet_size() is not redundant as
the driver is mixing looking up altsettings by index and by number,
which may not coincide.

Fixes: 659fefa0eb17 ("V4L/DVB: gspca_xirlink_cit: Add support for camera with a bcd version of 0.01")
Fixes: 59f8b0bf3c12 ("V4L/DVB: gspca_xirlink_cit: support bandwidth changing for devices with 1 alt setting")
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/gspca/xirlink_cit.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -1455,6 +1455,9 @@ static int cit_get_packet_size(struct gs
 		return -EIO;
 	}
 
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	return le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 }
 
@@ -2632,6 +2635,7 @@ static int sd_start(struct gspca_dev *gs
 
 static int sd_isoc_init(struct gspca_dev *gspca_dev)
 {
+	struct usb_interface_cache *intfc;
 	struct usb_host_interface *alt;
 	int max_packet_size;
 
@@ -2647,8 +2651,17 @@ static int sd_isoc_init(struct gspca_dev
 		break;
 	}
 
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
 	alt->endpoint[0].desc.wMaxPacketSize = cpu_to_le16(max_packet_size);
 
 	return 0;
@@ -2671,6 +2684,9 @@ static int sd_isoc_nego(struct gspca_dev
 		break;
 	}
 
+	/*
+	 * Existence of altsetting and endpoint was verified in sd_isoc_init()
+	 */
 	alt = &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	if (packet_size <= min_packet_size)

