Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12B96B4540
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjCJOcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjCJOcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C9C4DE19
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBC886192E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB75AC433D2;
        Fri, 10 Mar 2023 14:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458667;
        bh=/YOATX8XtpUjmYc6XebEFqVJBW/YHKJ9gLrDO5g3S3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TP+097dGFB6CDSps2FODBKmGsOJbdNeEvNjc/MbGxZt75sXdw2KQqa2mXKo3Vbd1
         fSHUdCgkEvfEMag0Z+7XHD0S0nYudtBxaeuQX7tiXfBcEazYfcjHPorii+hoKg03XV
         RAAnRQ/4F2R3Flba9oIUqSKQ6uU+8SaX/rEgifYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/357] ASoC: fsl_sai: initialize is_dsp_mode flag
Date:   Fri, 10 Mar 2023 14:36:33 +0100
Message-Id: <20230310133738.607459505@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index 027259695551c..f8445231ad782 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -212,6 +212,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	if (!sai->is_lsb_first)
 		val_cr4 |= FSL_SAI_CR4_MF;
 
+	sai->is_dsp_mode = false;
 	/* DAI mode */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-- 
2.39.2



