Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CFE1BCB62
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgD1SbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729595AbgD1SbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ADB421707;
        Tue, 28 Apr 2020 18:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098661;
        bh=psWuYx6KrdTEJ1QXZEjgcXCDgSQUaFrz3iTBrBHzfBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FxiGz6m5EALYLj7ywQxNTwERYO1QbUSsZhkn2fzH8raEHM9cn5NNOsnDY2iL3Ccz
         QQNubaiMUaDZQmi06UiNVFFPDR78IuR1EmCmEClGFMTQ1OgIpnZ6zmlzqvyAvi+Ey0
         yQ+HGKJP3oYIDvuMC3sFuC9wfm6p0yiOJKNZdu8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Paul Zimmerman <pauldzim@gmail.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.6 094/167] USB: hub: Fix handling of connect changes during sleep
Date:   Tue, 28 Apr 2020 20:24:30 +0200
Message-Id: <20200428182236.944807952@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 9f952e26295d977dbfc6fedeaf8c4f112c818d37 upstream.

Commit 8099f58f1ecd ("USB: hub: Don't record a connect-change event
during reset-resume") wasn't very well conceived.  The problem it
tried to fix was that if a connect-change event occurred while the
system was asleep (such as a device disconnecting itself from the bus
when it is suspended and then reconnecting when it resumes)
requiring a reset-resume during the system wakeup transition, the hub
port's change_bit entry would remain set afterward.  This would cause
the hub driver to believe another connect-change event had occurred
after the reset-resume, which was wrong and would lead the driver to
send unnecessary requests to the device (which could interfere with a
firmware update).

The commit tried to fix this by not setting the change_bit during the
wakeup.  But this was the wrong thing to do; it means that when a
device is unplugged while the system is asleep, the hub driver doesn't
realize anything has happened: The change_bit flag which would tell it
to handle the disconnect event is clear.

The commit needs to be reverted and the problem fixed in a different
way.  Fortunately an alternative solution was noted in the commit's
Changelog: We can continue to set the change_bit entry in
hub_activate() but then clear it when a reset-resume occurs.  That way
the the hub driver will see the change_bit when a device is
disconnected but won't see it when the device is still present.

That's what this patch does.

Reported-and-tested-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 8099f58f1ecd ("USB: hub: Don't record a connect-change event during reset-resume")
Tested-by: Paul Zimmerman <pauldzim@gmail.com>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2004221602480.11262-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1223,6 +1223,11 @@ static void hub_activate(struct usb_hub
 #ifdef CONFIG_PM
 			udev->reset_resume = 1;
 #endif
+			/* Don't set the change_bits when the device
+			 * was powered off.
+			 */
+			if (test_bit(port1, hub->power_bits))
+				set_bit(port1, hub->change_bits);
 
 		} else {
 			/* The power session is gone; tell hub_wq */
@@ -3088,6 +3093,15 @@ static int check_port_resume_type(struct
 		if (portchange & USB_PORT_STAT_C_ENABLE)
 			usb_clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_ENABLE);
+
+		/*
+		 * Whatever made this reset-resume necessary may have
+		 * turned on the port1 bit in hub->change_bits.  But after
+		 * a successful reset-resume we want the bit to be clear;
+		 * if it was on it would indicate that something happened
+		 * following the reset-resume.
+		 */
+		clear_bit(port1, hub->change_bits);
 	}
 
 	return status;


