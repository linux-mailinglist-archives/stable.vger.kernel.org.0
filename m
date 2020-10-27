Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287F629C37D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822090AbgJ0Rqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759074AbgJ0O1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:27:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A967520754;
        Tue, 27 Oct 2020 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808857;
        bh=YNwQ6Ze39AVqmfLlksSIwX/NztCfIeUM3KP2u0kCeKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unQIkpUYN+dzdjdg+qIJhnOVhm51Z0PxhOyMn/BMTeC7X/EgZFL5yeTtgHssyJl3W
         Y8cXUOLOLjQ4s3Pm1PrakRw1Xikp/JjXkUjGTlmaeuqOLuhsxy3qzx+uMt1meqN1ki
         Y/WDiosVjMCqe1ZyQEfaTx2hamnWVJawE2ia231o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/264] usb: ohci: Default to per-port over-current protection
Date:   Tue, 27 Oct 2020 14:55:01 +0100
Message-Id: <20201027135442.071804286@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

[ Upstream commit b77d2a0a223bc139ee8904991b2922d215d02636 ]

Some integrated OHCI controller hubs do not expose all ports of the hub
to pins on the SoC. In some cases the unconnected ports generate
spurious over-current events. For example the Broadcom 56060/Ranger 2 SoC
contains a nominally 3 port hub but only the first port is wired.

Default behaviour for ohci-platform driver is to use global over-current
protection mode (AKA "ganged"). This leads to the spurious over-current
events affecting all ports in the hub.

We now alter the default to use per-port over-current protection.

This patch results in the following configuration changes depending
on quirks:
- For quirk OHCI_QUIRK_SUPERIO no changes. These systems remain set up
  for ganged power switching and no over-current protection.
- For quirk OHCI_QUIRK_AMD756 or OHCI_QUIRK_HUB_POWER power switching
  remains at none, while over-current protection is now guaranteed to be
  set to per-port rather than the previous behaviour where it was either
  none or global over-current protection depending on the value at
  function entry.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20200910212512.16670-1-hamish.martin@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-hcd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index af11887f5f9e4..e88486d8084af 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -665,20 +665,24 @@ static int ohci_run (struct ohci_hcd *ohci)
 
 	/* handle root hub init quirks ... */
 	val = roothub_a (ohci);
-	val &= ~(RH_A_PSM | RH_A_OCPM);
+	/* Configure for per-port over-current protection by default */
+	val &= ~RH_A_NOCP;
+	val |= RH_A_OCPM;
 	if (ohci->flags & OHCI_QUIRK_SUPERIO) {
-		/* NSC 87560 and maybe others */
+		/* NSC 87560 and maybe others.
+		 * Ganged power switching, no over-current protection.
+		 */
 		val |= RH_A_NOCP;
-		val &= ~(RH_A_POTPGT | RH_A_NPS);
-		ohci_writel (ohci, val, &ohci->regs->roothub.a);
+		val &= ~(RH_A_POTPGT | RH_A_NPS | RH_A_PSM | RH_A_OCPM);
 	} else if ((ohci->flags & OHCI_QUIRK_AMD756) ||
 			(ohci->flags & OHCI_QUIRK_HUB_POWER)) {
 		/* hub power always on; required for AMD-756 and some
-		 * Mac platforms.  ganged overcurrent reporting, if any.
+		 * Mac platforms.
 		 */
 		val |= RH_A_NPS;
-		ohci_writel (ohci, val, &ohci->regs->roothub.a);
 	}
+	ohci_writel(ohci, val, &ohci->regs->roothub.a);
+
 	ohci_writel (ohci, RH_HS_LPSC, &ohci->regs->roothub.status);
 	ohci_writel (ohci, (val & RH_A_NPS) ? 0 : RH_B_PPCM,
 						&ohci->regs->roothub.b);
-- 
2.25.1



