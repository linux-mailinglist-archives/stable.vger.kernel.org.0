Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B36213F9
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiKHNz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiKHNzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:55:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCFCF4F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCBFAB81AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D108C433D7;
        Tue,  8 Nov 2022 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915752;
        bh=A9pFFBpqFO8/DP0AYj6SNFwLgssM1yD0yUVJDKzSacU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIkCpIsBqYaumhdpt9wGoFv2yPw/4RfPF5dQEqoriLamZRgHEhUSWbEM3w4qiahkz
         Ur3YY9R2O3H6yLe6NY3jSiVJpm2iEBLh9sKX0fRENCyTGOucIHQU4Rl1wGUSfLNYwE
         1wefc1tRHBPepDFsY8V2K6uP/gEy8ksWBYCu6bNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Patrick Thompson <ptf@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/118] mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake
Date:   Tue,  8 Nov 2022 14:38:49 +0100
Message-Id: <20221108133342.918316913@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Thompson <ptf@google.com>

[ Upstream commit 9dc0033e4658d6f9d9952c3c0c6be3ec25bc2985 ]

Enhanced Strobe (ES) does not work correctly on the ASUS 1100 series of
devices. Jasper Lake eMMCs (pci_id 8086:4dc4) are supposed to support
ES. There are also two system families under the series, thus this is
being scoped to the ASUS BIOS.

The failing ES prevents the installer from writing to disk. Falling back
to HS400 without ES fixes the issue.

Signed-off-by: Patrick Thompson <ptf@google.com>
Fixes: 315e3bd7ac19 ("mmc: sdhci-pci: Add support for Intel JSL")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221013210017.3751025-1-ptf@google.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 422ea3a1817a..7eb9a62ee074 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -967,6 +967,12 @@ static bool glk_broken_cqhci(struct sdhci_pci_slot *slot)
 		dmi_match(DMI_SYS_VENDOR, "IRBIS"));
 }
 
+static bool jsl_broken_hs400es(struct sdhci_pci_slot *slot)
+{
+	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_JSL_EMMC &&
+			dmi_match(DMI_BIOS_VENDOR, "ASUSTeK COMPUTER INC.");
+}
+
 static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	int ret = byt_emmc_probe_slot(slot);
@@ -975,9 +981,11 @@ static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE;
 
 	if (slot->chip->pdev->device != PCI_DEVICE_ID_INTEL_GLK_EMMC) {
-		slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
-		slot->host->mmc_host_ops.hs400_enhanced_strobe =
-						intel_hs400_enhanced_strobe;
+		if (!jsl_broken_hs400es(slot)) {
+			slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
+			slot->host->mmc_host_ops.hs400_enhanced_strobe =
+							intel_hs400_enhanced_strobe;
+		}
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
 	}
 
-- 
2.35.1



