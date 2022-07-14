Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D44574324
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiGNEak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237108AbiGNE3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:29:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C703729C8C;
        Wed, 13 Jul 2022 21:24:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21987B8237A;
        Thu, 14 Jul 2022 04:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F266C34114;
        Thu, 14 Jul 2022 04:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772695;
        bh=RUUKpFFgLZU5wPepFLY7h5IaUmNL/AXE1xUV7qaneFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIS/bHcUQvMR2p1uaEd0p2fPZ+IzvYmka5KBhD9iaY1+UVVs9ZOVdbnzHHsf7DNtQ
         J6A+fB5GG9WOg8MMZKu5z8kTu5Ow6GiJ7IJsanEfn6eBxnk4kU2Pki2pknRVQH5+/C
         tft/Av4VwaafPgg82rOREiwQIlLxR0Q+iGQ5HJ3gp1gxz2zuk/Gsys27Tx7XlV2t2C
         qKg6ubWcdyOR/n7t0PQymVBDptubxIaZssXljNRlphoENQ9W7GoJobaMS3FrMW8+yA
         bqfMTGX4sEn9rabPHT3jhg/LIv3si2V92ytRiDIcMoebQp7FMiBpE180M40escinIf
         WrMfZ15+OyAcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, srinivas.kandagatla@linaro.org,
        quic_srivasam@quicinc.com, quic_potturu@quicinc.com,
        pierre-louis.bossart@linux.intel.com,
        ckeepax@opensource.cirrus.com, yong.wu@mediatek.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 10/28] ASoC: wcd938x: Fix event generation for some controls
Date:   Thu, 14 Jul 2022 00:24:11 -0400
Message-Id: <20220714042429.281816-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042429.281816-1-sashal@kernel.org>
References: <20220714042429.281816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 10e7ff0047921e32b919ecee7be706dd33c107f8 ]

Currently wcd938x_*_put() unconditionally report that the value of the
control changed, resulting in spurious events being generated. Return 0 in
that case instead as we should. There is still an issue in the compander
control which is a bit more complex.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20220603122526.3914942-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd938x.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index 4480c118ed5d..8cdc45e669f2 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -2517,6 +2517,9 @@ static int wcd938x_tx_mode_put(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 
+	if (wcd938x->tx_mode[path] == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd938x->tx_mode[path] = ucontrol->value.enumerated.item[0];
 
 	return 1;
@@ -2539,6 +2542,9 @@ static int wcd938x_rx_hph_mode_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->hph_mode == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd938x->hph_mode = ucontrol->value.enumerated.item[0];
 
 	return 1;
@@ -2630,6 +2636,9 @@ static int wcd938x_ldoh_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->ldoh == ucontrol->value.integer.value[0])
+		return 0;
+
 	wcd938x->ldoh = ucontrol->value.integer.value[0];
 
 	return 1;
@@ -2652,6 +2661,9 @@ static int wcd938x_bcs_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->bcs_dis == ucontrol->value.integer.value[0])
+		return 0;
+
 	wcd938x->bcs_dis = ucontrol->value.integer.value[0];
 
 	return 1;
-- 
2.35.1

