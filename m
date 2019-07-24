Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0D8739C5
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390023AbfGXTnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389783AbfGXTnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:43:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12602083B;
        Wed, 24 Jul 2019 19:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997421;
        bh=w7nWYzjqEuQ8ULKO5ztdyA3UpMxJqPyn49Fi+kuKWD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYOjsqtn+KSN8IzOq49pxo/Bu8/sTdVCVPTdVH2nhcS3o2br/AJ52aCOfEbgA02WC
         wrZd0X7fcbYZc0wzEDUHKfbaqEawqqr/NwZN7xYdpAlBkmc0h4Xxh+xH8Drh8OoBg5
         R/Fna+SBh/Fs+40SM5ZzG6Ma+C6dZTt57eOh5sSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 018/371] wil6210: fix spurious interrupts in 3-msi
Date:   Wed, 24 Jul 2019 21:16:10 +0200
Message-Id: <20190724191725.869975532@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e10b0eddd5235aa5aef4e40b970e34e735611a80 ]

Interrupt is set in ICM (ICR & ~IMV) rising trigger.
As the driver masks the IRQ after clearing it, there can
be a race where an additional spurious interrupt is triggered
when the driver unmask the IRQ.
This can happen in case HW triggers an interrupt after the clear
and before the mask.

To prevent the second spurious interrupt the driver needs to mask the
IRQ before reading and clearing it.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 65 ++++++++++++--------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index e41ba24011d8..b00a13d6d530 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -296,21 +296,24 @@ void wil_configure_interrupt_moderation(struct wil6210_priv *wil)
 static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_RX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_rx(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err_ratelimited(wil, "spurious IRQ: RX\n");
+		wil6210_unmask_irq_rx(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_rx(wil);
-
 	/* RX_DONE and RX_HTRSH interrupts are the same if interrupt
 	 * moderation is not used. Interrupt moderation may cause RX
 	 * buffer overflow while RX_DONE is delayed. The required
@@ -355,21 +358,24 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 static irqreturn_t wil6210_irq_rx_edma(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_INT_GEN_RX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_rx_edma(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_INT_GEN_RX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err(wil, "spurious IRQ: RX\n");
+		wil6210_unmask_irq_rx_edma(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_rx_edma(wil);
-
 	if (likely(isr & BIT_RX_STATUS_IRQ)) {
 		wil_dbg_irq(wil, "RX status ring\n");
 		isr &= ~BIT_RX_STATUS_IRQ;
@@ -403,21 +409,24 @@ static irqreturn_t wil6210_irq_rx_edma(int irq, void *cookie)
 static irqreturn_t wil6210_irq_tx_edma(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_INT_GEN_TX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_tx_edma(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_INT_GEN_TX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err(wil, "spurious IRQ: TX\n");
+		wil6210_unmask_irq_tx_edma(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_tx_edma(wil);
-
 	if (likely(isr & BIT_TX_STATUS_IRQ)) {
 		wil_dbg_irq(wil, "TX status ring\n");
 		isr &= ~BIT_TX_STATUS_IRQ;
@@ -446,21 +455,24 @@ static irqreturn_t wil6210_irq_tx_edma(int irq, void *cookie)
 static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_TX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_tx(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err_ratelimited(wil, "spurious IRQ: TX\n");
+		wil6210_unmask_irq_tx(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_tx(wil);
-
 	if (likely(isr & BIT_DMA_EP_TX_ICR_TX_DONE)) {
 		wil_dbg_irq(wil, "TX done\n");
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
@@ -532,20 +544,23 @@ static bool wil_validate_mbox_regs(struct wil6210_priv *wil)
 static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_MISC_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
+
+	wil6210_mask_irq_misc(wil, false);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
 
 	trace_wil6210_irq_misc(isr);
 	wil_dbg_irq(wil, "ISR MISC 0x%08x\n", isr);
 
 	if (!isr) {
 		wil_err(wil, "spurious IRQ: MISC\n");
+		wil6210_unmask_irq_misc(wil, false);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_misc(wil, false);
-
 	if (isr & ISR_MISC_FW_ERROR) {
 		u32 fw_assert_code = wil_r(wil, wil->rgf_fw_assert_code_addr);
 		u32 ucode_assert_code =
-- 
2.20.1



