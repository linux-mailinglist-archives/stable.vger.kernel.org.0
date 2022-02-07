Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34B34ABD92
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388744AbiBGLpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384715AbiBGL3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0E9C043188;
        Mon,  7 Feb 2022 03:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93E12B81158;
        Mon,  7 Feb 2022 11:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0604C004E1;
        Mon,  7 Feb 2022 11:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233290;
        bh=mghb54hZFOF3Tf8Tw34fghEoY09mRRxhydg5x0NVEVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7YauR0KscXThr/XaJxanyUFWy8fjk6Gt/x+EkqeFjUYwhfJzCS924XyDaDvKSt98
         uRIJPAkR1pZMXZAIVdr7y1kiMqMeFKKQgWiw9vgUCG6afTYA+bamNO27Nv65sAq7ru
         peYhva8Me740YloGLJARO4vYRaMCnGhULi4mSxYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 076/110] ASoC: codecs: wcd938x: fix incorrect used of portid
Date:   Mon,  7 Feb 2022 12:06:49 +0100
Message-Id: <20220207103804.956829119@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

commit c5c1546a654f613e291a7c5d6f3660fc1eb6d0c7 upstream.

Mixer controls have the channel id in mixer->reg, which is not same
as port id. port id should be derived from chan_info array.
So fix this. Without this, its possible that we could corrupt
struct wcd938x_sdw_priv by accessing port_map array out of range
with channel id instead of port id.

Fixes: e8ba1e05bdc0 ("ASoC: codecs: wcd938x: add basic controls")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220126113549.8853-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -1432,14 +1432,10 @@ static int wcd938x_sdw_connect_port(stru
 	return 0;
 }
 
-static int wcd938x_connect_port(struct wcd938x_sdw_priv *wcd, u8 ch_id, u8 enable)
+static int wcd938x_connect_port(struct wcd938x_sdw_priv *wcd, u8 port_num, u8 ch_id, u8 enable)
 {
-	u8 port_num;
-
-	port_num = wcd->ch_info[ch_id].port_num;
-
 	return wcd938x_sdw_connect_port(&wcd->ch_info[ch_id],
-					&wcd->port_config[port_num],
+					&wcd->port_config[port_num - 1],
 					enable);
 }
 
@@ -2593,6 +2589,7 @@ static int wcd938x_set_compander(struct
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 	struct wcd938x_sdw_priv *wcd;
 	int value = ucontrol->value.integer.value[0];
+	int portidx;
 	struct soc_mixer_control *mc;
 	bool hphr;
 
@@ -2606,10 +2603,12 @@ static int wcd938x_set_compander(struct
 	else
 		wcd938x->comp1_enable = value;
 
+	portidx = wcd->ch_info[mc->reg].port_num;
+
 	if (value)
-		wcd938x_connect_port(wcd, mc->reg, true);
+		wcd938x_connect_port(wcd, portidx, mc->reg, true);
 	else
-		wcd938x_connect_port(wcd, mc->reg, false);
+		wcd938x_connect_port(wcd, portidx, mc->reg, false);
 
 	return 0;
 }
@@ -2882,9 +2881,11 @@ static int wcd938x_get_swr_port(struct s
 	struct wcd938x_sdw_priv *wcd;
 	struct soc_mixer_control *mixer = (struct soc_mixer_control *)kcontrol->private_value;
 	int dai_id = mixer->shift;
-	int portidx = mixer->reg;
+	int portidx, ch_idx = mixer->reg;
+
 
 	wcd = wcd938x->sdw_priv[dai_id];
+	portidx = wcd->ch_info[ch_idx].port_num;
 
 	ucontrol->value.integer.value[0] = wcd->port_enable[portidx];
 
@@ -2899,12 +2900,14 @@ static int wcd938x_set_swr_port(struct s
 	struct wcd938x_sdw_priv *wcd;
 	struct soc_mixer_control *mixer =
 		(struct soc_mixer_control *)kcontrol->private_value;
-	int portidx = mixer->reg;
+	int ch_idx = mixer->reg;
+	int portidx;
 	int dai_id = mixer->shift;
 	bool enable;
 
 	wcd = wcd938x->sdw_priv[dai_id];
 
+	portidx = wcd->ch_info[ch_idx].port_num;
 	if (ucontrol->value.integer.value[0])
 		enable = true;
 	else
@@ -2912,7 +2915,7 @@ static int wcd938x_set_swr_port(struct s
 
 	wcd->port_enable[portidx] = enable;
 
-	wcd938x_connect_port(wcd, portidx, enable);
+	wcd938x_connect_port(wcd, portidx, ch_idx, enable);
 
 	return 0;
 


