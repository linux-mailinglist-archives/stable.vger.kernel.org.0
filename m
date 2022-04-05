Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D054F35EF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241167AbiDEK4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346580AbiDEJpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FD4DA6FD;
        Tue,  5 Apr 2022 02:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7D426165C;
        Tue,  5 Apr 2022 09:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C160CC385A3;
        Tue,  5 Apr 2022 09:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151059;
        bh=D6m+o0u+CA+SvDho6afPxHeHyW7tn/a0c/86ypjkG+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbyN5SdgqACx0nfL+S1OJDR2/uQ9I4fXFKBUqOCesQ2SSZxRRHB8ufU/imKDFc7Mc
         bA45j1JjxvRBswe45BBI+czvlpSFzaJeoifwf8RcmGNdNJV9gwlUuFf7sjGVEshJFY
         AmiPacJ3jMAryrv/k34RXpJ/VNJqTkGZIlIhLEPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/913] ASoC: codecs: Check for error pointer after calling devm_regmap_init_mmio
Date:   Tue,  5 Apr 2022 09:22:20 +0200
Message-Id: <20220405070348.190484643@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit aa505ecccf2ae7546e0e262d574e18a9241f3005 ]

Since the potential failure of the devm_regmap_init_mmio(), it will
return error pointer and be assigned to the regmap.
Then the error pointer will be dereferenced.
For example rx->regmap will be used in rx_macro_mclk_enable().
Therefore, it should be better to check it.

Fixes: af3d54b99764 ("ASoC: codecs: lpass-rx-macro: add support for lpass rx macro")
Fixes: c39667ddcfc5 ("ASoC: codecs: lpass-tx-macro: add support for lpass tx macro")
Fixes: 809bcbcecebf ("ASoC: codecs: lpass-wsa-macro: Add support to WSA Macro")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220121171031.2826198-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c  | 2 ++
 sound/soc/codecs/lpass-tx-macro.c  | 2 ++
 sound/soc/codecs/lpass-wsa-macro.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 1c0409350e86..0f932ca61c81 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -3542,6 +3542,8 @@ static int rx_macro_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	rx->regmap = devm_regmap_init_mmio(dev, base, &rx_regmap_config);
+	if (IS_ERR(rx->regmap))
+		return PTR_ERR(rx->regmap);
 
 	dev_set_drvdata(dev, rx);
 
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 27a0d5defd27..e4bbc6bd4925 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1803,6 +1803,8 @@ static int tx_macro_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	tx->regmap = devm_regmap_init_mmio(dev, base, &tx_regmap_config);
+	if (IS_ERR(tx->regmap))
+		return PTR_ERR(tx->regmap);
 
 	dev_set_drvdata(dev, tx);
 
diff --git a/sound/soc/codecs/lpass-wsa-macro.c b/sound/soc/codecs/lpass-wsa-macro.c
index d3ac318fd6b6..dd1a8b7bc794 100644
--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -2405,6 +2405,8 @@ static int wsa_macro_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	wsa->regmap = devm_regmap_init_mmio(dev, base, &wsa_regmap_config);
+	if (IS_ERR(wsa->regmap))
+		return PTR_ERR(wsa->regmap);
 
 	dev_set_drvdata(dev, wsa);
 
-- 
2.34.1



