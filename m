Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A91B1B7FB3
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 22:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgDXUGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 16:06:12 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5084 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDXUGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 16:06:12 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea346740000>; Fri, 24 Apr 2020 13:05:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 24 Apr 2020 13:06:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 24 Apr 2020 13:06:11 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 20:06:11 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 24 Apr 2020 20:06:11 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.165.152]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ea346b20001>; Fri, 24 Apr 2020 13:06:11 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <baolin.wang@linaro.org>, <kstewart@linuxfoundation.org>,
        <tglx@linutronix.de>, <bradleybolen@gmail.com>,
        <gregkh@linuxfoundation.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <skomatineni@nvidia.com>
CC:     <anrao@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 5.4.33 2/2] sdhci: tegra: Enable MMC_CAP_WAIT_WHILE_BUSY host capability
Date:   Fri, 24 Apr 2020 13:06:06 -0700
Message-ID: <1587758766-3274-3-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587758766-3274-1-git-send-email-skomatineni@nvidia.com>
References: <1587758766-3274-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587758708; bh=AI2k/GeOJka+x5ydpwPpmWF5ssDecgtebTTmy/odja0=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=YYHHWuRg7Sak/+d89Z3NEfjL9oM9uuKaM/bUbtswcRSS+83xzFv/grlQRTzgO83LC
         FlTXKpNeylt3AJ98gajRwQ9glqWH+3dJITSvoPAZ7ZQdyWlPCC9d7blfWd4blPqnmS
         0Dnkht5YSeOQEz60ZL4SW8Uq21rpkowk4ggt/NAMhKWe16es5IpOiCa0QExe7lSZJO
         AHsk1Mw34bRWx7mGqr5ptk0hnVphqBiPlv6e+jRkOIQqSEMC26hFjecapS/9AAYiEN
         qJzY5yYaKbxSnm2UX0t+3K+I48sU07/iAIhesaMlIERseD9YJCNn6O8/uc7eNdJHGL
         h4PhfBdAQ49MA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ff124c31ccd7
("sdhci: tegra: Enable MMC_CAP_WAIT_WHILE_BUSY host capability")

Tegra sdhci host supports HW busy detection of the device busy
signaling over data0 lane.

So, this patch enables host capability MMC_CAP_wAIT_WHILE_BUSY.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index fa8f6a4..1c381f8 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1580,6 +1580,8 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 	if (rc)
 		goto err_parse_dt;
 
+	host->mmc->caps |= MMC_CAP_WAIT_WHILE_BUSY;
+
 	if (tegra_host->soc_data->nvquirks & NVQUIRK_ENABLE_DDR50)
 		host->mmc->caps |= MMC_CAP_1_8V_DDR;
 
-- 
2.7.4

