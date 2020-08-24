Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE5A2508F1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 21:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgHXTQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 15:16:03 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7898 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgHXTQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 15:16:02 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4411e40002>; Mon, 24 Aug 2020 12:15:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 12:16:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 24 Aug 2020 12:16:02 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 19:16:00 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 19:16:00 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4411ef0002>; Mon, 24 Aug 2020 12:16:00 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v4 0/7] Fix timeout clock used by hardware data timeout
Date:   Mon, 24 Aug 2020 12:15:50 -0700
Message-ID: <1598296557-32020-1-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598296548; bh=mW6MeP2iOU3Fc2Kxb88P6mogFG3buNVYe9PqrpY910w=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=brZDqkME0E/izfVwIhupHb3rXUULOTCDnGU89OUndJrW3PIHMmqmax9zZTrem2HF0
         jlZ32gKyucoUziV/V8v/dvQgpg0hcS8fGedO6AcjxZ3wK9KL/jA+WnmFMNJoz01hzE
         o1Rj+rvl8YyfoCMAzDqnlS7arJk2mEHnNPXvkKrXTRFB2CWj+lExteWhA3teLnX3wW
         P9nLzs3/8TIWrbrbraNdze7m7wbhvHnpefpHx5CxWHEYQSIDfgD93L69TQetzYaIr/
         JMsLGNUzhlABue0Jj2QZDKeBG2jPoSLYH0e7wz8dbzxHPsgGJRBueEM/bx4oWLfsWt
         FdRRdiHV28rzg==
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
[v4]:	Include additional dt-binding patch

[v3]:	Same as v2 with fixes tag

[v2]:	Includes minor fix
	- Patch-0006: parentheses around operand of '!'

Sowjanya Komatineni (7):
  sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra210
  sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra186
  dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later
  arm64: tegra: Add missing timeout clock to Tegra210 SDMMC
  arm64: tegra: Add missing timeout clock to Tegra186 SDMMC nodes
  arm64: tegra: Add missing timeout clock to Tegra194 SDMMC nodes
  sdhci: tegra: Add missing TMCLK for data timeout

 .../bindings/mmc/nvidia,tegra20-sdhci.txt          | 23 +++++++++++-
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           | 20 ++++++----
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           | 15 +++++---
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           | 20 ++++++----
 drivers/mmc/host/sdhci-tegra.c                     | 43 +++++++++++++++++++++-
 5 files changed, 96 insertions(+), 25 deletions(-)

-- 
2.7.4

