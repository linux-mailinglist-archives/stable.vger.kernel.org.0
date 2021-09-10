Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915E4406163
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbhIJAmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232010AbhIJASh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E31261215;
        Fri, 10 Sep 2021 00:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233025;
        bh=6CfwjVaR4AreFF15nKRjmwLM/H6Zw16p/K0HTzsauCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxcK/mDdMMBZUf4xvkLpC96VasaqFLQyCkaGLf7R7YbGZCvfVRBExnFqV5rlp8qXS
         RyJzDgVBBm8UHmQzb1c5O2J7vwn9HabJLUHncmouYOkSB3yH0EH7oJvQuVUH6QfoQd
         EP9G+iXb0+I8ZThJgQ6OXyAups1MdB9J5NfDtsA1fYsIYFcX49RuDXkC8QhaC9Aidy
         lV0MDM/uGZ6uGWKYDmlcRFHAW4zEtZ0HvG0vXKVERD/TyQXTO91smGBzwbiWL6Xt0D
         YozG+p2Vc7QMZonouDkQGBGXhl+5I6KKSqhQSYUQJNQfu703D6hFzm1FCtY38DR7aO
         awNLqD6zEtA3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David E. Box" <david.e.box@linux.intel.com>,
        Evgeny Novikov <novikov@ispras.ru>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 48/99] platform/x86: intel_pmc_core: Prevent possibile overflow
Date:   Thu,  9 Sep 2021 20:15:07 -0400
Message-Id: <20210910001558.173296-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

[ Upstream commit 45b6f75eab6aabf9d88933830f41f532d39f38d2 ]

Substate priority levels are encoded in 4 bits in the LPM_PRI register.
This value was used as an index to an array whose element size was less
than 16, leading to the possibility of overflow should we read a larger
than expected priority.  In addition to the overflow, bad values could lead
to incorrect state reporting.  So rework the priority code to prevent the
overflow and perform some validation of the register. Use the priority
register values if they give an ordering of unique numbers between 0 and
the maximum number of states.  Otherwise, use a default ordering instead.

Reported-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210814014728.520856-1-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 65 +++++++++++++++++++++------
 drivers/platform/x86/intel_pmc_core.h |  2 +
 2 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index b0e486a6bdfb..ae410a358ffe 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -1449,9 +1449,42 @@ static int pmc_core_pkgc_show(struct seq_file *s, void *unused)
 }
 DEFINE_SHOW_ATTRIBUTE(pmc_core_pkgc);
 
-static void pmc_core_get_low_power_modes(struct pmc_dev *pmcdev)
+static bool pmc_core_pri_verify(u32 lpm_pri, u8 *mode_order)
 {
-	u8 lpm_priority[LPM_MAX_NUM_MODES];
+	int i, j;
+
+	if (!lpm_pri)
+		return false;
+	/*
+	 * Each byte contains the priority level for 2 modes (7:4 and 3:0).
+	 * In a 32 bit register this allows for describing 8 modes. Store the
+	 * levels and look for values out of range.
+	 */
+	for (i = 0; i < 8; i++) {
+		int level = lpm_pri & GENMASK(3, 0);
+
+		if (level >= LPM_MAX_NUM_MODES)
+			return false;
+
+		mode_order[i] = level;
+		lpm_pri >>= 4;
+	}
+
+	/* Check that we have unique values */
+	for (i = 0; i < LPM_MAX_NUM_MODES - 1; i++)
+		for (j = i + 1; j < LPM_MAX_NUM_MODES; j++)
+			if (mode_order[i] == mode_order[j])
+				return false;
+
+	return true;
+}
+
+static void pmc_core_get_low_power_modes(struct platform_device *pdev)
+{
+	struct pmc_dev *pmcdev = platform_get_drvdata(pdev);
+	u8 pri_order[LPM_MAX_NUM_MODES] = LPM_DEFAULT_PRI;
+	u8 mode_order[LPM_MAX_NUM_MODES];
+	u32 lpm_pri;
 	u32 lpm_en;
 	int mode, i, p;
 
@@ -1462,24 +1495,28 @@ static void pmc_core_get_low_power_modes(struct pmc_dev *pmcdev)
 	lpm_en = pmc_core_reg_read(pmcdev, pmcdev->map->lpm_en_offset);
 	pmcdev->num_lpm_modes = hweight32(lpm_en);
 
-	/* Each byte contains information for 2 modes (7:4 and 3:0) */
-	for (mode = 0; mode < LPM_MAX_NUM_MODES; mode += 2) {
-		u8 priority = pmc_core_reg_read_byte(pmcdev,
-				pmcdev->map->lpm_priority_offset + (mode / 2));
-		int pri0 = GENMASK(3, 0) & priority;
-		int pri1 = (GENMASK(7, 4) & priority) >> 4;
+	/* Read 32 bit LPM_PRI register */
+	lpm_pri = pmc_core_reg_read(pmcdev, pmcdev->map->lpm_priority_offset);
 
-		lpm_priority[pri0] = mode;
-		lpm_priority[pri1] = mode + 1;
-	}
 
 	/*
-	 * Loop though all modes from lowest to highest priority,
+	 * If lpm_pri value passes verification, then override the default
+	 * modes here. Otherwise stick with the default.
+	 */
+	if (pmc_core_pri_verify(lpm_pri, mode_order))
+		/* Get list of modes in priority order */
+		for (mode = 0; mode < LPM_MAX_NUM_MODES; mode++)
+			pri_order[mode_order[mode]] = mode;
+	else
+		dev_warn(&pdev->dev, "Assuming a default substate order for this platform\n");
+
+	/*
+	 * Loop through all modes from lowest to highest priority,
 	 * and capture all enabled modes in order
 	 */
 	i = 0;
 	for (p = LPM_MAX_NUM_MODES - 1; p >= 0; p--) {
-		int mode = lpm_priority[p];
+		int mode = pri_order[p];
 
 		if (!(BIT(mode) & lpm_en))
 			continue;
@@ -1675,7 +1712,7 @@ static int pmc_core_probe(struct platform_device *pdev)
 	mutex_init(&pmcdev->lock);
 
 	pmcdev->pmc_xram_read_bit = pmc_core_check_read_lock_bit(pmcdev);
-	pmc_core_get_low_power_modes(pmcdev);
+	pmc_core_get_low_power_modes(pdev);
 	pmc_core_do_dmi_quirks(pmcdev);
 
 	if (pmcdev->map == &tgl_reg_map)
diff --git a/drivers/platform/x86/intel_pmc_core.h b/drivers/platform/x86/intel_pmc_core.h
index e8dae9c6c45f..b9bf3d3d6f7a 100644
--- a/drivers/platform/x86/intel_pmc_core.h
+++ b/drivers/platform/x86/intel_pmc_core.h
@@ -188,6 +188,8 @@ enum ppfear_regs {
 #define ICL_PMC_SLP_S0_RES_COUNTER_STEP		0x64
 
 #define LPM_MAX_NUM_MODES			8
+#define LPM_DEFAULT_PRI				{ 7, 6, 2, 5, 4, 1, 3, 0 }
+
 #define GET_X2_COUNTER(v)			((v) >> 1)
 #define LPM_STS_LATCH_MODE			BIT(31)
 
-- 
2.30.2

