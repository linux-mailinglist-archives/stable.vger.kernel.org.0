Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D212663DE08
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiK3SdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiK3SdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F91EC51
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B904EB81C95
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27611C433C1;
        Wed, 30 Nov 2022 18:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833178;
        bh=EjHKj7MXqckKih90OKtfWa2/WONzKLDU1+s8sYS1UDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlTA//gmpfBQCKuJA4e0M1wKLUlBVhxH/7eHfEdll5BiFJhUqyWgMj/X7kSn9CQVG
         k1RJQX+MGtBm3xwdlObfkSd4TFwCmLqqkVJFtRxPeYUwdb0AYcrsblM2NcLC7qpxJ1
         ZMVVU1Df0/ll16oqnE5VZmSxTAUNM14pDeO+brVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maarten Zanders <maarten.zanders@mind.be>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/206] ASoC: fsl_asrc fsl_esai fsl_sai: allow CONFIG_PM=N
Date:   Wed, 30 Nov 2022 19:20:54 +0100
Message-Id: <20221130180533.041335300@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maarten Zanders <maarten.zanders@mind.be>

[ Upstream commit 6a564338a23cefcfc29c4a535b98402d13efdda6 ]

When CONFIG_PM=N, pm_runtime_put_sync() returns -ENOSYS
which breaks the probe function of these drivers.

Other users of pm_runtime_put_sync() typically don't check
the return value. In order to keep the program flow as
intended, check for -ENOSYS.

This commit is similar to commit 0434d3f (omap-mailbox.c).

Fixes: cab04ab5900f ("ASoC: fsl_asrc: Don't use devm_regmap_init_mmio_clk")
Fixes: 203773e39347 ("ASoC: fsl_esai: Don't use devm_regmap_init_mmio_clk")
Fixes: 2277e7e36b4b ("ASoC: fsl_sai: Don't use devm_regmap_init_mmio_clk")
Signed-off-by: Maarten Zanders <maarten.zanders@mind.be>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20221028141129.100702-1-maarten.zanders@mind.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc.c | 2 +-
 sound/soc/fsl/fsl_esai.c | 2 +-
 sound/soc/fsl/fsl_sai.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 44dcbf49456c..08ca410ef551 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -1226,7 +1226,7 @@ static int fsl_asrc_probe(struct platform_device *pdev)
 	}
 
 	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_asrc_component,
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index bda66b30e063..763f5f0592af 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -1070,7 +1070,7 @@ static int fsl_esai_probe(struct platform_device *pdev)
 	regmap_write(esai_priv->regmap, REG_ESAI_RSMB, 0);
 
 	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	/*
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index bcf6b66a5ac0..5ba06df2ace5 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1150,7 +1150,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	}
 
 	ret = pm_runtime_put_sync(dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	/*
-- 
2.35.1



