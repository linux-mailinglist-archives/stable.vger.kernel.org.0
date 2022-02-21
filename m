Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50B84BE748
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350780AbiBUJjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351635AbiBUJhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:37:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BFE205CB;
        Mon, 21 Feb 2022 01:16:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8CA260018;
        Mon, 21 Feb 2022 09:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6748C340E9;
        Mon, 21 Feb 2022 09:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434976;
        bh=Kj5P1zY5l6pTNOhGPDTG6um+5ioqc9DX0x+C/sMtssQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQb+A/wWZZVsNCdfvZvOR8nHxF+A35kZq+AL53wzP6UPbVOKc3RS4580weyIY/dBL
         W/qBvJMZK09Szhtme0uS54oaIyWiQIwJAeGSTQE/2Z40uYwl2jIw3+ctutAr7MmQi3
         FAuSVLPCMkC8yL6KccfqZsuFteHEqsnCI+mtgSXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 187/196] dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size
Date:   Mon, 21 Feb 2022 09:50:19 +0100
Message-Id: <20220221084937.206219394@linuxfoundation.org>
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

commit da2ad87fba0891576aadda9161b8505fde81a84d upstream.

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: 97d49c59e219 ("dmaengine: rcar-dmac: set scatter/gather max segment size")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220111011239.452837-1-jiasheng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/rcar-dmac.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1868,7 +1868,10 @@ static int rcar_dmac_probe(struct platfo
 
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
-	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	ret = dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	if (ret)
+		return ret;
+
 	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
 	if (ret)
 		return ret;


