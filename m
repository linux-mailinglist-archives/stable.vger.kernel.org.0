Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9233640E37A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239649AbhIPQsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243006AbhIPQqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:46:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 149F061250;
        Thu, 16 Sep 2021 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809607;
        bh=9dp2HsjXh0v3QGCZzbXCEO3dbuO7d+bUPgzfJXClYpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeL0mS9Gt7FRhfUyhr2aRlg3NlMoWwkm46BDalaqib1h73vw7T8EFox8iRwswcA8j
         l96dK4jR59Cdjflk7vpMyM7fZDLJSnjFk01KdBVGVVACRnlv4wrhLNWKe/utO+6ymI
         FlSMgLOn4Qpsgkv9OyX/QeAZuKYBDmuhZx+fLlXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Ronak Vijay Raheja <rraheja@codeaurora.org>,
        Jack Pham <jackp@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 174/380] usb: gadget: composite: Allow bMaxPower=0 if self-powered
Date:   Thu, 16 Sep 2021 17:58:51 +0200
Message-Id: <20210916155809.996418044@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

[ Upstream commit bcacbf06c891374e7fdd7b72d11cda03b0269b43 ]

Currently the composite driver encodes the MaxPower field of
the configuration descriptor by reading the c->MaxPower of the
usb_configuration only if it is non-zero, otherwise it falls back
to using the value hard-coded in CONFIG_USB_GADGET_VBUS_DRAW.
However, there are cases when a configuration must explicitly set
bMaxPower to 0, particularly if its bmAttributes also has the
Self-Powered bit set, which is a valid combination.

This is specifically called out in the USB PD specification section
9.1, in which a PDUSB device "shall report zero in the bMaxPower
field after negotiating a mutually agreeable Contract", and also
verified by the USB Type-C Functional Test TD.4.10.2 Sink Power
Precedence Test.

The fix allows the c->MaxPower to be used for encoding the bMaxPower
even if it is 0, if the self-powered bit is also set.  An example
usage of this would be for a ConfigFS gadget to be dynamically
updated by userspace when the Type-C connection is determined to be
operating in Power Delivery mode.

Co-developed-by: Ronak Vijay Raheja <rraheja@codeaurora.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Ronak Vijay Raheja <rraheja@codeaurora.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210720080907.30292-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 72a9797dbbae..504c1cbc255d 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -482,7 +482,7 @@ static u8 encode_bMaxPower(enum usb_device_speed speed,
 {
 	unsigned val;
 
-	if (c->MaxPower)
+	if (c->MaxPower || (c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
 		val = c->MaxPower;
 	else
 		val = CONFIG_USB_GADGET_VBUS_DRAW;
@@ -936,7 +936,11 @@ static int set_config(struct usb_composite_dev *cdev,
 	}
 
 	/* when we return, be sure our power usage is valid */
-	power = c->MaxPower ? c->MaxPower : CONFIG_USB_GADGET_VBUS_DRAW;
+	if (c->MaxPower || (c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
+		power = c->MaxPower;
+	else
+		power = CONFIG_USB_GADGET_VBUS_DRAW;
+
 	if (gadget->speed < USB_SPEED_SUPER)
 		power = min(power, 500U);
 	else
-- 
2.30.2



