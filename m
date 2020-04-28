Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC23E1BC90D
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgD1SiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730605AbgD1SiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:38:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB28F208E0;
        Tue, 28 Apr 2020 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099092;
        bh=TeaS1cHqlCEkbfMEujQm1NjPPa5FBQpNl0nQJJvqyCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNpkI/OY9kWlvZ8K0+OB0Le8OUAwzMfbk28zupLagcCEpBsGsKWywYjWaI6gwOtrI
         E00rn6Doj8NFVsP1alTj+Y2/EVZ507iukfU4y2dk9X3jv0e9W88bNnlZRfiGANHmUT
         nhBbH9KUUGGAMjVSCQhQOyssCV8jAGCRwLKLovV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.6 154/167] xhci: prevent bus suspend if a roothub port detected a over-current condition
Date:   Tue, 28 Apr 2020 20:25:30 +0200
Message-Id: <20200428182245.044598334@linuxfoundation.org>
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
@@ -1569,6 +1569,8 @@ int xhci_hub_status_data(struct usb_hcd
 		}
 		if ((temp & PORT_RC))
 			reset_change = true;
+		if (temp & PORT_OC)
+			status = 1;
 	}
 	if (!status && !reset_change) {
 		xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
@@ -1634,6 +1636,13 @@ retry:
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


