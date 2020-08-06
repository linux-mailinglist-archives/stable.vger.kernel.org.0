Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC1923D4AF
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgHFAda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:33:30 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2404 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgHFAcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 20:32:47 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2b4f780001>; Wed, 05 Aug 2020 17:31:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 17:32:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 17:32:42 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 6 Aug
 2020 00:32:37 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 6 Aug 2020 00:32:37 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.172.190]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f2b4fa40001>; Wed, 05 Aug 2020 17:32:37 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 0/6] Fix timeout clock used by hardware data timeout
Date:   Wed, 5 Aug 2020 17:32:23 -0700
Message-ID: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596673912; bh=03jb/LgztnrHEpK38znEJW5tqPhf5WvCx8cvkc3rVxc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=OqUF+JZ8EydURty0st+SN/DP3zVMMWHKMeDUPWwH+e39E10bbPno/4IBlFxlwDBh/
         DEfOiYXQ4u3gF4RHDgokRoCQ+BEiiXjbxzmum6lh3EjI8WTUWoS7SEF2DLZB0TXzNc
         msrcj474Nttb8QmdoPOW3JOm5dppLuL6c+huA2zHJDRnFd7UJZxWtuTnG1oRQwGCd/
         0U/YHZhQ4ZLwEiszXjZRlV1IY3mZRZASu9+tr4zakHk5HJtCiW8zii1wRvHUD5b0Ya
         twctxVZor+OIpdgBT073bcBORNGKM09ZYib5Un49KZD5Vsi/ck+3tsy1rPzLT8EiMR
         4XIz4buWdGKOQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tegra210/Tegra186/Tegra194 has incorrectly enabled
SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK from the beginning of their support.

Tegra210 and later SDMMC hardware default uses sdmmc_legacy_tm (TMCLK)
all the time for hardware data timeout instead of SDCLK and this TMCLK
need to be kept enabled by Tegra sdmmc driver.

This series includes patches to fix this for Tegra210/Tegra186/Tegra194.

These patches need to be manually backported for 4.9, 4.14 and 4.19.

Will send patches to backport separately once these patches are ack'd.

Delta between patch versions:
[v3]:	Same as v2 with fixes tag

[v2]:	Includes minor fix
	- Patch-0006: parentheses around operand of '!'

Sowjanya Komatineni (6):
  sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra210
  sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra186
  arm64: tegra: Add missing timeout clock to Tegra210 SDMMC
  arm64: tegra: Add missing timeout clock to Tegra186 SDMMC nodes
  arm64: tegra: Add missing timeout clock to Tegra194 SDMMC nodes
  sdhci: tegra: Add missing TMCLK for data timeout

 arch/arm64/boot/dts/nvidia/tegra186.dtsi | 20 +++++++++------
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 15 ++++++-----
 arch/arm64/boot/dts/nvidia/tegra210.dtsi | 20 +++++++++------
 drivers/mmc/host/sdhci-tegra.c           | 43 ++++++++++++++++++++++++++++++--
 4 files changed, 74 insertions(+), 24 deletions(-)

-- 
2.7.4

