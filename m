Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D68213A4E5
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgANKDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729175AbgANKDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594B02467D;
        Tue, 14 Jan 2020 10:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996202;
        bh=pvOufZuphj6VLZXcaZb7RAaxRfAvsWGCvqjOw747ZXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkqXaa7jDp6MRUvV2tjlLcVi60qJm5nDyH05m5JnHA5e3WWVad66fkO8eU8+SMRLw
         pgiRGAT5kWGC2gKPl4fDWA4OcvmBOIpy1wvjaNdTMA4bc8VtgV3oQbW3OnrPp9xHbW
         mz2zQC1ac26Cs8XSqrM6cKkForayv+qGlb/SBajQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Peter Chen <peter.chen@freescale.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.4 04/78] usb: chipidea: host: Disable port power only if previously enabled
Date:   Tue, 14 Jan 2020 11:00:38 +0100
Message-Id: <20200114094353.105298870@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit c1ffba305dbcf3fb9ca969c20a97acbddc38f8e9 upstream.

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
Acked-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20191226155754.25451-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/host.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -26,6 +26,7 @@ static int (*orig_bus_suspend)(struct us
 
 struct ehci_ci_priv {
 	struct regulator *reg_vbus;
+	bool enabled;
 };
 
 static int ehci_ci_portpower(struct usb_hcd *hcd, int portnum, bool enable)
@@ -37,7 +38,7 @@ static int ehci_ci_portpower(struct usb_
 	int ret = 0;
 	int port = HCS_N_PORTS(ehci->hcs_params);
 
-	if (priv->reg_vbus) {
+	if (priv->reg_vbus && enable != priv->enabled) {
 		if (port > 1) {
 			dev_warn(dev,
 				"Not support multi-port regulator control\n");
@@ -53,6 +54,7 @@ static int ehci_ci_portpower(struct usb_
 				enable ? "enable" : "disable", ret);
 			return ret;
 		}
+		priv->enabled = enable;
 	}
 
 	if (enable && (ci->platdata->phy_mode == USBPHY_INTERFACE_MODE_HSIC)) {


