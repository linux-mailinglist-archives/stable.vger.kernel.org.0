Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A2F59511A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiHPEuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiHPEsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D2BCD538;
        Mon, 15 Aug 2022 13:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29650B80EAD;
        Mon, 15 Aug 2022 20:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0406CC433C1;
        Mon, 15 Aug 2022 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596223;
        bh=oZGOCMV2dnlc2c/xaoUlqt5cyP+8PuLV7tdYjOkXkgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGfDIRoQJHtMEzs5lidcnuH+edM10NetBMRUa7pp6Euk7y9005xa0Ku/MA+OK/dUI
         K8+26nOosSlMfADZzcGohAtdZ8amn8GPpaKj4jIKX/o1jtRnMz/pdfLvrpSqIEEONK
         na0vy6cyYEi5CNZiZ5gFXmmTYk5/3l4XzNbEufFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0978/1157] ASoC: fsl_asrc: force cast the asrc_format type
Date:   Mon, 15 Aug 2022 20:05:34 +0200
Message-Id: <20220815180518.860319842@linuxfoundation.org>
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

[ Upstream commit c49932726de24405d45516b3f8ad2735714fdf05 ]

Fix sparse warning:
sound/soc/fsl/fsl_asrc.c:1177:60: sparse: warning: incorrect type in argument 3 (different base types)
sound/soc/fsl/fsl_asrc.c:1177:60: sparse:    expected unsigned int [usertype] *out_value
sound/soc/fsl/fsl_asrc.c:1177:60: sparse:    got restricted snd_pcm_format_t *
sound/soc/fsl/fsl_asrc.c:1200:47: sparse: warning: restricted snd_pcm_format_t degrades to integer

Fixes: 4520af41fd21 ("ASoC: fsl_asrc: Support new property fsl,asrc-format")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1658399393-28777-3-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 20a9f8e924b3..aa5edf32d988 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -1066,6 +1066,7 @@ static int fsl_asrc_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *regs;
 	int irq, ret, i;
+	u32 asrc_fmt = 0;
 	u32 map_idx;
 	char tmp[16];
 	u32 width;
@@ -1174,7 +1175,8 @@ static int fsl_asrc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = of_property_read_u32(np, "fsl,asrc-format", &asrc->asrc_format);
+	ret = of_property_read_u32(np, "fsl,asrc-format", &asrc_fmt);
+	asrc->asrc_format = (__force snd_pcm_format_t)asrc_fmt;
 	if (ret) {
 		ret = of_property_read_u32(np, "fsl,asrc-width", &width);
 		if (ret) {
@@ -1197,7 +1199,7 @@ static int fsl_asrc_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (!(FSL_ASRC_FORMATS & (1ULL << asrc->asrc_format))) {
+	if (!(FSL_ASRC_FORMATS & pcm_format_to_bits(asrc->asrc_format))) {
 		dev_warn(&pdev->dev, "unsupported width, use default S24_LE\n");
 		asrc->asrc_format = SNDRV_PCM_FORMAT_S24_LE;
 	}
-- 
2.35.1



