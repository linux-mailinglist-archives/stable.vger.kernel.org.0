Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC7C6DC51C
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 11:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDJJ3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 05:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDJJ3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 05:29:49 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA49113
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 02:29:47 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6323e4561e5so616987b3a.1
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 02:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681118987; x=1683710987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RDhgwsGbQ+RG02qUycFzYAbnZw0WRThWWRGkWQWlY4Y=;
        b=LlyBdFghpbhPd8Dm7lng3m+uP6ddxZsMZLjJW2w5W65Ifd08dNxNk2uRfY37SKIFCT
         qJ+c1qHvoLDaHKBTjaaR/qgteVL1/UV/nR5MwGUSVTyJDefRk5AyHSt02YGVNcb2k/9j
         S8vvBYaV/jYOgQ2Zh/meFIbCYLlk+mekrpiNppnVE/sK7YhCFBxDWtUXufAhA8FZTjtI
         ilXANE09U5IzaseSkpTrzbOS2XnZZbjDRamuiGRxC174zEEU4jAB4vNTpa4JvAzkrnpw
         o2BRhgVJfyllMEo2rGLRoncTkXU7Zwr2dIuDebz5EbprSQNTKov9bM5CZxnvwEajzir0
         BKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681118987; x=1683710987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDhgwsGbQ+RG02qUycFzYAbnZw0WRThWWRGkWQWlY4Y=;
        b=gd4pBLcft+BXrVWp76kR6nPIsGFJjlmVCXKcQMgLDoj7Pbz7MEutKwlL+3mQ8KKjHy
         P5AqywQgzxuKNpFOpMYDyDZvWOk/e9IQq8ry78CZ4ATtawm1GvydbhCiNIRHfUri2F5B
         +diVgwAdYEXC45NGZMnmzlyN5cH2V0s2wI/+KX7g5dqSVmITsqPq8kuTja7SKtaF1nLu
         7cHBDfd/GlRHd6i6SV/4h0J1yAhQr2OoLeTWUHqRpmT+a1sWCtI2v5kMhi4mqmyiXc0v
         +aDkEeklM3tr7OGbvrLhFB6W49V5k6Ptz1AwuyPf/nJv2PqwsU+dT1+0u+jwqOxTMno9
         uxVw==
X-Gm-Message-State: AAQBX9dhIu4+LTiIokik4VGmVlvyGU9MarOFyjZMGmxINx6LHGMj85Sa
        iIrhua0hWlOV1apUHeZrALzzZQ==
X-Google-Smtp-Source: AKy350avzyL2Ebin3g9RG5/iInXJIHHSWjNxVlix5ev0kK/HULpLMiID312GNySMq2VpUOUHqonCdg==
X-Received: by 2002:aa7:9f96:0:b0:639:243f:da19 with SMTP id z22-20020aa79f96000000b00639243fda19mr1683867pfr.20.1681118987285;
        Mon, 10 Apr 2023 02:29:47 -0700 (PDT)
Received: from localhost.localdomain ([49.207.50.231])
        by smtp.gmail.com with ESMTPSA id 22-20020aa79216000000b005ac419804d5sm7597649pfo.98.2023.04.10.02.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 02:29:46 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH for-6.1.y] ASoC: codecs: lpass: fix the order or clks turn off during suspend
Date:   Mon, 10 Apr 2023 14:59:42 +0530
Message-Id: <20230410092942.3194774-1-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit a4a3203426f4b67535d6442ddc5dca8878a0678f ]

The order in which clocks are stopped matters as some of the clock
like NPL are derived from MCLK.

Without this patch, Dragonboard RB5 DSP would crash with below error:
 qcom_q6v5_pas 17300000.remoteproc: fatal error received:
 ABT_dal.c:278:ABTimeout: AHB Bus hang is detected,
 Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!

Turn off  fsgen first, followed by npl and then finally mclk, which is exactly
the opposite order of enable sequence.

Fixes: 1dc3459009c3 ("ASoC: codecs: lpass: register mclk after runtime pm")
Reported-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Link: https://lore.kernel.org/r/20230323110125.23790-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 sound/soc/codecs/lpass-rx-macro.c  | 4 ++--
 sound/soc/codecs/lpass-tx-macro.c  | 4 ++--
 sound/soc/codecs/lpass-wsa-macro.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 8621cfabcf5b..1639f3b66fac 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -3667,9 +3667,9 @@ static int __maybe_unused rx_macro_runtime_suspend(struct device *dev)
 	regcache_cache_only(rx->regmap, true);
 	regcache_mark_dirty(rx->regmap);
 
-	clk_disable_unprepare(rx->mclk);
-	clk_disable_unprepare(rx->npl);
 	clk_disable_unprepare(rx->fsgen);
+	clk_disable_unprepare(rx->npl);
+	clk_disable_unprepare(rx->mclk);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index e5611f655bed..d1d9d8d2df2d 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1946,9 +1946,9 @@ static int __maybe_unused tx_macro_runtime_suspend(struct device *dev)
 	regcache_cache_only(tx->regmap, true);
 	regcache_mark_dirty(tx->regmap);
 
-	clk_disable_unprepare(tx->mclk);
-	clk_disable_unprepare(tx->npl);
 	clk_disable_unprepare(tx->fsgen);
+	clk_disable_unprepare(tx->npl);
+	clk_disable_unprepare(tx->mclk);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/lpass-wsa-macro.c b/sound/soc/codecs/lpass-wsa-macro.c
index c012033fb69e..8ed48c86ccb3 100644
--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -2502,9 +2502,9 @@ static int __maybe_unused wsa_macro_runtime_suspend(struct device *dev)
 	regcache_cache_only(wsa->regmap, true);
 	regcache_mark_dirty(wsa->regmap);
 
-	clk_disable_unprepare(wsa->mclk);
-	clk_disable_unprepare(wsa->npl);
 	clk_disable_unprepare(wsa->fsgen);
+	clk_disable_unprepare(wsa->npl);
+	clk_disable_unprepare(wsa->mclk);
 
 	return 0;
 }
-- 
2.25.1

