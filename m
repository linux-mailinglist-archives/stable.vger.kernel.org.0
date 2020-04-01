Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD41319B2B8
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389951AbgDAQqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389775AbgDAQqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:46:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C4520705;
        Wed,  1 Apr 2020 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759592;
        bh=BDRnxjkLLGl0cAzOYdMWTic/foUoSslUvI3pJfjCOQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2C5vV+szXHv1ykryvGSCfDtiYcWSM7zLEhzR8y0ZY3ITx38W+k5AsztFvvlpl8R2
         U4JCmmb3pB3bvFJxhMSwJ2aTbyKm1/EK+0cSriqhsqVngxsadp3q+SCNk/Rz9KbV9b
         MNbx0De3MqssIBT9IpBaCf6joJdlLoaYEHUQXgK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 129/148] media: xirlink_cit: add missing descriptor sanity checks
Date:   Wed,  1 Apr 2020 18:18:41 +0200
Message-Id: <20200401161604.758832162@linuxfoundation.org>
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
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/xirlink_cit.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -1451,6 +1451,9 @@ static int cit_get_packet_size(struct gs
 		return -EIO;
 	}
 
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	return le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 }
 
@@ -2634,6 +2637,7 @@ static int sd_start(struct gspca_dev *gs
 
 static int sd_isoc_init(struct gspca_dev *gspca_dev)
 {
+	struct usb_interface_cache *intfc;
 	struct usb_host_interface *alt;
 	int max_packet_size;
 
@@ -2649,8 +2653,17 @@ static int sd_isoc_init(struct gspca_dev
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
@@ -2673,6 +2686,9 @@ static int sd_isoc_nego(struct gspca_dev
 		break;
 	}
 
+	/*
+	 * Existence of altsetting and endpoint was verified in sd_isoc_init()
+	 */
 	alt = &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	if (packet_size <= min_packet_size)


