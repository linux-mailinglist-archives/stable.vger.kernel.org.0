Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E14593DCA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343988AbiHOTiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344437AbiHOTgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:36:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A615B30F6B;
        Mon, 15 Aug 2022 11:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 514D5B81071;
        Mon, 15 Aug 2022 18:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD77C433C1;
        Mon, 15 Aug 2022 18:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589165;
        bh=NQ/7lkw2mnIkkDW+T812q2jdHGkwZYAPQVpi7RPSVnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhvZxD6JBY4IRjD7gSluDFw0MGyDBvRYoWzr2ATCj5LCqTa3tdN3b6WhWwJzlM2jS
         bX2Jesw0afpIV/pofEJsl8H9baGSiNT3RyCre26OdFGBfwEnRzo8RH6WGyLCH7pwre
         hHyfZf00GtFO4jKHYqzdvUwT0fgsWcqlqMkGgVMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 592/779] ASoC: imx-card: Fix DSD/PDM mclk frequency
Date:   Mon, 15 Aug 2022 20:03:56 +0200
Message-Id: <20220815180402.631828875@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit c0fabd12a8570cb932f13d9388f3d887ad44369b ]

The DSD/PDM rate not only DSD64/128/256/512, which are the
multiple rate of 44.1kHz,  but also support the multiple
rate of 8kHz, so can't force all mclk frequency to be
22579200Hz, need to assign the frequency according to
rate.

Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1657100575-8261-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 55bc1bb0dbbd..b28b30c69a3f 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -17,6 +17,9 @@
 
 #include "fsl_sai.h"
 
+#define IMX_CARD_MCLK_22P5792MHZ  22579200
+#define IMX_CARD_MCLK_24P576MHZ   24576000
+
 enum codec_type {
 	CODEC_DUMMY = 0,
 	CODEC_AK5558 = 1,
@@ -353,9 +356,14 @@ static int imx_aif_hw_params(struct snd_pcm_substream *substream,
 		mclk_freq = akcodec_get_mclk_rate(substream, params, slots, slot_width);
 	else
 		mclk_freq = params_rate(params) * slots * slot_width;
-	/* Use the maximum freq from DSD512 (512*44100 = 22579200) */
-	if (format_is_dsd(params))
-		mclk_freq = 22579200;
+
+	if (format_is_dsd(params)) {
+		/* Use the maximum freq from DSD512 (512*44100 = 22579200) */
+		if (!(params_rate(params) % 11025))
+			mclk_freq = IMX_CARD_MCLK_22P5792MHZ;
+		else
+			mclk_freq = IMX_CARD_MCLK_24P576MHZ;
+	}
 
 	ret = snd_soc_dai_set_sysclk(cpu_dai, link_data->cpu_sysclk_id, mclk_freq,
 				     SND_SOC_CLOCK_OUT);
-- 
2.35.1



