Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9941FEDF4
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 10:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgFRIlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 04:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgFRIlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 04:41:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A0A02089D;
        Thu, 18 Jun 2020 08:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592469709;
        bh=PI9huS1emkg240d2iTbBc8oURa4l0NT7HnYMVIn2nS4=;
        h=Subject:To:From:Date:From;
        b=kohFVZoL70ITs3h6pZhG8ax8BnNBg5OMlr8UHjScGbE3kgJvKB6M0HgxRsYerzyr9
         s6bUm+F3h/Y09JzHtqj7GyAfJNromlqyuCBKCj2TgrqHdO6xFKKQKEWNaS1Q+U/sGc
         iFzC5yZlJ3F2D0Z8ta/faI68BiGR5VZNFI0DgJuw=
Subject: patch "usb: typec: mux: intel_pmc_mux: Fix DP alternate mode entry" added to usb-linus
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        pmalani@chromium.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 10:41:34 +0200
Message-ID: <15924696945295@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: mux: intel_pmc_mux: Fix DP alternate mode entry

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 130206a88683d859f63ed6d4a56ab5c2b4930c8e Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Fri, 29 May 2020 16:17:53 +0300
Subject: usb: typec: mux: intel_pmc_mux: Fix DP alternate mode entry

The PMC needs to be notified separately about HPD (hotplug
detected) signal being high after mode entry. There is a bit
"HPD High" in the Alternate Mode Request that the driver
already sets, but that bit is only valid when the
DisplayPort Alternate Mode is directly entered from
disconnected state.

Fixes: 5c4edcdbcd97 ("usb: typec: mux: intel: Fix DP_HPD_LVL bit field")
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Tested-by: Prashant Malani <pmalani@chromium.org>
Link: https://lore.kernel.org/r/20200529131753.15587-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 962bc69a6a59..70ddc9d6d49e 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -148,7 +148,8 @@ pmc_usb_mux_dp_hpd(struct pmc_usb_port *port, struct typec_mux_state *state)
 	msg[0] = PMC_USB_DP_HPD;
 	msg[0] |= port->usb3_port << PMC_USB_MSG_USB3_PORT_SHIFT;
 
-	msg[1] = PMC_USB_DP_HPD_IRQ;
+	if (data->status & DP_STATUS_IRQ_HPD)
+		msg[1] = PMC_USB_DP_HPD_IRQ;
 
 	if (data->status & DP_STATUS_HPD_STATE)
 		msg[1] |= PMC_USB_DP_HPD_LVL;
@@ -161,6 +162,7 @@ pmc_usb_mux_dp(struct pmc_usb_port *port, struct typec_mux_state *state)
 {
 	struct typec_displayport_data *data = state->data;
 	struct altmode_req req = { };
+	int ret;
 
 	if (data->status & DP_STATUS_IRQ_HPD)
 		return pmc_usb_mux_dp_hpd(port, state);
@@ -181,7 +183,14 @@ pmc_usb_mux_dp(struct pmc_usb_port *port, struct typec_mux_state *state)
 	if (data->status & DP_STATUS_HPD_STATE)
 		req.mode_data |= PMC_USB_ALTMODE_HPD_HIGH;
 
-	return pmc_usb_command(port, (void *)&req, sizeof(req));
+	ret = pmc_usb_command(port, (void *)&req, sizeof(req));
+	if (ret)
+		return ret;
+
+	if (data->status & DP_STATUS_HPD_STATE)
+		return pmc_usb_mux_dp_hpd(port, state);
+
+	return 0;
 }
 
 static int
-- 
2.27.0


