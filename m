Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EDE259857
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbgIAQZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:25:34 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8859 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731186AbgIAQZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 12:25:24 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4e75720000>; Tue, 01 Sep 2020 09:23:14 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 09:25:21 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 01 Sep 2020 09:25:21 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 16:25:16 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Sep 2020 16:25:15 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.173.243]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4e75ea0000>; Tue, 01 Sep 2020 09:25:15 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 4.19 1/7] sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra210
Date:   Tue, 1 Sep 2020 09:24:44 -0700
Message-ID: <1598977490-1826-2-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598977490-1826-1-git-send-email-skomatineni@nvidia.com>
References: <1598977490-1826-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598977394; bh=Z6u+ABgJCAtbGnranS4dGkSh81P26Nk9qPAkKLFqkYY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=RF+9bBxp94yVUgbCuDReHxr0QBHPEK74jdYfcj+USsnIWfeX2BsboIrfC1qN2bjGE
         slkRQxGC9g2U6h4DAgdfKt5bmd6f2G02N6JHs1F+nFDd2I+ktrnifgqpAAIqIjfThG
         eFvB5SmVyeqVEMMGwF2tSz1ZwBupVZfpNL2qgX0Oftq3TcAz1QFuzSxrM4leVf8pR0
         DHHpidFHo7oGEGjppxRB82UTtAiF+4hACfj6P8F6D2VXRuWZhzUigrM/4OOuPy4h/R
         dyb9UWuxq1UayeMSFzMykXZduukkMyABHfDiPDM0XOQVAE3wu6laE1T+ofcqUxbRDz
         H6dpObyuWv0nA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK has been set on Tegra210
ever since Tegra210 support was added to the driver in commit
b5a84ecf025a ("mmc: tegra: Add Tegra210 support").

Tegra210 SDMMC hardware by default uses timeout clock (TMCLK)
instead of SDCLK and this quirk should not be set.

So, this patch remove this quirk for Tegra210.

Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 4.19
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 27bdf6d..731956e 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -423,7 +423,6 @@ static const struct sdhci_tegra_soc_data soc_data_tegra124 = {
 
 static const struct sdhci_pltfm_data sdhci_tegra210_pdata = {
 	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
-		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
 		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
-- 
2.7.4

