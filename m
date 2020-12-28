Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16412E3941
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388080AbgL1NVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:21:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387952AbgL1NVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:21:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B4E02076D;
        Mon, 28 Dec 2020 13:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161658;
        bh=sgF4Q3ov+2pWL1fm3BA2gwI9U7s0BINqtbqU6jWGU90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFgFJDcjgWmXZICtwobBxJjxex110x5mRNcUuTsI5faXpbX51kNgqt64VXAjgBqal
         GtNKuKgoo3SdsaCIKd2iK6Qs/zpjHme42lPdM/ozhfeFWohnytd3gcVcO9Hy+bJKQI
         jIyLmkT1Jnn+nJ33MuTDExcxaksRntLQPjja6HL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 043/346] xhci: Give USB2 ports time to enter U3 in bus suspend
Date:   Mon, 28 Dec 2020 13:46:02 +0100
Message-Id: <20201228124921.872006343@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
@@ -1617,6 +1617,10 @@ retry:
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
 	spin_unlock_irqrestore(&xhci->lock, flags);
+
+	if (bus_state->bus_suspended)
+		usleep_range(5000, 10000);
+
 	return 0;
 }
 


