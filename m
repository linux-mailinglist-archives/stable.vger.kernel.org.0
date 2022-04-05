Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695DD4F42A5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380635AbiDEMNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357952AbiDEK1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E433972D5;
        Tue,  5 Apr 2022 03:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9B66B81C89;
        Tue,  5 Apr 2022 10:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7D7C385A1;
        Tue,  5 Apr 2022 10:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153495;
        bh=41oa2V21gkwHryt3xAkM08QuvZpZF2TW4fviTnLf6Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUh1aoqeT1n+ibFy3JI1fuiO/L+vh2eP4txV/oo0xrGcFE9G9U6ZGQuMO2Po5KtAY
         ZXcerYlmLlgd6FCd/M7QESktoU/KamXflYZmVhpJWN6Va1i7Ie2M/b+1IRGXJikVrD
         KC8eO8zrk+p4SVvq2fdJRwNFNNfY298nqN3MFGNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/599] ASoC: wm8350: Handle error for wm8350_register_irq
Date:   Tue,  5 Apr 2022 09:28:54 +0200
Message-Id: <20220405070305.983746868@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit db0350da8084ad549bca16cc0486c11cc70a1f9b ]

As the potential failure of the wm8350_register_irq(),
it should be better to check it and return error if fails.
Also, use 'free_' in order to avoid the same code.

Fixes: a6ba2b2dabb5 ("ASoC: Implement WM8350 headphone jack detection")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220304023821.391936-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8350.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index a6aa212fa0c8..ec5d997725b9 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -1536,18 +1536,38 @@ static  int wm8350_component_probe(struct snd_soc_component *component)
 	wm8350_clear_bits(wm8350, WM8350_JACK_DETECT,
 			  WM8350_JDL_ENA | WM8350_JDR_ENA);
 
-	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L,
 			    wm8350_hpl_jack_handler, 0, "Left jack detect",
 			    priv);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R,
+	if (ret != 0)
+		goto err;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R,
 			    wm8350_hpr_jack_handler, 0, "Right jack detect",
 			    priv);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_MICSCD,
+	if (ret != 0)
+		goto free_jck_det_l;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_MICSCD,
 			    wm8350_mic_handler, 0, "Microphone short", priv);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_MICD,
+	if (ret != 0)
+		goto free_jck_det_r;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_MICD,
 			    wm8350_mic_handler, 0, "Microphone detect", priv);
+	if (ret != 0)
+		goto free_micscd;
 
 	return 0;
+
+free_micscd:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_MICSCD, priv);
+free_jck_det_r:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R, priv);
+free_jck_det_l:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L, priv);
+err:
+	return ret;
 }
 
 static void wm8350_component_remove(struct snd_soc_component *component)
-- 
2.34.1



