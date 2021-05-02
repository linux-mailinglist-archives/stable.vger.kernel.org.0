Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A363F370C8F
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhEBOGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233294AbhEBOGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED50B613ED;
        Sun,  2 May 2021 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964315;
        bh=p0dEHENok+HVq9plIeyUNJ5pj7jhyDM3rGXSLbW6w1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfEgat1Ye+RGaYzkeh9zqA2ztmAfYPh9TI9nP5oXMNmFaQuTXmSaB4T3kkPDQ4Cjw
         mihe+ReUTPIIdPKkPlNwZbJVvaR4HwT9kAvAHOZHmcjgHBwXV6yl1/AJSmsknq8aQN
         hs9cNrJSFqEUzUUPUXwWb7Ejn+R/VrFesNHVY9ULz1eKZaXD2eNacM0V2+s6/kZ5/K
         1eGrfq7EO5geTs8CImpqDyHI1JuMT/3ci9KGjz8NdEUOE4aBoGCwqo7UOMtIzDuRR5
         YzxTrkDZ3C0vllKBu7sArYvAhLAA2uKjU5Pbic9J0JPgWdjx5sSb/nXIV41TWaa2Xi
         U0ow1NvHFt++A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 33/34] platform/x86: intel_pmc_core: Don't use global pmcdev in quirks
Date:   Sun,  2 May 2021 10:04:33 -0400
Message-Id: <20210502140434.2719553-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

[ Upstream commit c9f86d6ca6b5e23d30d16ade4b9fff5b922a610a ]

The DMI callbacks, used for quirks, currently access the PMC by getting
the address a global pmc_dev struct. Instead, have the callbacks set a
global quirk specific variable. In probe, after calling dmi_check_system(),
pass pmc_dev to a function that will handle each quirk if its variable
condition is met. This allows removing the global pmc_dev later.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Link: https://lore.kernel.org/r/20210417031252.3020837-2-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index 571b4754477c..4c1312f1616c 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -831,9 +831,15 @@ static const struct pci_device_id pmc_pci_ids[] = {
  * the platform BIOS enforces 24Mhx Crystal to shutdown
  * before PMC can assert SLP_S0#.
  */
+static bool xtal_ignore;
 static int quirk_xtal_ignore(const struct dmi_system_id *id)
 {
-	struct pmc_dev *pmcdev = &pmc;
+	xtal_ignore = true;
+	return 0;
+}
+
+static void pmc_core_xtal_ignore(struct pmc_dev *pmcdev)
+{
 	u32 value;
 
 	value = pmc_core_reg_read(pmcdev, pmcdev->map->pm_vric1_offset);
@@ -842,7 +848,6 @@ static int quirk_xtal_ignore(const struct dmi_system_id *id)
 	/* Low Voltage Mode Enable */
 	value &= ~SPT_PMC_VRIC1_SLPS0LVEN;
 	pmc_core_reg_write(pmcdev, pmcdev->map->pm_vric1_offset, value);
-	return 0;
 }
 
 static const struct dmi_system_id pmc_core_dmi_table[]  = {
@@ -857,6 +862,14 @@ static const struct dmi_system_id pmc_core_dmi_table[]  = {
 	{}
 };
 
+static void pmc_core_do_dmi_quirks(struct pmc_dev *pmcdev)
+{
+	dmi_check_system(pmc_core_dmi_table);
+
+	if (xtal_ignore)
+		pmc_core_xtal_ignore(pmcdev);
+}
+
 static int pmc_core_probe(struct platform_device *pdev)
 {
 	static bool device_initialized;
@@ -898,7 +911,7 @@ static int pmc_core_probe(struct platform_device *pdev)
 	mutex_init(&pmcdev->lock);
 	platform_set_drvdata(pdev, pmcdev);
 	pmcdev->pmc_xram_read_bit = pmc_core_check_read_lock_bit();
-	dmi_check_system(pmc_core_dmi_table);
+	pmc_core_do_dmi_quirks(pmcdev);
 
 	pmc_core_dbgfs_register(pmcdev);
 
-- 
2.30.2

