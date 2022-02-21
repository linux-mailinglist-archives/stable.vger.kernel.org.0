Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37214BD74C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 08:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345850AbiBUHKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 02:10:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345852AbiBUHKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 02:10:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE47BEF
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 23:09:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C010B80E7A
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 07:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6380CC340E9;
        Mon, 21 Feb 2022 07:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645427391;
        bh=M8wwZQMt/N9YSAEeN1rOI+oU9ra2w8JckrlX5gsI9T4=;
        h=Subject:To:Cc:From:Date:From;
        b=NUHJy0XXObD/Hmosx0WNylodtplLZ19nDrEtHf42WGNgBlX6tomolgxks8aULz6/i
         fLVLgcXsv6JL4NqIwNy7NtMWuIruX/4CuyN2zDm4PnwmAqSZ5dpMpYl1PCVUqZ7fOC
         V7b/AuSXFyNFXB6FcBJeegNkFJiD9E/1y1mdNKgM=
Subject: FAILED: patch "[PATCH] dmaengine: sh: rcar-dmac: Check for error num after" failed to apply to 4.14-stable tree
To:     jiasheng@iscas.ac.cn, geert+renesas@glider.be, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 08:09:48 +0100
Message-ID: <164542738847126@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
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

