Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234442E425A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391661AbgL1OBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436668AbgL1OBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B996205CB;
        Mon, 28 Dec 2020 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164062;
        bh=3ewlcxh5eRrg520qImP6XLXqZ0grow7r8TFHfAkhKLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXNxFx9XszM0MZhCnIME0sHCTDWo4nUw/J1ZAT/Tnp3+zkpiSZS1nNKvl/chfKfZA
         xO+zB6prDE9hiEPV/Ib9GFbmUVX1qlvK8/RQIFO4uml04VrxtPYeaBv7bSEK98baF1
         UkFbizUcCGN1mp1JVsQbkc4QVyJc25uLq6yztPmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Akash Asthana <akashast@codeaurora.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/717] Revert "i2c: i2c-qcom-geni: Fix DMA transfer race"
Date:   Mon, 28 Dec 2020 13:40:13 +0100
Message-Id: <20201228125021.721220631@linuxfoundation.org>
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

[ Upstream commit 9cb4c67d7717135d6f4600a49ab07b470ea4ee2f ]

This reverts commit 02b9aec59243c6240fc42884acc958602146ddf6.

As talked about in the patch ("soc: qcom: geni: More properly switch
to DMA mode"), swapping the order of geni_se_setup_m_cmd() and
geni_se_xx_dma_prep() can sometimes cause corrupted transfers.  Thus
we traded one problem for another.  Now that we've debugged the
problem further and fixed the geni helper functions to more disable
FIFO interrupts when we move to DMA mode we can revert it and end up
with (hopefully) zero problems!

To be explicit, the patch ("soc: qcom: geni: More properly switch
to DMA mode") is a prerequisite for this one.

Fixes: 02b9aec59243 ("i2c: i2c-qcom-geni: Fix DMA transfer race")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Akash Asthana <akashast@codeaurora.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20201013142448.v2.2.I7b22281453b8a18ab16ef2bfd4c641fb1cc6a92c@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 8b4c35f47a70f..dce75b85253c1 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -366,6 +366,7 @@ static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		geni_se_select_mode(se, GENI_SE_FIFO);
 
 	writel_relaxed(len, se->base + SE_I2C_RX_TRANS_LEN);
+	geni_se_setup_m_cmd(se, I2C_READ, m_param);
 
 	if (dma_buf && geni_se_rx_dma_prep(se, dma_buf, len, &rx_dma)) {
 		geni_se_select_mode(se, GENI_SE_FIFO);
@@ -373,8 +374,6 @@ static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		dma_buf = NULL;
 	}
 
-	geni_se_setup_m_cmd(se, I2C_READ, m_param);
-
 	time_left = wait_for_completion_timeout(&gi2c->done, XFER_TIMEOUT);
 	if (!time_left)
 		geni_i2c_abort_xfer(gi2c);
@@ -408,6 +407,7 @@ static int geni_i2c_tx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		geni_se_select_mode(se, GENI_SE_FIFO);
 
 	writel_relaxed(len, se->base + SE_I2C_TX_TRANS_LEN);
+	geni_se_setup_m_cmd(se, I2C_WRITE, m_param);
 
 	if (dma_buf && geni_se_tx_dma_prep(se, dma_buf, len, &tx_dma)) {
 		geni_se_select_mode(se, GENI_SE_FIFO);
@@ -415,8 +415,6 @@ static int geni_i2c_tx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		dma_buf = NULL;
 	}
 
-	geni_se_setup_m_cmd(se, I2C_WRITE, m_param);
-
 	if (!dma_buf) /* Get FIFO IRQ */
 		writel_relaxed(1, se->base + SE_GENI_TX_WATERMARK_REG);
 
-- 
2.27.0



