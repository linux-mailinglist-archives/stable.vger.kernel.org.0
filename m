Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8394F26A8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiDEIDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbiDEH7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB15C3D498;
        Tue,  5 Apr 2022 00:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77292616C6;
        Tue,  5 Apr 2022 07:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80113C340EE;
        Tue,  5 Apr 2022 07:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145303;
        bh=c145VdMyJxlm+hQ909vw+MZ3c4iyEE6L2ZmaXRhsthw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnmD2kVB2yTL11JmOxqt7aBQtAczSwocgXigpZxfywbgSS1kJuvDg9MR20HZp0Y4M
         Y30pDFsoCf7di02Rsp/m4MCaxwmsiTndAyDpmxsvSJiARwz2+HAEQxVNrMUV8ybtyj
         0yl3wUTELVqileUPKMdH5K4WoyrvjbilaSU7Jx3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0359/1126] ASoC: codecs: rx-macro: fix accessing array out of bounds for enum type
Date:   Tue,  5 Apr 2022 09:18:26 +0200
Message-Id: <20220405070418.165627453@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit bcfe5f76cc4051ea3f9eb5d2c8ea621641f290a5 ]

Accessing enums using integer would result in array out of bounds access
on platforms like aarch64 where sizeof(long) is 8 compared to enum size
which is 4 bytes.

Fixes: 4f692926f562 ("ASoC: codecs: lpass-rx-macro: add dapm widgets and route")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220222183212.11580-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 32e85d2e9b90..3a3dc0539d92 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -2272,7 +2272,7 @@ static int rx_macro_mux_get(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_dapm_to_component(widget->dapm);
 	struct rx_macro *rx = snd_soc_component_get_drvdata(component);
 
-	ucontrol->value.integer.value[0] =
+	ucontrol->value.enumerated.item[0] =
 			rx->rx_port_value[widget->shift];
 	return 0;
 }
@@ -2284,7 +2284,7 @@ static int rx_macro_mux_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_dapm_to_component(widget->dapm);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	struct snd_soc_dapm_update *update = NULL;
-	u32 rx_port_value = ucontrol->value.integer.value[0];
+	u32 rx_port_value = ucontrol->value.enumerated.item[0];
 	u32 aif_rst;
 	struct rx_macro *rx = snd_soc_component_get_drvdata(component);
 
@@ -2396,7 +2396,7 @@ static int rx_macro_get_hph_pwr_mode(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct rx_macro *rx = snd_soc_component_get_drvdata(component);
 
-	ucontrol->value.integer.value[0] = rx->hph_pwr_mode;
+	ucontrol->value.enumerated.item[0] = rx->hph_pwr_mode;
 	return 0;
 }
 
@@ -2406,7 +2406,7 @@ static int rx_macro_put_hph_pwr_mode(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct rx_macro *rx = snd_soc_component_get_drvdata(component);
 
-	rx->hph_pwr_mode = ucontrol->value.integer.value[0];
+	rx->hph_pwr_mode = ucontrol->value.enumerated.item[0];
 	return 0;
 }
 
-- 
2.34.1



