Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EAF604018
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiJSJm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiJSJlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:41:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A74D57D9;
        Wed, 19 Oct 2022 02:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDE0661877;
        Wed, 19 Oct 2022 09:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E131BC433D7;
        Wed, 19 Oct 2022 09:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170372;
        bh=nHR/2PbanmSV3Ke5Rq57L14m7CqYrrb0pFEQAy9U4aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPxriR0+GRM9We3c8DXyhSfylhWOwegKTb1KzR/nXRxWH6cgcH0KQlm/0k1bK3aTT
         F3oR47LrWgxVUeiIlpIx8nNpYoscob+ZVwvBE34dD3ZvMM2U/r1R4hG2QF0cIJX+kt
         p5rajRMog6is9YMdemr3iSqC21/9LgNf0dt/egp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 629/862] hwrng: imx-rngc - use devm_clk_get_enabled
Date:   Wed, 19 Oct 2022 10:31:56 +0200
Message-Id: <20221019083317.708239220@linuxfoundation.org>
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

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 6a2bc448423cea44e7dba0f72d7c82ae04ab201e ]

Use the new devm_clk_get_enabled function to get our clock.

We don't have to disable and unprepare the clock ourselves any more in
error paths and in the remove function.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 10a2199caf43 ("hwrng: imx-rngc - Moving IRQ handler registering after imx_rngc_irq_mask_clear()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/imx-rngc.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index b05d676ca814..e32c52c10d4d 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -245,7 +245,7 @@ static int imx_rngc_probe(struct platform_device *pdev)
 	if (IS_ERR(rngc->base))
 		return PTR_ERR(rngc->base);
 
-	rngc->clk = devm_clk_get(&pdev->dev, NULL);
+	rngc->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(rngc->clk)) {
 		dev_err(&pdev->dev, "Can not get rng_clk\n");
 		return PTR_ERR(rngc->clk);
@@ -255,26 +255,20 @@ static int imx_rngc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	ret = clk_prepare_enable(rngc->clk);
-	if (ret)
-		return ret;
-
 	ver_id = readl(rngc->base + RNGC_VER_ID);
 	rng_type = ver_id >> RNGC_TYPE_SHIFT;
 	/*
 	 * This driver supports only RNGC and RNGB. (There's a different
 	 * driver for RNGA.)
 	 */
-	if (rng_type != RNGC_TYPE_RNGC && rng_type != RNGC_TYPE_RNGB) {
-		ret = -ENODEV;
-		goto err;
-	}
+	if (rng_type != RNGC_TYPE_RNGC && rng_type != RNGC_TYPE_RNGB)
+		return -ENODEV;
 
 	ret = devm_request_irq(&pdev->dev,
 			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);
 	if (ret) {
 		dev_err(rngc->dev, "Can't get interrupt working.\n");
-		goto err;
+		return ret;
 	}
 
 	init_completion(&rngc->rng_op_done);
@@ -294,14 +288,14 @@ static int imx_rngc_probe(struct platform_device *pdev)
 		ret = imx_rngc_self_test(rngc);
 		if (ret) {
 			dev_err(rngc->dev, "self test failed\n");
-			goto err;
+			return ret;
 		}
 	}
 
 	ret = hwrng_register(&rngc->rng);
 	if (ret) {
 		dev_err(&pdev->dev, "hwrng registration failed\n");
-		goto err;
+		return ret;
 	}
 
 	dev_info(&pdev->dev,
@@ -309,11 +303,6 @@ static int imx_rngc_probe(struct platform_device *pdev)
 		rng_type == RNGC_TYPE_RNGB ? 'B' : 'C',
 		(ver_id >> RNGC_VER_MAJ_SHIFT) & 0xff, ver_id & 0xff);
 	return 0;
-
-err:
-	clk_disable_unprepare(rngc->clk);
-
-	return ret;
 }
 
 static int __exit imx_rngc_remove(struct platform_device *pdev)
@@ -322,8 +311,6 @@ static int __exit imx_rngc_remove(struct platform_device *pdev)
 
 	hwrng_unregister(&rngc->rng);
 
-	clk_disable_unprepare(rngc->clk);
-
 	return 0;
 }
 
-- 
2.35.1



