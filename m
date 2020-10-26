Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9398D299F5D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441243AbgJ0AVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410974AbgJZXzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:55:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E1D320B1F;
        Mon, 26 Oct 2020 23:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756549;
        bh=aIiTGYggak3CM+beeinXqt9y0SWPQVk1XwmAovTDKd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmGY3bSVixfCbpnj/Z4L7WfGMEMzHLtcTleejhFVVdICO2iO7lH02i4sJzi4vYQDp
         J1zcOOpJ4KPsURf6cFPDBTFBIdhIll1X0TRoUGqrw6Y/khqu1enfzQeQ9rh8lDhUct
         LIVlvcXghxLYBFHH/htx3SxLg7lm/r3Rv9aJylHQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/80] mmc: via-sdmmc: Fix data race bug
Date:   Mon, 26 Oct 2020 19:54:22 -0400
Message-Id: <20201026235516.1025100-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 87d7ad089b318b4f319bf57f1daa64eb6d1d10ad ]

via_save_pcictrlreg() should be called with host->lock held
as it writes to pm_pcictrl_reg, otherwise there can be a race
condition between via_sd_suspend() and via_sdc_card_detect().
The same pattern is used in the function via_reset_pcictrl()
as well, where via_save_pcictrlreg() is called with host->lock
held.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lore.kernel.org/r/20200822061528.7035-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/via-sdmmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 8d96ecba1b553..d12a068b0f9ed 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1259,11 +1259,14 @@ static void via_init_sdc_pm(struct via_crdr_mmc_host *host)
 static int via_sd_suspend(struct pci_dev *pcidev, pm_message_t state)
 {
 	struct via_crdr_mmc_host *host;
+	unsigned long flags;
 
 	host = pci_get_drvdata(pcidev);
 
+	spin_lock_irqsave(&host->lock, flags);
 	via_save_pcictrlreg(host);
 	via_save_sdcreg(host);
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	pci_save_state(pcidev);
 	pci_enable_wake(pcidev, pci_choose_state(pcidev, state), 0);
-- 
2.25.1

