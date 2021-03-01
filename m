Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7353288AF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbhCARnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238365AbhCARh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:37:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF30F64F34;
        Mon,  1 Mar 2021 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617714;
        bh=llmFOKqNnAldU16VHcI9ELl7O4GowIq82Bmfr9sgEms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFObMmuMhWgamXHjMFVSpEcStg+nR6JsHyhASNhAGOsymN95HqXCcuJQvQpnq5o0M
         oL6+lN/zQpzpO2ihUZ3jcZiSUvMcXlwbutSqhokZ9iCnLy5ZaxB7OaLSBbxu/F/qJN
         ObQkhWPrgMOXg+znzeO8NZleDqhaj95KQ37EdlYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roja Rani Yarubandi <rojay@codeaurora.org>,
        Akash Asthana <akashast@codeaurora.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/340] i2c: qcom-geni: Store DMA mapping data in geni_i2c_dev struct
Date:   Mon,  1 Mar 2021 17:11:55 +0100
Message-Id: <20210301161056.718650304@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roja Rani Yarubandi <rojay@codeaurora.org>

[ Upstream commit 357ee8841d0b7bd822f25fc768afbc0c2ab7e47b ]

Store DMA mapping data in geni_i2c_dev struct to enhance DMA mapping
data scope. For example during shutdown callback to unmap DMA mapping,
this stored DMA mapping data can be used to call geni_se_tx_dma_unprep
and geni_se_rx_dma_unprep functions.

Add two helper functions geni_i2c_rx_msg_cleanup and
geni_i2c_tx_msg_cleanup to unwrap the things after rx/tx FIFO/DMA
transfers, so that the same can be used in geni_i2c_stop_xfer()
function during shutdown callback.

Signed-off-by: Roja Rani Yarubandi <rojay@codeaurora.org>
Reviewed-by: Akash Asthana <akashast@codeaurora.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 59 ++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 17abf60c94aeb..b56a427fb928f 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -87,6 +87,9 @@ struct geni_i2c_dev {
 	u32 clk_freq_out;
 	const struct geni_i2c_clk_fld *clk_fld;
 	int suspended;
+	void *dma_buf;
+	size_t xfer_len;
+	dma_addr_t dma_addr;
 };
 
 struct geni_i2c_err_log {
@@ -350,14 +353,39 @@ static void geni_i2c_tx_fsm_rst(struct geni_i2c_dev *gi2c)
 		dev_err(gi2c->se.dev, "Timeout resetting TX_FSM\n");
 }
 
+static void geni_i2c_rx_msg_cleanup(struct geni_i2c_dev *gi2c,
+				     struct i2c_msg *cur)
+{
+	gi2c->cur_rd = 0;
+	if (gi2c->dma_buf) {
+		if (gi2c->err)
+			geni_i2c_rx_fsm_rst(gi2c);
+		geni_se_rx_dma_unprep(&gi2c->se, gi2c->dma_addr, gi2c->xfer_len);
+		i2c_put_dma_safe_msg_buf(gi2c->dma_buf, cur, !gi2c->err);
+	}
+}
+
+static void geni_i2c_tx_msg_cleanup(struct geni_i2c_dev *gi2c,
+				     struct i2c_msg *cur)
+{
+	gi2c->cur_wr = 0;
+	if (gi2c->dma_buf) {
+		if (gi2c->err)
+			geni_i2c_tx_fsm_rst(gi2c);
+		geni_se_tx_dma_unprep(&gi2c->se, gi2c->dma_addr, gi2c->xfer_len);
+		i2c_put_dma_safe_msg_buf(gi2c->dma_buf, cur, !gi2c->err);
+	}
+}
+
 static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 				u32 m_param)
 {
-	dma_addr_t rx_dma;
+	dma_addr_t rx_dma = 0;
 	unsigned long time_left;
 	void *dma_buf = NULL;
 	struct geni_se *se = &gi2c->se;
 	size_t len = msg->len;
+	struct i2c_msg *cur;
 
 	if (!of_machine_is_compatible("lenovo,yoga-c630"))
 		dma_buf = i2c_get_dma_safe_msg_buf(msg, 32);
@@ -374,19 +402,18 @@ static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		geni_se_select_mode(se, GENI_SE_FIFO);
 		i2c_put_dma_safe_msg_buf(dma_buf, msg, false);
 		dma_buf = NULL;
+	} else {
+		gi2c->xfer_len = len;
+		gi2c->dma_addr = rx_dma;
+		gi2c->dma_buf = dma_buf;
 	}
 
+	cur = gi2c->cur;
 	time_left = wait_for_completion_timeout(&gi2c->done, XFER_TIMEOUT);
 	if (!time_left)
 		geni_i2c_abort_xfer(gi2c);
 
-	gi2c->cur_rd = 0;
-	if (dma_buf) {
-		if (gi2c->err)
-			geni_i2c_rx_fsm_rst(gi2c);
-		geni_se_rx_dma_unprep(se, rx_dma, len);
-		i2c_put_dma_safe_msg_buf(dma_buf, msg, !gi2c->err);
-	}
+	geni_i2c_rx_msg_cleanup(gi2c, cur);
 
 	return gi2c->err;
 }
@@ -394,11 +421,12 @@ static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 static int geni_i2c_tx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 				u32 m_param)
 {
-	dma_addr_t tx_dma;
+	dma_addr_t tx_dma = 0;
 	unsigned long time_left;
 	void *dma_buf = NULL;
 	struct geni_se *se = &gi2c->se;
 	size_t len = msg->len;
+	struct i2c_msg *cur;
 
 	if (!of_machine_is_compatible("lenovo,yoga-c630"))
 		dma_buf = i2c_get_dma_safe_msg_buf(msg, 32);
@@ -415,22 +443,21 @@ static int geni_i2c_tx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		geni_se_select_mode(se, GENI_SE_FIFO);
 		i2c_put_dma_safe_msg_buf(dma_buf, msg, false);
 		dma_buf = NULL;
+	} else {
+		gi2c->xfer_len = len;
+		gi2c->dma_addr = tx_dma;
+		gi2c->dma_buf = dma_buf;
 	}
 
 	if (!dma_buf) /* Get FIFO IRQ */
 		writel_relaxed(1, se->base + SE_GENI_TX_WATERMARK_REG);
 
+	cur = gi2c->cur;
 	time_left = wait_for_completion_timeout(&gi2c->done, XFER_TIMEOUT);
 	if (!time_left)
 		geni_i2c_abort_xfer(gi2c);
 
-	gi2c->cur_wr = 0;
-	if (dma_buf) {
-		if (gi2c->err)
-			geni_i2c_tx_fsm_rst(gi2c);
-		geni_se_tx_dma_unprep(se, tx_dma, len);
-		i2c_put_dma_safe_msg_buf(dma_buf, msg, !gi2c->err);
-	}
+	geni_i2c_tx_msg_cleanup(gi2c, cur);
 
 	return gi2c->err;
 }
-- 
2.27.0



