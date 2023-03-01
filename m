Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5BC6A72A7
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjCASII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjCASIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:08:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FC14AFD0
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:07:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39149B810D6
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBA6C4339B;
        Wed,  1 Mar 2023 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694066;
        bh=8LBZxdm372jxLC8ZhItmbl6QwtsaUE4WNTfcIL3TMt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdUQRg8rwiD2zPFTDrhcJbtBkc0mhrjOhkISdeNb2u4IQNGgNMUaWNqozWbQELEwp
         p2mGzYAOX8mNepg1oqppJMq17zYdKh72/64KVkFvSrliCLEDm6OonOXZTfEMnQbsDr
         fGSMyj+u/f0Ahb1UfwPbPaS0oj+h1OwCf4mBLjnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Vinod Koul <vkoul@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 7/9] dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size
Date:   Wed,  1 Mar 2023 19:07:23 +0100
Message-Id: <20230301180650.679766964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>
References: <20230301180650.395562988@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/dma/sh/rcar-dmac.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1816,7 +1816,10 @@ static int rcar_dmac_probe(struct platfo
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
 	dmac->dev->dma_parms = &dmac->parms;
-	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	ret = dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	if (ret)
+		return ret;
+
 	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
 	if (ret)
 		return ret;


