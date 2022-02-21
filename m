Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3034BDE4A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346943AbiBUJDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347485AbiBUJB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:01:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD66360C0;
        Mon, 21 Feb 2022 00:56:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F466B80EAF;
        Mon, 21 Feb 2022 08:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556B6C340F1;
        Mon, 21 Feb 2022 08:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433791;
        bh=kFWU/qVNY7RS+nn/qS0y7zGIjLNV/ntVRPEsieqg5lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaBowNK4VPbo99PawXR3WkkRaHyu+zU/sWMr/gsGhDfPveb5GsBBAE1zIyL3cHMx3
         bBAcbdKlcNYB1t+IdtDMEgJv8+z0A1x5AaLCpeltYl1G245Z1XcIyepMXM41ugsg6N
         umBdXUo/u0xR4qUgqXAamYOwAYeH5PWk2n2f3Kvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 43/58] dmaengine: sh: rcar-dmac: Check for error num after setting mask
Date:   Mon, 21 Feb 2022 09:49:36 +0100
Message-Id: <20220221084913.271805148@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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
@@ -1817,7 +1817,9 @@ static int rcar_dmac_probe(struct platfo
 	platform_set_drvdata(pdev, dmac);
 	dmac->dev->dma_parms = &dmac->parms;
 	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
-	dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
+	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
+	if (ret)
+		return ret;
 
 	ret = rcar_dmac_parse_of(&pdev->dev, dmac);
 	if (ret < 0)


