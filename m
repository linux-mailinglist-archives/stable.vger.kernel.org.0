Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5B6574272
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbiGNEY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiGNEYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DF328E14;
        Wed, 13 Jul 2022 21:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 097A261E91;
        Thu, 14 Jul 2022 04:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D82C34114;
        Thu, 14 Jul 2022 04:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772580;
        bh=OuR2fE51Nw9KFMYwaWsMlNUb5eNbAno7VLPZUKUduTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drYQSQ4F970Z38kngtVcJ/hLXkrJ/vXxAddKoFOHS5XUSE2rgUkDLA21Z5wgz9lbF
         wWfTXOjQNUohxbbWkLd5yYR+3VrydVpnHImzAbplFhMwG1WIF0leSPrq4vMXlr1FXa
         F4yFxvBiLPKE4IG0IGvCwqBO4OtENiP9nQ5W3nX4Jcolz4RRiZV2rxCa1nYKvKS+68
         2mtouRsVum6oI7fOlLsy0UdOUi0/DTSh8zetiShnt9UGN5KR551eFSFj6zN0XLiVX7
         sIyLG4SEdxUFR6yaCGquXHPN93Wc9NdKiXgI6dk308/n/M+KJf7rzRkN2R9Nh6QoZ/
         A5E4JEVuTR5iA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, srinivas.kandagatla@linaro.org,
        quic_potturu@quicinc.com, quic_srivasam@quicinc.com,
        pierre-louis.bossart@linux.intel.com,
        ckeepax@opensource.cirrus.com, yong.wu@mediatek.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 14/41] ASoC: wcd938x: Fix event generation for some controls
Date:   Thu, 14 Jul 2022 00:21:54 -0400
Message-Id: <20220714042221.281187-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
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
index 898b2887fa63..088cfda767cc 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -2519,6 +2519,9 @@ static int wcd938x_tx_mode_put(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 
+	if (wcd938x->tx_mode[path] == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd938x->tx_mode[path] = ucontrol->value.enumerated.item[0];
 
 	return 1;
@@ -2541,6 +2544,9 @@ static int wcd938x_rx_hph_mode_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->hph_mode == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd938x->hph_mode = ucontrol->value.enumerated.item[0];
 
 	return 1;
@@ -2632,6 +2638,9 @@ static int wcd938x_ldoh_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->ldoh == ucontrol->value.integer.value[0])
+		return 0;
+
 	wcd938x->ldoh = ucontrol->value.integer.value[0];
 
 	return 1;
@@ -2654,6 +2663,9 @@ static int wcd938x_bcs_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->bcs_dis == ucontrol->value.integer.value[0])
+		return 0;
+
 	wcd938x->bcs_dis = ucontrol->value.integer.value[0];
 
 	return 1;
-- 
2.35.1

