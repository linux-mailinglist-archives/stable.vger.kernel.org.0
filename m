Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F474F3BAC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbiDEMA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357665AbiDEK0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:26:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6E03335E;
        Tue,  5 Apr 2022 03:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA37FB81C8A;
        Tue,  5 Apr 2022 10:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06801C385A1;
        Tue,  5 Apr 2022 10:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153430;
        bh=CSMlmGL614k1X+ldBmtvlDf0XkR5AmyOsgqIcsGuQF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vO39spMg7GuRKvZDFNsuxRKYV6GXAOfegOcHFTbj/Bz/EKemLiUiCtHCIE8gPSW6O
         fRLXBmzsiqbyC2zt/xuB/ev56+NGH4dmlRcan7aSxQ8VV2d764HO/iUCy/9eBOuInk
         2f49QcBzc4+T/joeIArTfCEZHeN0hhLlJeTuACyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/599] ASoC: codecs: wcd934x: fix return value of wcd934x_rx_hph_mode_put
Date:   Tue,  5 Apr 2022 09:28:34 +0200
Message-Id: <20220405070305.390482911@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 4b0bec6088588a120d33db85b1f0d9f096d1df71 ]

wcd934x_rx_hph_mode_put currently returns zero eventhough it changes the value.
Fix this, so that change notifications are sent correctly.

Fixes: 1cde8b822332 ("ASoC: wcd934x: add basic controls")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220222183212.11580-10-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd934x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index 01df3f4e045a..f07dea0bc27e 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -2522,13 +2522,16 @@ static int wcd934x_rx_hph_mode_put(struct snd_kcontrol *kc,
 
 	mode_val = ucontrol->value.enumerated.item[0];
 
+	if (mode_val == wcd->hph_mode)
+		return 0;
+
 	if (mode_val == 0) {
 		dev_err(wcd->dev, "Invalid HPH Mode, default to ClSH HiFi\n");
 		mode_val = CLS_H_LOHIFI;
 	}
 	wcd->hph_mode = mode_val;
 
-	return 0;
+	return 1;
 }
 
 static int slim_rx_mux_get(struct snd_kcontrol *kc,
-- 
2.34.1



