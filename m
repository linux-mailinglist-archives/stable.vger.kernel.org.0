Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05395078D
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbfFXKH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbfFXKH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:57 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75765205C9;
        Mon, 24 Jun 2019 10:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370875;
        bh=WxEApTo0Goc840G+FER9x9kk6XQpZJV1dS/+Tj0WSW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOuTBovGhTqrt7/6T2Gu0xTQlTg6jMbX9JwgZ+hYip1DH/ypQbJrc80MEahmUh0JF
         fS2yLPAYmz404PfAX0P1ceYt5QGhb6OX2Xiua8/NQYznvSaS8G5k5vfZMMCI4/8Uvj
         QGBMGwzxZkjhkQqfTGoQI7x9k2n0byLKiWZyk5pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jjian Zhou <jjian.zhou@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Yong Mao <yong.mao@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.1 004/121] mmc: mediatek: fix SDIO IRQ interrupt handle flow
Date:   Mon, 24 Jun 2019 17:55:36 +0800
Message-Id: <20190624092320.878211381@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jjian zhou <jjian.zhou@mediatek.com>

commit 8a5df8ac628f4febea1e6cd3044bff2d536dd096 upstream.

SDIO IRQ is triggered by low level. It need disable SDIO IRQ
detected function. Otherwise the interrupt register can't be cleared.
It will process the interrupt more.

Signed-off-by: Jjian Zhou <jjian.zhou@mediatek.com>
Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Yong Mao <yong.mao@mediatek.com>
Fixes: 5215b2e952f3 ("mmc: mediatek: Add MMC_CAP_SDIO_IRQ support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mtk-sd.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1355,24 +1355,25 @@ static void msdc_request_timeout(struct
 	}
 }
 
-static void __msdc_enable_sdio_irq(struct mmc_host *mmc, int enb)
+static void __msdc_enable_sdio_irq(struct msdc_host *host, int enb)
 {
-	unsigned long flags;
-	struct msdc_host *host = mmc_priv(mmc);
-
-	spin_lock_irqsave(&host->lock, flags);
-	if (enb)
+	if (enb) {
 		sdr_set_bits(host->base + MSDC_INTEN, MSDC_INTEN_SDIOIRQ);
-	else
+		sdr_set_bits(host->base + SDC_CFG, SDC_CFG_SDIOIDE);
+	} else {
 		sdr_clr_bits(host->base + MSDC_INTEN, MSDC_INTEN_SDIOIRQ);
-	spin_unlock_irqrestore(&host->lock, flags);
+		sdr_clr_bits(host->base + SDC_CFG, SDC_CFG_SDIOIDE);
+	}
 }
 
 static void msdc_enable_sdio_irq(struct mmc_host *mmc, int enb)
 {
+	unsigned long flags;
 	struct msdc_host *host = mmc_priv(mmc);
 
-	__msdc_enable_sdio_irq(mmc, enb);
+	spin_lock_irqsave(&host->lock, flags);
+	__msdc_enable_sdio_irq(host, enb);
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	if (enb)
 		pm_runtime_get_noresume(host->dev);
@@ -1394,6 +1395,8 @@ static irqreturn_t msdc_irq(int irq, voi
 		spin_lock_irqsave(&host->lock, flags);
 		events = readl(host->base + MSDC_INT);
 		event_mask = readl(host->base + MSDC_INTEN);
+		if ((events & event_mask) & MSDC_INT_SDIOIRQ)
+			__msdc_enable_sdio_irq(host, 0);
 		/* clear interrupts */
 		writel(events & event_mask, host->base + MSDC_INT);
 
@@ -1402,10 +1405,8 @@ static irqreturn_t msdc_irq(int irq, voi
 		data = host->data;
 		spin_unlock_irqrestore(&host->lock, flags);
 
-		if ((events & event_mask) & MSDC_INT_SDIOIRQ) {
-			__msdc_enable_sdio_irq(host->mmc, 0);
+		if ((events & event_mask) & MSDC_INT_SDIOIRQ)
 			sdio_signal_irq(host->mmc);
-		}
 
 		if (!(events & (event_mask & ~MSDC_INT_SDIOIRQ)))
 			break;
@@ -1528,10 +1529,7 @@ static void msdc_init_hw(struct msdc_hos
 	sdr_set_bits(host->base + SDC_CFG, SDC_CFG_SDIO);
 
 	/* Config SDIO device detect interrupt function */
-	if (host->mmc->caps & MMC_CAP_SDIO_IRQ)
-		sdr_set_bits(host->base + SDC_CFG, SDC_CFG_SDIOIDE);
-	else
-		sdr_clr_bits(host->base + SDC_CFG, SDC_CFG_SDIOIDE);
+	sdr_clr_bits(host->base + SDC_CFG, SDC_CFG_SDIOIDE);
 
 	/* Configure to default data timeout */
 	sdr_set_field(host->base + SDC_CFG, SDC_CFG_DTOC, 3);
@@ -2052,7 +2050,12 @@ static void msdc_hw_reset(struct mmc_hos
 
 static void msdc_ack_sdio_irq(struct mmc_host *mmc)
 {
-	__msdc_enable_sdio_irq(mmc, 1);
+	unsigned long flags;
+	struct msdc_host *host = mmc_priv(mmc);
+
+	spin_lock_irqsave(&host->lock, flags);
+	__msdc_enable_sdio_irq(host, 1);
+	spin_unlock_irqrestore(&host->lock, flags);
 }
 
 static const struct mmc_host_ops mt_msdc_ops = {


