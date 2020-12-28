Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779162E3C52
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408069AbgL1OBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408313AbgL1OBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0410D206E5;
        Mon, 28 Dec 2020 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164059;
        bh=k+9nWgCHcHoRAZlN+GsVuaB9HhTJXD9OzDc54IToCxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7tXic2T/STegVv+heDvdgMlOvN1cWHiJbQwaV+8my5hK/A4N9t+Bv5Kq7QHIV8q/
         NmjYhVQ5yK8jfieOzxECA+nDkcwyzFLtvXCE//LBR9oFVjQQgBNlT67B1nxfFptmUr
         AyKCobpl4XLkFYco/D7hyN8OIofCRSTBLXIsw1aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Akash Asthana <akashast@codeaurora.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/717] soc: qcom: geni: More properly switch to DMA mode
Date:   Mon, 28 Dec 2020 13:40:12 +0100
Message-Id: <20201228125021.672250930@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 4b6ea87be44ef34732846fc71e44c41125f0c4fa ]

On geni-i2c transfers using DMA, it was seen that if you program the
command (I2C_READ) before calling geni_se_rx_dma_prep() that it could
cause interrupts to fire.  If we get unlucky, these interrupts can
just keep firing (and not be handled) blocking further progress and
hanging the system.

In commit 02b9aec59243 ("i2c: i2c-qcom-geni: Fix DMA transfer race")
we avoided that by making sure we didn't program the command until
after geni_se_rx_dma_prep() was called.  While that avoided the
problems, it also turns out to be invalid.  At least in the TX case we
started seeing sporadic corrupted transfers.  This is easily seen by
adding an msleep() between the DMA prep and the writing of the
command, which makes the problem worse.  That means we need to revert
that commit and find another way to fix the bogus IRQs.

Specifically, after reverting commit 02b9aec59243 ("i2c:
i2c-qcom-geni: Fix DMA transfer race"), I put some traces in.  I found
that the when the interrupts were firing like crazy:
- "m_stat" had bits for M_RX_IRQ_EN, M_RX_FIFO_WATERMARK_EN set.
- "dma" was set.

Further debugging showed that I could make the problem happen more
reliably by adding an "msleep(1)" any time after geni_se_setup_m_cmd()
ran up until geni_se_rx_dma_prep() programmed the length.

A rather simple fix is to change geni_se_select_dma_mode() so it's a
true inverse of geni_se_select_fifo_mode() and disables all the FIFO
related interrupts.  Now the problematic interrupts can't fire and we
can program things in the correct order without worrying.

As part of this, let's also change the writel_relaxed() in the prepare
function to a writel() so that our DMA is guaranteed to be prepared
now that we can't rely on geni_se_setup_m_cmd()'s writel().

NOTE: the only current user of GENI_SE_DMA in mainline is i2c.

Fixes: 37692de5d523 ("i2c: i2c-qcom-geni: Add bus driver for the Qualcomm GENI I2C controller")
Fixes: 02b9aec59243 ("i2c: i2c-qcom-geni: Fix DMA transfer race")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Akash Asthana <akashast@codeaurora.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20201013142448.v2.1.Ifdb1b69fa3367b81118e16e9e4e63299980ca798@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index d0e4f520cff8c..751a49f6534f4 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -289,10 +289,23 @@ static void geni_se_select_fifo_mode(struct geni_se *se)
 
 static void geni_se_select_dma_mode(struct geni_se *se)
 {
+	u32 proto = geni_se_read_proto(se);
 	u32 val;
 
 	geni_se_irq_clear(se);
 
+	val = readl_relaxed(se->base + SE_GENI_M_IRQ_EN);
+	if (proto != GENI_SE_UART) {
+		val &= ~(M_CMD_DONE_EN | M_TX_FIFO_WATERMARK_EN);
+		val &= ~(M_RX_FIFO_WATERMARK_EN | M_RX_FIFO_LAST_EN);
+	}
+	writel_relaxed(val, se->base + SE_GENI_M_IRQ_EN);
+
+	val = readl_relaxed(se->base + SE_GENI_S_IRQ_EN);
+	if (proto != GENI_SE_UART)
+		val &= ~S_CMD_DONE_EN;
+	writel_relaxed(val, se->base + SE_GENI_S_IRQ_EN);
+
 	val = readl_relaxed(se->base + SE_GENI_DMA_MODE_EN);
 	val |= GENI_DMA_MODE_EN;
 	writel_relaxed(val, se->base + SE_GENI_DMA_MODE_EN);
@@ -651,7 +664,7 @@ int geni_se_tx_dma_prep(struct geni_se *se, void *buf, size_t len,
 	writel_relaxed(lower_32_bits(*iova), se->base + SE_DMA_TX_PTR_L);
 	writel_relaxed(upper_32_bits(*iova), se->base + SE_DMA_TX_PTR_H);
 	writel_relaxed(GENI_SE_DMA_EOT_BUF, se->base + SE_DMA_TX_ATTR);
-	writel_relaxed(len, se->base + SE_DMA_TX_LEN);
+	writel(len, se->base + SE_DMA_TX_LEN);
 	return 0;
 }
 EXPORT_SYMBOL(geni_se_tx_dma_prep);
@@ -688,7 +701,7 @@ int geni_se_rx_dma_prep(struct geni_se *se, void *buf, size_t len,
 	writel_relaxed(upper_32_bits(*iova), se->base + SE_DMA_RX_PTR_H);
 	/* RX does not have EOT buffer type bit. So just reset RX_ATTR */
 	writel_relaxed(0, se->base + SE_DMA_RX_ATTR);
-	writel_relaxed(len, se->base + SE_DMA_RX_LEN);
+	writel(len, se->base + SE_DMA_RX_LEN);
 	return 0;
 }
 EXPORT_SYMBOL(geni_se_rx_dma_prep);
-- 
2.27.0



