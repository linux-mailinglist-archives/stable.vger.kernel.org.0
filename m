Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E000A59D7E1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbiHWJ0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbiHWJYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DE22BC9;
        Tue, 23 Aug 2022 01:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D0E5B81C3B;
        Tue, 23 Aug 2022 08:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A430C433C1;
        Tue, 23 Aug 2022 08:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243659;
        bh=jld3Qog9SsdZFeVcGy1YR+rTIrPAlZB2z9rTGiZgsQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqmiYjEiZAeJGtAgFmEmu4TtRuoNPj+uxPB6nlo6vj53VCljHNypntsky9YMAwHbz
         cfWFMw8mJ1ClWdJAa+kh37HIYCMYuhIW6hKmEzwnCIqE3Vb+2msUY6ELLH2oSqZz4G
         +CkUWG7rv2lMEAeDBSTTT8LRu7viiEzuA8/sb7QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 348/365] ASoC: codecs: va-macro: use fsgen as clock
Date:   Tue, 23 Aug 2022 10:04:09 +0200
Message-Id: <20220823080132.818607059@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 30097967e0566cac817273ef76add100f6b0f463 ]

VA Macro fsgen clock is supplied to other LPASS Macros using proper
clock apis, however the internal user uses the registers directly without
clk apis. This approch has race condition where in external users of
the clock might cut the clock while VA macro is actively using this.

Moving the internal usage to clk apis would provide a proper refcounting
and avoid such race conditions.

This issue was noticed while headset was pulled out while recording is
in progress and shifting record patch to DMIC.

Reported-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Link: https://lore.kernel.org/r/20220727124749.4604-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-va-macro.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index d18b56e60433..1ea10dc70748 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -199,6 +199,7 @@ struct va_macro {
 	struct clk *mclk;
 	struct clk *macro;
 	struct clk *dcodec;
+	struct clk *fsgen;
 	struct clk_hw hw;
 	struct lpass_macro *pds;
 
@@ -467,9 +468,9 @@ static int va_macro_mclk_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		return va_macro_mclk_enable(va, true);
+		return clk_prepare_enable(va->fsgen);
 	case SND_SOC_DAPM_POST_PMD:
-		return va_macro_mclk_enable(va, false);
+		clk_disable_unprepare(va->fsgen);
 	}
 
 	return 0;
@@ -1473,6 +1474,12 @@ static int va_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clkout;
 
+	va->fsgen = clk_hw_get_clk(&va->hw, "fsgen");
+	if (IS_ERR(va->fsgen)) {
+		ret = PTR_ERR(va->fsgen);
+		goto err_clkout;
+	}
+
 	ret = devm_snd_soc_register_component(dev, &va_macro_component_drv,
 					      va_macro_dais,
 					      ARRAY_SIZE(va_macro_dais));
-- 
2.35.1



