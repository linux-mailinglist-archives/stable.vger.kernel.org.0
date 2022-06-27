Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE5855D57B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiF0LoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbiF0LnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:43:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB319639F;
        Mon, 27 Jun 2022 04:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3701C6114F;
        Mon, 27 Jun 2022 11:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BA2C3411D;
        Mon, 27 Jun 2022 11:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329922;
        bh=IRmThKysSLlpUtiRWc9wKOq0pKCTMvyUDvxk8mYfgqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdPKdKLiJG90LyizHzQKPHViOAZwJThHQLQgTJYdPUFMjYRaUvdMYoq5j5KdXRV8+
         SHd7y7UZ0u7a82c1aJ3vmS4jHrZisFGetlnkE/EVEM6Kg6auXqBDhbBp+MUrYK63w0
         ++N2yb1CB1ktkP89VhCZDhNznpyCaiPY6iQjOTH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mengqi Zhang <mengqi.zhang@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.18 024/181] mmc: mediatek: wait dma stop bit reset to 0
Date:   Mon, 27 Jun 2022 13:19:57 +0200
Message-Id: <20220627111945.266129119@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mengqi Zhang <mengqi.zhang@mediatek.com>

commit 89bcd9a64b849380ef57e3032b307574e48db524 upstream.

MediaTek IP requires that after dma stop, it need to wait this dma stop
bit auto-reset to 0. When bus is in high loading state, it will take a
while for the dma stop complete. If there is no waiting operation here,
when program runs to clear fifo and reset, bus will hang.

In addition, there should be no return in msdc_data_xfer_next() if
there is data need be transferred, because no matter what error occurs
here, it should continue to excute to the following mmc_request_done.
Otherwise the core layer may wait complete forever.

Signed-off-by: Mengqi Zhang <mengqi.zhang@mediatek.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220609112239.18911-1-mengqi.zhang@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1356,7 +1356,7 @@ static void msdc_data_xfer_next(struct m
 		msdc_request_done(host, mrq);
 }
 
-static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
+static void msdc_data_xfer_done(struct msdc_host *host, u32 events,
 				struct mmc_request *mrq, struct mmc_data *data)
 {
 	struct mmc_command *stop;
@@ -1376,7 +1376,7 @@ static bool msdc_data_xfer_done(struct m
 	spin_unlock_irqrestore(&host->lock, flags);
 
 	if (done)
-		return true;
+		return;
 	stop = data->stop;
 
 	if (check_data || (stop && stop->error)) {
@@ -1385,12 +1385,15 @@ static bool msdc_data_xfer_done(struct m
 		sdr_set_field(host->base + MSDC_DMA_CTRL, MSDC_DMA_CTRL_STOP,
 				1);
 
+		ret = readl_poll_timeout_atomic(host->base + MSDC_DMA_CTRL, val,
+						!(val & MSDC_DMA_CTRL_STOP), 1, 20000);
+		if (ret)
+			dev_dbg(host->dev, "DMA stop timed out\n");
+
 		ret = readl_poll_timeout_atomic(host->base + MSDC_DMA_CFG, val,
 						!(val & MSDC_DMA_CFG_STS), 1, 20000);
-		if (ret) {
-			dev_dbg(host->dev, "DMA stop timed out\n");
-			return false;
-		}
+		if (ret)
+			dev_dbg(host->dev, "DMA inactive timed out\n");
 
 		sdr_clr_bits(host->base + MSDC_INTEN, data_ints_mask);
 		dev_dbg(host->dev, "DMA stop\n");
@@ -1415,9 +1418,7 @@ static bool msdc_data_xfer_done(struct m
 		}
 
 		msdc_data_xfer_next(host, mrq);
-		done = true;
 	}
-	return done;
 }
 
 static void msdc_set_buswidth(struct msdc_host *host, u32 width)
@@ -2416,6 +2417,9 @@ static void msdc_cqe_disable(struct mmc_
 	if (recovery) {
 		sdr_set_field(host->base + MSDC_DMA_CTRL,
 			      MSDC_DMA_CTRL_STOP, 1);
+		if (WARN_ON(readl_poll_timeout(host->base + MSDC_DMA_CTRL, val,
+			!(val & MSDC_DMA_CTRL_STOP), 1, 3000)))
+			return;
 		if (WARN_ON(readl_poll_timeout(host->base + MSDC_DMA_CFG, val,
 			!(val & MSDC_DMA_CFG_STS), 1, 3000)))
 			return;


