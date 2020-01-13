Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F86813975D
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 18:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgAMRTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 12:19:10 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41716 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgAMRTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 12:19:10 -0500
Received: by mail-lf1-f68.google.com with SMTP id m30so7439003lfp.8;
        Mon, 13 Jan 2020 09:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y9qTdRaov7akAd1kWwr41VKiqR66XXQQc/qOrXnFVXg=;
        b=rn9JAu6nnPkEwisbhpxjElmLNy8FYGc5+xhVAxngbThwCrC6hXMLlqGGBQHfPsjsvd
         nDx5GC6CUpcERGxiFNlUVhYACEVtkY2EEPJ+6jTN+DDNhGpN15vWISHFYwr4TEqIFKtE
         rM+MOv/UsDurzBqFCw0oN2TRGV6A5A+1zjWGfs7qHITMhlbA475MU9DcgyHtVIfP7Ktn
         /Cqmm7Uj7wGCJdnP0R/H+tHy67vl1tbu8uWnTlknBeAj6j+OdYdvgcN46Zo24w2rtmaG
         4W/uEDadhqalXu4rA8bkerK3HGChhgjgbY3+DF9m/RhoA49Vjj3EEIERqWCfExBTOF0A
         d+TA==
X-Gm-Message-State: APjAAAUuVB5qVsE5+A0vXhqxf5RjbNEhoGnDV3HAEG9PQiyBEQHmpjgl
        EQTMV1Khpmtgd9spa8CCFgE=
X-Google-Smtp-Source: APXvYqxskbfVukahiLeuZqdt8WTBWZxOf/4mCEvgBtp81Sp6R+iJevv42KjDtiBgK2IZdMcNZ4VhZw==
X-Received: by 2002:ac2:555c:: with SMTP id l28mr10218611lfk.52.1578935947579;
        Mon, 13 Jan 2020 09:19:07 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id r2sm5950078lfn.13.2020.01.13.09.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 09:19:06 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1ir3Mo-00080W-S2; Mon, 13 Jan 2020 18:19:06 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] media: usbtv: fix control-message timeouts
Date:   Mon, 13 Jan 2020 18:18:18 +0100
Message-Id: <20200113171818.30715-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was issuing synchronous uninterruptible control requests
without using a timeout. This could lead to the driver hanging on
various user requests due to a malfunctioning (or malicious) device
until the device is physically disconnected.

The USB upper limit of five seconds per request should be more than
enough.

Fixes: f3d27f34fdd7 ("[media] usbtv: Add driver for Fushicai USBTV007 video frame grabber")
Fixes: c53a846c48f2 ("[media] usbtv: add video controls")
Cc: stable <stable@vger.kernel.org>     # 3.11
Cc: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/usbtv/usbtv-core.c  | 2 +-
 drivers/media/usb/usbtv/usbtv-video.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 5095c380b2c1..ee9c656d121f 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -56,7 +56,7 @@ int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size)
 
 		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, index, NULL, 0, 0);
+			value, index, NULL, 0, USB_CTRL_GET_TIMEOUT);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 3d9284a09ee5..b249f037900c 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -800,7 +800,8 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = usb_control_msg(usbtv->udev,
 			usb_rcvctrlpipe(usbtv->udev, 0), USBTV_CONTROL_REG,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0, USBTV_BASE + 0x0244, (void *)data, 3, 0);
+			0, USBTV_BASE + 0x0244, (void *)data, 3,
+			USB_CTRL_GET_TIMEOUT);
 		if (ret < 0)
 			goto error;
 	}
@@ -851,7 +852,7 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
 	ret = usb_control_msg(usbtv->udev, usb_sndctrlpipe(usbtv->udev, 0),
 			USBTV_CONTROL_REG,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0, index, (void *)data, size, 0);
+			0, index, (void *)data, size, USB_CTRL_SET_TIMEOUT);
 
 error:
 	if (ret < 0)
-- 
2.24.1

