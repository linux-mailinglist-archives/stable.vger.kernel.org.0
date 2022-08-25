Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472665A05B2
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiHYBeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiHYBeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:34:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F188990C78;
        Wed, 24 Aug 2022 18:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66FD9B826E1;
        Thu, 25 Aug 2022 01:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDB5C433D7;
        Thu, 25 Aug 2022 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391251;
        bh=+Zm5w2JHc09zjVTeU6dWw6UlURO3/nugqxZNU/3E4w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+ZxqrZUe4WB7N3XbR7H70JBKG38OidvM17/8swhvba6pHcymkPu3W/n7BB0HJ/fn
         tGOKYtcw62kWDcR3EJlEmLdBQeazPOYcChkA/eFsvQgEhYotjAcCzsG3YjfNziBCF7
         65SuYuZz192SePggQjik5mB9+TTF63BfGfVKVt8EyQ61/1Hye+B+7RwP98p11l8l9m
         N0rmntF2KOBsgwO/odOal+z0qmSGBK4hWNHZGHbfWMJ070Ib4jOba8b0KsIxjX7Otx
         4303T+4uu8hXiNYiz4dIR1XluzuKxacoIpPhlm71qDXTJTX4r6Y9w9KaET4gmrnMV9
         YJHJGAg5+tXcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, p.zabel@pengutronix.de,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        ckeepax@opensource.cirrus.com, kuninori.morimoto.gx@renesas.com,
        hkallweit1@gmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 02/38] ASoC: sh: rz-ssi: Improve error handling in rz_ssi_probe() error path
Date:   Wed, 24 Aug 2022 21:33:25 -0400
Message-Id: <20220825013401.22096-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit c75ed9f54ce8d349fee557f2b471a4d637ed2a6b ]

We usually do cleanup in reverse order of init. Currently in case of
error rz_ssi_release_dma_channels() done in the reverse order. This
patch improves error handling in rz_ssi_probe() error path.

While at it, use "goto cleanup" style to reduce code duplication.

Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20220728092612.38858-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index e392de7a262e..3d74acffec11 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -1016,32 +1016,36 @@ static int rz_ssi_probe(struct platform_device *pdev)
 
 	ssi->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 	if (IS_ERR(ssi->rstc)) {
-		rz_ssi_release_dma_channels(ssi);
-		return PTR_ERR(ssi->rstc);
+		ret = PTR_ERR(ssi->rstc);
+		goto err_reset;
 	}
 
 	reset_control_deassert(ssi->rstc);
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
-		rz_ssi_release_dma_channels(ssi);
-		pm_runtime_disable(ssi->dev);
-		reset_control_assert(ssi->rstc);
-		return dev_err_probe(ssi->dev, ret, "pm_runtime_resume_and_get failed\n");
+		dev_err(&pdev->dev, "pm_runtime_resume_and_get failed\n");
+		goto err_pm;
 	}
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &rz_ssi_soc_component,
 					      rz_ssi_soc_dai,
 					      ARRAY_SIZE(rz_ssi_soc_dai));
 	if (ret < 0) {
-		rz_ssi_release_dma_channels(ssi);
-
-		pm_runtime_put(ssi->dev);
-		pm_runtime_disable(ssi->dev);
-		reset_control_assert(ssi->rstc);
 		dev_err(&pdev->dev, "failed to register snd component\n");
+		goto err_snd_soc;
 	}
 
+	return 0;
+
+err_snd_soc:
+	pm_runtime_put(ssi->dev);
+err_pm:
+	pm_runtime_disable(ssi->dev);
+	reset_control_assert(ssi->rstc);
+err_reset:
+	rz_ssi_release_dma_channels(ssi);
+
 	return ret;
 }
 
-- 
2.35.1

