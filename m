Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BA560BAAB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiJXUjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbiJXUip (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:38:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B429A9E3;
        Mon, 24 Oct 2022 11:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCA15B819B8;
        Mon, 24 Oct 2022 12:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DA0C433C1;
        Mon, 24 Oct 2022 12:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615478;
        bh=EmaDTsfjjX6VkFtwvm9RhgPGxlFp62StVDajk3ToO9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGldKGJFFtuZN4CP00EgIRQTt3vbYtE2Uf8h4aniKHWBc8fo9EyZIUxb1YuW7yYss
         k/GzJ4zBNdx8QpO/ewnaJDROTqNxq2Gx6/ZhyJNoZbz1PZMVGZ/BS9I8JqGYh4u/6p
         95fW1olFsiYlqB0YvnE1W4nOMdkG3DH8Md+3Wnek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/530] ASoC: codecs: tx-macro: fix kcontrol put
Date:   Mon, 24 Oct 2022 13:29:41 +0200
Message-Id: <20221024113055.822423707@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit c1057a08af438e0cf5450c1d977a3011198ed2f8 ]

tx_macro_tx_mixer_put() and tx_macro_dec_mode_put() currently returns zero
eventhough it changes the value.
Fix this, so that change notifications are sent correctly.

Fixes: d207bdea0ca9 ("ASoC: codecs: lpass-tx-macro: add dapm widgets and route")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220906170112.1984-6-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index e4bbc6bd4925..feafb8a90ffe 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -815,17 +815,23 @@ static int tx_macro_tx_mixer_put(struct snd_kcontrol *kcontrol,
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);
 
 	if (enable) {
+		if (tx->active_decimator[dai_id] == dec_id)
+			return 0;
+
 		set_bit(dec_id, &tx->active_ch_mask[dai_id]);
 		tx->active_ch_cnt[dai_id]++;
 		tx->active_decimator[dai_id] = dec_id;
 	} else {
+		if (tx->active_decimator[dai_id] == -1)
+			return 0;
+
 		tx->active_ch_cnt[dai_id]--;
 		clear_bit(dec_id, &tx->active_ch_mask[dai_id]);
 		tx->active_decimator[dai_id] = -1;
 	}
 	snd_soc_dapm_mixer_update_power(widget->dapm, kcontrol, enable, update);
 
-	return 0;
+	return 1;
 }
 
 static int tx_macro_enable_dec(struct snd_soc_dapm_widget *w,
@@ -1011,9 +1017,12 @@ static int tx_macro_dec_mode_put(struct snd_kcontrol *kcontrol,
 	int path = e->shift_l;
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);
 
+	if (tx->dec_mode[path] == value)
+		return 0;
+
 	tx->dec_mode[path] = value;
 
-	return 0;
+	return 1;
 }
 
 static int tx_macro_get_bcs(struct snd_kcontrol *kcontrol,
-- 
2.35.1



