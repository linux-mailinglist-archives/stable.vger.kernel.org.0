Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB54E14BADB
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgA1Ols (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:41:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbgA1ON4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:13:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D38E24688;
        Tue, 28 Jan 2020 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220835;
        bh=FIIZiQrPCFTJOTi6y0n20X+dQYu6x1A+iUeRhJ0vEQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHbYxnHxjOSGNl9Uj533DGDIXWUOMuCjykbym6S1J4eWBJzNyEXTPgIo54wRqSgqz
         s+Z4K9fU5cJZ8f3ZP/ZrSqv3Oc8dRnYJCW3Z0Ye+tOmkKoJniFXzzWpINoddEsCEyx
         Y8jvjc3zSQCI9D7IxblvCnHv6Ja89mhGCCP2P26g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.4 167/183] Input: keyspan-remote - fix control-message timeouts
Date:   Tue, 28 Jan 2020 15:06:26 +0100
Message-Id: <20200128135846.339032727@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ba9a103f40fc4a3ec7558ec9b0b97d4f92034249 upstream.

The driver was issuing synchronous uninterruptible control requests
without using a timeout. This could lead to the driver hanging on probe
due to a malfunctioning (or malicious) device until the device is
physically disconnected. While sleeping in probe the driver prevents
other devices connected to the same hub from being added to (or removed
from) the bus.

The USB upper limit of five seconds per request should be more than
enough.

Fixes: 99f83c9c9ac9 ("[PATCH] USB: add driver for Keyspan Digital Remote")
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Link: https://lore.kernel.org/r/20200113171715.30621-1-johan@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/misc/keyspan_remote.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/input/misc/keyspan_remote.c
+++ b/drivers/input/misc/keyspan_remote.c
@@ -344,7 +344,8 @@ static int keyspan_setup(struct usb_devi
 	int retval = 0;
 
 	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x11, 0x40, 0x5601, 0x0, NULL, 0, 0);
+				 0x11, 0x40, 0x5601, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set bit rate due to error: %d\n",
 			__func__, retval);
@@ -352,7 +353,8 @@ static int keyspan_setup(struct usb_devi
 	}
 
 	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x44, 0x40, 0x0, 0x0, NULL, 0, 0);
+				 0x44, 0x40, 0x0, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set resume sensitivity due to error: %d\n",
 			__func__, retval);
@@ -360,7 +362,8 @@ static int keyspan_setup(struct usb_devi
 	}
 
 	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x22, 0x40, 0x0, 0x0, NULL, 0, 0);
+				 0x22, 0x40, 0x0, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to turn receive on due to error: %d\n",
 			__func__, retval);


