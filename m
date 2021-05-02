Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDB1370D1F
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhEBOIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233847AbhEBOH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA19E613E6;
        Sun,  2 May 2021 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964387;
        bh=b/4/snAFzXE0X7t+C86OV+5qWxelrwStOefSSLFUZ7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjS2f8uY8Gw8zAzRvipiSJny4/aEx9dDMKJR+W4SEq7YVG5BDkuxILAWbQJohp+7z
         TOi4jCxTS750TUpbSBcwGaVgtwYQd2BgMqNDwgMM1HNxRc3rd0M/3Az7O/FJCFQPQG
         +MuNWvhRqzf6KIUkM8thABMIFTZR6xtRy0n7SghETimal2NitCyG5je1653DVZw0Uz
         WQJ6fPrXfzDXSDT4SGZhokbm/dVIveL6pkKIQXHxwOfrQIM2eAfFOqiZDnLT9q/i2y
         9/Inb9IB+2ysKqZkM4okAPX6ktHqrW+6HL5cVNO54D7oPqVQeLOcIXCgruLgajnjuZ
         mlFgZh+C4PoQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/10] PCI: PM: Do not read power state in pci_enable_device_flags()
Date:   Sun,  2 May 2021 10:06:15 -0400
Message-Id: <20210502140623.2720479-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140623.2720479-1-sashal@kernel.org>
References: <20210502140623.2720479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 4514d991d99211f225d83b7e640285f29f0755d0 ]

It should not be necessary to update the current_state field of
struct pci_dev in pci_enable_device_flags() before calling
do_pci_enable_device() for the device, because none of the
code between that point and the pci_set_power_state() call in
do_pci_enable_device() invoked later depends on it.

Moreover, doing that is actively harmful in some cases.  For example,
if the given PCI device depends on an ACPI power resource whose _STA
method initially returns 0 ("off"), but the config space of the PCI
device is accessible and the power state retrieved from the
PCI_PM_CTRL register is D0, the current_state field in the struct
pci_dev representing that device will get out of sync with the
power.state of its ACPI companion object and that will lead to
power management issues going forward.

To avoid such issues it is better to leave the current_state value
as is until it is changed to PCI_D0 by do_pci_enable_device() as
appropriate.  However, the power state of the device is not changed
to PCI_D0 if it is already enabled when pci_enable_device_flags()
gets called for it, so update its current_state in that case, but
use pci_update_current_state() covering platform PM too for that.

Link: https://lore.kernel.org/lkml/20210314000439.3138941-1-luzmaximilian@gmail.com/
Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
Tested-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b7f65fc54dc2..22e8172f373d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1328,20 +1328,10 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 	int err;
 	int i, bars = 0;
 
-	/*
-	 * Power state could be unknown at this point, either due to a fresh
-	 * boot or a device removal call.  So get the current power state
-	 * so that things like MSI message writing will behave as expected
-	 * (e.g. if the device really is in D0 at enable time).
-	 */
-	if (dev->pm_cap) {
-		u16 pmcsr;
-		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
-		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
-	}
-
-	if (atomic_inc_return(&dev->enable_cnt) > 1)
+	if (atomic_inc_return(&dev->enable_cnt) > 1) {
+		pci_update_current_state(dev, dev->current_state);
 		return 0;		/* already enabled */
+	}
 
 	bridge = pci_upstream_bridge(dev);
 	if (bridge)
-- 
2.30.2

