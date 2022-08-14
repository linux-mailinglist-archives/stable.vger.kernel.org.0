Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68335923D1
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbiHNQZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241469AbiHNQYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3221705C;
        Sun, 14 Aug 2022 09:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1A5FB80B7F;
        Sun, 14 Aug 2022 16:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B227C433C1;
        Sun, 14 Aug 2022 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494150;
        bh=jld3Qog9SsdZFeVcGy1YR+rTIrPAlZB2z9rTGiZgsQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8dD0HLBl+98TsP4rPlh3fth9MrmW9jTHcxLL2m31WlG/x+K03WQp+cDJ3/I+8cLi
         WkSMhnPnxgKHuHc/ggM2rZWpyaHg4hV7tbQ5EsjN47r6PXrljcy0mVY4U7xp1UMXuS
         bPM/drygpuis5G99YaYpNVPwuuel6dyyg0TKegfN8+xV4nknQDMUzJVoEDHCH9zItc
         KWM7VySs8/duSwqBY9WUIn+NiA0AMuKT7vUG8lc/s1PYDOv6awJwat3IBt3KxcRQ1i
         k0llxbTTG0fnZ2W5nKG6wYms8CqCiUxTJ9TuelpSQk8uqobss1/cD4ewzaeUNBLJ5n
         BUZOt08HxSHJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bgoswami@quicinc.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 33/48] ASoC: codecs: va-macro: use fsgen as clock
Date:   Sun, 14 Aug 2022 12:19:26 -0400
Message-Id: <20220814161943.2394452-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

