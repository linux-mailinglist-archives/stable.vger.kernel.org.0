Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDE7299E52
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439539AbgJ0AOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411773AbgJ0ALe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:11:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE7421741;
        Tue, 27 Oct 2020 00:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757494;
        bh=LOs2ic7kUCAtLOVQFQXO7gcnQiewmk0p48xl6tzGisA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itT/0s1it8eSvsbdi5l6PeHftMY2Zv8pnwDBJmcZ3cATqBV5Id+St6oF/sxkWxIJm
         L2efUDFi4a0mU6cVqhzm4SgF6E/TVC/FJpKr1FGx9yUf5yZah+6XKv0REvMBOHCxAk
         u4Y6Unf8qGqSQael3FGXfhyZwjmiXPlLb7s5gXbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/25] mmc: via-sdmmc: Fix data race bug
Date:   Mon, 26 Oct 2020 20:11:06 -0400
Message-Id: <20201027001123.1027642-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027001123.1027642-1-sashal@kernel.org>
References: <20201027001123.1027642-1-sashal@kernel.org>
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
index 63fac78b3d46a..b455e9cf95afc 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1269,11 +1269,14 @@ static void via_init_sdc_pm(struct via_crdr_mmc_host *host)
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

