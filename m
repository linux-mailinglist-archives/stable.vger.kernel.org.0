Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B141593CFA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbiHOTgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344250AbiHOTg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:36:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8A9642D2;
        Mon, 15 Aug 2022 11:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C1AD611E8;
        Mon, 15 Aug 2022 18:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AA6C433C1;
        Mon, 15 Aug 2022 18:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589141;
        bh=ZrmD6NIvlvB4c/OD2NuWsSHOYZ1Vb1Ay9jCFCc1P/sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8OQADtHScLQZuVAlDPqJ42iAV+SMzqpcyaWBzBShZOHABb8ghbxRn3zmP8MjUb4M
         Feg1AN6Fvx9S7o8H7O9MimD8OGC3x8zfi8AVEESCvlnvnzhOKBiAeIpB9dVwXgPZpU
         tHgMx1oukAOMZZMlQ2ht7qSA/Vl8kEGFe6dRDRv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 625/779] ASoC: fsl_easrc: use snd_pcm_format_t type for sample_format
Date:   Mon, 15 Aug 2022 20:04:29 +0200
Message-Id: <20220815180404.101146633@linuxfoundation.org>
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

[ Upstream commit de27216cf2d645c2fd14e513707bdcd54e5b1de4 ]

Fix sparse warning:
sound/soc/fsl/fsl_easrc.c:562:33: sparse: warning: restricted snd_pcm_format_t degrades to integer
sound/soc/fsl/fsl_easrc.c:563:34: sparse: warning: restricted snd_pcm_format_t degrades to integer
sound/soc/fsl/fsl_easrc.c:565:38: sparse: warning: restricted snd_pcm_format_t degrades to integer
sound/soc/fsl/fsl_easrc.c:566:39: sparse: warning: restricted snd_pcm_format_t degrades to integer
sound/soc/fsl/fsl_easrc.c:608:33: sparse: warning: restricted snd_pcm_format_t degrades to integer
sound/soc/fsl/fsl_easrc.c:609:34: sparse: warning: restricted snd_pcm_format_t degrades to integer
sound/soc/fsl/fsl_easrc.c:615:40: sparse: warning: restricted snd_pcm_format_t degrades to integer
sound/soc/fsl/fsl_easrc.c:616:41: sparse: warning: restricted snd_pcm_format_t degrades to integer

sound/soc/fsl/fsl_easrc.c:1465:51: sparse: warning: incorrect type in assignment (different base types)
sound/soc/fsl/fsl_easrc.c:1465:51: sparse:    expected unsigned int sample_format
sound/soc/fsl/fsl_easrc.c:1465:51: sparse:    got restricted snd_pcm_format_t [usertype] format
sound/soc/fsl/fsl_easrc.c:1467:52: sparse: warning: incorrect type in assignment (different base types)
sound/soc/fsl/fsl_easrc.c:1467:52: sparse:    expected unsigned int sample_format
sound/soc/fsl/fsl_easrc.c:1467:52: sparse:    got restricted snd_pcm_format_t [usertype] asrc_format
sound/soc/fsl/fsl_easrc.c:1470:52: sparse: warning: incorrect type in assignment (different base types)
sound/soc/fsl/fsl_easrc.c:1470:52: sparse:    expected unsigned int sample_format
sound/soc/fsl/fsl_easrc.c:1470:52: sparse:    got restricted snd_pcm_format_t [usertype] format
sound/soc/fsl/fsl_easrc.c:1472:51: sparse: warning: incorrect type in assignment (different base types)
sound/soc/fsl/fsl_easrc.c:1472:51: sparse:    expected unsigned int sample_format
sound/soc/fsl/fsl_easrc.c:1472:51: sparse:    got restricted snd_pcm_format_t [usertype] asrc_format
sound/soc/fsl/fsl_easrc.c:1484:41: sparse: warning: incorrect type in argument 2 (different base types)
sound/soc/fsl/fsl_easrc.c:1484:41: sparse:    expected restricted snd_pcm_format_t [usertype] *in_raw_format
sound/soc/fsl/fsl_easrc.c:1484:41: sparse:    got unsigned int *
sound/soc/fsl/fsl_easrc.c:1485:41: sparse: warning: incorrect type in argument 3 (different base types)
sound/soc/fsl/fsl_easrc.c:1485:41: sparse:    expected restricted snd_pcm_format_t [usertype] *out_raw_format
sound/soc/fsl/fsl_easrc.c:1485:41: sparse:    got unsigned int *
sound/soc/fsl/fsl_easrc.c:1937:60: sparse: warning: incorrect type in argument 3 (different base types)
sound/soc/fsl/fsl_easrc.c:1937:60: sparse:    expected unsigned int [usertype] *out_value
sound/soc/fsl/fsl_easrc.c:1937:60: sparse:    got restricted snd_pcm_format_t *
sound/soc/fsl/fsl_easrc.c:1943:49: sparse: warning: restricted snd_pcm_format_t degrades to integer

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1658399393-28777-5-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 9 ++++++---
 sound/soc/fsl/fsl_easrc.h | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index be14f84796cb..cf0e10d17dbe 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -476,7 +476,8 @@ static int fsl_easrc_prefilter_config(struct fsl_asrc *easrc,
 	struct fsl_asrc_pair *ctx;
 	struct device *dev;
 	u32 inrate, outrate, offset = 0;
-	u32 in_s_rate, out_s_rate, in_s_fmt, out_s_fmt;
+	u32 in_s_rate, out_s_rate;
+	snd_pcm_format_t in_s_fmt, out_s_fmt;
 	int ret, i;
 
 	if (!easrc)
@@ -1873,6 +1874,7 @@ static int fsl_easrc_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct device_node *np;
 	void __iomem *regs;
+	u32 asrc_fmt = 0;
 	int ret, irq;
 
 	easrc = devm_kzalloc(dev, sizeof(*easrc), GFP_KERNEL);
@@ -1933,13 +1935,14 @@ static int fsl_easrc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = of_property_read_u32(np, "fsl,asrc-format", &easrc->asrc_format);
+	ret = of_property_read_u32(np, "fsl,asrc-format", &asrc_fmt);
+	easrc->asrc_format = (__force snd_pcm_format_t)asrc_fmt;
 	if (ret) {
 		dev_err(dev, "failed to asrc format\n");
 		return ret;
 	}
 
-	if (!(FSL_EASRC_FORMATS & (1ULL << easrc->asrc_format))) {
+	if (!(FSL_EASRC_FORMATS & (pcm_format_to_bits(easrc->asrc_format)))) {
 		dev_warn(dev, "unsupported format, switching to S24_LE\n");
 		easrc->asrc_format = SNDRV_PCM_FORMAT_S24_LE;
 	}
diff --git a/sound/soc/fsl/fsl_easrc.h b/sound/soc/fsl/fsl_easrc.h
index 30620d56252c..5b8469757c12 100644
--- a/sound/soc/fsl/fsl_easrc.h
+++ b/sound/soc/fsl/fsl_easrc.h
@@ -569,7 +569,7 @@ struct fsl_easrc_io_params {
 	unsigned int access_len;
 	unsigned int fifo_wtmk;
 	unsigned int sample_rate;
-	unsigned int sample_format;
+	snd_pcm_format_t sample_format;
 	unsigned int norm_rate;
 };
 
-- 
2.35.1



