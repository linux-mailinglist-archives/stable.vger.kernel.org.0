Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3773B4F27C5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiDEIIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbiDEH7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CC05C36C;
        Tue,  5 Apr 2022 00:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49D1B614F9;
        Tue,  5 Apr 2022 07:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564A7C340EE;
        Tue,  5 Apr 2022 07:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145270;
        bh=YbFVVYLvOd61kWQyMJiFn6+0v0bzDIQNgFVTs0ZqXdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhplFOUNyOjjkic0Kw63S6eYq4hq2RFXyxwjwbuQYMGnZnwCN8fSLAXlk3MuQWl7s
         8FLgbiaToFX3eIUV6mkQqLuj50ZjPVbSVvn04UwK3Xn7gLT12M/f8wG631rHpBk+k1
         l7K4RsiJQV6556/6KbMvQpT2Sm2IdfA9G1MNWp+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0307/1126] ASoC: simple-card-utils: Set sysclk on all components
Date:   Tue,  5 Apr 2022 09:17:34 +0200
Message-Id: <20220405070416.625175308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit ce2f7b8d4290c22e462e465d1da38a1c113ae66a ]

If an mclk-fs value was provided in the device tree configuration, the
calculated MCLK was fed into the downstream codec DAI and CPU DAI,
however set_sysclk was not being called on the platform device. Some
platform devices such as the Xilinx Audio Formatter need to know the MCLK
as well.

Call snd_soc_component_set_sysclk on each component in the stream to set
the proper sysclk value in addition to the existing call of
snd_soc_dai_set_sysclk on the codec DAI and CPU DAI. This may end up
resulting in redundant calls if one of the snd_soc_dai_set_sysclk calls
ends up calling snd_soc_component_set_sysclk itself, but that isn't
expected to cause any significant harm.

Fixes: f48dcbb6d47d ("ASoC: simple-card-utils: share asoc_simple_hw_param()")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20220120195832.1742271-5-robert.hancock@calian.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index a81323d1691d..9736102e6808 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -275,6 +275,7 @@ int asoc_simple_hw_params(struct snd_pcm_substream *substream,
 		mclk_fs = props->mclk_fs;
 
 	if (mclk_fs) {
+		struct snd_soc_component *component;
 		mclk = params_rate(params) * mclk_fs;
 
 		for_each_prop_dai_codec(props, i, pdai) {
@@ -282,16 +283,30 @@ int asoc_simple_hw_params(struct snd_pcm_substream *substream,
 			if (ret < 0)
 				return ret;
 		}
+
 		for_each_prop_dai_cpu(props, i, pdai) {
 			ret = asoc_simple_set_clk_rate(pdai, mclk);
 			if (ret < 0)
 				return ret;
 		}
+
+		/* Ensure sysclk is set on all components in case any
+		 * (such as platform components) are missed by calls to
+		 * snd_soc_dai_set_sysclk.
+		 */
+		for_each_rtd_components(rtd, i, component) {
+			ret = snd_soc_component_set_sysclk(component, 0, 0,
+							   mclk, SND_SOC_CLOCK_IN);
+			if (ret && ret != -ENOTSUPP)
+				return ret;
+		}
+
 		for_each_rtd_codec_dais(rtd, i, sdai) {
 			ret = snd_soc_dai_set_sysclk(sdai, 0, mclk, SND_SOC_CLOCK_IN);
 			if (ret && ret != -ENOTSUPP)
 				return ret;
 		}
+
 		for_each_rtd_cpu_dais(rtd, i, sdai) {
 			ret = snd_soc_dai_set_sysclk(sdai, 0, mclk, SND_SOC_CLOCK_OUT);
 			if (ret && ret != -ENOTSUPP)
-- 
2.34.1



