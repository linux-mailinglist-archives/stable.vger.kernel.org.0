Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561AE2538DC
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 22:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHZUFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 16:05:35 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15640 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgHZUFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 16:05:34 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f46c0800000>; Wed, 26 Aug 2020 13:05:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 13:05:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 26 Aug 2020 13:05:34 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Aug
 2020 20:05:31 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 26 Aug 2020 20:05:31 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f46c08a0001>; Wed, 26 Aug 2020 13:05:31 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v5 0/7] Fix timeout clock used by hardware data timeout
Date:   Wed, 26 Aug 2020 13:05:07 -0700
Message-ID: <1598472314-30235-1-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598472320; bh=OdHdRc/UaKnVvZSMHA9sLxAncOLEzYZlr2zxYS7NCA8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=sAdcDtKkrSV7v71/ylV5CdddbSsNGcdWUtD93tmrrU8I6vAzTN8ABnIMcY2RfqVzO
         APeQBIJ564TncDxfV852Dy9g1tvAQURmvfcHfeEn3XjnNuTUEsQzfAx4102501Q/JS
         MLejpnY9Dd885BSoSZvP+1nREqNop/ENTV7T0QYf4knbeNYK9AlEmqITZvucBEk55q
         RyGGydmX8japWg2pX3H16C8xSTBBtFhZ6HuF0lhS+E0/ezimf/U/MITo2nLFVKZ+JV
         G+zmIxhlMsovytOJitiQjiedRhQ/tiBgMIcC6lY/CCbb8a0RtgitpbJO3Z6NPSqu27
         xKmS6XlQwNOfg==
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
[v5]:	Include below changes based on v4 feedback
	- updated dt-binding doc to be more clear
	- updated Tegra sdhci driver to retrieve sdhci and tmclk clocks
	  based on no. of clocks in sdhci device node as old device trees
	  do not use sdhci clock name and this allows proper clock retrival
	  irrespective of sdhci and tmclk clocks order in device tree.	  
	- Added separate quirk for identifying SoC's supporting separate
	  timeout clock to be more clear.

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

 .../bindings/mmc/nvidia,tegra20-sdhci.txt          | 32 +++++++-
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           | 20 +++--
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           | 15 ++--
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           | 20 +++--
 drivers/mmc/host/sdhci-tegra.c                     | 91 +++++++++++++++++++---
 5 files changed, 143 insertions(+), 35 deletions(-)

-- 
2.7.4

