Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D12593F96
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245314AbiHOVC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347661AbiHOVCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:02:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965DDCE48A;
        Mon, 15 Aug 2022 12:14:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3400FB8111E;
        Mon, 15 Aug 2022 19:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDF0C433C1;
        Mon, 15 Aug 2022 19:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590849;
        bh=fZqr0HeqVX/CO92GLshtVf3UowJIdnYMudi1aIHwhnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJkcuaFnLxSTwsznWGfFCAMnR/wkNu/fSJSDr3cjqy7ro1i8n3KrLA4AroD870pdv
         ZQSMpLtmpYuKDTXFSUccteQYNdRDLG/h+BlE61SG5Qe4uVptxxfeXCLWtGfgi5Zh5F
         NL/wcVQWQTDtq2fUMe63i9kyrion5eO7b4zTj/ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0390/1095] drm/vc4: dsi: Fix dsi0 interrupt support
Date:   Mon, 15 Aug 2022 19:56:29 +0200
Message-Id: <20220815180445.826563250@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit bc5b815e06f90cccdb6461aba1e49fdc2f3c8cd1 ]

DSI0 seemingly had very little or no testing as a load of
the register mappings were incorrect/missing, so host
transfers always timed out due to enabling/checking incorrect
bits in the interrupt enable and status registers.

Fixes: 4078f5757144 ("drm/vc4: Add DSI driver")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-16-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 111 ++++++++++++++++++++++++++--------
 1 file changed, 85 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index 97a258c934af..333ea96fcde4 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -181,8 +181,50 @@
 
 #define DSI0_TXPKT_PIX_FIFO		0x20 /* AKA PIX_FIFO */
 
-#define DSI0_INT_STAT		0x24
-#define DSI0_INT_EN		0x28
+#define DSI0_INT_STAT			0x24
+#define DSI0_INT_EN			0x28
+# define DSI0_INT_FIFO_ERR		BIT(25)
+# define DSI0_INT_CMDC_DONE_MASK	VC4_MASK(24, 23)
+# define DSI0_INT_CMDC_DONE_SHIFT	23
+#  define DSI0_INT_CMDC_DONE_NO_REPEAT		1
+#  define DSI0_INT_CMDC_DONE_REPEAT		3
+# define DSI0_INT_PHY_DIR_RTF		BIT(22)
+# define DSI0_INT_PHY_D1_ULPS		BIT(21)
+# define DSI0_INT_PHY_D1_STOP		BIT(20)
+# define DSI0_INT_PHY_RXLPDT		BIT(19)
+# define DSI0_INT_PHY_RXTRIG		BIT(18)
+# define DSI0_INT_PHY_D0_ULPS		BIT(17)
+# define DSI0_INT_PHY_D0_LPDT		BIT(16)
+# define DSI0_INT_PHY_D0_FTR		BIT(15)
+# define DSI0_INT_PHY_D0_STOP		BIT(14)
+/* Signaled when the clock lane enters the given state. */
+# define DSI0_INT_PHY_CLK_ULPS		BIT(13)
+# define DSI0_INT_PHY_CLK_HS		BIT(12)
+# define DSI0_INT_PHY_CLK_FTR		BIT(11)
+/* Signaled on timeouts */
+# define DSI0_INT_PR_TO			BIT(10)
+# define DSI0_INT_TA_TO			BIT(9)
+# define DSI0_INT_LPRX_TO		BIT(8)
+# define DSI0_INT_HSTX_TO		BIT(7)
+/* Contention on a line when trying to drive the line low */
+# define DSI0_INT_ERR_CONT_LP1		BIT(6)
+# define DSI0_INT_ERR_CONT_LP0		BIT(5)
+/* Control error: incorrect line state sequence on data lane 0. */
+# define DSI0_INT_ERR_CONTROL		BIT(4)
+# define DSI0_INT_ERR_SYNC_ESC		BIT(3)
+# define DSI0_INT_RX2_PKT		BIT(2)
+# define DSI0_INT_RX1_PKT		BIT(1)
+# define DSI0_INT_CMD_PKT		BIT(0)
+
+#define DSI0_INTERRUPTS_ALWAYS_ENABLED	(DSI0_INT_ERR_SYNC_ESC | \
+					 DSI0_INT_ERR_CONTROL |	 \
+					 DSI0_INT_ERR_CONT_LP0 | \
+					 DSI0_INT_ERR_CONT_LP1 | \
+					 DSI0_INT_HSTX_TO |	 \
+					 DSI0_INT_LPRX_TO |	 \
+					 DSI0_INT_TA_TO |	 \
+					 DSI0_INT_PR_TO)
+
 # define DSI1_INT_PHY_D3_ULPS		BIT(30)
 # define DSI1_INT_PHY_D3_STOP		BIT(29)
 # define DSI1_INT_PHY_D2_ULPS		BIT(28)
@@ -892,6 +934,9 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 
 		DSI_PORT_WRITE(PHY_AFEC0, afec0);
 
+		/* AFEC reset hold time */
+		mdelay(1);
+
 		DSI_PORT_WRITE(PHY_AFEC1,
 			       VC4_SET_FIELD(6,  DSI0_PHY_AFEC1_IDR_DLANE1) |
 			       VC4_SET_FIELD(6,  DSI0_PHY_AFEC1_IDR_DLANE0) |
@@ -1058,12 +1103,9 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 		DSI_PORT_WRITE(CTRL, DSI_PORT_READ(CTRL) | DSI1_CTRL_EN);
 
 	/* Bring AFE out of reset. */
-	if (dsi->variant->port == 0) {
-	} else {
-		DSI_PORT_WRITE(PHY_AFEC0,
-			       DSI_PORT_READ(PHY_AFEC0) &
-			       ~DSI1_PHY_AFEC0_RESET);
-	}
+	DSI_PORT_WRITE(PHY_AFEC0,
+		       DSI_PORT_READ(PHY_AFEC0) &
+		       ~DSI_PORT_BIT(PHY_AFEC0_RESET));
 
 	vc4_dsi_ulps(dsi, false);
 
@@ -1182,13 +1224,28 @@ static ssize_t vc4_dsi_host_transfer(struct mipi_dsi_host *host,
 	/* Enable the appropriate interrupt for the transfer completion. */
 	dsi->xfer_result = 0;
 	reinit_completion(&dsi->xfer_completion);
-	DSI_PORT_WRITE(INT_STAT, DSI1_INT_TXPKT1_DONE | DSI1_INT_PHY_DIR_RTF);
-	if (msg->rx_len) {
-		DSI_PORT_WRITE(INT_EN, (DSI1_INTERRUPTS_ALWAYS_ENABLED |
-					DSI1_INT_PHY_DIR_RTF));
+	if (dsi->variant->port == 0) {
+		DSI_PORT_WRITE(INT_STAT,
+			       DSI0_INT_CMDC_DONE_MASK | DSI1_INT_PHY_DIR_RTF);
+		if (msg->rx_len) {
+			DSI_PORT_WRITE(INT_EN, (DSI0_INTERRUPTS_ALWAYS_ENABLED |
+						DSI0_INT_PHY_DIR_RTF));
+		} else {
+			DSI_PORT_WRITE(INT_EN,
+				       (DSI0_INTERRUPTS_ALWAYS_ENABLED |
+					VC4_SET_FIELD(DSI0_INT_CMDC_DONE_NO_REPEAT,
+						      DSI0_INT_CMDC_DONE)));
+		}
 	} else {
-		DSI_PORT_WRITE(INT_EN, (DSI1_INTERRUPTS_ALWAYS_ENABLED |
-					DSI1_INT_TXPKT1_DONE));
+		DSI_PORT_WRITE(INT_STAT,
+			       DSI1_INT_TXPKT1_DONE | DSI1_INT_PHY_DIR_RTF);
+		if (msg->rx_len) {
+			DSI_PORT_WRITE(INT_EN, (DSI1_INTERRUPTS_ALWAYS_ENABLED |
+						DSI1_INT_PHY_DIR_RTF));
+		} else {
+			DSI_PORT_WRITE(INT_EN, (DSI1_INTERRUPTS_ALWAYS_ENABLED |
+						DSI1_INT_TXPKT1_DONE));
+		}
 	}
 
 	/* Send the packet. */
@@ -1205,7 +1262,7 @@ static ssize_t vc4_dsi_host_transfer(struct mipi_dsi_host *host,
 		ret = dsi->xfer_result;
 	}
 
-	DSI_PORT_WRITE(INT_EN, DSI1_INTERRUPTS_ALWAYS_ENABLED);
+	DSI_PORT_WRITE(INT_EN, DSI_PORT_BIT(INTERRUPTS_ALWAYS_ENABLED));
 
 	if (ret)
 		goto reset_fifo_and_return;
@@ -1251,7 +1308,7 @@ static ssize_t vc4_dsi_host_transfer(struct mipi_dsi_host *host,
 		       DSI_PORT_BIT(CTRL_RESET_FIFOS));
 
 	DSI_PORT_WRITE(TXPKT1C, 0);
-	DSI_PORT_WRITE(INT_EN, DSI1_INTERRUPTS_ALWAYS_ENABLED);
+	DSI_PORT_WRITE(INT_EN, DSI_PORT_BIT(INTERRUPTS_ALWAYS_ENABLED));
 	return ret;
 }
 
@@ -1388,26 +1445,28 @@ static irqreturn_t vc4_dsi_irq_handler(int irq, void *data)
 	DSI_PORT_WRITE(INT_STAT, stat);
 
 	dsi_handle_error(dsi, &ret, stat,
-			 DSI1_INT_ERR_SYNC_ESC, "LPDT sync");
+			 DSI_PORT_BIT(INT_ERR_SYNC_ESC), "LPDT sync");
 	dsi_handle_error(dsi, &ret, stat,
-			 DSI1_INT_ERR_CONTROL, "data lane 0 sequence");
+			 DSI_PORT_BIT(INT_ERR_CONTROL), "data lane 0 sequence");
 	dsi_handle_error(dsi, &ret, stat,
-			 DSI1_INT_ERR_CONT_LP0, "LP0 contention");
+			 DSI_PORT_BIT(INT_ERR_CONT_LP0), "LP0 contention");
 	dsi_handle_error(dsi, &ret, stat,
-			 DSI1_INT_ERR_CONT_LP1, "LP1 contention");
+			 DSI_PORT_BIT(INT_ERR_CONT_LP1), "LP1 contention");
 	dsi_handle_error(dsi, &ret, stat,
-			 DSI1_INT_HSTX_TO, "HSTX timeout");
+			 DSI_PORT_BIT(INT_HSTX_TO), "HSTX timeout");
 	dsi_handle_error(dsi, &ret, stat,
-			 DSI1_INT_LPRX_TO, "LPRX timeout");
+			 DSI_PORT_BIT(INT_LPRX_TO), "LPRX timeout");
 	dsi_handle_error(dsi, &ret, stat,
-			 DSI1_INT_TA_TO, "turnaround timeout");
+			 DSI_PORT_BIT(INT_TA_TO), "turnaround timeout");
 	dsi_handle_error(dsi, &ret, stat,
-			 DSI1_INT_PR_TO, "peripheral reset timeout");
+			 DSI_PORT_BIT(INT_PR_TO), "peripheral reset timeout");
 
-	if (stat & (DSI1_INT_TXPKT1_DONE | DSI1_INT_PHY_DIR_RTF)) {
+	if (stat & ((dsi->variant->port ? DSI1_INT_TXPKT1_DONE :
+					  DSI0_INT_CMDC_DONE_MASK) |
+		    DSI_PORT_BIT(INT_PHY_DIR_RTF))) {
 		complete(&dsi->xfer_completion);
 		ret = IRQ_HANDLED;
-	} else if (stat & DSI1_INT_HSTX_TO) {
+	} else if (stat & DSI_PORT_BIT(INT_HSTX_TO)) {
 		complete(&dsi->xfer_completion);
 		dsi->xfer_result = -ETIMEDOUT;
 		ret = IRQ_HANDLED;
-- 
2.35.1



