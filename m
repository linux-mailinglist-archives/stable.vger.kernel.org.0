Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2096088CD
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiJVIXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiJVIVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:21:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2002DE46D;
        Sat, 22 Oct 2022 00:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E7CB82E2D;
        Sat, 22 Oct 2022 07:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9D1C433C1;
        Sat, 22 Oct 2022 07:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425473;
        bh=b2T9RUet62fU3Ztf9GawhjllprseIO+DUXDl6aQp68Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE28KD4irLTXgSO4qszzrdtzEebOXgGGCdak0qF5sDzQS6U/9zO6tA/fAFWmnFeRQ
         m8GOxJIA+t9U5rkfsxG0mSj2ZoKQ91YBrhbJ6jr3bRMzexCat2xiSBCx4iMHZxeZPc
         wvtbRUycafsIXcA9G5SmYfYUVjrJNO2OMdM92bl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kshitiz Varshney <kshitiz.varshney@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 512/717] hwrng: imx-rngc - Moving IRQ handler registering after imx_rngc_irq_mask_clear()
Date:   Sat, 22 Oct 2022 09:26:31 +0200
Message-Id: <20221022072520.918378507@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/char/hw_random/imx-rngc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -270,13 +270,6 @@ static int imx_rngc_probe(struct platfor
 		goto err;
 	}
 
-	ret = devm_request_irq(&pdev->dev,
-			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);
-	if (ret) {
-		dev_err(rngc->dev, "Can't get interrupt working.\n");
-		goto err;
-	}
-
 	init_completion(&rngc->rng_op_done);
 
 	rngc->rng.name = pdev->name;
@@ -290,6 +283,13 @@ static int imx_rngc_probe(struct platfor
 
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


