Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9728B579E05
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbiGSM5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiGSM4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0A95C945;
        Tue, 19 Jul 2022 05:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73D1DB81B10;
        Tue, 19 Jul 2022 12:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20BFC341C6;
        Tue, 19 Jul 2022 12:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233356;
        bh=hA1qIK0DBCrwchGNAPuuqfIrR5e5Gk370lNmeck5ih8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxXmWR8BgRZU1X7cp8QU1RqmtMd9jCd8HQa1VrPUcu8sZadGgLe26w1QKWVx30GQ0
         RzNIVj4Mn/sX+WLkbNWuMS7JBmk0HhEM6MmDRu0McDhlep2tYRYX26mMK0UL2TVVhE
         mvcIItcop0L7t39M5AGpPy1zUgHDPSRLzkYb3aFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 058/231] ASoC: Intel: Skylake: Correct the ssp rate discovery in skl_get_ssp_clks()
Date:   Tue, 19 Jul 2022 13:52:23 +0200
Message-Id: <20220719114719.058311756@linuxfoundation.org>
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

[ Upstream commit 219af251bd1694bce1f627d238347d2eaf13de61 ]

The present flag is only set once when one rate has been found to be saved.
This will effectively going to ignore any rate discovered at later time and
based on the code, this is not the intention.

Fixes: bc2bd45b1f7f3 ("ASoC: Intel: Skylake: Parse nhlt and register clock device")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220630065638.11183-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-nhlt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/skylake/skl-nhlt.c b/sound/soc/intel/skylake/skl-nhlt.c
index 2439a574ac2f..366f7bd9bc02 100644
--- a/sound/soc/intel/skylake/skl-nhlt.c
+++ b/sound/soc/intel/skylake/skl-nhlt.c
@@ -99,7 +99,6 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 	struct nhlt_fmt_cfg *fmt_cfg;
 	struct wav_fmt_ext *wav_fmt;
 	unsigned long rate;
-	bool present = false;
 	int rate_index = 0;
 	u16 channels, bps;
 	u8 clk_src;
@@ -113,6 +112,8 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 		return;
 
 	for (i = 0; i < fmt->fmt_count; i++) {
+		bool present = false;
+
 		fmt_cfg = &fmt->fmt_config[i];
 		wav_fmt = &fmt_cfg->fmt_ext;
 
-- 
2.35.1



