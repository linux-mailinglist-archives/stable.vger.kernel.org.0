Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A6D147D44
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbgAXJ6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgAXJ6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:58:51 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E39DE20709;
        Fri, 24 Jan 2020 09:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859930;
        bh=u1WkSyoL9u4fM3PwEXoSRjeYvXZfk8P71aNKex/LgUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNoTh1ULOrQvLchRkH+mRg/ZqH/0yQLpGbMUrFhHhbmtLvJ7Gjj7jzar5cRKdb6gJ
         0R80MwN5vpiZ35hPFU/EdQZTy2gReO9YzDZLyXDaWuSNkRWtTYAabMthYrFgpfoq6d
         P2ouxl7Efew6qiJ1J50It//VOIiAp5iPVfL6sZe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 223/343] PCI: PM: Avoid possible suspend-to-idle issue
Date:   Fri, 24 Jan 2020 10:30:41 +0100
Message-Id: <20200124092949.375590396@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d491f2b75237ef37d8867830ab7fad8d9659e853 ]

If a PCI driver leaves the device handled by it in D0 and calls
pci_save_state() on the device in its ->suspend() or ->suspend_late()
callback, it can expect the device to stay in D0 over the whole
s2idle cycle.  However, that may not be the case if there is a
spurious wakeup while the system is suspended, because in that case
pci_pm_suspend_noirq() will run again after pci_pm_resume_noirq()
which calls pci_restore_state(), via pci_pm_default_resume_early(),
so state_saved is cleared and the second iteration of
pci_pm_suspend_noirq() will invoke pci_prepare_to_sleep() which
may change the power state of the device.

To avoid that, add a new internal flag, skip_bus_pm, that will be set
by pci_pm_suspend_noirq() when it runs for the first time during the
given system suspend-resume cycle if the state of the device has
been saved already and the device is still in D0.  Setting that flag
will cause the next iterations of pci_pm_suspend_noirq() to set
state_saved for pci_pm_resume_noirq(), so that it always restores the
device state from the originally saved data, and avoid calling
pci_prepare_to_sleep() for the device.

Fixes: 33e4f80ee69b ("ACPI / PM: Ignore spurious SCI wakeups from suspend-to-idle")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 17 ++++++++++++++++-
 include/linux/pci.h      |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 522e59274b5d0..1589a147c5364 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -728,6 +728,8 @@ static int pci_pm_suspend(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
+	pci_dev->skip_bus_pm = false;
+
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_SUSPEND);
 
@@ -801,7 +803,20 @@ static int pci_pm_suspend_noirq(struct device *dev)
 		}
 	}
 
-	if (!pci_dev->state_saved) {
+	if (pci_dev->skip_bus_pm) {
+		/*
+		 * The function is running for the second time in a row without
+		 * going through full resume, which is possible only during
+		 * suspend-to-idle in a spurious wakeup case.  Moreover, the
+		 * device was originally left in D0, so its power state should
+		 * not be changed here and the device register values saved
+		 * originally should be restored on resume again.
+		 */
+		pci_dev->state_saved = true;
+	} else if (pci_dev->state_saved) {
+		if (pci_dev->current_state == PCI_D0)
+			pci_dev->skip_bus_pm = true;
+	} else {
 		pci_save_state(pci_dev);
 		if (pci_power_manageable(pci_dev))
 			pci_prepare_to_sleep(pci_dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 59f4d10568c65..430f3c335446e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -346,6 +346,7 @@ struct pci_dev {
 						   D3cold, not set for devices
 						   powered on/off by the
 						   corresponding bridge */
+	unsigned int	skip_bus_pm:1;	/* Internal: Skip bus-level PM */
 	unsigned int	ignore_hotplug:1;	/* Ignore hotplug events */
 	unsigned int	hotplug_user_indicators:1; /* SlotCtl indicators
 						      controlled exclusively by
-- 
2.20.1



