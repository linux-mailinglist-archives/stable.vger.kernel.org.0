Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67E56DEE84
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjDLImL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjDLIl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD72728A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 369AE62FF9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A080C433EF;
        Wed, 12 Apr 2023 08:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288867;
        bh=Ys/RNCcDaan94e580LeV2ag4qgEvG4FZkLsFpFSpw0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlMNYVuMEJfzaL4GtGLtWmo8SCZCiAy6t/OD48V0NTMk0IDippJQsluyxb0VdPNLy
         Aek8O6wFl5g0Dn3ORWnKOlaZtt91/2vhT6i9ZvXUs5VR4WQVbSNe/cPn6ExAi0xbvW
         SbLhSGHMkSlqWUsDJEax4uUSYXCL8/ci2EDzB3I4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amit Pundir <amit.pundir@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/164] ASoC: codecs: lpass: fix the order or clks turn off during suspend
Date:   Wed, 12 Apr 2023 10:32:20 +0200
Message-Id: <20230412082837.650168325@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c  | 4 ++--
 sound/soc/codecs/lpass-tx-macro.c  | 4 ++--
 sound/soc/codecs/lpass-wsa-macro.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 8621cfabcf5b6..1639f3b66facb 100644
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
index e5611f655beda..d1d9d8d2df2d2 100644
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
index c012033fb69ed..8ed48c86ccb33 100644
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
2.39.2



