Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD456087AA
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbiJVIFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiJVIEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC74C2D20DD;
        Sat, 22 Oct 2022 00:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36B03B82DF0;
        Sat, 22 Oct 2022 07:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBCBC433C1;
        Sat, 22 Oct 2022 07:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424947;
        bh=/KXZ6TtpDb4MRpdGoI3eHmCgdlt22zSQ2OvKcABdU/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBK6/10b16xb76icKQyFOXy/Sp0hQ++I5NdtB3d/TybsHysSyGBGEI/Ae5i4F+JbE
         mV8VFpF1kc9hEBZ09DovH8zdaeOe/Ds9bAouZ3zIixL6hqzsCNzRkh8WC+xYsP77Fk
         c0gKYqJn8PbrhAD6HL/XKG4SrHVWELJFC9v3hyKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 336/717] ASoC: codecs: tx-macro: fix kcontrol put
Date:   Sat, 22 Oct 2022 09:23:35 +0200
Message-Id: <20221022072510.096164409@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 55503ba480bb..e162a08d9945 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -823,17 +823,23 @@ static int tx_macro_tx_mixer_put(struct snd_kcontrol *kcontrol,
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
@@ -1019,9 +1025,12 @@ static int tx_macro_dec_mode_put(struct snd_kcontrol *kcontrol,
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



