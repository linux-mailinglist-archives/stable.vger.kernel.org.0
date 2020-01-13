Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877FA139756
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 18:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgAMRR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 12:17:29 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37119 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgAMRR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 12:17:28 -0500
Received: by mail-lf1-f67.google.com with SMTP id b15so7446300lfc.4;
        Mon, 13 Jan 2020 09:17:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9m41qUTzIRJJakUykLj2yxJoWCGlTXPYpdoX2xvbBMA=;
        b=lzaTqvwrqH+kg3+wnCI/Kmr+M07/jTN/r9WZSmgifyEbY9KUkJKxmTi2YCPv8rdVsr
         HXSevYGRmvWvHCL5ecva1CNhnrUOorC7sOk3J1pA5SOzq1LfDtp5vvC6bWXHvWbB3ck8
         +7Fzanf3JVY9lzOVEGLP+UUXduwFS92lr6aPWENd5IwYV5vs7+ulBw4AQKvaMis7rVDK
         TQWwY1sLuqKYwpb3BLdWQh84caDyix9IcK8u7KeV3tRZSLqLQfTNGz3GRJNOZlWpS0s6
         8KeE66Ew0sU/1y5uZZWaQl1vRu45Mc+Y/cfCRHp2BgJjve1Kj1i6tBIvgONInEIMpq7N
         fhFg==
X-Gm-Message-State: APjAAAUXzgRCXTEzJwDMTAxew48pd7QmfdGUNsIECm39582viz7FpAH1
        jbgy1m4/pzM1L5Jt2cKa1Lo=
X-Google-Smtp-Source: APXvYqyL9cG3pPXjlHZhqSEBycmTM3iVOEX2hFl/z4oMBIvFShLBEcF8/uJMYti83XXCiqPbjwLa1A==
X-Received: by 2002:a19:c7c5:: with SMTP id x188mr10208572lff.22.1578935846285;
        Mon, 13 Jan 2020 09:17:26 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id e17sm6313349ljg.101.2020.01.13.09.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 09:17:25 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1ir3LB-0007ye-NK; Mon, 13 Jan 2020 18:17:25 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] Input: keyspan-remote: fix control-message timeouts
Date:   Mon, 13 Jan 2020 18:17:15 +0100
Message-Id: <20200113171715.30621-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was issuing synchronous uninterruptible control requests
without using a timeout. This could lead to the driver hanging on probe
due to a malfunctioning (or malicious) device until the device is
physically disconnected. While sleeping in probe the driver prevents
other devices connected to the same hub from being added to (or removed
from) the bus.

The USB upper limit of five seconds per request should be more than
enough.

Fixes: 99f83c9c9ac9 ("[PATCH] USB: add driver for Keyspan Digital Remote")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/input/misc/keyspan_remote.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
index 83368f1e7c4e..4650f4a94989 100644
--- a/drivers/input/misc/keyspan_remote.c
+++ b/drivers/input/misc/keyspan_remote.c
@@ -336,7 +336,8 @@ static int keyspan_setup(struct usb_device* dev)
 	int retval = 0;
 
 	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x11, 0x40, 0x5601, 0x0, NULL, 0, 0);
+				 0x11, 0x40, 0x5601, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set bit rate due to error: %d\n",
 			__func__, retval);
@@ -344,7 +345,8 @@ static int keyspan_setup(struct usb_device* dev)
 	}
 
 	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x44, 0x40, 0x0, 0x0, NULL, 0, 0);
+				 0x44, 0x40, 0x0, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set resume sensitivity due to error: %d\n",
 			__func__, retval);
@@ -352,7 +354,8 @@ static int keyspan_setup(struct usb_device* dev)
 	}
 
 	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x22, 0x40, 0x0, 0x0, NULL, 0, 0);
+				 0x22, 0x40, 0x0, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to turn receive on due to error: %d\n",
 			__func__, retval);
-- 
2.24.1

