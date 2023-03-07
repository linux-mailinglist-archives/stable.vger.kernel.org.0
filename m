Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F153C6AEA7B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjCGReY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjCGReJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7C09B987
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D447614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821DEC433EF;
        Tue,  7 Mar 2023 17:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210180;
        bh=J1sKUlr4GhJNA9vvNkUOmX8MWjYRm4iYKwt6yfHNjQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phB5orVo+VanmbVh1MCVIp5LYwKnfGg7fF7gb60xHENhW9Z7suyPohCH3cxMazDTI
         Kqz4JCFmMNJLpBls766BM9U57wVWMrmR0m1+FaR8CkXjoYvRYvx+MigNC5yCoVQE4W
         EAraByAkvRT6iOIMynKPYqfdfxAJpOn/JNL2zyOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0428/1001] ASoC: codecs: lpass: fix incorrect mclk rate
Date:   Tue,  7 Mar 2023 17:53:20 +0100
Message-Id: <20230307170039.929878191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit e7621434378c40b62ef858c14ae6415fb6469a8e ]

For some reason we ended up with incorrect mclk rate which should be
1920000 instead of 96000, So far we were getting lucky as the same clk
is set to 192000 by wsa and va macro. This issue is discovered when there
is no wsa macro active and only rx or tx path is tested.
Fix this by setting correct rate.

Fixes: c39667ddcfc5 ("ASoC: codecs: lpass-tx-macro: add support for lpass tx macro")
Fixes: af3d54b99764 ("ASoC: codecs: lpass-rx-macro: add support for lpass rx macro")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-7-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 4 ++--
 sound/soc/codecs/lpass-tx-macro.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index dd6970d5eb8d1..8621cfabcf5b6 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -366,7 +366,7 @@
 #define CDC_RX_DSD1_CFG2			(0x0F8C)
 #define RX_MAX_OFFSET				(0x0F8C)
 
-#define MCLK_FREQ		9600000
+#define MCLK_FREQ		19200000
 
 #define RX_MACRO_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000 |\
 			SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_48000 |\
@@ -3579,7 +3579,7 @@ static int rx_macro_probe(struct platform_device *pdev)
 
 	/* set MCLK and NPL rates */
 	clk_set_rate(rx->mclk, MCLK_FREQ);
-	clk_set_rate(rx->npl, 2 * MCLK_FREQ);
+	clk_set_rate(rx->npl, MCLK_FREQ);
 
 	ret = clk_prepare_enable(rx->macro);
 	if (ret)
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index b9475ba55e203..2449a2df66df0 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -203,7 +203,7 @@
 #define TX_MACRO_AMIC_UNMUTE_DELAY_MS	100
 #define TX_MACRO_DMIC_HPF_DELAY_MS	300
 #define TX_MACRO_AMIC_HPF_DELAY_MS	300
-#define MCLK_FREQ		9600000
+#define MCLK_FREQ		19200000
 
 enum {
 	TX_MACRO_AIF_INVALID = 0,
@@ -2014,7 +2014,7 @@ static int tx_macro_probe(struct platform_device *pdev)
 
 	/* set MCLK and NPL rates */
 	clk_set_rate(tx->mclk, MCLK_FREQ);
-	clk_set_rate(tx->npl, 2 * MCLK_FREQ);
+	clk_set_rate(tx->npl, MCLK_FREQ);
 
 	ret = clk_prepare_enable(tx->macro);
 	if (ret)
-- 
2.39.2



