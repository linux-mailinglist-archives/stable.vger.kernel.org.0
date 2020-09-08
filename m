Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E210261C6C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgIHTTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730988AbgIHQCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC3B2253A;
        Tue,  8 Sep 2020 15:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579447;
        bh=bj7S8NOxjiQFmYSOuM/EOhUq7I9dIdjVaxbLer2TCMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3gGIPaUYCZLYiEJid9mNnBSyiaEfxZ7uJIvIPJC2bdSCixst6Np8RQvVGcJiufha
         Tfcb41fiGadfs8/aIHg4yxUCwxiq6znmbce3QQXhzyQonqe4i0bs+bA4K0ybodiwvH
         gh75PtJeNvM0Pef6vQ6vd0lOJpmF0Pn6kg1OhLOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 051/186] mmc: sdhci-acpi: Fix HS400 tuning for AMDI0040
Date:   Tue,  8 Sep 2020 17:23:13 +0200
Message-Id: <20200908152244.141535975@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

[ Upstream commit 61d7437ed13906984c44697970ee792ac6271a31 ]

The AMD eMMC Controller can only use the tuned clock while in HS200 and
HS400 mode. If we switch to a different mode, we need to disable the
tuned clock. If we have previously performed tuning and switch back to
HS200 or HS400, we can re-enable the tuned clock.

Previously the tuned clock was not getting disabled when switching to
DDR52 which is part of the HS400 tuning sequence.

Fixes: 34597a3f60b1 ("mmc: sdhci-acpi: Add support for ACPI HID of AMD Controller with HS400")
Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200819125832.v2.1.Ie8f0689ec9f449203328b37409d1cf06b565f331@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-acpi.c | 67 +++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index d8b76cb8698aa..2d9f79b50a7fa 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -535,6 +535,11 @@ static const struct sdhci_acpi_slot sdhci_acpi_slot_qcom_sd = {
 	.caps    = MMC_CAP_NONREMOVABLE,
 };
 
+struct amd_sdhci_host {
+	bool	tuned_clock;
+	bool	dll_enabled;
+};
+
 /* AMD sdhci reset dll register. */
 #define SDHCI_AMD_RESET_DLL_REGISTER    0x908
 
@@ -554,26 +559,66 @@ static void sdhci_acpi_amd_hs400_dll(struct sdhci_host *host)
 }
 
 /*
- * For AMD Platform it is required to disable the tuning
- * bit first controller to bring to HS Mode from HS200
- * mode, later enable to tune to HS400 mode.
+ * The initialization sequence for HS400 is:
+ *     HS->HS200->Perform Tuning->HS->HS400
+ *
+ * The re-tuning sequence is:
+ *     HS400->DDR52->HS->HS200->Perform Tuning->HS->HS400
+ *
+ * The AMD eMMC Controller can only use the tuned clock while in HS200 and HS400
+ * mode. If we switch to a different mode, we need to disable the tuned clock.
+ * If we have previously performed tuning and switch back to HS200 or
+ * HS400, we can re-enable the tuned clock.
+ *
  */
 static void amd_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
+	struct sdhci_acpi_host *acpi_host = sdhci_priv(host);
+	struct amd_sdhci_host *amd_host = sdhci_acpi_priv(acpi_host);
 	unsigned int old_timing = host->timing;
+	u16 val;
 
 	sdhci_set_ios(mmc, ios);
-	if (old_timing == MMC_TIMING_MMC_HS200 &&
-	    ios->timing == MMC_TIMING_MMC_HS)
-		sdhci_writew(host, 0x9, SDHCI_HOST_CONTROL2);
-	if (old_timing != MMC_TIMING_MMC_HS400 &&
-	    ios->timing == MMC_TIMING_MMC_HS400) {
-		sdhci_writew(host, 0x80, SDHCI_HOST_CONTROL2);
-		sdhci_acpi_amd_hs400_dll(host);
+
+	if (old_timing != host->timing && amd_host->tuned_clock) {
+		if (host->timing == MMC_TIMING_MMC_HS400 ||
+		    host->timing == MMC_TIMING_MMC_HS200) {
+			val = sdhci_readw(host, SDHCI_HOST_CONTROL2);
+			val |= SDHCI_CTRL_TUNED_CLK;
+			sdhci_writew(host, val, SDHCI_HOST_CONTROL2);
+		} else {
+			val = sdhci_readw(host, SDHCI_HOST_CONTROL2);
+			val &= ~SDHCI_CTRL_TUNED_CLK;
+			sdhci_writew(host, val, SDHCI_HOST_CONTROL2);
+		}
+
+		/* DLL is only required for HS400 */
+		if (host->timing == MMC_TIMING_MMC_HS400 &&
+		    !amd_host->dll_enabled) {
+			sdhci_acpi_amd_hs400_dll(host);
+			amd_host->dll_enabled = true;
+		}
 	}
 }
 
+static int amd_sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
+{
+	int err;
+	struct sdhci_host *host = mmc_priv(mmc);
+	struct sdhci_acpi_host *acpi_host = sdhci_priv(host);
+	struct amd_sdhci_host *amd_host = sdhci_acpi_priv(acpi_host);
+
+	amd_host->tuned_clock = false;
+
+	err = sdhci_execute_tuning(mmc, opcode);
+
+	if (!err && !host->tuning_err)
+		amd_host->tuned_clock = true;
+
+	return err;
+}
+
 static const struct sdhci_ops sdhci_acpi_ops_amd = {
 	.set_clock	= sdhci_set_clock,
 	.set_bus_width	= sdhci_set_bus_width,
@@ -601,6 +646,7 @@ static int sdhci_acpi_emmc_amd_probe_slot(struct platform_device *pdev,
 
 	host->mmc_host_ops.select_drive_strength = amd_select_drive_strength;
 	host->mmc_host_ops.set_ios = amd_set_ios;
+	host->mmc_host_ops.execute_tuning = amd_sdhci_execute_tuning;
 	return 0;
 }
 
@@ -612,6 +658,7 @@ static const struct sdhci_acpi_slot sdhci_acpi_slot_amd_emmc = {
 			  SDHCI_QUIRK_32BIT_ADMA_SIZE,
 	.quirks2	= SDHCI_QUIRK2_BROKEN_64_BIT_DMA,
 	.probe_slot     = sdhci_acpi_emmc_amd_probe_slot,
+	.priv_size	= sizeof(struct amd_sdhci_host),
 };
 
 struct sdhci_acpi_uid_slot {
-- 
2.25.1



