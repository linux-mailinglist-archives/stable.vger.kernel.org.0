Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B40C1BC8E7
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgD1Sgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730411AbgD1Sgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:36:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91E8B20575;
        Tue, 28 Apr 2020 18:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099009;
        bh=4ZKCqnq3aMeP0p5bGe5j0lm2MElKEZ8zCA5qJu5O/l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQzSsvxYPXe8p6ieKX7U8aHlJ3/aGT4z/dpTGCAEVOz0jYbp6HQEYrUoVfNf4lmKX
         X/7AYWQ73LKCPd4XzMxf5jgZA+JVqM4/UUztCnHdflOTpoD1XX6R7IY8jVp6CRnMGV
         PkeaAuyKXCNKdZqRYemMDPkWdtF7k6qHKWfaubpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/168] PCI/PM: Add pcie_wait_for_link_delay()
Date:   Tue, 28 Apr 2020 20:23:39 +0200
Message-Id: <20200428182237.556526922@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



