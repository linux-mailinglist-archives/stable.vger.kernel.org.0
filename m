Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846272DEF55
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgLSNCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgLSM66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.9 39/49] xhci: Give USB2 ports time to enter U3 in bus suspend
Date:   Sat, 19 Dec 2020 13:58:43 +0100
Message-Id: <20201219125346.578741877@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit c1373f10479b624fb6dba0805d673e860f1b421d upstream.

If a USB2 device wakeup is not enabled/supported the link state may
still be in U0 in xhci_bus_suspend(), where it's then manually put
to suspended U3 state.

Just as with selective suspend the device needs time to enter U3
suspend before continuing with further suspend operations
(e.g. system suspend), otherwise we may enter system suspend with link
state in U0.

[commit message rewording -Mathias]

Cc: <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20201208092912.1773650-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-hub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1712,6 +1712,10 @@ retry:
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
 	spin_unlock_irqrestore(&xhci->lock, flags);
+
+	if (bus_state->bus_suspended)
+		usleep_range(5000, 10000);
+
 	return 0;
 }
 


