Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9545250816
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbfFXKEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729743AbfFXKEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:37 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F5BB205ED;
        Mon, 24 Jun 2019 10:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370676;
        bh=TZPaRkPROyoay+S6+8vlutN8XMG7y/b8GH5AwoiUKc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLpdph86UbZ3UNptUn7KNC8fwD7nQkp+fewC2ss0hintVf2keZpDs1AxeMauK1f/j
         jCooI52nJ+DoH8ZsiDImDgsiKk/0LL2x5Mg8sBQXWDPQ7ER3W49wd1+fHUVOm1ahBZ
         1VqtbwJANN9qon+Mo4nmDOhLxkb1tiqQ01dGLWuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 15/90] mmc: core: Prevent processing SDIO IRQs when the card is suspended
Date:   Mon, 24 Jun 2019 17:56:05 +0800
Message-Id: <20190624092315.035472958@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 83293386bc95cf5e9f0c0175794455835bd1cb4a upstream.

Processing of SDIO IRQs must obviously be prevented while the card is
system suspended, otherwise we may end up trying to communicate with an
uninitialized SDIO card.

Reports throughout the years shows that this is not only a theoretical
problem, but a real issue. So, let's finally fix this problem, by keeping
track of the state for the card and bail out before processing the SDIO
IRQ, in case the card is suspended.

Cc: stable@vger.kernel.org
Reported-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sdio.c     |   13 ++++++++++++-
 drivers/mmc/core/sdio_irq.c |    4 ++++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -934,6 +934,10 @@ static int mmc_sdio_pre_suspend(struct m
  */
 static int mmc_sdio_suspend(struct mmc_host *host)
 {
+	/* Prevent processing of SDIO IRQs in suspended state. */
+	mmc_card_set_suspended(host->card);
+	cancel_delayed_work_sync(&host->sdio_irq_work);
+
 	mmc_claim_host(host);
 
 	if (mmc_card_keep_power(host) && mmc_card_wake_sdio_irq(host))
@@ -982,13 +986,20 @@ static int mmc_sdio_resume(struct mmc_ho
 		err = sdio_enable_4bit_bus(host->card);
 	}
 
-	if (!err && host->sdio_irqs) {
+	if (err)
+		goto out;
+
+	/* Allow SDIO IRQs to be processed again. */
+	mmc_card_clr_suspended(host->card);
+
+	if (host->sdio_irqs) {
 		if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD))
 			wake_up_process(host->sdio_irq_thread);
 		else if (host->caps & MMC_CAP_SDIO_IRQ)
 			host->ops->enable_sdio_irq(host, 1);
 	}
 
+out:
 	mmc_release_host(host);
 
 	host->pm_flags &= ~MMC_PM_KEEP_POWER;
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -38,6 +38,10 @@ static int process_sdio_pending_irqs(str
 	unsigned char pending;
 	struct sdio_func *func;
 
+	/* Don't process SDIO IRQs if the card is suspended. */
+	if (mmc_card_suspended(card))
+		return 0;
+
 	/*
 	 * Optimization, if there is only 1 function interrupt registered
 	 * and we know an IRQ was signaled then call irq handler directly.


