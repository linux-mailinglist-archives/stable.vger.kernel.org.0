Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67C9404FCE
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353221AbhIIMWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353053AbhIIMUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EA2A6128A;
        Thu,  9 Sep 2021 11:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188230;
        bh=tDBSWzYhCOTHYddrfn0XbNNvp/91KucQtUMSTSX2/sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwvgWJoUTEo4DQCMb6WcRa8+udmkN+PfBpuV8AdWInHHZOgTkgTAc2D8InEJWtQL2
         eMIGir2EWPutNu1kQWvK1hHmXxc+TbMXidm+pHb0ogPTrLxQ1gl1SnFwpwjUSVi3Pr
         p1WqpRuuiaRRtFRVqa9gK5AgNAMH0ofeAWV5gjOITrJIMivJ/Bxdz1msQzHC+zPGMm
         Dvl6Q4vMJKV0VWblRh6JMul6bpzoT3ofcl/2M5QksgxGmlPGak1X9s2gcDfucgjku0
         An1UgQhLIicSTr25y6YVi/fl4iBxt+kMFwJ7e+1iz7v/GTjYs6ZtZLXQ6dc3KaihFm
         JSGTwe7kh75Hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Narani <manish.narani@xilinx.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 182/219] mmc: sdhci-of-arasan: Check return value of non-void funtions
Date:   Thu,  9 Sep 2021 07:45:58 -0400
Message-Id: <20210909114635.143983-182-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Narani <manish.narani@xilinx.com>

[ Upstream commit 66bad6ed2204fdb78a0a8fb89d824397106a5471 ]

At a couple of places, the return values of the non-void functions were
not getting checked. This was reported by the coverity tool. Modify the
code to check the return values of the same.

Addresses-Coverity: ("check_return")
Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1623753837-21035-5-git-send-email-manish.narani@xilinx.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-arasan.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index fc3e41c76ab4..9a630ba37484 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -273,7 +273,12 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
 			 * through low speeds without power cycling.
 			 */
 			sdhci_set_clock(host, host->max_clk);
-			phy_power_on(sdhci_arasan->phy);
+			if (phy_power_on(sdhci_arasan->phy)) {
+				pr_err("%s: Cannot power on phy.\n",
+				       mmc_hostname(host->mmc));
+				return;
+			}
+
 			sdhci_arasan->is_phy_on = true;
 
 			/*
@@ -323,7 +328,12 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
 		msleep(20);
 
 	if (ctrl_phy) {
-		phy_power_on(sdhci_arasan->phy);
+		if (phy_power_on(sdhci_arasan->phy)) {
+			pr_err("%s: Cannot power on phy.\n",
+			       mmc_hostname(host->mmc));
+			return;
+		}
+
 		sdhci_arasan->is_phy_on = true;
 	}
 }
@@ -479,7 +489,9 @@ static int sdhci_arasan_suspend(struct device *dev)
 		ret = phy_power_off(sdhci_arasan->phy);
 		if (ret) {
 			dev_err(dev, "Cannot power off phy.\n");
-			sdhci_resume_host(host);
+			if (sdhci_resume_host(host))
+				dev_err(dev, "Cannot resume host.\n");
+
 			return ret;
 		}
 		sdhci_arasan->is_phy_on = false;
-- 
2.30.2

