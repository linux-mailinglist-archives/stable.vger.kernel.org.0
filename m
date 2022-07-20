Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F44957ABAE
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240991AbiGTBOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240997AbiGTBOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:14:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A180865571;
        Tue, 19 Jul 2022 18:13:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BF7DB81DC0;
        Wed, 20 Jul 2022 01:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D96C341CA;
        Wed, 20 Jul 2022 01:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279578;
        bh=AlRYRU4V5TJDntlv9pC4QvcgEa5MRoS+G+jtvGQpEks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMbcTnhNTLaCvnYtE612E+Gm5xeHQhmw3WxrxwT2ZDlAYAIsWKrJdwS63vVOlWV2w
         dapd70Qyreqz6mFpjCr6aMJce/9ZTAuZ4Uyk3Pyj+K/PTjcuglw5GbH489o3xndVJ1
         N0AaZzPAbQf7ijEAiUxjKwTsrwV8uvWVUfX+jDPryg/i652vPQufcTBLQTle0DLDAu
         AWLUUalHvh0yQZ+sFRZB/fFWZYMEov9LG+umOuTdUgxabNuZeRUFsWuUnYhQtxmQuo
         mOlbqThZDBSD6/csTaHQfGNNcoweThtCgZFENz5pCMrs3rNn1jp5kw9JaA3AfWyrdt
         1eBk++FqbSq8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yassine Oudjana <y.oudjana@protonmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        srinivas.kandagatla@linaro.org, bgoswami@quicinc.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 38/54] ASoC: wcd9335: Use int array instead of bitmask for TX mixers
Date:   Tue, 19 Jul 2022 21:10:15 -0400
Message-Id: <20220720011031.1023305-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit a5d6d28e2ea38dff017cb562dfbe0259d093a851 ]

Currently slim_tx_mixer_get reports all TX mixers as enabled when
at least one is, due to it reading the entire tx_port_value bitmask
without testing the specific bit corresponding to a TX port.
Furthermore, using the same bitmask for all capture DAIs makes
setting one mixer affect them all. To prevent this, and since
the SLIM TX muxes effectively only connect to one of the mixers
at a time, turn tx_port_value into an int array storing the DAI
index each of the ports is connected to.

Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Link: https://lore.kernel.org/r/20220622061745.35399-1-y.oudjana@protonmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 1e60db4056ad..ad887c9c7573 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -342,7 +342,7 @@ struct wcd9335_codec {
 	struct regulator_bulk_data supplies[WCD9335_MAX_SUPPLY];
 
 	unsigned int rx_port_value[WCD9335_RX_MAX];
-	unsigned int tx_port_value;
+	unsigned int tx_port_value[WCD9335_TX_MAX];
 	int hph_l_gain;
 	int hph_r_gain;
 	u32 rx_bias_count;
@@ -1328,8 +1328,13 @@ static int slim_tx_mixer_get(struct snd_kcontrol *kc,
 
 	struct snd_soc_dapm_context *dapm = snd_soc_dapm_kcontrol_dapm(kc);
 	struct wcd9335_codec *wcd = dev_get_drvdata(dapm->dev);
+	struct snd_soc_dapm_widget *widget = snd_soc_dapm_kcontrol_widget(kc);
+	struct soc_mixer_control *mixer =
+			(struct soc_mixer_control *)kc->private_value;
+	int dai_id = widget->shift;
+	int port_id = mixer->shift;
 
-	ucontrol->value.integer.value[0] = wcd->tx_port_value;
+	ucontrol->value.integer.value[0] = wcd->tx_port_value[port_id] == dai_id;
 
 	return 0;
 }
@@ -1352,12 +1357,12 @@ static int slim_tx_mixer_put(struct snd_kcontrol *kc,
 	case AIF2_CAP:
 	case AIF3_CAP:
 		/* only add to the list if value not set */
-		if (enable && !(wcd->tx_port_value & BIT(port_id))) {
-			wcd->tx_port_value |= BIT(port_id);
+		if (enable && wcd->tx_port_value[port_id] != dai_id) {
+			wcd->tx_port_value[port_id] = dai_id;
 			list_add_tail(&wcd->tx_chs[port_id].list,
 					&wcd->dai[dai_id].slim_ch_list);
-		} else if (!enable && (wcd->tx_port_value & BIT(port_id))) {
-			wcd->tx_port_value &= ~BIT(port_id);
+		} else if (!enable && wcd->tx_port_value[port_id] == dai_id) {
+			wcd->tx_port_value[port_id] = -1;
 			list_del_init(&wcd->tx_chs[port_id].list);
 		}
 		break;
-- 
2.35.1

