Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1E213F455
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389697AbgAPRJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:09:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389689AbgAPRJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C19B24686;
        Thu, 16 Jan 2020 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194569;
        bh=aFuI9s9qrYGvRS3aJIBpExQNugQRFOhhIn8THPtBKoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6Wwm9cfTpwTEcc321Q2yGt7PJg9zR1zcxvro7wJCQCwpbYJ9CN3zB5HSdZb2u03A
         FjsznxaEvP+2INjOWgjUZb7H7HqUPAFVtDiEYrtxyFUUUa9f9L6qXOIbwsr/ukV//t
         ZYcIlPFZoU66wqlVewQfSOGqZG1krmDDSHk4ydcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Robert R . Howell" <RHowell@uwyo.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 447/671] PM: ACPI/PCI: Resume all devices during hibernation
Date:   Thu, 16 Jan 2020 12:01:25 -0500
Message-Id: <20200116170509.12787-184-sashal@kernel.org>
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

[ Upstream commit 501debd4aa5edc755037c39ea5a8fba23b41e580 ]

Both the PCI bus type and the ACPI PM domain avoid resuming
runtime-suspended devices with DPM_FLAG_SMART_SUSPEND set during
hibernation (before creating the snapshot image of system memory),
but that turns out to be a mistake.  It leads to functional issues
and adds complexity that's hard to justify.

For this reason, resume all runtime-suspended PCI devices and all
devices in the ACPI PM domains before creating a snapshot image of
system memory during hibernation.

Fixes: 05087360fd7a (ACPI / PM: Take SMART_SUSPEND driver flag into account)
Fixes: c4b65157aeef (PCI / PM: Take SMART_SUSPEND driver flag into account)
Link: https://lore.kernel.org/linux-acpi/917d4399-2e22-67b1-9d54-808561f9083f@uwyo.edu/T/#maf065fe6e4974f2a9d79f332ab99dfaba635f64c
Reported-by: Robert R. Howell <RHowell@uwyo.edu>
Tested-by: Robert R. Howell <RHowell@uwyo.edu>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_pm.c | 13 +++++++------
 drivers/pci/pci-driver.c | 16 ++++++++--------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index e0927c5fd282..11b7a1632e5a 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1116,13 +1116,14 @@ EXPORT_SYMBOL_GPL(acpi_subsys_resume_early);
 int acpi_subsys_freeze(struct device *dev)
 {
 	/*
-	 * This used to be done in acpi_subsys_prepare() for all devices and
-	 * some drivers may depend on it, so do it here.  Ideally, however,
-	 * runtime-suspended devices should not be touched during freeze/thaw
-	 * transitions.
+	 * Resume all runtime-suspended devices before creating a snapshot
+	 * image of system memory, because the restore kernel generally cannot
+	 * be expected to always handle them consistently and they need to be
+	 * put into the runtime-active metastate during system resume anyway,
+	 * so it is better to ensure that the state saved in the image will be
+	 * always consistent with that.
 	 */
-	if (!dev_pm_test_driver_flags(dev, DPM_FLAG_SMART_SUSPEND))
-		pm_runtime_resume(dev);
+	pm_runtime_resume(dev);
 
 	return pm_generic_freeze(dev);
 }
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index e69af9b8361d..5def4b74d54a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -996,15 +996,15 @@ static int pci_pm_freeze(struct device *dev)
 	}
 
 	/*
-	 * This used to be done in pci_pm_prepare() for all devices and some
-	 * drivers may depend on it, so do it here.  Ideally, runtime-suspended
-	 * devices should not be touched during freeze/thaw transitions,
-	 * however.
+	 * Resume all runtime-suspended devices before creating a snapshot
+	 * image of system memory, because the restore kernel generally cannot
+	 * be expected to always handle them consistently and they need to be
+	 * put into the runtime-active metastate during system resume anyway,
+	 * so it is better to ensure that the state saved in the image will be
+	 * always consistent with that.
 	 */
-	if (!dev_pm_smart_suspend_and_suspended(dev)) {
-		pm_runtime_resume(dev);
-		pci_dev->state_saved = false;
-	}
+	pm_runtime_resume(dev);
+	pci_dev->state_saved = false;
 
 	if (pm->freeze) {
 		int error;
-- 
2.20.1

