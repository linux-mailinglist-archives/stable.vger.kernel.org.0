Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91A45F268
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 07:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfGDFwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 01:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbfGDFwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 01:52:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7655218A4;
        Thu,  4 Jul 2019 05:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562219538;
        bh=B0PRN7HvXst7ivQvpFTEksVTRhchddU1yxrzmpJcGL4=;
        h=Subject:To:From:Date:From;
        b=clq7HnfnVeTKSVQ4bGJbUKXu8JhHpaZkiKJReOBoywXKI1bW6c24ABRgKJGv1Y6gl
         SU+OLEVcszR2mLYIg8Euc0wsR+4JQf0w6rRzREr7VJa2YegPP7Ao0pKIIiRqcNfDOK
         7tg5JP6GHu6Oq3KbTdv0qsTTMou/2MvfRh66pFZg=
Subject: patch "usb: Handle USB3 remote wakeup for LPM enabled devices correctly" added to usb-next
To:     chiasheng.lee@intel.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Jul 2019 07:51:37 +0200
Message-ID: <1562219497126132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: Handle USB3 remote wakeup for LPM enabled devices correctly

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From e244c4699f859cf7149b0781b1894c7996a8a1df Mon Sep 17 00:00:00 2001
From: "Lee, Chiasheng" <chiasheng.lee@intel.com>
Date: Thu, 20 Jun 2019 10:56:04 +0300
Subject: usb: Handle USB3 remote wakeup for LPM enabled devices correctly

With Link Power Management (LPM) enabled USB3 links transition to low
power U1/U2 link states from U0 state automatically.

Current hub code detects USB3 remote wakeups by checking if the software
state still shows suspended, but the link has transitioned from suspended
U3 to enabled U0 state.

As it takes some time before the hub thread reads the port link state
after a USB3 wake notification, the link may have transitioned from U0
to U1/U2, and wake is not detected by hub code.

Fix this by handling U1/U2 states in the same way as U0 in USB3 wakeup
handling

This patch should be added to stable kernels since 4.13 where LPM was
kept enabled during suspend/resume

Cc: <stable@vger.kernel.org> # v4.13+
Signed-off-by: Lee, Chiasheng <chiasheng.lee@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a59e1573b43b..236313f41f4a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3619,6 +3619,7 @@ static int hub_handle_remote_wakeup(struct usb_hub *hub, unsigned int port,
 	struct usb_device *hdev;
 	struct usb_device *udev;
 	int connect_change = 0;
+	u16 link_state;
 	int ret;
 
 	hdev = hub->hdev;
@@ -3628,9 +3629,11 @@ static int hub_handle_remote_wakeup(struct usb_hub *hub, unsigned int port,
 			return 0;
 		usb_clear_port_feature(hdev, port, USB_PORT_FEAT_C_SUSPEND);
 	} else {
+		link_state = portstatus & USB_PORT_STAT_LINK_STATE;
 		if (!udev || udev->state != USB_STATE_SUSPENDED ||
-				 (portstatus & USB_PORT_STAT_LINK_STATE) !=
-				 USB_SS_PORT_LS_U0)
+				(link_state != USB_SS_PORT_LS_U0 &&
+				 link_state != USB_SS_PORT_LS_U1 &&
+				 link_state != USB_SS_PORT_LS_U2))
 			return 0;
 	}
 
-- 
2.22.0


