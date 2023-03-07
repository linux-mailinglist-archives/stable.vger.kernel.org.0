Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2E36AEA27
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjCGRbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjCGRau (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CB3A2F0C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 110FA614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FACC433EF;
        Tue,  7 Mar 2023 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209970;
        bh=IYrIAxunQeGysVGq/FcYaEvQZuZdhhhu++n7Yfiwjac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKNfHgUDcu3268AvOEYnf5ZoJz3UsxPfQuQoHWvriqQEKIogrw9U/lkp9Hg4C7PfJ
         xdrmdohhTdaxPPn7mD0jScaWaf/ooKPn6Vr2JIx310OuOYpUDXC547MmqAZ49tq/J/
         mrs1Wz/R7jTZrGrdLdTDHolF1ryNUVIruWhz2D/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0359/1001] ASoC: fsl_sai: initialize is_dsp_mode flag
Date:   Tue,  7 Mar 2023 17:52:11 +0100
Message-Id: <20230307170037.009313734@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit a23924b7dd7b748fff8e305e1daf590fed2af21b ]

Initialize is_dsp_mode flag in the beginning of function
fsl_sai_set_dai_fmt_tr().

When the DAIFMT is DAIFMT_DSP_B the first time, is_dsp_mode is
true, then the second time DAIFMT is DAIFMT_I2S, is_dsp_mode
still true, which is a wrong state. So need to initialize
is_dsp_mode flag every time.

Fixes: a3f7dcc9cc03 ("ASoC: fsl-sai: Add SND_SOC_DAIFMT_DSP_A/B support.")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/1673852874-32200-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 35a52c3a020d1..4967f2daa6d97 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -281,6 +281,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		val_cr4 |= FSL_SAI_CR4_MF;
 
 	sai->is_pdm_mode = false;
+	sai->is_dsp_mode = false;
 	/* DAI mode */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-- 
2.39.2



