Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDB04BD72F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 08:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345852AbiBUHKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 02:10:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345851AbiBUHKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 02:10:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3ECB69
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 23:10:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9363CE0E16
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 07:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F62EC340E9;
        Mon, 21 Feb 2022 07:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645427397;
        bh=pEYmByWiwKF2X3QQJLd8VlvotDohA7aADSGU7llfhfY=;
        h=Subject:To:Cc:From:Date:From;
        b=bkmU4gorN9/8sD3ZCfx5m8qUrnl/RPmTNmHcvqlcmXfnDxm8X9LaddWeicJ8bemVb
         cXFz5Qzh7KHECbPHj9JBLqdAYd+8hgSI7aZaGz6N0J0xBQe1vZPP1CYhgIgVkxiT6s
         f05vuyRv6cFot6+Y76ycfIjtgqhyEFkFMiHI0Ynk=
Subject: FAILED: patch "[PATCH] dmaengine: sh: rcar-dmac: Check for error num after" failed to apply to 5.4-stable tree
To:     jiasheng@iscas.ac.cn, geert+renesas@glider.be, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 08:09:49 +0100
Message-ID: <1645427389179147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da2ad87fba0891576aadda9161b8505fde81a84d Mon Sep 17 00:00:00 2001
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Date: Tue, 11 Jan 2022 09:12:39 +0800
Subject: [PATCH] dmaengine: sh: rcar-dmac: Check for error num after
 dma_set_max_seg_size

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: 97d49c59e219 ("dmaengine: rcar-dmac: set scatter/gather max segment size")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220111011239.452837-1-jiasheng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index 4a34ddd9c1c6..13d12d660cc2 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1868,7 +1868,10 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 
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

