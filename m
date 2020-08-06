Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B1A23D4AC
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHFAd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:33:29 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2405 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgHFAcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 20:32:48 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2b4f790000>; Wed, 05 Aug 2020 17:31:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 17:32:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 05 Aug 2020 17:32:43 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 6 Aug
 2020 00:32:38 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 6 Aug 2020 00:32:38 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.172.190]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f2b4fa50000>; Wed, 05 Aug 2020 17:32:37 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 1/6] sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra210
Date:   Wed, 5 Aug 2020 17:32:24 -0700
Message-ID: <1596673949-1571-2-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
References: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596673913; bh=ZQ7B/TsNvuyH9rMk/OPATa1sR4Pf7TSD0PRa0PJNRKQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=T+iGMEQpS5uICh+JqVSN1qc9iSn2seHf6A5yVPMjvk0J0mlvds5K9ja+QUL7GPAST
         OchTWXJ0gbze4lPX3YQJM2nYwXwMRwjPRo27THWRA5kwIlJgNDYG30RKDQBg8hjueK
         MMKfpUqGnpE+3wV9iYzCOow8EdZPuhdYM0h59o48J+t7lInrZQ7WP+FIffDiAV6Ahi
         bmBXZkM/lpNQZU7dt+fmVdl2Xs1wSoYwEh/IUXjNeONoxzIq5/cYFpCcJLLChoaKyC
         fiXPTvhnKJE4tUDDTETVFVWjYgD/jDOx83Ggxi0l0i4cknBieuqSYClThLDobWyCHF
         GLAN6T0gc1FYg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")

SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK is set for Tegra210 from the
beginning of Tegra210 support in the driver.

Tegra210 SDMMC hardware by default uses timeout clock (TMCLK)
instead of SDCLK and this quirk should not be set.

So, this patch remove this quirk for Tegra210.

Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 5.4
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 0a3f9d0..2be3511 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1418,7 +1418,6 @@ static const struct sdhci_ops tegra210_sdhci_ops = {
 
 static const struct sdhci_pltfm_data sdhci_tegra210_pdata = {
 	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
-		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
 		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
-- 
2.7.4

