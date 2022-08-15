Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522FC593AF7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344390AbiHOTnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345006AbiHOTmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:42:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B3941D11;
        Mon, 15 Aug 2022 11:47:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3116461215;
        Mon, 15 Aug 2022 18:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FBBC433C1;
        Mon, 15 Aug 2022 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589275;
        bh=Fwi3sWQJEDyeCfSlZ8mzk9hmc7TmCoU9uZk6Wb8OtrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMsnNHLWIQr9xPdiP42iKIn/G8MM+8YsxPOsZ0b+N7aRbtshbA5UuaIEm+G1BBfv4
         hZXEJGvOXtUzXz6uZuTp8LlWUjEZX0JV7waSVzJvooWKuRLdTTnP9+IrFLHyJzwf6V
         Npt4KXPBX2tKKoPSX7g2JWqIlsNrNhv+bD0dWDkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 626/779] ASoC: imx-card: use snd_pcm_format_t type for asrc_format
Date:   Mon, 15 Aug 2022 20:04:30 +0200
Message-Id: <20220815180404.131743767@linuxfoundation.org>
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

[ Upstream commit 409a8652e909e323c715f3088e6c3133e37c8881 ]

Fix sparse warning:
sound/soc/fsl/imx-card.c:653:59: sparse: warning: incorrect type in assignment (different base types)
sound/soc/fsl/imx-card.c:653:59: sparse:    expected unsigned int [usertype] asrc_format
sound/soc/fsl/imx-card.c:653:59: sparse:    got restricted snd_pcm_format_t [usertype]
sound/soc/fsl/imx-card.c:655:59: sparse: warning: incorrect type in assignment (different base types)
sound/soc/fsl/imx-card.c:655:59: sparse:    expected unsigned int [usertype] asrc_format
sound/soc/fsl/imx-card.c:655:59: sparse:    got restricted snd_pcm_format_t [usertype]

Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1658399393-28777-6-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index b28b30c69a3f..593d69b96523 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -118,7 +118,7 @@ struct imx_card_data {
 	struct snd_soc_card card;
 	int num_dapm_routes;
 	u32 asrc_rate;
-	u32 asrc_format;
+	snd_pcm_format_t asrc_format;
 };
 
 static struct imx_akcodec_fs_mul ak4458_fs_mul[] = {
@@ -474,7 +474,7 @@ static int be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
 
 	mask = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
 	snd_mask_none(mask);
-	snd_mask_set(mask, data->asrc_format);
+	snd_mask_set(mask, (__force unsigned int)data->asrc_format);
 
 	return 0;
 }
@@ -493,6 +493,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	struct dai_link_data *link_data;
 	struct of_phandle_args args;
 	int ret, num_links;
+	u32 asrc_fmt = 0;
 	u32 width;
 
 	ret = snd_soc_of_parse_card_name(card, "model");
@@ -639,7 +640,8 @@ static int imx_card_parse_of(struct imx_card_data *data)
 				goto err;
 			}
 
-			ret = of_property_read_u32(args.np, "fsl,asrc-format", &data->asrc_format);
+			ret = of_property_read_u32(args.np, "fsl,asrc-format", &asrc_fmt);
+			data->asrc_format = (__force snd_pcm_format_t)asrc_fmt;
 			if (ret) {
 				/* Fallback to old binding; translate to asrc_format */
 				ret = of_property_read_u32(args.np, "fsl,asrc-width", &width);
-- 
2.35.1



