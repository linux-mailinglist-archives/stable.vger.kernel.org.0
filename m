Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C53583137
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbiG0Rsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243201AbiG0RsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:48:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5505F2E9F7;
        Wed, 27 Jul 2022 09:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2152BB821AC;
        Wed, 27 Jul 2022 16:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0CEC433D6;
        Wed, 27 Jul 2022 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940837;
        bh=Nz5k/Pa4IhuCRVsu7UChZptB4Ka9QpSOYr0VI7yB1mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykKm8yErsQe6Tv6TWPNuFtE4//NY8UD0HEZuJX1lHLLykn8xJp8TqADhh2/8AhMpk
         PMcnw058rnPUZ5Apz5ZZ4vUMZ4xuxrOquLVcrolUYhMM1Sgrxh0NUxW19a1N8/fn2o
         eLunvE9up1j1AbR9VP9dWR2A+BVuPHnDnEFm47/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.18 131/158] spi: bcm2835: bcm2835_spi_handle_err(): fix NULL pointer deref for non DMA transfers
Date:   Wed, 27 Jul 2022 18:13:15 +0200
Message-Id: <20220727161026.649979100@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 4ceaa684459d414992acbefb4e4c31f2dfc50641 upstream.

In case a IRQ based transfer times out the bcm2835_spi_handle_err()
function is called. Since commit 1513ceee70f2 ("spi: bcm2835: Drop
dma_pending flag") the TX and RX DMA transfers are unconditionally
canceled, leading to NULL pointer derefs if ctlr->dma_tx or
ctlr->dma_rx are not set.

Fix the NULL pointer deref by checking that ctlr->dma_tx and
ctlr->dma_rx are valid pointers before accessing them.

Fixes: 1513ceee70f2 ("spi: bcm2835: Drop dma_pending flag")
Cc: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20220719072234.2782764-1-mkl@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm2835.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1138,10 +1138,14 @@ static void bcm2835_spi_handle_err(struc
 	struct bcm2835_spi *bs = spi_controller_get_devdata(ctlr);
 
 	/* if an error occurred and we have an active dma, then terminate */
-	dmaengine_terminate_sync(ctlr->dma_tx);
-	bs->tx_dma_active = false;
-	dmaengine_terminate_sync(ctlr->dma_rx);
-	bs->rx_dma_active = false;
+	if (ctlr->dma_tx) {
+		dmaengine_terminate_sync(ctlr->dma_tx);
+		bs->tx_dma_active = false;
+	}
+	if (ctlr->dma_rx) {
+		dmaengine_terminate_sync(ctlr->dma_rx);
+		bs->rx_dma_active = false;
+	}
 	bcm2835_spi_undo_prologue(bs);
 
 	/* and reset */


