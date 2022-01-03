Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7EE48317B
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 14:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiACNlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 08:41:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58542 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiACNlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 08:41:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3722B80ED4
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 13:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26533C36AED;
        Mon,  3 Jan 2022 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641217261;
        bh=frur6pMHn59IOWJwFfLI4NC5X0Sc1KqNoz7Ik+4tHuY=;
        h=Subject:To:From:Date:From;
        b=jtKwv7YAPMDYnBKEtO0TX+lrBGb0m0nWDQuounrJ+54yUNyF4RETi0lXpSQBClZ9H
         Sb7sNKbQGiKYEQr/rPBw3FfigPREd16CqmhIpab1Iy29NtkjHE1+IuXtI+/D+tptTw
         pkpTwWlHLM3hoYPhYpmLi5JULTgaaXM0pMWHA+Nw=
Subject: patch "USB: core: Fix bug in resuming hub's handling of wakeup requests" added to usb-testing
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        noodles@earth.li, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Jan 2022 14:40:49 +0100
Message-ID: <164121724986192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: core: Fix bug in resuming hub's handling of wakeup requests

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 0f663729bb4afc92a9986b66131ebd5b8a9254d1 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Sat, 1 Jan 2022 14:52:14 -0500
Subject: USB: core: Fix bug in resuming hub's handling of wakeup requests

Bugzilla #213839 reports a 7-port hub that doesn't work properly when
devices are plugged into some of the ports; the kernel goes into an
unending disconnect/reinitialize loop as shown in the bug report.

This "7-port hub" comprises two four-port hubs with one plugged into
the other; the failures occur when a device is plugged into one of the
downstream hub's ports.  (These hubs have other problems too.  For
example, they bill themselves as USB-2.0 compliant but they only run
at full speed.)

It turns out that the failures are caused by bugs in both the kernel
and the hub.  The hub's bug is that it reports a different
bmAttributes value in its configuration descriptor following a remote
wakeup (0xe0 before, 0xc0 after -- the wakeup-support bit has
changed).

The kernel's bug is inside the hub driver's resume handler.  When
hub_activate() sees that one of the hub's downstream ports got a
wakeup request from a child device, it notes this fact by setting the
corresponding bit in the hub->change_bits variable.  But this variable
is meant for connection changes, not wakeup events; setting it causes
the driver to believe the downstream port has been disconnected and
then connected again (in addition to having received a wakeup
request).

Because of this, the hub driver then tries to check whether the device
currently plugged into the downstream port is the same as the device
that had been attached there before.  Normally this check succeeds and
wakeup handling continues with no harm done (which is why the bug
remained undetected until now).  But with these dodgy hubs, the check
fails because the config descriptor has changed.  This causes the hub
driver to reinitialize the child device, leading to the
disconnect/reinitialize loop described in the bug report.

The proper way to note reception of a downstream wakeup request is
to set a bit in the hub->event_bits variable instead of
hub->change_bits.  That way the hub driver will realize that something
has happened to the port but will not think the port and child device
have been disconnected.  This patch makes that change.

Cc: <stable@vger.kernel.org>
Tested-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YdCw7nSfWYPKWQoD@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 721794f0f494..47a1c8bddf86 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1228,7 +1228,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 			 */
 			if (portchange || (hub_is_superspeed(hub->hdev) &&
 						port_resumed))
-				set_bit(port1, hub->change_bits);
+				set_bit(port1, hub->event_bits);
 
 		} else if (udev->persist_enabled) {
 #ifdef CONFIG_PM
-- 
2.34.1


