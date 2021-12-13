Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C36472758
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbhLMKAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:00:04 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46902 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbhLMJ6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0DEB3CE0F1B;
        Mon, 13 Dec 2021 09:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93316C34602;
        Mon, 13 Dec 2021 09:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389489;
        bh=JODOhe0cWrBUlHdiGaUFuX3uSPmcjlYZLnjIAoAulAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piyFnHyFp4bBdsvRex9bs3x5L64Bp8313PqRh2O42A7/dXRfPHNOk/7xBj87ZnU9X
         vDacColkOsYWO16tJj1SyHekC1YlL5W4AK9+jYbybf53h2yYBXKLRX3Iqix3AJtgBf
         g5EcZfUbFI2n/a4KLZd9d2cKJ+40zwDIxYrbuoaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 111/171] ASoC: codecs: wcd934x: handle channel mappping list correctly
Date:   Mon, 13 Dec 2021 10:30:26 +0100
Message-Id: <20211213092948.791673901@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 23ba28616d3063bd4c4953598ed5e439ca891101 upstream.

Currently each channel is added as list to dai channel list, however
there is danger of adding same channel to multiple dai channel list
which endups corrupting the other list where its already added.

This patch ensures that the channel is actually free before adding to
the dai channel list and also ensures that the channel is on the list
before deleting it.

This check was missing previously, and we did not hit this issue as
we were testing very simple usecases with sequence of amixer commands.

Fixes: a70d9245759a ("ASoC: wcd934x: add capture dapm widgets")
Fixes: dd9eb19b5673 ("ASoC: wcd934x: add playback dapm widgets")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211130160507.22180-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |  119 +++++++++++++++++++++++++++++++++------------
 1 file changed, 88 insertions(+), 31 deletions(-)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -3326,6 +3326,31 @@ static int slim_rx_mux_get(struct snd_kc
 	return 0;
 }
 
+static int slim_rx_mux_to_dai_id(int mux)
+{
+	int aif_id;
+
+	switch (mux) {
+	case 1:
+		aif_id = AIF1_PB;
+		break;
+	case 2:
+		aif_id = AIF2_PB;
+		break;
+	case 3:
+		aif_id = AIF3_PB;
+		break;
+	case 4:
+		aif_id = AIF4_PB;
+		break;
+	default:
+		aif_id = -1;
+		break;
+	}
+
+	return aif_id;
+}
+
 static int slim_rx_mux_put(struct snd_kcontrol *kc,
 			   struct snd_ctl_elem_value *ucontrol)
 {
@@ -3333,43 +3358,59 @@ static int slim_rx_mux_put(struct snd_kc
 	struct wcd934x_codec *wcd = dev_get_drvdata(w->dapm->dev);
 	struct soc_enum *e = (struct soc_enum *)kc->private_value;
 	struct snd_soc_dapm_update *update = NULL;
+	struct wcd934x_slim_ch *ch, *c;
 	u32 port_id = w->shift;
+	bool found = false;
+	int mux_idx;
+	int prev_mux_idx = wcd->rx_port_value[port_id];
+	int aif_id;
 
-	if (wcd->rx_port_value[port_id] == ucontrol->value.enumerated.item[0])
-		return 0;
+	mux_idx = ucontrol->value.enumerated.item[0];
 
-	wcd->rx_port_value[port_id] = ucontrol->value.enumerated.item[0];
+	if (mux_idx == prev_mux_idx)
+		return 0;
 
-	switch (wcd->rx_port_value[port_id]) {
+	switch(mux_idx) {
 	case 0:
-		list_del_init(&wcd->rx_chs[port_id].list);
-		break;
-	case 1:
-		list_add_tail(&wcd->rx_chs[port_id].list,
-			      &wcd->dai[AIF1_PB].slim_ch_list);
-		break;
-	case 2:
-		list_add_tail(&wcd->rx_chs[port_id].list,
-			      &wcd->dai[AIF2_PB].slim_ch_list);
-		break;
-	case 3:
-		list_add_tail(&wcd->rx_chs[port_id].list,
-			      &wcd->dai[AIF3_PB].slim_ch_list);
+		aif_id = slim_rx_mux_to_dai_id(prev_mux_idx);
+		if (aif_id < 0)
+			return 0;
+
+		list_for_each_entry_safe(ch, c, &wcd->dai[aif_id].slim_ch_list, list) {
+			if (ch->port == port_id + WCD934X_RX_START) {
+				found = true;
+				list_del_init(&ch->list);
+				break;
+			}
+		}
+		if (!found)
+			return 0;
+
 		break;
-	case 4:
-		list_add_tail(&wcd->rx_chs[port_id].list,
-			      &wcd->dai[AIF4_PB].slim_ch_list);
+	case 1 ... 4:
+		aif_id = slim_rx_mux_to_dai_id(mux_idx);
+		if (aif_id < 0)
+			return 0;
+
+		if (list_empty(&wcd->rx_chs[port_id].list)) {
+			list_add_tail(&wcd->rx_chs[port_id].list,
+				      &wcd->dai[aif_id].slim_ch_list);
+		} else {
+			dev_err(wcd->dev ,"SLIM_RX%d PORT is busy\n", port_id);
+			return 0;
+		}
 		break;
+
 	default:
-		dev_err(wcd->dev, "Unknown AIF %d\n",
-			wcd->rx_port_value[port_id]);
+		dev_err(wcd->dev, "Unknown AIF %d\n", mux_idx);
 		goto err;
 	}
 
+	wcd->rx_port_value[port_id] = mux_idx;
 	snd_soc_dapm_mux_update_power(w->dapm, kc, wcd->rx_port_value[port_id],
 				      e, update);
 
-	return 0;
+	return 1;
 err:
 	return -EINVAL;
 }
@@ -3815,6 +3856,7 @@ static int slim_tx_mixer_put(struct snd_
 	struct soc_mixer_control *mixer =
 			(struct soc_mixer_control *)kc->private_value;
 	int enable = ucontrol->value.integer.value[0];
+	struct wcd934x_slim_ch *ch, *c;
 	int dai_id = widget->shift;
 	int port_id = mixer->shift;
 
@@ -3822,17 +3864,32 @@ static int slim_tx_mixer_put(struct snd_
 	if (enable == wcd->tx_port_value[port_id])
 		return 0;
 
-	wcd->tx_port_value[port_id] = enable;
-
-	if (enable)
-		list_add_tail(&wcd->tx_chs[port_id].list,
-			      &wcd->dai[dai_id].slim_ch_list);
-	else
-		list_del_init(&wcd->tx_chs[port_id].list);
+	if (enable) {
+		if (list_empty(&wcd->tx_chs[port_id].list)) {
+			list_add_tail(&wcd->tx_chs[port_id].list,
+				      &wcd->dai[dai_id].slim_ch_list);
+		} else {
+			dev_err(wcd->dev ,"SLIM_TX%d PORT is busy\n", port_id);
+			return 0;
+		}
+	 } else {
+		bool found = false;
+
+		list_for_each_entry_safe(ch, c, &wcd->dai[dai_id].slim_ch_list, list) {
+			if (ch->port == port_id) {
+				found = true;
+				list_del_init(&wcd->tx_chs[port_id].list);
+				break;
+			}
+		}
+		if (!found)
+			return 0;
+	 }
 
+	wcd->tx_port_value[port_id] = enable;
 	snd_soc_dapm_mixer_update_power(widget->dapm, kc, enable, update);
 
-	return 0;
+	return 1;
 }
 
 static const struct snd_kcontrol_new aif1_slim_cap_mixer[] = {


