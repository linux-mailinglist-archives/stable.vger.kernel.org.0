Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBCD13F4AC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389483AbgAPRIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389464AbgAPRIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89C3B24685;
        Thu, 16 Jan 2020 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194521;
        bh=qGCvbFL5fX//JsOK2d4ucXPkoRsm4vNcS0c4doK2kGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKuemI4Nbw13GBzN+hv2i0EepCrU+H/koeP6WmViGvn/yirfBpzDRZ2UAQ4v+KIbg
         AdKURLKl8zaJMC7v2bZhdA8/t4VN+c2jy6cqU15+6CMjpkZ+4lNzD5DdcVGLwUPefY
         gCASUBGC/wHOr6klT548y2annMWxxoN/h4oOqkeU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 412/671] PCI: PM: Skip devices in D0 for suspend-to-idle
Date:   Thu, 16 Jan 2020 12:00:50 -0500
Message-Id: <20200116170509.12787-149-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 3e26c5feed2add218046ecf91bab3cfa9bf762a6 ]

Commit d491f2b75237 ("PCI: PM: Avoid possible suspend-to-idle issue")
attempted to avoid a problem with devices whose drivers want them to
stay in D0 over suspend-to-idle and resume, but it did not go as far
as it should with that.

Namely, first of all, the power state of a PCI bridge with a
downstream device in D0 must be D0 (based on the PCI PM spec r1.2,
sec 6, table 6-1, if the bridge is not in D0, there can be no PCI
transactions on its secondary bus), but that is not actively enforced
during system-wide PM transitions, so use the skip_bus_pm flag
introduced by commit d491f2b75237 for that.

Second, the configuration of devices left in D0 (whatever the reason)
during suspend-to-idle need not be changed and attempting to put them
into D0 again by force is pointless, so explicitly avoid doing that.

Fixes: d491f2b75237 ("PCI: PM: Avoid possible suspend-to-idle issue")
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 47 ++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 5c9873fcbd08..e69af9b8361d 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -526,7 +526,6 @@ static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 	pci_power_up(pci_dev);
 	pci_restore_state(pci_dev);
 	pci_pme_restore(pci_dev);
-	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 }
 
 /*
@@ -833,18 +832,16 @@ static int pci_pm_suspend_noirq(struct device *dev)
 
 	if (pci_dev->skip_bus_pm) {
 		/*
-		 * The function is running for the second time in a row without
+		 * Either the device is a bridge with a child in D0 below it, or
+		 * the function is running for the second time in a row without
 		 * going through full resume, which is possible only during
-		 * suspend-to-idle in a spurious wakeup case.  Moreover, the
-		 * device was originally left in D0, so its power state should
-		 * not be changed here and the device register values saved
-		 * originally should be restored on resume again.
+		 * suspend-to-idle in a spurious wakeup case.  The device should
+		 * be in D0 at this point, but if it is a bridge, it may be
+		 * necessary to save its state.
 		 */
-		pci_dev->state_saved = true;
-	} else if (pci_dev->state_saved) {
-		if (pci_dev->current_state == PCI_D0)
-			pci_dev->skip_bus_pm = true;
-	} else {
+		if (!pci_dev->state_saved)
+			pci_save_state(pci_dev);
+	} else if (!pci_dev->state_saved) {
 		pci_save_state(pci_dev);
 		if (pci_power_manageable(pci_dev))
 			pci_prepare_to_sleep(pci_dev);
@@ -853,6 +850,22 @@ static int pci_pm_suspend_noirq(struct device *dev)
 	dev_dbg(dev, "PCI PM: Suspend power state: %s\n",
 		pci_power_name(pci_dev->current_state));
 
+	if (pci_dev->current_state == PCI_D0) {
+		pci_dev->skip_bus_pm = true;
+		/*
+		 * Per PCI PM r1.2, table 6-1, a bridge must be in D0 if any
+		 * downstream device is in D0, so avoid changing the power state
+		 * of the parent bridge by setting the skip_bus_pm flag for it.
+		 */
+		if (pci_dev->bus->self)
+			pci_dev->bus->self->skip_bus_pm = true;
+	}
+
+	if (pci_dev->skip_bus_pm && !pm_suspend_via_firmware()) {
+		dev_dbg(dev, "PCI PM: Skipped\n");
+		goto Fixup;
+	}
+
 	pci_pm_set_unknown_state(pci_dev);
 
 	/*
@@ -900,7 +913,16 @@ static int pci_pm_resume_noirq(struct device *dev)
 	if (dev_pm_smart_suspend_and_suspended(dev))
 		pm_runtime_set_active(dev);
 
-	pci_pm_default_resume_early(pci_dev);
+	/*
+	 * In the suspend-to-idle case, devices left in D0 during suspend will
+	 * stay in D0, so it is not necessary to restore or update their
+	 * configuration here and attempting to put them into D0 again may
+	 * confuse some firmware, so avoid doing that.
+	 */
+	if (!pci_dev->skip_bus_pm || pm_suspend_via_firmware())
+		pci_pm_default_resume_early(pci_dev);
+
+	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
@@ -1201,6 +1223,7 @@ static int pci_pm_restore_noirq(struct device *dev)
 	}
 
 	pci_pm_default_resume_early(pci_dev);
+	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
-- 
2.20.1

