Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A870739F09
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfFHLko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbfFHLkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E486214AF;
        Sat,  8 Jun 2019 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994042;
        bh=noleOwUoIG5PHZLpaj98UPxKciN2J1xZrQuRDb+DVgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUvbbr4dOX8hvUsYK1SHen+s4A+Nz/7g0DfkiVMqvtupoP7ZS0irZ+OXqzk1zzM9l
         luIxpbdtM7ssy6jQ6vRK24sm32DaeMG3acXBpcwmubazApf9FlthrbC0pZD8xsX9+5
         dvKoim2wz0cI1U7sjDw5hkmNJqYIjauem+eE/gIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 33/70] ACPI/PCI: PM: Add missing wakeup.flags.valid checks
Date:   Sat,  8 Jun 2019 07:39:12 -0400
Message-Id: <20190608113950.8033-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 9a51c6b1f9e0239a9435db036b212498a2a3b75c ]

Both acpi_pci_need_resume() and acpi_dev_needs_resume() check if the
current ACPI wakeup configuration of the device matches what is
expected as far as system wakeup from sleep states is concerned, as
reflected by the device_may_wakeup() return value for the device.

However, they only should do that if wakeup.flags.valid is set for
the device's ACPI companion, because otherwise the wakeup.prepare_count
value for it is meaningless.

Add the missing wakeup.flags.valid checks to these functions.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_pm.c | 4 ++--
 drivers/pci/pci-acpi.c   | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 824ae985ad93..ccb59768b1f3 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -949,8 +949,8 @@ static bool acpi_dev_needs_resume(struct device *dev, struct acpi_device *adev)
 	u32 sys_target = acpi_target_system_state();
 	int ret, state;
 
-	if (!pm_runtime_suspended(dev) || !adev ||
-	    device_may_wakeup(dev) != !!adev->wakeup.prepare_count)
+	if (!pm_runtime_suspended(dev) || !adev || (adev->wakeup.flags.valid &&
+	    device_may_wakeup(dev) != !!adev->wakeup.prepare_count))
 		return true;
 
 	if (sys_target == ACPI_STATE_S0)
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index e1949f7efd9c..bf32fde328c2 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -666,7 +666,8 @@ static bool acpi_pci_need_resume(struct pci_dev *dev)
 	if (!adev || !acpi_device_power_manageable(adev))
 		return false;
 
-	if (device_may_wakeup(&dev->dev) != !!adev->wakeup.prepare_count)
+	if (adev->wakeup.flags.valid &&
+	    device_may_wakeup(&dev->dev) != !!adev->wakeup.prepare_count)
 		return true;
 
 	if (acpi_target_system_state() == ACPI_STATE_S0)
-- 
2.20.1

