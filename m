Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A48722F12C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbgG0OWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgG0OWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60FB92075A;
        Mon, 27 Jul 2020 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859752;
        bh=aM8aXjRYZdfpSzdluY0ajWuw/nyk1LjO5JNDkFZWCuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0dIaZCquUGFIU5T1sKdq9hbCrvqTpCJn+3B8GlBdBzK+ITE6DKufP9uWxWgOsLw4
         Bg8w8p+ignYGOa83nrhJzrRgYAWm5B7nsegSAQh1G/g/+hG/ArEYXJY3zyJk9H6NsJ
         gTMozhCUhM8pAMjHOHKSSr/hTYrBS0OpY52UyJzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Akash Asthana <akashast@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mukesh Kumar Savaliya <msavaliy@codeaurora.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 092/179] i2c: i2c-qcom-geni: Fix DMA transfer race
Date:   Mon, 27 Jul 2020 16:04:27 +0200
Message-Id: <20200727134937.156171105@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 02b9aec59243c6240fc42884acc958602146ddf6 ]

When I have KASAN enabled on my kernel and I start stressing the
touchscreen my system tends to hang.  The touchscreen is one of the
only things that does a lot of big i2c transfers and ends up hitting
the DMA paths in the geni i2c driver.  It appears that KASAN adds
enough delay in my system to tickle a race condition in the DMA setup
code.

When the system hangs, I found that it was running the geni_i2c_irq()
over and over again.  It had these:

m_stat   = 0x04000080
rx_st    = 0x30000011
dm_tx_st = 0x00000000
dm_rx_st = 0x00000000
dma      = 0x00000001

Notably we're in DMA mode but are getting M_RX_IRQ_EN and
M_RX_FIFO_WATERMARK_EN over and over again.

Putting some traces in geni_i2c_rx_one_msg() showed that when we
failed we were getting to the start of geni_i2c_rx_one_msg() but were
never executing geni_se_rx_dma_prep().

I believe that the problem here is that we are starting the geni
command before we run geni_se_rx_dma_prep().  If a transfer makes it
far enough before we do that then we get into the state I have
observed.  Let's change the order, which seems to work fine.

Although problems were seen on the RX path, code inspection suggests
that the TX should be changed too.  Change it as well.

Fixes: 37692de5d523 ("i2c: i2c-qcom-geni: Add bus driver for the Qualcomm GENI I2C controller")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Akash Asthana <akashast@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Mukesh Kumar Savaliya <msavaliy@codeaurora.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 18d1e4fd4cf34..7f130829bf018 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -367,7 +367,6 @@ static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		geni_se_select_mode(se, GENI_SE_FIFO);
 
 	writel_relaxed(len, se->base + SE_I2C_RX_TRANS_LEN);
-	geni_se_setup_m_cmd(se, I2C_READ, m_param);
 
 	if (dma_buf && geni_se_rx_dma_prep(se, dma_buf, len, &rx_dma)) {
 		geni_se_select_mode(se, GENI_SE_FIFO);
@@ -375,6 +374,8 @@ static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		dma_buf = NULL;
 	}
 
+	geni_se_setup_m_cmd(se, I2C_READ, m_param);
+
 	time_left = wait_for_completion_timeout(&gi2c->done, XFER_TIMEOUT);
 	if (!time_left)
 		geni_i2c_abort_xfer(gi2c);
@@ -408,7 +409,6 @@ static int geni_i2c_tx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		geni_se_select_mode(se, GENI_SE_FIFO);
 
 	writel_relaxed(len, se->base + SE_I2C_TX_TRANS_LEN);
-	geni_se_setup_m_cmd(se, I2C_WRITE, m_param);
 
 	if (dma_buf && geni_se_tx_dma_prep(se, dma_buf, len, &tx_dma)) {
 		geni_se_select_mode(se, GENI_SE_FIFO);
@@ -416,6 +416,8 @@ static int geni_i2c_tx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 		dma_buf = NULL;
 	}
 
+	geni_se_setup_m_cmd(se, I2C_WRITE, m_param);
+
 	if (!dma_buf) /* Get FIFO IRQ */
 		writel_relaxed(1, se->base + SE_GENI_TX_WATERMARK_REG);
 
-- 
2.25.1



