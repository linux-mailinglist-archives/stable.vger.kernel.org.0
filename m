Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A1C3B618C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhF1OgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235022AbhF1Oep (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4815861C8E;
        Mon, 28 Jun 2021 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890617;
        bh=LtahQ9gWc2A435DmfktVK9pynBJbqyxjZ7gckmuFY38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQ8uedzM48u5TGLV9OvA3dA+WiBKZIHi/bOu9ynqHR3L8gJ3KKkJkDPVmfoktCOFw
         /B4woPuHVO8fserg2R8LGrYc5p/1mhDSbo4S4jpzpkUNTA23xRfmuv1NG1rDgcnUCw
         fgRVVxpoA83E1X+FPrhlDBiO7dCTspwuy/FZL07ulk3uGaTDdzI7NJ9SiKDIC2RlSP
         x896oUroWxqJVTSqOuih6Eo5CuR/fGKEyiP46STLLCzzFhVp/H8gG6JcmaI+oSJcm1
         eOCDZsBx2Gr2RSn8VOClp668ehMNwCtBndqTX7Z6dwBdF5Z5MuG3/MyDmFMXo/+dTb
         Wk4OeKkaaSAgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Michael <phyre@rogers.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/71] Revert "PCI: PM: Do not read power state in pci_enable_device_flags()"
Date:   Mon, 28 Jun 2021 10:29:05 -0400
Message-Id: <20210628143004.32596-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 4d6035f9bf4ea12776322746a216e856dfe46698 ]

Revert commit 4514d991d992 ("PCI: PM: Do not read power state in
pci_enable_device_flags()") that is reported to cause PCI device
initialization issues on some systems.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213481
Link: https://lore.kernel.org/linux-acpi/YNDoGICcg0V8HhpQ@eldamar.lan
Reported-by: Michael <phyre@rogers.com>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Fixes: 4514d991d992 ("PCI: PM: Do not read power state in pci_enable_device_flags()")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 34a06e89e176..3c3bc9f58498 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1666,11 +1666,21 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 	int err;
 	int i, bars = 0;
 
-	if (atomic_inc_return(&dev->enable_cnt) > 1) {
-		pci_update_current_state(dev, dev->current_state);
-		return 0;		/* already enabled */
+	/*
+	 * Power state could be unknown at this point, either due to a fresh
+	 * boot or a device removal call.  So get the current power state
+	 * so that things like MSI message writing will behave as expected
+	 * (e.g. if the device really is in D0 at enable time).
+	 */
+	if (dev->pm_cap) {
+		u16 pmcsr;
+		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
+		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
 	}
 
+	if (atomic_inc_return(&dev->enable_cnt) > 1)
+		return 0;		/* already enabled */
+
 	bridge = pci_upstream_bridge(dev);
 	if (bridge)
 		pci_enable_bridge(bridge);
-- 
2.30.2

