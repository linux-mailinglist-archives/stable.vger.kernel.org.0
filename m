Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148BB13A57A
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgANKIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbgANKHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:07:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3873924677;
        Tue, 14 Jan 2020 10:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996471;
        bh=8AIZEBeI+orkEPwjWlJSquPttIx5N798ymgLlc/bwHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIr9V7QOxTw6Nlh4NqzojvTkLo9eZRfC4Jr41qkn0Q+zVI8XixHllg82Z6WMJGa29
         Dy38grSz84k84Qg33vr8iQUV0XFBumjwUhhHoKA+8OiipoB3MVSmEgC0orlRMmiISa
         wzoOSr7O2iYORfT93f7+8InijtQBenzLHE38eJo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Bin Liu <b-liu@ti.com>
Subject: [PATCH 4.19 27/46] usb: musb: fix idling for suspend after disconnect interrupt
Date:   Tue, 14 Jan 2020 11:01:44 +0100
Message-Id: <20200114094345.907114623@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 5fbf7a2534703fd71159d3d71504b0ad01b43394 upstream.

When disconnected as USB B-device, suspend interrupt should come before
diconnect interrupt, because the DP/DM pins are shorter than the
VBUS/GND pins on the USB connectors. But we sometimes get a suspend
interrupt after disconnect interrupt. In that case we have devctl set to
99 with VBUS still valid and musb_pm_runtime_check_session() wrongly
thinks we have an active session. We have no other interrupts after
disconnect coming in this case at least with the omap2430 glue.

Let's fix the issue by checking the interrupt status again with
delayed work for the devctl 99 case. In the suspend after disconnect
case the devctl session bit has cleared by then and musb can idle.
For a typical USB B-device connect case we just continue with normal
interrupts.

Fixes: 467d5c980709 ("usb: musb: Implement session bit based runtime PM for musb-core")

Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Bin Liu <b-liu@ti.com>
Link: https://lore.kernel.org/r/20200107152625.857-2-b-liu@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1842,6 +1842,9 @@ static const struct attribute_group musb
 #define MUSB_QUIRK_B_INVALID_VBUS_91	(MUSB_DEVCTL_BDEVICE | \
 					 (2 << MUSB_DEVCTL_VBUS_SHIFT) | \
 					 MUSB_DEVCTL_SESSION)
+#define MUSB_QUIRK_B_DISCONNECT_99	(MUSB_DEVCTL_BDEVICE | \
+					 (3 << MUSB_DEVCTL_VBUS_SHIFT) | \
+					 MUSB_DEVCTL_SESSION)
 #define MUSB_QUIRK_A_DISCONNECT_19	((3 << MUSB_DEVCTL_VBUS_SHIFT) | \
 					 MUSB_DEVCTL_SESSION)
 
@@ -1864,6 +1867,11 @@ static void musb_pm_runtime_check_sessio
 	s = MUSB_DEVCTL_FSDEV | MUSB_DEVCTL_LSDEV |
 		MUSB_DEVCTL_HR;
 	switch (devctl & ~s) {
+	case MUSB_QUIRK_B_DISCONNECT_99:
+		musb_dbg(musb, "Poll devctl in case of suspend after disconnect\n");
+		schedule_delayed_work(&musb->irq_work,
+				      msecs_to_jiffies(1000));
+		break;
 	case MUSB_QUIRK_B_INVALID_VBUS_91:
 		if (musb->quirk_retries && !musb->flush_irq_work) {
 			musb_dbg(musb,


