Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2BA2065E1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388520AbgFWVel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388839AbgFWUKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:10:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4142020EDD;
        Tue, 23 Jun 2020 20:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943050;
        bh=R8XjNxWpSIzEbas4dzwJWPRJLJ09C2aTBITyqFatshA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwnVxf1rEifrXHOIN2+BMscapCmeB52gy99gqfzNerMb8wuYWZ4QCBtrjrmvgYSy+
         /dK8Ny/eaEO23gBfxoI7fexNMyhnp+Pb9D17OxxwuPru1FB3Lo2wFidn3Ui/em3PEL
         WC6WfS67OqjJAknq+ZNnF9nn+6cs8wamorttsVBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 209/477] PCI/PM: Assume ports without DLL Link Active train links in 100 ms
Date:   Tue, 23 Jun 2020 21:53:26 +0200
Message-Id: <20200623195417.459387347@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ec411e02b7a2e785a4ed9ed283207cd14f48699d ]

Kai-Heng Feng reported that it takes a long time (> 1 s) to resume
Thunderbolt-connected devices from both runtime suspend and system sleep
(s2idle).

This was because some Downstream Ports that support > 5 GT/s do not also
support Data Link Layer Link Active reporting.  Per PCIe r5.0 sec 6.6.1:

  With a Downstream Port that supports Link speeds greater than 5.0 GT/s,
  software must wait a minimum of 100 ms after Link training completes
  before sending a Configuration Request to the device immediately below
  that Port. Software can determine when Link training completes by polling
  the Data Link Layer Link Active bit or by setting up an associated
  interrupt (see Section 6.7.3.3).

Sec 7.5.3.6 requires such Ports to support DLL Link Active reporting, but
at least the Intel JHL6240 Thunderbolt 3 Bridge [8086:15c0] and the Intel
JHL7540 Thunderbolt 3 Bridge [8086:15ea] do not.

Previously we tried to wait for Link training to complete, but since there
was no DLL Link Active reporting, all we could do was wait the worst-case
1000 ms, then another 100 ms.

Instead of using the supported speeds to determine whether to wait for Link
training, check whether the port supports DLL Link Active reporting.  The
Ports in question do not, so we'll wait only the 100 ms required for Ports
that support Link speeds <= 5 GT/s.

This of course assumes these Ports always train the Link within 100 ms even
if they are operating at > 5 GT/s, which is not required by the spec.

[bhelgaas: commit log, comment]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206837
Link: https://lore.kernel.org/r/20200514133043.27429-1-mika.westerberg@linux.intel.com
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6d3234f756923..809f2584e3384 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4660,7 +4660,8 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
  * pcie_wait_for_link_delay - Wait until link is active or inactive
  * @pdev: Bridge device
  * @active: waiting for active or inactive?
- * @delay: Delay to wait after link has become active (in ms)
+ * @delay: Delay to wait after link has become active (in ms). Specify %0
+ *	   for no delay.
  *
  * Use this to wait till link becomes active or inactive.
  */
@@ -4701,7 +4702,7 @@ static bool pcie_wait_for_link_delay(struct pci_dev *pdev, bool active,
 		msleep(10);
 		timeout -= 10;
 	}
-	if (active && ret)
+	if (active && ret && delay)
 		msleep(delay);
 	else if (ret != active)
 		pci_info(pdev, "Data Link Layer Link Active not %s in 1000 msec\n",
@@ -4822,17 +4823,28 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	if (!pcie_downstream_port(dev))
 		return;
 
-	if (pcie_get_speed_cap(dev) <= PCIE_SPEED_5_0GT) {
-		pci_dbg(dev, "waiting %d ms for downstream link\n", delay);
-		msleep(delay);
-	} else {
-		pci_dbg(dev, "waiting %d ms for downstream link, after activation\n",
-			delay);
-		if (!pcie_wait_for_link_delay(dev, true, delay)) {
+	/*
+	 * Per PCIe r5.0, sec 6.6.1, for downstream ports that support
+	 * speeds > 5 GT/s, we must wait for link training to complete
+	 * before the mandatory delay.
+	 *
+	 * We can only tell when link training completes via DLL Link
+	 * Active, which is required for downstream ports that support
+	 * speeds > 5 GT/s (sec 7.5.3.6).  Unfortunately some common
+	 * devices do not implement Link Active reporting even when it's
+	 * required, so we'll check for that directly instead of checking
+	 * the supported link speed.  We assume devices without Link Active
+	 * reporting can train in 100 ms regardless of speed.
+	 */
+	if (dev->link_active_reporting) {
+		pci_dbg(dev, "waiting for link to train\n");
+		if (!pcie_wait_for_link_delay(dev, true, 0)) {
 			/* Did not train, no need to wait any further */
 			return;
 		}
 	}
+	pci_dbg(child, "waiting %d ms to become accessible\n", delay);
+	msleep(delay);
 
 	if (!pci_device_is_present(child)) {
 		pci_dbg(child, "waiting additional %d ms to become accessible\n", delay);
-- 
2.25.1



