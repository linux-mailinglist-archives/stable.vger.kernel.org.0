Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644D1603C84
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJSIsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJSIry (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:47:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBD868882;
        Wed, 19 Oct 2022 01:45:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6004761804;
        Wed, 19 Oct 2022 08:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71665C433D6;
        Wed, 19 Oct 2022 08:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168961;
        bh=DKXEvkae9Qlu8kF9vn+0R4ngMyO0P2H39NsbsvQknGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pf3+/k5irivnJHcVhHx5pNJDwKxPwej9CzZN6KbU0hieVBgkQD/opq/VbuXA8x+Ur
         MJ7V1XKlytOiheIkdpReqZbBEcGLnKN0Qy9KB41qkHmac6dr2tWzRBSxyWZaWtHyel
         S4Zj6OERf8UTgNZ0r2Dg4dMlRCAvfFNYgol0sVF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 073/862] dmaengine: qcom-adm: fix wrong calling convention for prep_slave_sg
Date:   Wed, 19 Oct 2022 10:22:40 +0200
Message-Id: <20221019083253.160008981@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Marangi <ansuelsmth@gmail.com>

commit b9d2140c3badf4107973ad77c5a0ec3075705c85 upstream.

The calling convention for pre_slave_sg is to return NULL on error and
provide an error log to the system. Qcom-adm instead provide error
pointer when an error occur. This indirectly cause kernel panic for
example for the nandc driver that checks only if the pointer returned by
device_prep_slave_sg is not NULL. Returning an error pointer makes nandc
think the device_prep_slave_sg function correctly completed and makes
the kernel panics later in the code.

While nandc is the one that makes the kernel crash, it was pointed out
that the real problem is qcom-adm not following calling convention for
that function.

To fix this, drop returning error pointer and return NULL with an error
log.

Fixes: 03de6b273805 ("dmaengine: qcom-adm: stop abusing slave_id config")
Fixes: 5c9f8c2dbdbe ("dmaengine: qcom: Add ADM driver")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.11+
Link: https://lore.kernel.org/r/20220916041256.7104-1-ansuelsmth@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/qcom/qcom_adm.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/dma/qcom/qcom_adm.c
+++ b/drivers/dma/qcom/qcom_adm.c
@@ -379,13 +379,13 @@ static struct dma_async_tx_descriptor *a
 		if (blk_size < 0) {
 			dev_err(adev->dev, "invalid burst value: %d\n",
 				burst);
-			return ERR_PTR(-EINVAL);
+			return NULL;
 		}
 
 		crci = achan->crci & 0xf;
 		if (!crci || achan->crci > 0x1f) {
 			dev_err(adev->dev, "invalid crci value\n");
-			return ERR_PTR(-EINVAL);
+			return NULL;
 		}
 	}
 
@@ -403,8 +403,10 @@ static struct dma_async_tx_descriptor *a
 	}
 
 	async_desc = kzalloc(sizeof(*async_desc), GFP_NOWAIT);
-	if (!async_desc)
-		return ERR_PTR(-ENOMEM);
+	if (!async_desc) {
+		dev_err(adev->dev, "not enough memory for async_desc struct\n");
+		return NULL;
+	}
 
 	async_desc->mux = achan->mux ? ADM_CRCI_CTL_MUX_SEL : 0;
 	async_desc->crci = crci;
@@ -414,8 +416,10 @@ static struct dma_async_tx_descriptor *a
 				sizeof(*cple) + 2 * ADM_DESC_ALIGN;
 
 	async_desc->cpl = kzalloc(async_desc->dma_len, GFP_NOWAIT);
-	if (!async_desc->cpl)
+	if (!async_desc->cpl) {
+		dev_err(adev->dev, "not enough memory for cpl struct\n");
 		goto free;
+	}
 
 	async_desc->adev = adev;
 
@@ -437,8 +441,10 @@ static struct dma_async_tx_descriptor *a
 	async_desc->dma_addr = dma_map_single(adev->dev, async_desc->cpl,
 					      async_desc->dma_len,
 					      DMA_TO_DEVICE);
-	if (dma_mapping_error(adev->dev, async_desc->dma_addr))
+	if (dma_mapping_error(adev->dev, async_desc->dma_addr)) {
+		dev_err(adev->dev, "dma mapping error for cpl\n");
 		goto free;
+	}
 
 	cple_addr = async_desc->dma_addr + ((void *)cple - async_desc->cpl);
 
@@ -454,7 +460,7 @@ static struct dma_async_tx_descriptor *a
 
 free:
 	kfree(async_desc);
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 /**


