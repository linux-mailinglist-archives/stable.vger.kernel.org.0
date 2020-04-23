Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC4F1B67E0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgDWXKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:10:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50354 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728598AbgDWXGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:53 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvd-0004lP-Sz; Fri, 24 Apr 2020 00:06:46 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvW-00E6wh-Ml; Fri, 24 Apr 2020 00:06:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Keiya Nobuta" <nobuta.keiya@fujitsu.com>
Date:   Fri, 24 Apr 2020 00:06:52 +0100
Message-ID: <lsq.1587683028.868709353@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 185/245] usb: core: hub: Improved device recognition
 on remote wakeup
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Keiya Nobuta <nobuta.keiya@fujitsu.com>

commit 9c06ac4c83df6d6fbdbf7488fbad822b4002ba19 upstream.

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
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200109051448.28150-1-nobuta.keiya@fujitsu.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1125,6 +1125,7 @@ static void hub_activate(struct usb_hub
 			 * PORT_OVER_CURRENT is not. So check for any of them.
 			 */
 			if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
+			    (portchange & USB_PORT_STAT_C_CONNECTION) ||
 			    (portstatus & USB_PORT_STAT_OVERCURRENT) ||
 			    (portchange & USB_PORT_STAT_C_OVERCURRENT))
 				set_bit(port1, hub->change_bits);

