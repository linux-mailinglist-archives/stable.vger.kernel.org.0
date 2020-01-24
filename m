Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B08148250
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391612AbgAXL06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391203AbgAXL05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:57 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A57520718;
        Fri, 24 Jan 2020 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865216;
        bh=lcD3OYL1oJj/v9xAdAAqjKr3WJXr5132M3qh7cKMe1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pk/zVF9e30MNmt66UpApIbT9UHKKDmMUkSfefUDgPbqUJ6qV5YapdZZwnD6TKxEk1
         JwfCnwkE+lmI6V8giuDp8yXK/dIWBJy5SJsbV3EF6JK9RONvwHHoX03/jA+/56KygI
         CZj7Vw1UTddFi+RxWpTzGpfw2j1sGIiPSaNx3vZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Robert R. Howell" <RHowell@uwyo.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 462/639] PM: ACPI/PCI: Resume all devices during hibernation
Date:   Fri, 24 Jan 2020 10:30:32 +0100
Message-Id: <20200124093145.093330625@linuxfoundation.org>
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
index e0927c5fd2821..11b7a1632e5aa 100644
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
index e69af9b8361dc..5def4b74d54a0 100644
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



