Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3635154151D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359505AbiFGU2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376557AbiFGU07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:26:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773FD13390C;
        Tue,  7 Jun 2022 11:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E37ACE2319;
        Tue,  7 Jun 2022 18:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6BAC36B00;
        Tue,  7 Jun 2022 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626771;
        bh=Wb4wHBnIxsErUFrT9wcDvns8Nnx/YuBz7eUmKYwzkC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCHQiIulbqPlxUgMMPQEnfi4fmtEQiJv9UemOcURIFK6rMuCA2nWmyemdN85bPVki
         AtMjrCOisr71IacOyIu1Dsx7L5gDyaTYe5/iUShimA24CwsUHQ6MOZq1bXG6Ui0egW
         ttboM+EgZ672emVSBBJoCYOud2OYfRMLy95cPDx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 498/772] ASoC: sh: rz-ssi: Propagate error codes returned from platform_get_irq_byname()
Date:   Tue,  7 Jun 2022 19:01:30 +0200
Message-Id: <20220607165003.657658218@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 91686a3984f34df0ab844cdbaa7e4d9621129f5d ]

Propagate error codes returned from platform_get_irq_byname() instead of
returning -ENODEV. platform_get_irq_byname() may return -EPROBE_DEFER, to
handle such cases propagate the error codes.

While at it drop the dev_err_probe() messages as platform_get_irq_byname()
already does this for us in case of error.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20220426074922.13319-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index 7379b1489e35..3b55444a1b58 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -983,8 +983,7 @@ static int rz_ssi_probe(struct platform_device *pdev)
 	/* Error Interrupt */
 	ssi->irq_int = platform_get_irq_byname(pdev, "int_req");
 	if (ssi->irq_int < 0)
-		return dev_err_probe(&pdev->dev, -ENODEV,
-				     "Unable to get SSI int_req IRQ\n");
+		return ssi->irq_int;
 
 	ret = devm_request_irq(&pdev->dev, ssi->irq_int, &rz_ssi_interrupt,
 			       0, dev_name(&pdev->dev), ssi);
@@ -996,8 +995,7 @@ static int rz_ssi_probe(struct platform_device *pdev)
 		/* Tx and Rx interrupts (pio only) */
 		ssi->irq_tx = platform_get_irq_byname(pdev, "dma_tx");
 		if (ssi->irq_tx < 0)
-			return dev_err_probe(&pdev->dev, -ENODEV,
-					     "Unable to get SSI dma_tx IRQ\n");
+			return ssi->irq_tx;
 
 		ret = devm_request_irq(&pdev->dev, ssi->irq_tx,
 				       &rz_ssi_interrupt, 0,
@@ -1008,8 +1006,7 @@ static int rz_ssi_probe(struct platform_device *pdev)
 
 		ssi->irq_rx = platform_get_irq_byname(pdev, "dma_rx");
 		if (ssi->irq_rx < 0)
-			return dev_err_probe(&pdev->dev, -ENODEV,
-					     "Unable to get SSI dma_rx IRQ\n");
+			return ssi->irq_rx;
 
 		ret = devm_request_irq(&pdev->dev, ssi->irq_rx,
 				       &rz_ssi_interrupt, 0,
-- 
2.35.1



