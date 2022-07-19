Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6847579DBD
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbiGSMyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242037AbiGSMx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:53:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0D3936B1;
        Tue, 19 Jul 2022 05:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 964246177D;
        Tue, 19 Jul 2022 12:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6111BC36AEF;
        Tue, 19 Jul 2022 12:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233274;
        bh=ASndOkuuuaWHwQJWwIUvQAr0o/kQ4UHxMrFqEXaLhew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEHlkmLlhpXzuSIDmjrrLQvNSjnFy0h+2Lw1m1rAQsWTIh9i3htZVdbj+TJlRO6Zz
         IwtOgqmd/v/GgOHT2akGyOwA5oYz+9QcwYUHA45OCXsd7GFBbYiU/CqStnMs9tbEph
         A6Z5LF0kPeUXGLTQnFQh9Mug2aVkDA+It23YUbEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 059/231] ASoC: Intel: Skylake: Correct the handling of fmt_config flexible array
Date:   Tue, 19 Jul 2022 13:52:24 +0200
Message-Id: <20220719114719.128741063@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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
index 366f7bd9bc02..deb7b820325e 100644
--- a/sound/soc/intel/skylake/skl-nhlt.c
+++ b/sound/soc/intel/skylake/skl-nhlt.c
@@ -111,11 +111,12 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
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
@@ -133,12 +134,18 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
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
@@ -154,8 +161,11 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 
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
@@ -169,6 +179,9 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 
 			parent = skl_get_parent_clk(clk_src);
 
+			/* Move to the next nhlt_fmt_cfg */
+			fmt_cfg = (struct nhlt_fmt_cfg *)(fmt_cfg->config.caps +
+							  fmt_cfg->config.size);
 			/*
 			 * Do not copy the config data if there is no parent
 			 * clock available for this clock source select
@@ -177,9 +190,9 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 				continue;
 
 			sclk[id].rate_cfg[rate_index].rate = rate;
-			sclk[id].rate_cfg[rate_index].config = fmt_cfg;
+			sclk[id].rate_cfg[rate_index].config = saved_fmt_cfg;
 			sclkfs[id].rate_cfg[rate_index].rate = rate;
-			sclkfs[id].rate_cfg[rate_index].config = fmt_cfg;
+			sclkfs[id].rate_cfg[rate_index].config = saved_fmt_cfg;
 			sclk[id].parent_name = parent->name;
 			sclkfs[id].parent_name = parent->name;
 
@@ -193,13 +206,13 @@ static void skl_get_mclk(struct skl_dev *skl, struct skl_ssp_clk *mclk,
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
@@ -228,7 +241,7 @@ static void skl_get_mclk(struct skl_dev *skl, struct skl_ssp_clk *mclk,
 		return;
 
 	mclk[id].rate_cfg[0].rate = parent->rate/div_ratio;
-	mclk[id].rate_cfg[0].config = &fmt->fmt_config[0];
+	mclk[id].rate_cfg[0].config = fmt_cfg;
 	mclk[id].parent_name = parent->name;
 }
 
-- 
2.35.1



