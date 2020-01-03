Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65BC112FA9A
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 17:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgACQfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 11:35:55 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46601 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgACQfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 11:35:36 -0500
Received: by mail-lj1-f195.google.com with SMTP id m26so41970604ljc.13;
        Fri, 03 Jan 2020 08:35:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wOGJDK9VxSi0BWGjIljSq4Feb+Qmi92twu6Ha+tsjbE=;
        b=cnVUvsvXf783t5+2W62Fg2E7o4YGU3E0lvBkN+xPaXe2wPLCzyi01iygyLxI9N0Y5p
         CiKREjOEAY9hRPGYxvF9ihI9y3vtSKhXqr16B00Lpv4U+N8hTH94K7X4hDDTs4zlzlAy
         aEVhNYjqya7kBwy8MhFKmO+G+UFmF9GaX44ogVtqri8JkoGWZkXNdirrhcEFP/su9Eol
         NDdLeieM33Iez2bg/FRRM9xt5axFHEummOmIhhH1Wg53NAdjXFO8pFZirpWkk2nDgAdO
         u6FMmnPDer2tOxHZLTidLo+2ecNncyRblcowiFKrCwb8P0OLbHDU+3Mu1g90SDYU+a40
         xytw==
X-Gm-Message-State: APjAAAXnXhEzANHbeXpfFCX8MzuxA9FRmF4gelMGpKUmT6XGtxNWzGen
        xh5pG6ctF+PXap8oGbKeLE8=
X-Google-Smtp-Source: APXvYqyatX6mOcKLHVud6xipKNRdmBsg36UpiSC6YsOJEh3KwyNzesOFwI+O4Bmvtdt2PcidB4wVmg==
X-Received: by 2002:a2e:7816:: with SMTP id t22mr53001895ljc.161.1578069333139;
        Fri, 03 Jan 2020 08:35:33 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id u17sm15855057ljk.62.2020.01.03.08.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 08:35:32 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1inPvB-0000Kz-D3; Fri, 03 Jan 2020 17:35:33 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4/6] media: xirlink_cit: add missing descriptor sanity checks
Date:   Fri,  3 Jan 2020 17:35:11 +0100
Message-Id: <20200103163513.1229-5-johan@kernel.org>
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

Note that the sanity check in cit_get_packet_size() is not redundant as
the driver is mixing looking up altsettings by index and by number,
which may not coincide.

Fixes: 659fefa0eb17 ("V4L/DVB: gspca_xirlink_cit: Add support for camera with a bcd version of 0.01")
Fixes: 59f8b0bf3c12 ("V4L/DVB: gspca_xirlink_cit: support bandwidth changing for devices with 1 alt setting")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/gspca/xirlink_cit.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
index 934a90bd78c2..c579b100f066 100644
--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -1442,6 +1442,9 @@ static int cit_get_packet_size(struct gspca_dev *gspca_dev)
 		return -EIO;
 	}
 
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	return le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 }
 
@@ -2626,6 +2629,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 static int sd_isoc_init(struct gspca_dev *gspca_dev)
 {
+	struct usb_interface_cache *intfc;
 	struct usb_host_interface *alt;
 	int max_packet_size;
 
@@ -2641,8 +2645,17 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
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
@@ -2665,6 +2678,9 @@ static int sd_isoc_nego(struct gspca_dev *gspca_dev)
 		break;
 	}
 
+	/*
+	 * Existence of altsetting and endpoint was verified in sd_isoc_init()
+	 */
 	alt = &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	if (packet_size <= min_packet_size)
-- 
2.24.1

