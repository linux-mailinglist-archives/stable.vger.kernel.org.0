Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9381BCA37
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgD1SsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729842AbgD1SlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:41:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A11F2076A;
        Tue, 28 Apr 2020 18:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099283;
        bh=lXv8GvFJ5TXg/OJvEjNdWkFA+38PmRAfdEtTJ/mfdWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkgTLuEHDXG/R8Y/VOWv1bXuVmswpSOhkfCZqhAnMOAFPzvxx5B6IFMZCmHU3hzuJ
         TR+qyVBP9lsGt18S7vMevRxDLUn6vthsa7xsFezJgplTZu1NJgKMZ7QJVJhVleMwW3
         ZwmXnKK8H/cYDM/hjKbhEv6Rk8aOgfcrPpycAFHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 128/131] xhci: prevent bus suspend if a roothub port detected a over-current condition
Date:   Tue, 28 Apr 2020 20:25:40 +0200
Message-Id: <20200428182241.423544899@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit e9fb08d617bfae5471d902112667d0eeb9dee3c4 upstream.

Suspending the bus and host controller while a port is in a over-current
condition may halt the host.
Also keep the roothub running if over-current is active.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200421140822.28233-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-hub.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1481,6 +1481,8 @@ int xhci_hub_status_data(struct usb_hcd
 		}
 		if ((temp & PORT_RC))
 			reset_change = true;
+		if (temp & PORT_OC)
+			status = 1;
 	}
 	if (!status && !reset_change) {
 		xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
@@ -1546,6 +1548,13 @@ retry:
 				 port_index);
 			goto retry;
 		}
+		/* bail out if port detected a over-current condition */
+		if (t1 & PORT_OC) {
+			bus_state->bus_suspended = 0;
+			spin_unlock_irqrestore(&xhci->lock, flags);
+			xhci_dbg(xhci, "Bus suspend bailout, port over-current detected\n");
+			return -EBUSY;
+		}
 		/* suspend ports in U0, or bail out for new connect changes */
 		if ((t1 & PORT_PE) && (t1 & PORT_PLS_MASK) == XDEV_U0) {
 			if ((t1 & PORT_CSC) && wake_enabled) {


