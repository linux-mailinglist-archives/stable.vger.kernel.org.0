Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5493E2A5566
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388567AbgKCVJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387859AbgKCVJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F202206B5;
        Tue,  3 Nov 2020 21:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437787;
        bh=/8qzp9Aw62n0zv3u0XvP9Hdc5B7+f0PFu8lF0blwd2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9WhiQ2MG6iC0mf6pQFl1iDe9Ju90DSL2dyeoSiHVS3uClXII9Mr6sQ66+J7kZKno
         TUepszcZ/4b0g9L1Qa7VEZ9srR9X6F4rakmDM/WejjKKnEX92hrbEeAGZPz/EPEC7U
         RFsUL9lH1bTE9FiyZtz8JpQKZlERkp6PFKQ9sMFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 033/125] mmc: via-sdmmc: Fix data race bug
Date:   Tue,  3 Nov 2020 21:36:50 +0100
Message-Id: <20201103203201.721204577@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a863a345fc59b..8c0e348c6053c 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1275,11 +1275,14 @@ static void via_init_sdc_pm(struct via_crdr_mmc_host *host)
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
2.27.0



