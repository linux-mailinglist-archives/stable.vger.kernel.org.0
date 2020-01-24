Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04171481A7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390870AbgAXLVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390482AbgAXLVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:36 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22EC7206D4;
        Fri, 24 Jan 2020 11:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864895;
        bh=3Ex/mXexqXxXMMGo1YyKzygo6nVNMvVs8fQmSKw30Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHW3U4K1LFpIWsNDUFrckIom88W8l9FWdYvu8wYXCuhGInVO/sTJJ+TitpEYQuERF
         4Xl3tDdeNTbCRLEvt3WDBVVbEkKZseKoqXN403cQ173oUsIPRube/UBbF6D3C1aqlz
         y41L4E56RVyFxlAge2YKxkzOZzECid/v0c8xwBTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 395/639] PCI: PM: Avoid possible suspend-to-idle issue
Date:   Fri, 24 Jan 2020 10:29:25 +0100
Message-Id: <20200124093136.400482106@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index bc1ff41ce3d35..5c9873fcbd08b 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -736,6 +736,8 @@ static int pci_pm_suspend(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
+	pci_dev->skip_bus_pm = false;
+
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_SUSPEND);
 
@@ -829,7 +831,20 @@ static int pci_pm_suspend_noirq(struct device *dev)
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
index b1f297f4b7b0b..94853094b6ef4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -342,6 +342,7 @@ struct pci_dev {
 						   D3cold, not set for devices
 						   powered on/off by the
 						   corresponding bridge */
+	unsigned int	skip_bus_pm:1;	/* Internal: Skip bus-level PM */
 	unsigned int	ignore_hotplug:1;	/* Ignore hotplug events */
 	unsigned int	hotplug_user_indicators:1; /* SlotCtl indicators
 						      controlled exclusively by
-- 
2.20.1



