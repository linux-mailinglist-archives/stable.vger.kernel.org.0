Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA95603EEF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiJSJXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiJSJXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:23:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E110B6008;
        Wed, 19 Oct 2022 02:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8D98CE2175;
        Wed, 19 Oct 2022 09:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8902DC433B5;
        Wed, 19 Oct 2022 09:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170374;
        bh=3qOQ4Jb42O8ZGVhsLpe/7X8WWC3+fEostx++8jWyCwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3ldRHvFzgiycj4IgLirOPXUKCGuPua8JBsK8BRFEmqh1A+WJXUOgTEcWxNeWZIrE
         EYdMry0sYcRETf/xUYgrVKz5d1CsG1I0gY8xmyGv34tDMzwNRsbuFO2TRL7f857PFH
         vV1liarTdXdaZ9jlE0jnBEaxIjIpP0iWTiehaQPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kshitiz Varshney <kshitiz.varshney@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 630/862] hwrng: imx-rngc - Moving IRQ handler registering after imx_rngc_irq_mask_clear()
Date:   Wed, 19 Oct 2022 10:31:57 +0200
Message-Id: <20221019083317.756212832@linuxfoundation.org>
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

From: Kshitiz Varshney <kshitiz.varshney@nxp.com>

[ Upstream commit 10a2199caf437e893d9027d97700b3c6010048b7 ]

Issue:
While servicing interrupt, if the IRQ happens to be because of a SEED_DONE
due to a previous boot stage, you end up completing the completion
prematurely, hence causing kernel to crash while booting.

Fix:
Moving IRQ handler registering after imx_rngc_irq_mask_clear()

Fixes: 1d5449445bd0 (hwrng: mx-rngc - add a driver for Freescale RNGC)
Signed-off-by: Kshitiz Varshney <kshitiz.varshney@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/imx-rngc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index e32c52c10d4d..1d7ce7443586 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -264,13 +264,6 @@ static int imx_rngc_probe(struct platform_device *pdev)
 	if (rng_type != RNGC_TYPE_RNGC && rng_type != RNGC_TYPE_RNGB)
 		return -ENODEV;
 
-	ret = devm_request_irq(&pdev->dev,
-			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);
-	if (ret) {
-		dev_err(rngc->dev, "Can't get interrupt working.\n");
-		return ret;
-	}
-
 	init_completion(&rngc->rng_op_done);
 
 	rngc->rng.name = pdev->name;
@@ -284,6 +277,13 @@ static int imx_rngc_probe(struct platform_device *pdev)
 
 	imx_rngc_irq_mask_clear(rngc);
 
+	ret = devm_request_irq(&pdev->dev,
+			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);
+	if (ret) {
+		dev_err(rngc->dev, "Can't get interrupt working.\n");
+		return ret;
+	}
+
 	if (self_test) {
 		ret = imx_rngc_self_test(rngc);
 		if (ret) {
-- 
2.35.1



