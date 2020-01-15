Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B835E13C09D
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgAOMVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:21:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbgAOMVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 07:21:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C001207FF;
        Wed, 15 Jan 2020 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579090874;
        bh=f1oJB8fmMEk1uZlaxMqhY5MfMoD6s0r/AgRWoRE7bfw=;
        h=Subject:To:From:Date:From;
        b=D0iOMgHsHQO3T5scDXRhXiaqF/YZ3XtSnOAEmOoFVfyeNA/eW5EaxeIea2/LiKCXT
         /62IjmS+UIRd9fprkT0dhzEOsRRC9hRXOFICfOk8S37AnBlXo2iYeT300pPXTJWfmp
         PThlw9sM+RwiRergiq9JopkZxAV/+l0Xf/iUnBTQ=
Subject: patch "usb: core: hub: Improved device recognition on remote wakeup" added to usb-linus
To:     nobuta.keiya@fujitsu.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Jan 2020 13:21:11 +0100
Message-ID: <157909087124168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: core: hub: Improved device recognition on remote wakeup

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9c06ac4c83df6d6fbdbf7488fbad822b4002ba19 Mon Sep 17 00:00:00 2001
From: Keiya Nobuta <nobuta.keiya@fujitsu.com>
Date: Thu, 9 Jan 2020 14:14:48 +0900
Subject: usb: core: hub: Improved device recognition on remote wakeup

If hub_activate() is called before D+ has stabilized after remote
wakeup, the following situation might occur:

         __      ___________________
        /  \    /
D+   __/    \__/

Hub  _______________________________
          |  ^   ^           ^
          |  |   |           |
Host _____v__|___|___________|______
          |  |   |           |
          |  |   |           \-- Interrupt Transfer (*3)
          |  |    \-- ClearPortFeature (*2)
          |   \-- GetPortStatus (*1)
          \-- Host detects remote wakeup

- D+ goes high, Host starts running by remote wakeup
- D+ is not stable, goes low
- Host requests GetPortStatus at (*1) and gets the following hub status:
  - Current Connect Status bit is 0
  - Connect Status Change bit is 1
- D+ stabilizes, goes high
- Host requests ClearPortFeature and thus Connect Status Change bit is
  cleared at (*2)
- After waiting 100 ms, Host starts the Interrupt Transfer at (*3)
- Since the Connect Status Change bit is 0, Hub returns NAK.

In this case, port_event() is not called in hub_event() and Host cannot
recognize device. To solve this issue, flag change_bits even if only
Connect Status Change bit is 1 when got in the first GetPortStatus.

This issue occurs rarely because it only if D+ changes during a very
short time between GetPortStatus and ClearPortFeature. However, it is
fatal if it occurs in embedded system.

Signed-off-by: Keiya Nobuta <nobuta.keiya@fujitsu.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200109051448.28150-1-nobuta.keiya@fujitsu.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8c4e5adbf820..3405b146edc9 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1192,6 +1192,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 			 * PORT_OVER_CURRENT is not. So check for any of them.
 			 */
 			if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
+			    (portchange & USB_PORT_STAT_C_CONNECTION) ||
 			    (portstatus & USB_PORT_STAT_OVERCURRENT) ||
 			    (portchange & USB_PORT_STAT_C_OVERCURRENT))
 				set_bit(port1, hub->change_bits);
-- 
2.24.1


