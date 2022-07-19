Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F777579C27
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbiGSMgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240745AbiGSMgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:36:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BE179ECD;
        Tue, 19 Jul 2022 05:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8D28616F8;
        Tue, 19 Jul 2022 12:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9475C341C6;
        Tue, 19 Jul 2022 12:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232797;
        bh=2VpfmzO2i9ibqxokC7JLDiTparlUaunxAFDXgTG+bFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYPKU9vYqByVQX8UlyXZMy12GSy9zrp1eAM2CU/aVl2gPZuz1kxhVp6yqRpQ27f6F
         IQJXKHLyxbqSCGQ2eUG2aWhZ+RVCxmmk+747XIc1D6qoH8eIYE+WP7+Qp0xAPa5M+C
         w/kN2laDYWBSVzmoGF1h/eg7MuWDFXca/lpGi4To=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/167] ASoC: Intel: Skylake: Correct the handling of fmt_config flexible array
Date:   Tue, 19 Jul 2022 13:53:00 +0200
Message-Id: <20220719114701.269629450@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit fc976f5629afb4160ee77798b14a693eac903ffd ]

The struct nhlt_format's fmt_config is a flexible array, it must not be
used as normal array.
When moving to the next nhlt_fmt_cfg we need to take into account the data
behind the ->config.caps (indicated by ->config.size).

The logic of the code also changed: it is no longer saves the _last_
fmt_cfg for all found rates.

Fixes: bc2bd45b1f7f3 ("ASoC: Intel: Skylake: Parse nhlt and register clock device")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220630065638.11183-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-nhlt.c | 37 ++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-nhlt.c b/sound/soc/intel/skylake/skl-nhlt.c
index cb02ec255728..74f60f5dfaef 100644
--- a/sound/soc/intel/skylake/skl-nhlt.c
+++ b/sound/soc/intel/skylake/skl-nhlt.c
@@ -213,11 +213,12 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 	if (fmt->fmt_count == 0)
 		return;
 
+	fmt_cfg = (struct nhlt_fmt_cfg *)fmt->fmt_config;
 	for (i = 0; i < fmt->fmt_count; i++) {
+		struct nhlt_fmt_cfg *saved_fmt_cfg = fmt_cfg;
 		bool present = false;
 
-		fmt_cfg = &fmt->fmt_config[i];
-		wav_fmt = &fmt_cfg->fmt_ext;
+		wav_fmt = &saved_fmt_cfg->fmt_ext;
 
 		channels = wav_fmt->fmt.channels;
 		bps = wav_fmt->fmt.bits_per_sample;
@@ -235,12 +236,18 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 		 * derive the rate.
 		 */
 		for (j = i; j < fmt->fmt_count; j++) {
-			fmt_cfg = &fmt->fmt_config[j];
-			wav_fmt = &fmt_cfg->fmt_ext;
+			struct nhlt_fmt_cfg *tmp_fmt_cfg = fmt_cfg;
+
+			wav_fmt = &tmp_fmt_cfg->fmt_ext;
 			if ((fs == wav_fmt->fmt.samples_per_sec) &&
-			   (bps == wav_fmt->fmt.bits_per_sample))
+			   (bps == wav_fmt->fmt.bits_per_sample)) {
 				channels = max_t(u16, channels,
 						wav_fmt->fmt.channels);
+				saved_fmt_cfg = tmp_fmt_cfg;
+			}
+			/* Move to the next nhlt_fmt_cfg */
+			tmp_fmt_cfg = (struct nhlt_fmt_cfg *)(tmp_fmt_cfg->config.caps +
+							      tmp_fmt_cfg->config.size);
 		}
 
 		rate = channels * bps * fs;
@@ -256,8 +263,11 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 
 		/* Fill rate and parent for sclk/sclkfs */
 		if (!present) {
+			struct nhlt_fmt_cfg *first_fmt_cfg;
+
+			first_fmt_cfg = (struct nhlt_fmt_cfg *)fmt->fmt_config;
 			i2s_config_ext = (struct skl_i2s_config_blob_ext *)
-						fmt->fmt_config[0].config.caps;
+						first_fmt_cfg->config.caps;
 
 			/* MCLK Divider Source Select */
 			if (is_legacy_blob(i2s_config_ext->hdr.sig)) {
@@ -271,6 +281,9 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 
 			parent = skl_get_parent_clk(clk_src);
 
+			/* Move to the next nhlt_fmt_cfg */
+			fmt_cfg = (struct nhlt_fmt_cfg *)(fmt_cfg->config.caps +
+							  fmt_cfg->config.size);
 			/*
 			 * Do not copy the config data if there is no parent
 			 * clock available for this clock source select
@@ -279,9 +292,9 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 				continue;
 
 			sclk[id].rate_cfg[rate_index].rate = rate;
-			sclk[id].rate_cfg[rate_index].config = fmt_cfg;
+			sclk[id].rate_cfg[rate_index].config = saved_fmt_cfg;
 			sclkfs[id].rate_cfg[rate_index].rate = rate;
-			sclkfs[id].rate_cfg[rate_index].config = fmt_cfg;
+			sclkfs[id].rate_cfg[rate_index].config = saved_fmt_cfg;
 			sclk[id].parent_name = parent->name;
 			sclkfs[id].parent_name = parent->name;
 
@@ -295,13 +308,13 @@ static void skl_get_mclk(struct skl_dev *skl, struct skl_ssp_clk *mclk,
 {
 	struct skl_i2s_config_blob_ext *i2s_config_ext;
 	struct skl_i2s_config_blob_legacy *i2s_config;
-	struct nhlt_specific_cfg *fmt_cfg;
+	struct nhlt_fmt_cfg *fmt_cfg;
 	struct skl_clk_parent_src *parent;
 	u32 clkdiv, div_ratio;
 	u8 clk_src;
 
-	fmt_cfg = &fmt->fmt_config[0].config;
-	i2s_config_ext = (struct skl_i2s_config_blob_ext *)fmt_cfg->caps;
+	fmt_cfg = (struct nhlt_fmt_cfg *)fmt->fmt_config;
+	i2s_config_ext = (struct skl_i2s_config_blob_ext *)fmt_cfg->config.caps;
 
 	/* MCLK Divider Source Select and divider */
 	if (is_legacy_blob(i2s_config_ext->hdr.sig)) {
@@ -330,7 +343,7 @@ static void skl_get_mclk(struct skl_dev *skl, struct skl_ssp_clk *mclk,
 		return;
 
 	mclk[id].rate_cfg[0].rate = parent->rate/div_ratio;
-	mclk[id].rate_cfg[0].config = &fmt->fmt_config[0];
+	mclk[id].rate_cfg[0].config = fmt_cfg;
 	mclk[id].parent_name = parent->name;
 }
 
-- 
2.35.1



