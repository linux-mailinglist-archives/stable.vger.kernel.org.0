Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD2112AD5A
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 16:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfLZP6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 10:58:10 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38863 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfLZP6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Dec 2019 10:58:09 -0500
Received: by mail-pg1-f193.google.com with SMTP id a33so13030883pgm.5;
        Thu, 26 Dec 2019 07:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Sc/QM60TLDKLCJyG51lQ93byw6/RqTEsu4YWyZPPW+4=;
        b=ObJhDY3m1giX7IMM+TocG9g+ou2I5nCWXeMf7XFf6tq0yORrDGmN7i3Q8Q10njeqTt
         QWjHXJJmpUvIdjJUwaCaUhjctHUZ+F/iXiPouMOq1ssnSgFq8W+ESzD5WH8QGOEXDf2J
         qClVechzGE/Xj0CgeAYLlVtVGtiVVWbBaddt/AWbT/sVeOGsxVZPX+FcxSuUvQgnfm1w
         fnc+Q4rkOosPe5c9mojXpmSMIPD4q1Ike1/rqTLSDqU2iA1XwKa8R9hdFZSh/WTWXZ8x
         1vidOBtv2tj7wntzTrmJiLHAMGFGl++QeVy+7M44gmQDVw04JS7yv/fAJoicNVyblivA
         lZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Sc/QM60TLDKLCJyG51lQ93byw6/RqTEsu4YWyZPPW+4=;
        b=ApDEFzPWf1R/OLK/2qr7xn8nFtqXXWPs0xpr27tPKs9r5264rshyuT0QlWS9RSuW0f
         VkJAO8cwkbOl/Zsto0RWQZCEbnNTBg6/dmHIrLnKikAD8RgsGJuK9ka1QYWVVVlT2bGE
         st/QP1xO+gbRwBLxQBD6d4dGby0xBEfu1R9sHIdiN30MRH3wL8vguFg8e3drxysQTF3g
         zDbpND3vbbK0EiYe2RFWwVN8myR24sdkkvFAU0zwwsl0xL5RCqnlkMMw+4cv5BEeeMkT
         tdPMOiNKPquhQ/LTeWbCoWuyJ4HEOfEUYJjIwg20WED6+gdq5FFwj9KatNjXF6T2Nw19
         RvZw==
X-Gm-Message-State: APjAAAWKtyIG7Hk1PLB9D4fmFK1pP8j2aw64VsfnDi+ADIh6xbL0oQJg
        lzguSANznp2/e9rx1PHjzhQsVnlE
X-Google-Smtp-Source: APXvYqyZIfc/06xxz7P7R0ZAi+ysQgE1I01Mo/VbflldUlzmyAq3fxGB80h3C8AEKnbCRfN3CaD3Lw==
X-Received: by 2002:aa7:9aeb:: with SMTP id y11mr50638957pfp.63.1577375889222;
        Thu, 26 Dec 2019 07:58:09 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 144sm39109626pfc.124.2019.12.26.07.58.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Dec 2019 07:58:08 -0800 (PST)
From:   Guenter Roeck <linux@roeck-us.net>
To:     Peter Chen <peter.chen@freescale.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        stable@vger.kernel.org
Subject: [PATCH] usb: chipidea: host: Disable port power only if previously enabled
Date:   Thu, 26 Dec 2019 07:57:54 -0800
Message-Id: <20191226155754.25451-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On shutdown, ehci_power_off() is called unconditionally to power off
each port, even if it was never called to power on the port.
For chipidea, this results in a call to ehci_ci_portpower() with a request
to power off ports even if the port was never powered on.
This results in the following warning from the regulator code.

WARNING: CPU: 0 PID: 182 at drivers/regulator/core.c:2596 _regulator_disable+0x1a8/0x210
unbalanced disables for usb_otg2_vbus
Modules linked in:
CPU: 0 PID: 182 Comm: init Not tainted 5.4.6 #1
Hardware name: Freescale i.MX7 Dual (Device Tree)
[<c0313658>] (unwind_backtrace) from [<c030d698>] (show_stack+0x10/0x14)
[<c030d698>] (show_stack) from [<c1133afc>] (dump_stack+0xe0/0x10c)
[<c1133afc>] (dump_stack) from [<c0349098>] (__warn+0xf4/0x10c)
[<c0349098>] (__warn) from [<c0349128>] (warn_slowpath_fmt+0x78/0xbc)
[<c0349128>] (warn_slowpath_fmt) from [<c09f36ac>] (_regulator_disable+0x1a8/0x210)
[<c09f36ac>] (_regulator_disable) from [<c09f374c>] (regulator_disable+0x38/0xe8)
[<c09f374c>] (regulator_disable) from [<c0df7bac>] (ehci_ci_portpower+0x38/0xdc)
[<c0df7bac>] (ehci_ci_portpower) from [<c0db4fa4>] (ehci_port_power+0x50/0xa4)
[<c0db4fa4>] (ehci_port_power) from [<c0db5420>] (ehci_silence_controller+0x5c/0xc4)
[<c0db5420>] (ehci_silence_controller) from [<c0db7644>] (ehci_stop+0x3c/0xcc)
[<c0db7644>] (ehci_stop) from [<c0d5bdc4>] (usb_remove_hcd+0xe0/0x19c)
[<c0d5bdc4>] (usb_remove_hcd) from [<c0df7638>] (host_stop+0x38/0xa8)
[<c0df7638>] (host_stop) from [<c0df2f34>] (ci_hdrc_remove+0x44/0xe4)
...

Keeping track of the power enable state avoids the warning and traceback.

Fixes: c8679a2fb8dec ("usb: chipidea: host: add portpower override")
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Peter Chen <peter.chen@freescale.com>
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/usb/chipidea/host.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index b45ceb91c735..48e4a5ca1835 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -26,6 +26,7 @@ static int (*orig_bus_suspend)(struct usb_hcd *hcd);
 
 struct ehci_ci_priv {
 	struct regulator *reg_vbus;
+	bool enabled;
 };
 
 static int ehci_ci_portpower(struct usb_hcd *hcd, int portnum, bool enable)
@@ -37,7 +38,7 @@ static int ehci_ci_portpower(struct usb_hcd *hcd, int portnum, bool enable)
 	int ret = 0;
 	int port = HCS_N_PORTS(ehci->hcs_params);
 
-	if (priv->reg_vbus) {
+	if (priv->reg_vbus && enable != priv->enabled) {
 		if (port > 1) {
 			dev_warn(dev,
 				"Not support multi-port regulator control\n");
@@ -53,6 +54,7 @@ static int ehci_ci_portpower(struct usb_hcd *hcd, int portnum, bool enable)
 				enable ? "enable" : "disable", ret);
 			return ret;
 		}
+		priv->enabled = enable;
 	}
 
 	if (enable && (ci->platdata->phy_mode == USBPHY_INTERFACE_MODE_HSIC)) {
-- 
2.17.1

