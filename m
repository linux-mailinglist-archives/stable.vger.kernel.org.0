Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F6317FC08
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbgCJNSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730876AbgCJNLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:11:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF5824649;
        Tue, 10 Mar 2020 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845861;
        bh=V8sW1L2DUH/z4U3zVXfsxDO+qGRwv2AuKWrOLPt7x/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JL80NatpWPhqgHQ9zrMcxQhl3OOBH0XKUitH23HtonbEsT9Qz8mLWCyxgKS7MDU3l
         KlTEYBMfv9FxE34GvskJA+lgXu9Wt+FcVvJm109Dj3N793ZQNk/dXjm64r4DzMoi9w
         /NezjrzbAEZ9D6BTmpPpWmVvYn/Yd78Dgsb98c6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Jack Pham <jackp@codeaurora.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH 4.14 126/126] xhci: handle port status events for removed USB3 hcd
Date:   Tue, 10 Mar 2020 13:42:27 +0100
Message-Id: <20200310124211.430808842@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 1245374e9b8340fc255fd51b2015173a83050d03 upstream.

At xhci removal the USB3 hcd (shared_hcd) is removed before the primary
USB2 hcd. Interrupts for port status changes may still occur for USB3
ports after the shared_hcd is freed, causing  NULL pointer dereference.

Check if xhci->shared_hcd is still valid before handing USB3 port events

Cc: <stable@vger.kernel.org>
Reported-by: Peter Chen <peter.chen@nxp.com>
Tested-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Macpaul Lin <macpaul.lin@mediatek.com>
[redone for 4.14.y based on Mathias's comments]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1640,6 +1640,12 @@ static void handle_port_status(struct xh
 	if ((major_revision == 0x03) != (hcd->speed >= HCD_USB3))
 		hcd = xhci->shared_hcd;
 
+	if (!hcd) {
+		xhci_dbg(xhci, "No hcd found for port %u event\n", port_id);
+		bogus_port_status = true;
+		goto cleanup;
+	}
+
 	if (major_revision == 0) {
 		xhci_warn(xhci, "Event for port %u not in "
 				"Extended Capabilities, ignoring.\n",


