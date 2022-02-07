Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AD64ABD3F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387181AbiBGLkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386606AbiBGLfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:35:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB677C043181;
        Mon,  7 Feb 2022 03:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B8A8B8102E;
        Mon,  7 Feb 2022 11:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDA3C004E1;
        Mon,  7 Feb 2022 11:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233704;
        bh=+G3hb5+RB2uCCKVlicO2SP2tFVuFlczkrJDxVN1aZDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfPcXSW9PE62VB75Dcvz6jkSPkfDll7dkH4i1VCZmliLNR7x22CRCCp9H2FzRnx/Q
         S2ZKV7a8TTR4O/EK35Q+U5tdjIbGlujaPhXUWq7+W7EmWP5j5iMc6GKp8n7V7Zy9Vi
         HAVdK1i+iN5DYa8UGaigqQqJMaVXhVWb1FimUnRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 062/126] spi: uniphier: fix reference count leak in uniphier_spi_probe()
Date:   Mon,  7 Feb 2022 12:06:33 +0100
Message-Id: <20220207103806.254652960@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

commit 37c2c83ca4f1ef4b6908181ac98e18360af89b42 upstream.

The issue happens in several error paths in uniphier_spi_probe().
When either dma_get_slave_caps() or devm_spi_register_master() returns
an error code, the function forgets to decrease the refcount of both
`dma_rx` and `dma_tx` objects, which may lead to refcount leaks.

Fix it by decrementing the reference count of specific objects in
those error paths.

Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Fixes: 28d1dddc59f6 ("spi: uniphier: Add DMA transfer mode support")
Link: https://lore.kernel.org/r/20220125101214.35677-1-xiongx18@fudan.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-uniphier.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -726,7 +726,7 @@ static int uniphier_spi_probe(struct pla
 		if (ret) {
 			dev_err(&pdev->dev, "failed to get TX DMA capacities: %d\n",
 				ret);
-			goto out_disable_clk;
+			goto out_release_dma;
 		}
 		dma_tx_burst = caps.max_burst;
 	}
@@ -735,7 +735,7 @@ static int uniphier_spi_probe(struct pla
 	if (IS_ERR_OR_NULL(master->dma_rx)) {
 		if (PTR_ERR(master->dma_rx) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
-			goto out_disable_clk;
+			goto out_release_dma;
 		}
 		master->dma_rx = NULL;
 		dma_rx_burst = INT_MAX;
@@ -744,7 +744,7 @@ static int uniphier_spi_probe(struct pla
 		if (ret) {
 			dev_err(&pdev->dev, "failed to get RX DMA capacities: %d\n",
 				ret);
-			goto out_disable_clk;
+			goto out_release_dma;
 		}
 		dma_rx_burst = caps.max_burst;
 	}
@@ -753,10 +753,20 @@ static int uniphier_spi_probe(struct pla
 
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (ret)
-		goto out_disable_clk;
+		goto out_release_dma;
 
 	return 0;
 
+out_release_dma:
+	if (!IS_ERR_OR_NULL(master->dma_rx)) {
+		dma_release_channel(master->dma_rx);
+		master->dma_rx = NULL;
+	}
+	if (!IS_ERR_OR_NULL(master->dma_tx)) {
+		dma_release_channel(master->dma_tx);
+		master->dma_tx = NULL;
+	}
+
 out_disable_clk:
 	clk_disable_unprepare(priv->clk);
 


