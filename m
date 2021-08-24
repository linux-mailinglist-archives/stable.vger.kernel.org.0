Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE08E3F653E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbhHXRKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239874AbhHXRJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BD2E6147F;
        Tue, 24 Aug 2021 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824424;
        bh=rFWVkTbFx0XTXndnBQgZe6MHT/XWE9zLb9BHU1Gz09o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6/zMwfHx6Ak7XRvXUaVMe+48UMdtvJeX01qWFXrn2wEAiHct4nrluUBvJ8wPYxNB
         uJVMnhoKWgSuKX88P/LrR8Okp0veRvdJv9a0uLLnGXbRkZMX8hvhYTxgxV6UfD1jTX
         Gg4SubjyTv+tKoQUucWXM4BK6CxpwExHM0Kt2y5RLKiHsekaBOWmsz0Mq7YE7Mr0bZ
         Z8oqhZvMpdCGDhOLvj9ucK1dqRXkfUYbWxp1QRuRlOUPEmD4WP0mYCljqXryatW7aU
         oKqkLndmew1q6FlTkTqwx+mdg+o7/K3b8gqQ9X6saJmi34T2WxKcPAimpD7KPkX/MI
         DOu1ATaBhVvTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Kerello <christophe.kerello@foss.st.com>,
        Yann Gautier <yann.gautier@foss.st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 74/98] mmc: mmci: stm32: Check when the voltage switch procedure should be done
Date:   Tue, 24 Aug 2021 12:58:44 -0400
Message-Id: <20210824165908.709932-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@foss.st.com>

[ Upstream commit d8e193f13b07e6c0ffaa1a999386f1989f2b4c5e ]

If the card has not been power cycled, it may still be using 1.8V
signaling. This situation is detected in mmc_sd_init_card function and
should be handled in mmci stm32 variant.  The host->pwr_reg variable is
also correctly protected with spin locks.

Fixes: 94b94a93e355 ("mmc: mmci_sdmmc: Implement signal voltage callbacks")
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Signed-off-by: Yann Gautier <yann.gautier@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210701143353.13188-1-yann.gautier@foss.st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmci_stm32_sdmmc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci_stm32_sdmmc.c b/drivers/mmc/host/mmci_stm32_sdmmc.c
index 51db30acf4dc..fdaa11f92fe6 100644
--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -479,8 +479,9 @@ static int sdmmc_post_sig_volt_switch(struct mmci_host *host,
 	u32 status;
 	int ret = 0;
 
-	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_180) {
-		spin_lock_irqsave(&host->lock, flags);
+	spin_lock_irqsave(&host->lock, flags);
+	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_180 &&
+	    host->pwr_reg & MCI_STM32_VSWITCHEN) {
 		mmci_write_pwrreg(host, host->pwr_reg | MCI_STM32_VSWITCH);
 		spin_unlock_irqrestore(&host->lock, flags);
 
@@ -492,9 +493,11 @@ static int sdmmc_post_sig_volt_switch(struct mmci_host *host,
 
 		writel_relaxed(MCI_STM32_VSWENDC | MCI_STM32_CKSTOPC,
 			       host->base + MMCICLEAR);
+		spin_lock_irqsave(&host->lock, flags);
 		mmci_write_pwrreg(host, host->pwr_reg &
 				  ~(MCI_STM32_VSWITCHEN | MCI_STM32_VSWITCH));
 	}
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	return ret;
 }
-- 
2.30.2

