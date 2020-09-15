Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDC626B6CB
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgIPAKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgIOO0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3730A2242E;
        Tue, 15 Sep 2020 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179552;
        bh=3H9Jwp0sFydrB2FpgZDxC/bkvsg7JhW9qW9radhoODQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XI4kb1HUyg4jPJi/pS2dIghUX+d1HABCHTJhpt6FrVDz2ZBPQgu/Oi8G+jOBW44g
         zXwRaaJPCL8BiVYt6uFtq3qW1i9ahfO60KWst368Sa37Wzrxx/3t6X8jb6W39FV0Kr
         kDwXb9F6be5vswG5jId2RKz1sjavPUNuIcZ1ahpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/132] mmc: sdhci-acpi: Clear amd_sdhci_host on reset
Date:   Tue, 15 Sep 2020 16:12:07 +0200
Message-Id: <20200915140645.336609887@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

[ Upstream commit 2cf9bfe9be75ed3656bbf882fb70c3e3047866e4 ]

The commit 61d7437ed1390 ("mmc: sdhci-acpi: Fix HS400 tuning for AMDI0040")
broke resume for eMMC HS400. When the system suspends the eMMC controller
is powered down. So, on resume we need to reinitialize the controller.
Although, amd_sdhci_host was not getting cleared, so the DLL was never
re-enabled on resume. This results in HS400 being non-functional.

To fix the problem, this change clears the tuned_clock flag, clears the
dll_enabled flag and disables the DLL on reset.

Fixes: 61d7437ed1390 ("mmc: sdhci-acpi: Fix HS400 tuning for AMDI0040")
Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200831150517.1.I93c78bfc6575771bb653c9d3fca5eb018a08417d@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-acpi.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index 5581a5c86fce3..b2d924c5e82ee 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -547,12 +547,18 @@ static int amd_select_drive_strength(struct mmc_card *card,
 	return MMC_SET_DRIVER_TYPE_A;
 }
 
-static void sdhci_acpi_amd_hs400_dll(struct sdhci_host *host)
+static void sdhci_acpi_amd_hs400_dll(struct sdhci_host *host, bool enable)
 {
+	struct sdhci_acpi_host *acpi_host = sdhci_priv(host);
+	struct amd_sdhci_host *amd_host = sdhci_acpi_priv(acpi_host);
+
 	/* AMD Platform requires dll setting */
 	sdhci_writel(host, 0x40003210, SDHCI_AMD_RESET_DLL_REGISTER);
 	usleep_range(10, 20);
-	sdhci_writel(host, 0x40033210, SDHCI_AMD_RESET_DLL_REGISTER);
+	if (enable)
+		sdhci_writel(host, 0x40033210, SDHCI_AMD_RESET_DLL_REGISTER);
+
+	amd_host->dll_enabled = enable;
 }
 
 /*
@@ -592,10 +598,8 @@ static void amd_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 		/* DLL is only required for HS400 */
 		if (host->timing == MMC_TIMING_MMC_HS400 &&
-		    !amd_host->dll_enabled) {
-			sdhci_acpi_amd_hs400_dll(host);
-			amd_host->dll_enabled = true;
-		}
+		    !amd_host->dll_enabled)
+			sdhci_acpi_amd_hs400_dll(host, true);
 	}
 }
 
@@ -616,10 +620,23 @@ static int amd_sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	return err;
 }
 
+static void amd_sdhci_reset(struct sdhci_host *host, u8 mask)
+{
+	struct sdhci_acpi_host *acpi_host = sdhci_priv(host);
+	struct amd_sdhci_host *amd_host = sdhci_acpi_priv(acpi_host);
+
+	if (mask & SDHCI_RESET_ALL) {
+		amd_host->tuned_clock = false;
+		sdhci_acpi_amd_hs400_dll(host, false);
+	}
+
+	sdhci_reset(host, mask);
+}
+
 static const struct sdhci_ops sdhci_acpi_ops_amd = {
 	.set_clock	= sdhci_set_clock,
 	.set_bus_width	= sdhci_set_bus_width,
-	.reset		= sdhci_reset,
+	.reset		= amd_sdhci_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
 };
 
-- 
2.25.1



