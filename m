Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5373785B0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhEJLBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhEJK4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88F436157E;
        Mon, 10 May 2021 10:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643605;
        bh=xoj/v+TXr1cQ6UwFZAfzsBmRusB6teJiPeKzDHG8t+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAaEYD3fhzgigYJO59wdDICUorcbeKBKKxDmcAKtK+MBDqDaDAv+S4DeSfKw35eog
         9K0v6/3PSqAhJU3gVjav030te9gIL5oyFlh9BhKjZwptrs021V/7wa6wds2R9doVyn
         Gw3vQJPjmm8Nbc7Df/DZ9u54mANWoF2cT9jPgOGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 082/342] PCI: PM: Do not read power state in pci_enable_device_flags()
Date:   Mon, 10 May 2021 12:17:52 +0200
Message-Id: <20210510102012.831225917@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
index 9449dfde2841..5ddc27d9a275 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1870,20 +1870,10 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
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



