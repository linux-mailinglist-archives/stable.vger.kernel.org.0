Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BD413F659
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgAPRFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388409AbgAPRCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B1342073A;
        Thu, 16 Jan 2020 17:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194152;
        bh=NMtzhIfJOHOAtmyYoR7QWOqYodHl2omDYrFFEDvuwAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgPPZVwAfS9d11fp0NkTA/Jgbn0Krawh8k5y2ZBdcxTN4tGBNg2CldsugaXHHCwB+
         W71uTEhMdEtMnOtIf5+sNay+i19fUER2BngReOmDNz88DnrBKamIppkzAYhE9ODf+c
         6PLrmjLanKL4aRccmOW2vGiolBEoQoywNfP7CLrs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 236/671] PCI: Fix "try" semantics of bus and slot reset
Date:   Thu, 16 Jan 2020 11:52:25 -0500
Message-Id: <20200116165940.10720-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit ddefc033eecf23f1e8b81d0663c5db965adf5516 ]

The commit referenced below introduced device locking around save and
restore of state for each device during a PCI bus "try" reset, making it
decidely non-"try" and prone to deadlock in the event that a device is
already locked.  Restore __pci_reset_bus() and __pci_reset_slot() to their
advertised locking semantics by pushing the save and restore functions into
the branch where the entire tree is already locked.  Extend the helper
function names with "_locked" and update the comment to reflect this
calling requirement.

Fixes: b014e96d1abb ("PCI: Protect pci_error_handlers->reset_notify() usage with device_lock()")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 54 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c9f51fc24563..57a87a001b4f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5039,39 +5039,42 @@ static int pci_slot_trylock(struct pci_slot *slot)
 	return 0;
 }
 
-/* Save and disable devices from the top of the tree down */
-static void pci_bus_save_and_disable(struct pci_bus *bus)
+/*
+ * Save and disable devices from the top of the tree down while holding
+ * the @dev mutex lock for the entire tree.
+ */
+static void pci_bus_save_and_disable_locked(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		pci_dev_lock(dev);
 		pci_dev_save_and_disable(dev);
-		pci_dev_unlock(dev);
 		if (dev->subordinate)
-			pci_bus_save_and_disable(dev->subordinate);
+			pci_bus_save_and_disable_locked(dev->subordinate);
 	}
 }
 
 /*
- * Restore devices from top of the tree down - parent bridges need to be
- * restored before we can get to subordinate devices.
+ * Restore devices from top of the tree down while holding @dev mutex lock
+ * for the entire tree.  Parent bridges need to be restored before we can
+ * get to subordinate devices.
  */
-static void pci_bus_restore(struct pci_bus *bus)
+static void pci_bus_restore_locked(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		pci_dev_lock(dev);
 		pci_dev_restore(dev);
-		pci_dev_unlock(dev);
 		if (dev->subordinate)
-			pci_bus_restore(dev->subordinate);
+			pci_bus_restore_locked(dev->subordinate);
 	}
 }
 
-/* Save and disable devices from the top of the tree down */
-static void pci_slot_save_and_disable(struct pci_slot *slot)
+/*
+ * Save and disable devices from the top of the tree down while holding
+ * the @dev mutex lock for the entire tree.
+ */
+static void pci_slot_save_and_disable_locked(struct pci_slot *slot)
 {
 	struct pci_dev *dev;
 
@@ -5080,26 +5083,25 @@ static void pci_slot_save_and_disable(struct pci_slot *slot)
 			continue;
 		pci_dev_save_and_disable(dev);
 		if (dev->subordinate)
-			pci_bus_save_and_disable(dev->subordinate);
+			pci_bus_save_and_disable_locked(dev->subordinate);
 	}
 }
 
 /*
- * Restore devices from top of the tree down - parent bridges need to be
- * restored before we can get to subordinate devices.
+ * Restore devices from top of the tree down while holding @dev mutex lock
+ * for the entire tree.  Parent bridges need to be restored before we can
+ * get to subordinate devices.
  */
-static void pci_slot_restore(struct pci_slot *slot)
+static void pci_slot_restore_locked(struct pci_slot *slot)
 {
 	struct pci_dev *dev;
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
-		pci_dev_lock(dev);
 		pci_dev_restore(dev);
-		pci_dev_unlock(dev);
 		if (dev->subordinate)
-			pci_bus_restore(dev->subordinate);
+			pci_bus_restore_locked(dev->subordinate);
 	}
 }
 
@@ -5158,17 +5160,15 @@ static int __pci_reset_slot(struct pci_slot *slot)
 	if (rc)
 		return rc;
 
-	pci_slot_save_and_disable(slot);
-
 	if (pci_slot_trylock(slot)) {
+		pci_slot_save_and_disable_locked(slot);
 		might_sleep();
 		rc = pci_reset_hotplug_slot(slot->hotplug, 0);
+		pci_slot_restore_locked(slot);
 		pci_slot_unlock(slot);
 	} else
 		rc = -EAGAIN;
 
-	pci_slot_restore(slot);
-
 	return rc;
 }
 
@@ -5254,17 +5254,15 @@ static int __pci_reset_bus(struct pci_bus *bus)
 	if (rc)
 		return rc;
 
-	pci_bus_save_and_disable(bus);
-
 	if (pci_bus_trylock(bus)) {
+		pci_bus_save_and_disable_locked(bus);
 		might_sleep();
 		rc = pci_bridge_secondary_bus_reset(bus->self);
+		pci_bus_restore_locked(bus);
 		pci_bus_unlock(bus);
 	} else
 		rc = -EAGAIN;
 
-	pci_bus_restore(bus);
-
 	return rc;
 }
 
-- 
2.20.1

