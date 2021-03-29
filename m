Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4990334DABD
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhC2WX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231926AbhC2WWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF08561989;
        Mon, 29 Mar 2021 22:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056571;
        bh=FQDotDYB2kx0DiCenCNSx/Ze6Fyb9n9SGNI8bgThfK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDMowY99yTNcg4/ztiipy8f3tN1iZpRhjxRDuYxNoxkiEusXvS1KfEkLJ2BWre4B/
         x+YQU+XM1PvhC6heBGPkIcYCEQoU5d51u4846A3SPH4kKc+xq8/MUQb9QeeALtGe2T
         DuAbswZgoduP1XzYKzUSo/QB/PiK2UOhpVe91z8qF+I9PErgwLusdyZjVJYHgYWkIq
         YvDTdJ5Mn6A6l7wpiaCDClxjEF5W9aSyCQie9ribXyXJCvrwQhjYCAQuQ4bWr0RA80
         ynd9clJRnCfhl0kUONB0hHlgHGUPk9FzAzXiFqblobUbcsklBHa1tmMceJnH8HvWQn
         G4tOdlXi9UCcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David E. Box" <david.e.box@linux.intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/33] platform/x86: intel_pmc_core: Ignore GBE LTR on Tiger Lake platforms
Date:   Mon, 29 Mar 2021 18:22:12 -0400
Message-Id: <20210329222222.2382987-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

[ Upstream commit d1635448f1105e549b4041aab930dbc6945fc635 ]

Due to a HW limitation, the Latency Tolerance Reporting (LTR) value
programmed in the Tiger Lake GBE controller is not large enough to allow
the platform to enter Package C10, which in turn prevents the platform from
achieving its low power target during suspend-to-idle.  Ignore the GBE LTR
value on Tiger Lake. LTR ignore functionality is currently performed solely
by a debugfs write call. Split out the LTR code into its own function that
can be called by both the debugfs writer and by this work around.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Sasha Neftin <sasha.neftin@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Link: https://lore.kernel.org/r/20210319201844.3305399-2-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 50 +++++++++++++++++++--------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index 3e5fe66333f1..e06b36e87a33 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -863,34 +863,45 @@ static int pmc_core_pll_show(struct seq_file *s, void *unused)
 }
 DEFINE_SHOW_ATTRIBUTE(pmc_core_pll);
 
-static ssize_t pmc_core_ltr_ignore_write(struct file *file,
-					 const char __user *userbuf,
-					 size_t count, loff_t *ppos)
+static int pmc_core_send_ltr_ignore(u32 value)
 {
 	struct pmc_dev *pmcdev = &pmc;
 	const struct pmc_reg_map *map = pmcdev->map;
-	u32 val, buf_size, fd;
-	int err;
-
-	buf_size = count < 64 ? count : 64;
-
-	err = kstrtou32_from_user(userbuf, buf_size, 10, &val);
-	if (err)
-		return err;
+	u32 reg;
+	int err = 0;
 
 	mutex_lock(&pmcdev->lock);
 
-	if (val > map->ltr_ignore_max) {
+	if (value > map->ltr_ignore_max) {
 		err = -EINVAL;
 		goto out_unlock;
 	}
 
-	fd = pmc_core_reg_read(pmcdev, map->ltr_ignore_offset);
-	fd |= (1U << val);
-	pmc_core_reg_write(pmcdev, map->ltr_ignore_offset, fd);
+	reg = pmc_core_reg_read(pmcdev, map->ltr_ignore_offset);
+	reg |= BIT(value);
+	pmc_core_reg_write(pmcdev, map->ltr_ignore_offset, reg);
 
 out_unlock:
 	mutex_unlock(&pmcdev->lock);
+
+	return err;
+}
+
+static ssize_t pmc_core_ltr_ignore_write(struct file *file,
+					 const char __user *userbuf,
+					 size_t count, loff_t *ppos)
+{
+	u32 buf_size, value;
+	int err;
+
+	buf_size = min_t(u32, count, 64);
+
+	err = kstrtou32_from_user(userbuf, buf_size, 10, &value);
+	if (err)
+		return err;
+
+	err = pmc_core_send_ltr_ignore(value);
+
 	return err == 0 ? count : err;
 }
 
@@ -1244,6 +1255,15 @@ static int pmc_core_probe(struct platform_device *pdev)
 	pmcdev->pmc_xram_read_bit = pmc_core_check_read_lock_bit();
 	dmi_check_system(pmc_core_dmi_table);
 
+	/*
+	 * On TGL, due to a hardware limitation, the GBE LTR blocks PC10 when
+	 * a cable is attached. Tell the PMC to ignore it.
+	 */
+	if (pmcdev->map == &tgl_reg_map) {
+		dev_dbg(&pdev->dev, "ignoring GBE LTR\n");
+		pmc_core_send_ltr_ignore(3);
+	}
+
 	pmc_core_dbgfs_register(pmcdev);
 
 	device_initialized = true;
-- 
2.30.1

