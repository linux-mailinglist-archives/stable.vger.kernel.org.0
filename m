Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCADB22EF50
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbgG0OPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730682AbgG0OPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:15:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FF420663;
        Mon, 27 Jul 2020 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859317;
        bh=sZJADNEv5yYJ4d0fShCRIvioPpF6lHr/82zsUvW411o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7fNtseREti7SwBR6hy1ugzYdbvAr1inyeU+RCFIJedmOsQvkp7EjTDYmFCi0I1oz
         yszLuAQmjI0oazS/6tj38ENHZSllm7dc4v7XXz+TlVgv6qf1MFdmkYQNzow7uwWnjh
         7piRlC+PK89KWR3etMWyfriOLQcham5qSTHlYhtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Volkerding <volkerdi@gmail.com>,
        Karol Herbst <kherbst@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/138] Revert "PCI/PM: Assume ports without DLL Link Active train links in 100 ms"
Date:   Mon, 27 Jul 2020 16:04:16 +0200
Message-Id: <20200727134928.461807301@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit d08c30d7a0d1826f771f16cde32bd86e48401791 ]

This reverts commit ec411e02b7a2e785a4ed9ed283207cd14f48699d.

Patrick reported that this commit broke hybrid graphics on a ThinkPad X1
Extreme 2nd with Intel UHD Graphics 630 and NVIDIA GeForce GTX 1650 Mobile:

  nouveau 0000:01:00.0: fifo: PBDMA0: 01000000 [] ch 0 [00ff992000 DRM] subc 0 mthd 0008 data 00000000

Karol reported that this commit broke Nouveau firmware loading on a Lenovo
P1G2 with Intel UHD Graphics 630 and NVIDIA TU117GLM [Quadro T1000 Mobile]:

  nouveau 0000:01:00.0: acr: AHESASC binary failed

In both cases, reverting ec411e02b7a2 solved the problem.  Unfortunately,
this revert will reintroduce the "Thunderbolt bridges take long time to
resume from D3cold" problem:
https://bugzilla.kernel.org/show_bug.cgi?id=206837

Link: https://lore.kernel.org/r/CAErSpo5sTeK_my1dEhWp7aHD0xOp87+oHYWkTjbL7ALgDbXo-Q@mail.gmail.com
Link: https://lore.kernel.org/r/CACO55tsAEa5GXw5oeJPG=mcn+qxNvspXreJYWDJGZBy5v82JDA@mail.gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208597
Reported-by: Patrick Volkerding <volkerdi@gmail.com>
Reported-by: Karol Herbst <kherbst@redhat.com>
Fixes: ec411e02b7a2 ("PCI/PM: Assume ports without DLL Link Active train links in 100 ms")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 08f7b1ed8c62e..b1b2c8ddbc927 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4610,8 +4610,7 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
  * pcie_wait_for_link_delay - Wait until link is active or inactive
  * @pdev: Bridge device
  * @active: waiting for active or inactive?
- * @delay: Delay to wait after link has become active (in ms). Specify %0
- *	   for no delay.
+ * @delay: Delay to wait after link has become active (in ms)
  *
  * Use this to wait till link becomes active or inactive.
  */
@@ -4652,7 +4651,7 @@ static bool pcie_wait_for_link_delay(struct pci_dev *pdev, bool active,
 		msleep(10);
 		timeout -= 10;
 	}
-	if (active && ret && delay)
+	if (active && ret)
 		msleep(delay);
 	else if (ret != active)
 		pci_info(pdev, "Data Link Layer Link Active not %s in 1000 msec\n",
@@ -4773,28 +4772,17 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	if (!pcie_downstream_port(dev))
 		return;
 
-	/*
-	 * Per PCIe r5.0, sec 6.6.1, for downstream ports that support
-	 * speeds > 5 GT/s, we must wait for link training to complete
-	 * before the mandatory delay.
-	 *
-	 * We can only tell when link training completes via DLL Link
-	 * Active, which is required for downstream ports that support
-	 * speeds > 5 GT/s (sec 7.5.3.6).  Unfortunately some common
-	 * devices do not implement Link Active reporting even when it's
-	 * required, so we'll check for that directly instead of checking
-	 * the supported link speed.  We assume devices without Link Active
-	 * reporting can train in 100 ms regardless of speed.
-	 */
-	if (dev->link_active_reporting) {
-		pci_dbg(dev, "waiting for link to train\n");
-		if (!pcie_wait_for_link_delay(dev, true, 0)) {
+	if (pcie_get_speed_cap(dev) <= PCIE_SPEED_5_0GT) {
+		pci_dbg(dev, "waiting %d ms for downstream link\n", delay);
+		msleep(delay);
+	} else {
+		pci_dbg(dev, "waiting %d ms for downstream link, after activation\n",
+			delay);
+		if (!pcie_wait_for_link_delay(dev, true, delay)) {
 			/* Did not train, no need to wait any further */
 			return;
 		}
 	}
-	pci_dbg(child, "waiting %d ms to become accessible\n", delay);
-	msleep(delay);
 
 	if (!pci_device_is_present(child)) {
 		pci_dbg(child, "waiting additional %d ms to become accessible\n", delay);
-- 
2.25.1



