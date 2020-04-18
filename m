Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07C11AF0DA
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgDROww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgDROmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880D222202;
        Sat, 18 Apr 2020 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220928;
        bh=4ZKCqnq3aMeP0p5bGe5j0lm2MElKEZ8zCA5qJu5O/l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7KTMu79CWekh+DAPfy2BnLf61nmYvma36h/K6tdLjMKzLr8L5oLKYEk0IrH+H8LP
         MiFJnG1IpXt8aBKrZMpQG0skowd7qsqsFLSvtXWRRwViTYWa6zCe2ddJAb8X8Q/hNZ
         CnizLvcO4P91yMv9Q/JIg156rOXGhnKWmHgcSFxk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 65/78] PCI/PM: Add pcie_wait_for_link_delay()
Date:   Sat, 18 Apr 2020 10:40:34 -0400
Message-Id: <20200418144047.9013-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 4827d63891b6a839dac49c6ab62e61c4b011c4f2 ]

Add pcie_wait_for_link_delay().  Similar to pcie_wait_for_link() but allows
passing custom activation delay in milliseconds.

Link: https://lore.kernel.org/r/20191112091617.70282-2-mika.westerberg@linux.intel.com
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 981ae16f935bc..94d6e120b4734 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4605,14 +4605,17 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
 
 	return pci_dev_wait(dev, "PM D3->D0", PCIE_RESET_READY_POLL_MS);
 }
+
 /**
- * pcie_wait_for_link - Wait until link is active or inactive
+ * pcie_wait_for_link_delay - Wait until link is active or inactive
  * @pdev: Bridge device
  * @active: waiting for active or inactive?
+ * @delay: Delay to wait after link has become active (in ms)
  *
  * Use this to wait till link becomes active or inactive.
  */
-bool pcie_wait_for_link(struct pci_dev *pdev, bool active)
+static bool pcie_wait_for_link_delay(struct pci_dev *pdev, bool active,
+				     int delay)
 {
 	int timeout = 1000;
 	bool ret;
@@ -4649,13 +4652,25 @@ bool pcie_wait_for_link(struct pci_dev *pdev, bool active)
 		timeout -= 10;
 	}
 	if (active && ret)
-		msleep(100);
+		msleep(delay);
 	else if (ret != active)
 		pci_info(pdev, "Data Link Layer Link Active not %s in 1000 msec\n",
 			active ? "set" : "cleared");
 	return ret == active;
 }
 
+/**
+ * pcie_wait_for_link - Wait until link is active or inactive
+ * @pdev: Bridge device
+ * @active: waiting for active or inactive?
+ *
+ * Use this to wait till link becomes active or inactive.
+ */
+bool pcie_wait_for_link(struct pci_dev *pdev, bool active)
+{
+	return pcie_wait_for_link_delay(pdev, active, 100);
+}
+
 void pci_reset_secondary_bus(struct pci_dev *dev)
 {
 	u16 ctrl;
-- 
2.20.1

