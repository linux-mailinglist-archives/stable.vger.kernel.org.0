Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052A4627ED7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiKNMwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiKNMwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:52:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C1E252A5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:52:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8326112D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010EBC433D6;
        Mon, 14 Nov 2022 12:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430329;
        bh=xiikqHMCr52yhtg5rUwmSWj4mTcV+/D6KvAva8l/pOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxZT45YzNSV5Fq/4Neu6GL4qQD04PR/9z4y75L1MIkPueFFGOU/U5WBrcjCfUXaAG
         wXZIeM8F9GxpZm9b0quYA+FWkBPQy9s3GPWYyfaInfkI7jcnP0t8MKka+Pyul41DTk
         PIGILwR6AMM7uERBGSAbq1+7QFwUqXO7iaTFFAjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 93/95] dmaengine: at_hdmac: Check return code of dma_async_device_register
Date:   Mon, 14 Nov 2022 13:46:27 +0100
Message-Id: <20221114124446.368671891@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit c47e6403fa099f200868d6b106701cb42d181d2b upstream.

dma_async_device_register() can fail, check the return code and display an
error.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-16-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1901,7 +1901,11 @@ static int __init at_dma_probe(struct pl
 	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
 	  plat_dat->nr_channels);
 
-	dma_async_device_register(&atdma->dma_common);
+	err = dma_async_device_register(&atdma->dma_common);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to register: %d.\n", err);
+		goto err_dma_async_device_register;
+	}
 
 	/*
 	 * Do not return an error if the dmac node is not present in order to
@@ -1921,6 +1925,7 @@ static int __init at_dma_probe(struct pl
 
 err_of_dma_controller_register:
 	dma_async_device_unregister(&atdma->dma_common);
+err_dma_async_device_register:
 	dma_pool_destroy(atdma->memset_pool);
 err_memset_pool_create:
 	dma_pool_destroy(atdma->dma_desc_pool);


