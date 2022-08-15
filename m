Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B605950E1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiHPErE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiHPEqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02DC175458;
        Mon, 15 Aug 2022 13:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB4E861234;
        Mon, 15 Aug 2022 20:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ED8C433C1;
        Mon, 15 Aug 2022 20:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596227;
        bh=AyU24YVz++nhNR4ubWOG1XjYUMz+8Y1xf/PQPu5HIz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RN3dhG9efRZ/VoubCDi6qnH8cwb5fVCGKYqrO0AgcvtR19AxehYoX3n/HoxVGRBfq
         rsl6xYJ8vi+wr0i/IdmGQ5LQuqS35sHmr896qBIe1TDULQEnJWOA/LZwuPZxo+xNuQ
         U5S/g823b133jdPqLjB6zbyuOcjavLkPIfJpdmnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0979/1157] ASoC: fsl-asoc-card: force cast the asrc_format type
Date:   Mon, 15 Aug 2022 20:05:35 +0200
Message-Id: <20220815180518.908629797@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 6c7b077dad62178c33f9a3ae17f90d6b0bf6e2e5 ]

Fix sparse warning:
sound/soc/fsl/fsl-asoc-card.c:833:45: sparse: warning: incorrect type in argument 3 (different base types)
sound/soc/fsl/fsl-asoc-card.c:833:45: sparse:    expected unsigned int [usertype] *out_value
sound/soc/fsl/fsl-asoc-card.c:833:45: sparse:    got restricted snd_pcm_format_t *

Fixes: 859e364302c5 ("ASoC: fsl-asoc-card: Support new property fsl, asrc-format")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1658399393-28777-4-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index d9a0d4768c4d..c836848ef0a6 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -537,6 +537,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	struct device *codec_dev = NULL;
 	const char *codec_dai_name;
 	const char *codec_dev_name;
+	u32 asrc_fmt = 0;
 	u32 width;
 	int ret;
 
@@ -829,8 +830,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 			goto asrc_fail;
 		}
 
-		ret = of_property_read_u32(asrc_np, "fsl,asrc-format",
-					   &priv->asrc_format);
+		ret = of_property_read_u32(asrc_np, "fsl,asrc-format", &asrc_fmt);
+		priv->asrc_format = (__force snd_pcm_format_t)asrc_fmt;
 		if (ret) {
 			/* Fallback to old binding; translate to asrc_format */
 			ret = of_property_read_u32(asrc_np, "fsl,asrc-width",
-- 
2.35.1



