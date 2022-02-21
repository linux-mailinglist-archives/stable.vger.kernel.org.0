Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC88C4BDC4B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350739AbiBUJj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351585AbiBUJh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:37:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE093A5E1;
        Mon, 21 Feb 2022 01:16:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7412A60C1D;
        Mon, 21 Feb 2022 09:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C61C340E9;
        Mon, 21 Feb 2022 09:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434961;
        bh=iL+rlQ5kuc2Mat8DU3mcVFaTxdmYQC76utMHrm2gPHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adSllQ0PMtX4X0ASmout0mKAES/Nw+tsTsCZYeobMhzV6pUIqpuaXe2AtEBGtiWAV
         eOLC3J3ZfsuF5wOxCQm/gGZyNdgrkICrBK3RRuD42IaPJtEG8LcplGBclom7Z9qwcY
         3zwjqx5jnIja5rq7fj2oMvCpjwbaV2YRl62oDpWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 185/196] dmaengine: sh: rcar-dmac: Check for error num after setting mask
Date:   Mon, 21 Feb 2022 09:50:17 +0100
Message-Id: <20220221084937.125928023@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit 2d21543efe332cd8c8f212fb7d365bc8b0690bfa upstream.

Because of the possible failure of the dma_supported(), the
dma_set_mask_and_coherent() may return error num.
Therefore, it should be better to check it and return the error if
fails.

Fixes: dc312349e875 ("dmaengine: rcar-dmac: Widen DMA mask to 40 bits")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220106030939.2644320-1-jiasheng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/rcar-dmac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1869,7 +1869,9 @@ static int rcar_dmac_probe(struct platfo
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
 	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
-	dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
+	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
+	if (ret)
+		return ret;
 
 	ret = rcar_dmac_parse_of(&pdev->dev, dmac);
 	if (ret < 0)


