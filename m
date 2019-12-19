Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DC31269AE
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfLSSkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbfLSSkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:40:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63DB5206D7;
        Thu, 19 Dec 2019 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780806;
        bh=HUDxa4sCtle48J86+gvHNgyZO8KfClOJARkzh9eND58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/B+ndnkI6GEizDLHRyu/MYmK2ame6tosoETsGnyu+rj4l+oddN5y3Hd2OR9mV79/
         8fR7VE/mT+8dPzSckkDL8im+1qiEzgh90lvzMPrGQqLzKU2LVpirjoCdNgXwNFiXxI
         ylb3c98dkEEPvoaVKnQW0K5lB7uz0PAeARNZY6E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 126/162] xhci: make sure interrupts are restored to correct state
Date:   Thu, 19 Dec 2019 19:33:54 +0100
Message-Id: <20191219183215.438374642@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit bd82873f23c9a6ad834348f8b83f3b6a5bca2c65 ]

spin_unlock_irqrestore() might be called with stale flags after
reading port status, possibly restoring interrupts to a incorrect
state.

If a usb2 port just finished resuming while the port status is read
the spin lock will be temporary released and re-acquired in a separate
function. The flags parameter is passed as value instead of a pointer,
not updating flags properly before the final spin_unlock_irqrestore()
is called.

Cc: <stable@vger.kernel.org> # v3.12+
Fixes: 8b3d45705e54 ("usb: Fix xHCI host issues on remote wakeup.")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-7-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 421825b44202b..bd31b016c51db 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -704,7 +704,7 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 		struct xhci_bus_state *bus_state,
 		__le32 __iomem **port_array,
 		u16 wIndex, u32 raw_port_status,
-		unsigned long flags)
+		unsigned long *flags)
 	__releases(&xhci->lock)
 	__acquires(&xhci->lock)
 {
@@ -786,12 +786,12 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 			xhci_set_link_state(xhci, port_array, wIndex,
 					XDEV_U0);
 
-			spin_unlock_irqrestore(&xhci->lock, flags);
+			spin_unlock_irqrestore(&xhci->lock, *flags);
 			time_left = wait_for_completion_timeout(
 					&bus_state->rexit_done[wIndex],
 					msecs_to_jiffies(
 						XHCI_MAX_REXIT_TIMEOUT_MS));
-			spin_lock_irqsave(&xhci->lock, flags);
+			spin_lock_irqsave(&xhci->lock, *flags);
 
 			if (time_left) {
 				slot_id = xhci_find_slot_id_by_port(hcd,
@@ -937,7 +937,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			break;
 		}
 		status = xhci_get_port_status(hcd, bus_state, port_array,
-				wIndex, temp, flags);
+				wIndex, temp, &flags);
 		if (status == 0xffffffff)
 			goto error;
 
-- 
2.20.1



