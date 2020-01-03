Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D0812FA98
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 17:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgACQfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 11:35:36 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45707 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgACQfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 11:35:34 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so32158587lfa.12;
        Fri, 03 Jan 2020 08:35:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XMpeSMQqCmVMBjs6tekc+S1FNP6LOEYLPDRMzZL0Udw=;
        b=YI+M4AVbCcye0GMaWkhFa0GymmOkGJVJ5lquQDxd9uHVbIzEBTH5kvzfWTEKcN3hFc
         dMxCcMts/qc1JlMfPn0+cWnxbYUDop9sfNvSYLoI/MpgIbcDRP8cwZOe5uQEbyJTjJ5b
         tb+Cf3AR+2dZmLjU5gzELHLmvV7jsV9tBL2VA3ShVwD9IsL4MRiI62X0LZkNNY0oxUgt
         rfgcLYkfYcEUEFQgAdkIplB/apq4GAHskZLMeH1otSE1P3Is4cUJYvE443zrxYG9CNYs
         QSg83Lau34D58lDNZOTYsTkFJAS6s510nwpz/9MIk1A9Rmx0ZFkg/1OOWUGwVqbn0GhK
         Th6Q==
X-Gm-Message-State: APjAAAUT5XjyBQHyw+W1/zdRvKd3gxb8H3rFSvfAUA/uQLBzoyUB/gLC
        8jdu7HDDRI3Zblef0sSB+ukluify
X-Google-Smtp-Source: APXvYqxpfJSvhuzuLgdXVlOKI4W1C/fxw3JnLN40r/V/o5hgJeYKUVXNqXgr/k46Kj/hvbpO/OwA/w==
X-Received: by 2002:ac2:508e:: with SMTP id f14mr46728621lfm.72.1578069332612;
        Fri, 03 Jan 2020 08:35:32 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id w19sm24845957lfl.55.2020.01.03.08.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 08:35:31 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1inPvB-0000Ku-9l; Fri, 03 Jan 2020 17:35:33 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/6] media: stv06xx: add missing descriptor sanity checks
Date:   Fri,  3 Jan 2020 17:35:10 +0100
Message-Id: <20200103163513.1229-4-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103163513.1229-1-johan@kernel.org>
References: <20200103163513.1229-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/media/usb/gspca/stv06xx/stv06xx.c     | 19 ++++++++++++++++++-
 .../media/usb/gspca/stv06xx/stv06xx_pb0100.c  |  4 ++++
 2 files changed, 22 insertions(+), 1 deletion(-)

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
@@ -306,11 +309,21 @@ static int stv06xx_start(struct gspca_dev *gspca_dev)
 
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
-- 
2.24.1

