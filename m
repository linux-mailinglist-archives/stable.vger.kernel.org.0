Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781A91CAF8E
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgEHMlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgEHMlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9229E21835;
        Fri,  8 May 2020 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941705;
        bh=UvijrepgSM9bTTBiI9Swq+Upxzh2Ou3oIRDUNq7ka3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbQzel4AxT2OmXaGiuaMniVav1rUJZVHU5BUksLHHz4L8qVqosp+C0PCxt6ugMPOK
         /Loe2iE9wy8QEoa11ytuv2W+G89RMtcfXyXZRV8duLgyX/96opB6+rY0i7MiBuqBXc
         xyc3mv9cmQxT9BXykDmTKNoB75HWxDwGUHcEJ3tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@marvell.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 138/312] mmc: sdhci: restore behavior when setting VDD via external regulator
Date:   Fri,  8 May 2020 14:32:09 +0200
Message-Id: <20200508123134.198259687@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@marvell.com>

commit 918f4cbd4340ddd1eb389cd8efa3b07ac74ec4c0 upstream.

After commit 52221610dd84 ("mmc: sdhci: Improve external VDD regulator
support"), for the VDD is supplied via external regulators, we ignore
the code to convert a VDD voltage request into one of the standard
SDHCI voltage levels, then program it in the SDHCI_POWER_CONTROL. This
brings two issues:

1. SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON quirk isn't handled properly any
more.

2. What's more, once SDHCI_POWER_ON bit is set, some controllers such
as the sdhci-pxav3 used in marvell berlin SoCs require the voltage
levels programming in the SDHCI_POWER_CONTROL register, even the VDD
is supplied by external regulator. So the host in marvell berlin SoCs
still works fine after the commit. However, commit 3cbc6123a93d ("mmc:
sdhci: Set SDHCI_POWER_ON with external vmmc") sets the SDHCI_POWER_ON
bit, this would make the host in marvell berlin SoCs won't work any
more with external vmmc.

This patch restores the behavior when setting VDD through external
regulator by moving the call of mmc_regulator_set_ocr() to the end
of sdhci_set_power() function.

After this patch, the sdcard on Marvell Berlin SoC boards work again.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Fixes: 52221610dd84 ("mmc: sdhci: Improve external VDD ...")
Reviewed-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1290,19 +1290,6 @@ static void sdhci_set_power(struct sdhci
 	struct mmc_host *mmc = host->mmc;
 	u8 pwr = 0;
 
-	if (!IS_ERR(mmc->supply.vmmc)) {
-		spin_unlock_irq(&host->lock);
-		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
-		spin_lock_irq(&host->lock);
-
-		if (mode != MMC_POWER_OFF)
-			sdhci_writeb(host, SDHCI_POWER_ON, SDHCI_POWER_CONTROL);
-		else
-			sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
-
-		return;
-	}
-
 	if (mode != MMC_POWER_OFF) {
 		switch (1 << vdd) {
 		case MMC_VDD_165_195:
@@ -1363,6 +1350,12 @@ static void sdhci_set_power(struct sdhci
 		if (host->quirks & SDHCI_QUIRK_DELAY_AFTER_POWER)
 			mdelay(10);
 	}
+
+	if (!IS_ERR(mmc->supply.vmmc)) {
+		spin_unlock_irq(&host->lock);
+		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
+		spin_lock_irq(&host->lock);
+	}
 }
 
 /*****************************************************************************\


