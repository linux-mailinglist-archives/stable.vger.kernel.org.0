Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7227B40E0DF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241432AbhIPQZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241923AbhIPQXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:23:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F90614C8;
        Thu, 16 Sep 2021 16:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808945;
        bh=WANJpW8yev+oEtAtw71e8zPFe2o8jLjScIPcYNsFcsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQPiDCP0MC7X7QfJrP7qIhidM+xmL9qnX+AdGQYvKM9DERdyQtONm/hXyxuIX6SmD
         zb3QKrGa9I4vdBLjN1ktTflZYSUTP52OHLsIRiUyVWdyfZe9eeEnsqbvuk8m16/xLP
         9dmTY3ev4cN2ntXPK5xVluUxAA1plU6ppv1O2MfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Narani <manish.narani@xilinx.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/306] mmc: sdhci-of-arasan: Check return value of non-void funtions
Date:   Thu, 16 Sep 2021 17:59:53 +0200
Message-Id: <20210916155802.521646122@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0c5479a06e9e..fc38db64a6b4 100644
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



