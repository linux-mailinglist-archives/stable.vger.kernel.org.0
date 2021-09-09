Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE154054C3
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348275AbhIIND3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355600AbhIIM5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:57:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37AF663269;
        Thu,  9 Sep 2021 11:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188720;
        bh=GwWaIrqi2OV4eQQUwGjcgPfex5Wvf5O8YS156OwunKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRdAgkwhGFckGswnQOKeGZikKw5aOq5SeiNlIfNRN92+OilcSNhYLEc8WZy2Ff/k3
         7ywWRvnxWQYOg+TEGgNqQdQhrmkfFIxL695KNN5sQsY3DMHRuKlgkaWP0DsOBh+6Im
         L95D+pigZjsdcF18WM4jjgu+4UU6Zo3LyPNNSlY7y+UvMDaqlvwygYl7a2I93NeGl3
         kdCsl/HI1LIiO38wkL95iAZCEtJnWks/Dg4iKtNZlbe11/CNzj11GxvnAz3C1oX4eQ
         6d8gUP/lWD7dm0iqR+uTaE66qXSQMjHAU/Xq9dn2WbZhxXc1s9hUfS2FvAf9ggapZz
         JjsKR/1pmDarw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Narani <manish.narani@xilinx.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 59/74] mmc: sdhci-of-arasan: Check return value of non-void funtions
Date:   Thu,  9 Sep 2021 07:57:11 -0400
Message-Id: <20210909115726.149004-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index 9c77bfe4334f..d1a2418b0c5e 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -185,7 +185,12 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
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
@@ -221,7 +226,12 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
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
@@ -395,7 +405,9 @@ static int sdhci_arasan_suspend(struct device *dev)
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

