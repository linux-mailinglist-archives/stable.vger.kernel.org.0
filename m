Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BEF17F87B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgCJMsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgCJMsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:48:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232D824696;
        Tue, 10 Mar 2020 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844501;
        bh=OGGGzMf5/sPshGBhZOQD+x+b6tpwe/sDC7tBy0ZU3uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wfsw2y1pehXT0AGG042cpefh0h1kD4qUAyaxy5zR/9uaYnL5ilQUXhYd1nbq1vBPK
         QtSZ9kaopyl6J7c97/SAgK5tpldo/No3pxWkmJs1rH1Y6ypwxZ5KpV+888PKcgr8L4
         aoZeH2kq7IJPu3+GlB4XUWG/Ja5ROd29ovWo77xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <jackp@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/168] usb: gadget: composite: Support more than 500mA MaxPower
Date:   Tue, 10 Mar 2020 13:37:42 +0100
Message-Id: <20200310123637.338486743@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

[ Upstream commit a2035411fa1d1206cea7d5dfe833e78481844a76 ]

USB 3.x SuperSpeed peripherals can draw up to 900mA of VBUS power
when in configured state. However, if a configuration wanting to
take advantage of this is added with MaxPower greater than 500
(currently possible if using a ConfigFS gadget) the composite
driver fails to accommodate this for a couple reasons:

 - usb_gadget_vbus_draw() when called from set_config() and
   composite_resume() will be passed the MaxPower value without
   regard for the current connection speed, resulting in a
   violation for USB 2.0 since the max is 500mA.

 - the bMaxPower of the configuration descriptor would be
   incorrectly encoded, again if the connection speed is only
   at USB 2.0 or below, likely wrapping around U8_MAX since
   the 2mA multiplier corresponds to a maximum of 510mA.

Fix these by adding checks against the current gadget->speed
when the c->MaxPower value is used (set_config() and
composite_resume()) and appropriately limit based on whether
it is currently at a low-/full-/high- or super-speed connection.

Because 900 is not divisible by 8, with the round-up division
currently used in encode_bMaxPower() a MaxPower of 900mA will
result in an encoded value of 0x71. When a host stack (including
Linux and Windows) enumerates this on a single port root hub, it
reads this value back and decodes (multiplies by 8) to get 904mA
which is strictly greater than 900mA that is typically budgeted
for that port, causing it to reject the configuration. Instead,
we should be using the round-down behavior of normal integral
division so that 900 / 8 -> 0x70 or 896mA to stay within range.
And we might as well change it for the high/full/low case as well
for consistency.

N.B. USB 3.2 Gen N x 2 allows for up to 1500mA but there doesn't
seem to be any any peripheral controller supported by Linux that
does two lane operation, so for now keeping the clamp at 900
should be fine.

Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 0d45d7a4f9493..d7871636fced8 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -438,9 +438,13 @@ static u8 encode_bMaxPower(enum usb_device_speed speed,
 	if (!val)
 		return 0;
 	if (speed < USB_SPEED_SUPER)
-		return DIV_ROUND_UP(val, 2);
+		return min(val, 500U) / 2;
 	else
-		return DIV_ROUND_UP(val, 8);
+		/*
+		 * USB 3.x supports up to 900mA, but since 900 isn't divisible
+		 * by 8 the integral division will effectively cap to 896mA.
+		 */
+		return min(val, 900U) / 8;
 }
 
 static int config_buf(struct usb_configuration *config,
@@ -852,6 +856,10 @@ static int set_config(struct usb_composite_dev *cdev,
 
 	/* when we return, be sure our power usage is valid */
 	power = c->MaxPower ? c->MaxPower : CONFIG_USB_GADGET_VBUS_DRAW;
+	if (gadget->speed < USB_SPEED_SUPER)
+		power = min(power, 500U);
+	else
+		power = min(power, 900U);
 done:
 	usb_gadget_vbus_draw(gadget, power);
 	if (result >= 0 && cdev->delayed_status)
@@ -2278,7 +2286,7 @@ void composite_resume(struct usb_gadget *gadget)
 {
 	struct usb_composite_dev	*cdev = get_gadget_data(gadget);
 	struct usb_function		*f;
-	u16				maxpower;
+	unsigned			maxpower;
 
 	/* REVISIT:  should we have config level
 	 * suspend/resume callbacks?
@@ -2292,10 +2300,14 @@ void composite_resume(struct usb_gadget *gadget)
 				f->resume(f);
 		}
 
-		maxpower = cdev->config->MaxPower;
+		maxpower = cdev->config->MaxPower ?
+			cdev->config->MaxPower : CONFIG_USB_GADGET_VBUS_DRAW;
+		if (gadget->speed < USB_SPEED_SUPER)
+			maxpower = min(maxpower, 500U);
+		else
+			maxpower = min(maxpower, 900U);
 
-		usb_gadget_vbus_draw(gadget, maxpower ?
-			maxpower : CONFIG_USB_GADGET_VBUS_DRAW);
+		usb_gadget_vbus_draw(gadget, maxpower);
 	}
 
 	cdev->suspended = 0;
-- 
2.20.1



