Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26607CACBF
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfJCR2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388354AbfJCQNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:13:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 772282054F;
        Thu,  3 Oct 2019 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119212;
        bh=6b5jTT1uSMagUS3nV3QpOU2+HHivB8utPxBdWmXGx7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0d+JYRCXYZ4iy8loQGGfwM+x6Xu+Oqi+gY6rB1lzyrD7ERw0oQvfpgnaWupNo6r98
         Lv8+MlWjgt9ME2FI8K7L8cnnYK/Q8aUESCz5aee/qsPtskmqFwJ4lfV6Trikx+sLOi
         s8AChB52Hl6B7loqgZGV5Jec8S3YYDqenrc0A5h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 128/185] mmc: core: Clarify sdio_irq_pending flag for MMC_CAP2_SDIO_IRQ_NOTHREAD
Date:   Thu,  3 Oct 2019 17:53:26 +0200
Message-Id: <20191003154506.607376909@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 36d57efb4af534dd6b442ea0b9a04aa6dfa37abe ]

The sdio_irq_pending flag is used to let host drivers indicate that it has
signaled an IRQ. If that is the case and we only have a single SDIO func
that have claimed an SDIO IRQ, our assumption is that we can avoid reading
the SDIO_CCCR_INTx register and just call the SDIO func irq handler
immediately. This makes sense, but the flag is set/cleared in a somewhat
messy order, let's fix that up according to below.

First, the flag is currently set in sdio_run_irqs(), which is executed as a
work that was scheduled from sdio_signal_irq(). To make it more implicit
that the host have signaled an IRQ, let's instead immediately set the flag
in sdio_signal_irq(). This also makes the behavior consistent with host
drivers that uses the legacy, mmc_signal_sdio_irq() API. This have no
functional impact, because we don't expect host drivers to call
sdio_signal_irq() until after the work (sdio_run_irqs()) have been executed
anyways.

Second, currently we never clears the flag when using the sdio_run_irqs()
work, but only when using the sdio_irq_thread(). Let make the behavior
consistent, by moving the flag to be cleared inside the common
process_sdio_pending_irqs() function. Additionally, tweak the behavior of
the flag slightly, by avoiding to clear it unless we processed the SDIO
IRQ. The purpose with this at this point, is to keep the information about
whether there have been an SDIO IRQ signaled by the host, so at system
resume we can decide to process it without reading the SDIO_CCCR_INTx
register.

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sdio_irq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index 2fdd84c67f191..0656d740b0dd2 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -35,6 +35,7 @@ static int process_sdio_pending_irqs(struct mmc_host *host)
 {
 	struct mmc_card *card = host->card;
 	int i, ret, count;
+	bool sdio_irq_pending = host->sdio_irq_pending;
 	unsigned char pending;
 	struct sdio_func *func;
 
@@ -42,13 +43,16 @@ static int process_sdio_pending_irqs(struct mmc_host *host)
 	if (mmc_card_suspended(card))
 		return 0;
 
+	/* Clear the flag to indicate that we have processed the IRQ. */
+	host->sdio_irq_pending = false;
+
 	/*
 	 * Optimization, if there is only 1 function interrupt registered
 	 * and we know an IRQ was signaled then call irq handler directly.
 	 * Otherwise do the full probe.
 	 */
 	func = card->sdio_single_irq;
-	if (func && host->sdio_irq_pending) {
+	if (func && sdio_irq_pending) {
 		func->irq_handler(func);
 		return 1;
 	}
@@ -100,7 +104,6 @@ void sdio_run_irqs(struct mmc_host *host)
 {
 	mmc_claim_host(host);
 	if (host->sdio_irqs) {
-		host->sdio_irq_pending = true;
 		process_sdio_pending_irqs(host);
 		if (host->ops->ack_sdio_irq)
 			host->ops->ack_sdio_irq(host);
@@ -119,6 +122,7 @@ void sdio_irq_work(struct work_struct *work)
 
 void sdio_signal_irq(struct mmc_host *host)
 {
+	host->sdio_irq_pending = true;
 	queue_delayed_work(system_wq, &host->sdio_irq_work, 0);
 }
 EXPORT_SYMBOL_GPL(sdio_signal_irq);
@@ -163,7 +167,6 @@ static int sdio_irq_thread(void *_host)
 		if (ret)
 			break;
 		ret = process_sdio_pending_irqs(host);
-		host->sdio_irq_pending = false;
 		mmc_release_host(host);
 
 		/*
-- 
2.20.1



