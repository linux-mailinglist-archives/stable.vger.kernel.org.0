Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C05C549542
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243663AbiFMKai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245132AbiFMK1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:27:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E46245BB;
        Mon, 13 Jun 2022 03:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3927AB80E94;
        Mon, 13 Jun 2022 10:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD6FC34114;
        Mon, 13 Jun 2022 10:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115597;
        bh=r3w9mf82Q9TSr2F+49vnzyLqXi4WacsulumrBjsiqsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDOKp4KM94xSEj/bm9S+HHJ8FxnHo9ed2mrHexUYNHDM7npSmPMOzhcg2Vurwm1MH
         9xbWMzwcYcXM2jvjSDP42h3AtE3OsdfZ+3Iop5qFeoD1dTx2mjlZ8k+jFGMA3YFlLT
         mm3EXATkFrCAR6UD7s01aZi8TiBoXOEA0ZeGvhig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 131/167] video: fbdev: pxa3xx-gcu: release the resources correctly in pxa3xx_gcu_probe/remove()
Date:   Mon, 13 Jun 2022 12:10:05 +0200
Message-Id: <20220613094911.620869381@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d87ad457f7e1b8d2492ca5b1531eb35030a1cc8f ]

In pxa3xx_gcu_probe(), the sequence of error lable is wrong, it will
leads some resource leaked, so adjust the sequence to handle the error
correctly, and if pxa3xx_gcu_add_buffer() fails, pxa3xx_gcu_free_buffers()
need be called.
In pxa3xx_gcu_remove(), add missing clk_disable_unpreprare().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pxa3xx-gcu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
index 50bce45e7f3d..184773b6b9e4 100644
--- a/drivers/video/fbdev/pxa3xx-gcu.c
+++ b/drivers/video/fbdev/pxa3xx-gcu.c
@@ -662,6 +662,7 @@ static int pxa3xx_gcu_probe(struct platform_device *pdev)
 	for (i = 0; i < 8; i++) {
 		ret = pxa3xx_gcu_add_buffer(dev, priv);
 		if (ret) {
+			pxa3xx_gcu_free_buffers(dev, priv);
 			dev_err(dev, "failed to allocate DMA memory\n");
 			goto err_disable_clk;
 		}
@@ -677,15 +678,15 @@ static int pxa3xx_gcu_probe(struct platform_device *pdev)
 			SHARED_SIZE, irq);
 	return 0;
 
-err_free_dma:
-	dma_free_coherent(dev, SHARED_SIZE,
-			priv->shared, priv->shared_phys);
+err_disable_clk:
+	clk_disable_unprepare(priv->clk);
 
 err_misc_deregister:
 	misc_deregister(&priv->misc_dev);
 
-err_disable_clk:
-	clk_disable_unprepare(priv->clk);
+err_free_dma:
+	dma_free_coherent(dev, SHARED_SIZE,
+			  priv->shared, priv->shared_phys);
 
 	return ret;
 }
@@ -698,6 +699,7 @@ static int pxa3xx_gcu_remove(struct platform_device *pdev)
 	pxa3xx_gcu_wait_idle(priv);
 	misc_deregister(&priv->misc_dev);
 	dma_free_coherent(dev, SHARED_SIZE, priv->shared, priv->shared_phys);
+	clk_disable_unprepare(priv->clk);
 	pxa3xx_gcu_free_buffers(dev, priv);
 
 	return 0;
-- 
2.35.1



