Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2461F22F9
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgFHXLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbgFHXL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02E8220897;
        Mon,  8 Jun 2020 23:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657889;
        bh=8ytuBy4b62zsfobpy3ImeP8JbnWVrWV3o5vABkvCtmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9ok72UT3eWh5tiCYk/2OMepss5v+ki2yWhrgP3HCrYb3LFDpU2Evyqx3d5dRUrV1
         maugMZN1MAMgQ2U35/RKJNhxyuu6FmnxQM3DXuRr//NiGx1jl8FBTuHk+wBIn8uv2z
         So0+FI10zfIiOMWT1Y7GVBUpvXnpRPqLxMplvCkQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 245/274] mmc: mmci: Switch to mmc_regulator_set_vqmmc()
Date:   Mon,  8 Jun 2020 19:05:38 -0400
Message-Id: <20200608230607.3361041-245-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 3e09a81e166c0a5544832459be17561a6b231ac7 ]

Instead of reimplementing the logic in mmc_regulator_set_vqmmc(), use the
mmc code function directly.

This also allows us to fix a related issue on STM32MP1, when a voltage
switch of 1.8V is done for the eMMC, but the current level is already set
to 1.8V. More precisely, in this scenario the call to the
->post_sig_volt_switch() hangs, indefinitely waiting for the voltage switch
to complete. Fix this problem by checking if mmc_regulator_set_vqmmc()
returned 1 and then skip invoking the callback.

Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20200416163649.336967-3-marex@denx.de
[Ulf: Updated the commit message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmci.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 647567def612..a69d6a0c2e15 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1861,31 +1861,17 @@ static int mmci_get_cd(struct mmc_host *mmc)
 static int mmci_sig_volt_switch(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct mmci_host *host = mmc_priv(mmc);
-	int ret = 0;
-
-	if (!IS_ERR(mmc->supply.vqmmc)) {
+	int ret;
 
-		switch (ios->signal_voltage) {
-		case MMC_SIGNAL_VOLTAGE_330:
-			ret = regulator_set_voltage(mmc->supply.vqmmc,
-						2700000, 3600000);
-			break;
-		case MMC_SIGNAL_VOLTAGE_180:
-			ret = regulator_set_voltage(mmc->supply.vqmmc,
-						1700000, 1950000);
-			break;
-		case MMC_SIGNAL_VOLTAGE_120:
-			ret = regulator_set_voltage(mmc->supply.vqmmc,
-						1100000, 1300000);
-			break;
-		}
+	ret = mmc_regulator_set_vqmmc(mmc, ios);
 
-		if (!ret && host->ops && host->ops->post_sig_volt_switch)
-			ret = host->ops->post_sig_volt_switch(host, ios);
+	if (!ret && host->ops && host->ops->post_sig_volt_switch)
+		ret = host->ops->post_sig_volt_switch(host, ios);
+	else if (ret)
+		ret = 0;
 
-		if (ret)
-			dev_warn(mmc_dev(mmc), "Voltage switch failed\n");
-	}
+	if (ret < 0)
+		dev_warn(mmc_dev(mmc), "Voltage switch failed\n");
 
 	return ret;
 }
-- 
2.25.1

