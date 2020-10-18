Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41120291B46
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731102AbgJRT3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732198AbgJRT1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:27:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D63522267;
        Sun, 18 Oct 2020 19:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049274;
        bh=1FLgUbR5eKsXYDDLwvofUli0dXW97O8sLDhbkjbdx+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU+ObNs8TcWgVs4HcDRlsJd1LIhNvFKY40vIHhq4fKkYW0LyMuElXa8sdn+Mvfr2d
         atXiaakFyoCcsL70HJP3hJkjsnLIG0xm9/yiI4OXwQB+V+oj2Ybf4G+PapbeokREoc
         8GeRe+bKlpLPVDhM5Xwu7G+b+84QPy0SMLJo2+Vs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 22/33] usb: ohci: Default to per-port over-current protection
Date:   Sun, 18 Oct 2020 15:27:17 -0400
Message-Id: <20201018192728.4056577-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192728.4056577-1-sashal@kernel.org>
References: <20201018192728.4056577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 27bd3e49fe8e3..07d76d9d4ce1b 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -663,20 +663,24 @@ static int ohci_run (struct ohci_hcd *ohci)
 
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

