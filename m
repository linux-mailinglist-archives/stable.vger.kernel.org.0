Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84A23B5FE9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhF1OVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232563AbhF1OVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDE5561C82;
        Mon, 28 Jun 2021 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889921;
        bh=DvIU2tOIquYSUjtpFVLqksYCeHbDH6SIwBl1dW07/kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbKP8CVmhR0DGnBfPQzsCs3kObC9OHQ8wPE75pah5CLM/JTPdxwaofn2AQFP/Ssnf
         /r+Y2Q8BIHER+a2J6jERIsT28cBr9Ot+JWGnjDsCnerfr1kUT8i4JHzIccD+aH0fHl
         aGNFumOnTwHDVYY+IPvw/m23nTmhbffOPx9vzEtnnhzf8+CMq3RlyFln7i13RY4sUv
         VE+6huOugmqpd3CMHDi2cdWKI0vPhyYBOPaAXyt+2NE9O/ldBvBEt9f4ymj0IbTgde
         E3tmytDnqSb9JRvP+FnW0JV60LThoooLLSy4Y0v/qL3h5HTfMYPWtJVtq2FWe6fmpk
         rAY+Nrfum4gdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Michael <phyre@rogers.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 012/110] Revert "PCI: PM: Do not read power state in pci_enable_device_flags()"
Date:   Mon, 28 Jun 2021 10:16:50 -0400
Message-Id: <20210628141828.31757-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index e4d4e399004b..16a17215f633 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1870,11 +1870,21 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
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

