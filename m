Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4383A250916
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 21:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHXTQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 15:16:42 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1907 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgHXTQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 15:16:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4411b50000>; Mon, 24 Aug 2020 12:15:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 12:16:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Aug 2020 12:16:02 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 19:16:02 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 19:16:02 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4411f10000>; Mon, 24 Aug 2020 12:16:01 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v4 2/7] sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra186
Date:   Mon, 24 Aug 2020 12:15:52 -0700
Message-ID: <1598296557-32020-3-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598296557-32020-1-git-send-email-skomatineni@nvidia.com>
References: <1598296557-32020-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598296501; bh=mXqaDHZAnjiA2FC3TMHhwQF8i9i1LflPE/o4KLabvD8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=GjhX+lMiPI8VUJDopPttINNU4y1BHlJT72xtFKOw82Ecv1VqFgdpCQFCIYjcw50lb
         3tToFhNhR/XnwKveia5PJK/xGpWiSeDTbCYZlHtDyuBwys8jDuHUPIgZ9kbIzEZvfa
         vrJw2ZhFMOR6Y2EkKIcFmbM686eDRPX4i6MxQSum6QUpZiHgHO6i8V8tdyUeoSwT3Z
         1/Vkb7ioXNb+MjPvSTkbLGb2tdb/fE3Ff59g9RNLKSf4DTJCqIQ3+TQ7N8mnYtJWJX
         wab3uVzQKdqtf2kyKmF+RQLrN8twFyv/SApexrcI7W5ak4LGt6D1mWByQ/rN0xfyS+
         lNBArKGCTJAkg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4346b7c7941d ("mmc: tegra: Add Tegra186 support")

SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK is set for Tegra186 from the
beginning of its support in driver.

Tegra186 SDMMC hardware by default uses timeout clock (TMCLK) instead
of SDCLK and this quirk should not be set.

So, this patch remove this quirk for Tegra186.

Fixes: 4346b7c7941d ("mmc: tegra: Add Tegra186 support")
Cc: stable <stable@vger.kernel.org> # 5.4
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 2be3511..31ed321 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1455,7 +1455,6 @@ static const struct sdhci_ops tegra186_sdhci_ops = {
 
 static const struct sdhci_pltfm_data sdhci_tegra186_pdata = {
 	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
-		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
 		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
-- 
2.7.4

