Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA60B20641A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390626AbgFWVQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390822AbgFWU17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:27:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B9B20702;
        Tue, 23 Jun 2020 20:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944079;
        bh=3UCPZR2zeAskPCWyEr5PkUxJorj5DnhR6MseG5q1/aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfNRIBghEAKo6PJLM9gN08K6RPjXZ9tvvDvqeGsK0cJRLg/KhhrfkAMvnMnuqTxET
         y1+W96ituQ/070Z7C3ecKgwyZNcy1skiyxb+vbyVkTZDaDluXJroy88Mg3Y7pmic40
         Z6wczTQwxcSYNCGzfhFb6vNtgno9YRa4X5D/egDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Peter Ujfalusi <peter.ujflausi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/314] ASoC: ti: omap-mcbsp: Fix an error handling path in asoc_mcbsp_probe()
Date:   Tue, 23 Jun 2020 21:55:29 +0200
Message-Id: <20200623195345.265310226@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 03990fd58d2b7c8f7d53e514ba9b8749fac260f9 ]

If an error occurs after the call to 'omap_mcbsp_init()', the reference to
'mcbsp->fclk' must be decremented, as already done in the remove function.

This can be achieved easily by using the devm_ variant of 'clk_get()'
when the reference is taken in 'omap_mcbsp_init()'

This fixes the leak in the probe and has the side effect to simplify both
the error handling path of 'omap_mcbsp_init()' and the remove function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Peter Ujfalusi <peter.ujflausi@ti.com>
Link: https://lore.kernel.org/r/20200512134325.252073-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/omap-mcbsp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/sound/soc/ti/omap-mcbsp.c b/sound/soc/ti/omap-mcbsp.c
index 26b503bbdb5fe..3273b317fa3b9 100644
--- a/sound/soc/ti/omap-mcbsp.c
+++ b/sound/soc/ti/omap-mcbsp.c
@@ -686,7 +686,7 @@ static int omap_mcbsp_init(struct platform_device *pdev)
 	mcbsp->dma_data[1].addr = omap_mcbsp_dma_reg_params(mcbsp,
 						SNDRV_PCM_STREAM_CAPTURE);
 
-	mcbsp->fclk = clk_get(&pdev->dev, "fck");
+	mcbsp->fclk = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(mcbsp->fclk)) {
 		ret = PTR_ERR(mcbsp->fclk);
 		dev_err(mcbsp->dev, "unable to get fck: %d\n", ret);
@@ -711,7 +711,7 @@ static int omap_mcbsp_init(struct platform_device *pdev)
 		if (ret) {
 			dev_err(mcbsp->dev,
 				"Unable to create additional controls\n");
-			goto err_thres;
+			return ret;
 		}
 	}
 
@@ -724,8 +724,6 @@ static int omap_mcbsp_init(struct platform_device *pdev)
 err_st:
 	if (mcbsp->pdata->buffer_size)
 		sysfs_remove_group(&mcbsp->dev->kobj, &additional_attr_group);
-err_thres:
-	clk_put(mcbsp->fclk);
 	return ret;
 }
 
@@ -1442,8 +1440,6 @@ static int asoc_mcbsp_remove(struct platform_device *pdev)
 
 	omap_mcbsp_st_cleanup(pdev);
 
-	clk_put(mcbsp->fclk);
-
 	return 0;
 }
 
-- 
2.25.1



