Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A45582D4A
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbiG0QzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240569AbiG0Qx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:53:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07851025;
        Wed, 27 Jul 2022 09:35:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D13161A90;
        Wed, 27 Jul 2022 16:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC1CC433D7;
        Wed, 27 Jul 2022 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939712;
        bh=+rV4JY9n8a2iKgQ+TTEEimbDlhhzuyUdhmvcKyKyi1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSAN4j0CPQsLNGuqyMkVj9gtIH7NsXwAwRnxK/fUT6QJHyeKPrpQyUIOapyy5LAQD
         G2aV4UDj/cFulswAX0jI8zPeBmip1C7E57rWKuwkDdm/U4JDX0LzREifSCt8vwPVj6
         HQs5jerU03Bt441O9AbX7z6RjLoZAex8YRUEawwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 077/105] spi: bcm2835: bcm2835_spi_handle_err(): fix NULL pointer deref for non DMA transfers
Date:   Wed, 27 Jul 2022 18:11:03 +0200
Message-Id: <20220727161015.162983431@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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
@@ -1174,10 +1174,14 @@ static void bcm2835_spi_handle_err(struc
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


