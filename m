Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF4337CE8B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344994AbhELRFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244429AbhELQqI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA7B61E76;
        Wed, 12 May 2021 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836098;
        bh=duAe1FrZC4y4/RYe4QCNSLaIoM7Stfdqv5l+hkpzsVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gneHKz9CExiqlzDT0M1UTEfj2NVInm/SsrvzLVcOTSCCZsHXP6Yynj6WqsM+xqtSC
         viARXqcomY9NCtaT4SUu5rhSMpiJRpLMBqpVZwviZI9zOz1Upkmu4ZZuz9Y2zve8ra
         9INFGdHEcYwGAn0RUt+p/A0UsPEYwoncpxdQKKPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 610/677] rtw88: refine napi deinit flow
Date:   Wed, 12 May 2021 16:50:56 +0200
Message-Id: <20210512144857.633429335@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 7bd3760c71f7a18485d2c10ea0887e1d41519f4e ]

We used to stop napi before disabling irqs. And it turns out
to cause some problem when we try to stop device while interrupt arrives.

To safely stop pci, we do three steps:
1. disable interrupt
2. synchronize_irq
3. stop_napi
Since step 2 and 3 may not finish as expected when interrupt is enabled,
use rtwpci->running to decide whether interrupt should be re-enabled at
the time.

Fixes: 9e2fd29864c5 ("rtw88: add napi support")
Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210415084703.27255-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 19 ++++++++++++++-----
 drivers/net/wireless/realtek/rtw88/pci.h |  1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 786a48649946..6b5c885798a4 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -581,23 +581,30 @@ static int rtw_pci_start(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 
+	rtw_pci_napi_start(rtwdev);
+
 	spin_lock_bh(&rtwpci->irq_lock);
+	rtwpci->running = true;
 	rtw_pci_enable_interrupt(rtwdev, rtwpci, false);
 	spin_unlock_bh(&rtwpci->irq_lock);
 
-	rtw_pci_napi_start(rtwdev);
-
 	return 0;
 }
 
 static void rtw_pci_stop(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	struct pci_dev *pdev = rtwpci->pdev;
 
+	spin_lock_bh(&rtwpci->irq_lock);
+	rtwpci->running = false;
+	rtw_pci_disable_interrupt(rtwdev, rtwpci);
+	spin_unlock_bh(&rtwpci->irq_lock);
+
+	synchronize_irq(pdev->irq);
 	rtw_pci_napi_stop(rtwdev);
 
 	spin_lock_bh(&rtwpci->irq_lock);
-	rtw_pci_disable_interrupt(rtwdev, rtwpci);
 	rtw_pci_dma_release(rtwdev, rtwpci);
 	spin_unlock_bh(&rtwpci->irq_lock);
 }
@@ -1138,7 +1145,8 @@ static irqreturn_t rtw_pci_interrupt_threadfn(int irq, void *dev)
 		rtw_fw_c2h_cmd_isr(rtwdev);
 
 	/* all of the jobs for this interrupt have been done */
-	rtw_pci_enable_interrupt(rtwdev, rtwpci, rx);
+	if (rtwpci->running)
+		rtw_pci_enable_interrupt(rtwdev, rtwpci, rx);
 	spin_unlock_bh(&rtwpci->irq_lock);
 
 	return IRQ_HANDLED;
@@ -1558,7 +1566,8 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
 		spin_lock_bh(&rtwpci->irq_lock);
-		rtw_pci_enable_interrupt(rtwdev, rtwpci, false);
+		if (rtwpci->running)
+			rtw_pci_enable_interrupt(rtwdev, rtwpci, false);
 		spin_unlock_bh(&rtwpci->irq_lock);
 		/* When ISR happens during polling and before napi_complete
 		 * while no further data is received. Data on the dma_ring will
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index e76fc549a788..0ffae887527a 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -211,6 +211,7 @@ struct rtw_pci {
 	spinlock_t irq_lock;
 	u32 irq_mask[4];
 	bool irq_enabled;
+	bool running;
 
 	/* napi structure */
 	struct net_device netdev;
-- 
2.30.2



