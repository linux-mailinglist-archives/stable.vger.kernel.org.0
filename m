Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B76A4729B2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbhLMKX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242211AbhLMKUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:20:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B2DC08EAFA;
        Mon, 13 Dec 2021 01:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFB1CB80E83;
        Mon, 13 Dec 2021 09:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24690C34601;
        Mon, 13 Dec 2021 09:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389485;
        bh=oVI2L5Y/QgONeFmQaI1+k95QDY05CDNeV1WSyGyDTeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCeF+xxxNDYxa8fGIFeq/yUv87LQC0tGrhPbQ++cI1YBG/NAY9cJoj4MyOlyVZuQr
         ftzO7HtwJUWYn5iV0igY5WG5d3OTG/Wr2sZX9c17in710WwpFeldNpIvpPjB1Pu0wZ
         tdYqbPfwy4IqLcKlvya2NvYZ6yzcrWuRUpgd4SYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 110/171] ASoC: codecs: wsa881x: fix return values from kcontrol put
Date:   Mon, 13 Dec 2021 10:30:25 +0100
Message-Id: <20211213092948.760479502@linuxfoundation.org>
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

commit 3fc27e9a1f619b50700f020e6cd270c1b74755f0 upstream.

wsa881x_set_port() and wsa881x_put_pa_gain() currently returns zero eventhough
it changes the value. Fix this, so that change notifications are sent
correctly.

Fixes: a0aab9e1404a ("ASoC: codecs: add wsa881x amplifier support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211130160507.22180-5-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wsa881x.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -772,7 +772,8 @@ static int wsa881x_put_pa_gain(struct sn
 
 		usleep_range(1000, 1010);
 	}
-	return 0;
+
+	return 1;
 }
 
 static int wsa881x_get_port(struct snd_kcontrol *kcontrol,
@@ -816,15 +817,22 @@ static int wsa881x_set_port(struct snd_k
 		(struct soc_mixer_control *)kcontrol->private_value;
 	int portidx = mixer->reg;
 
-	if (ucontrol->value.integer.value[0])
+	if (ucontrol->value.integer.value[0]) {
+		if (data->port_enable[portidx])
+			return 0;
+
 		data->port_enable[portidx] = true;
-	else
+	} else {
+		if (!data->port_enable[portidx])
+			return 0;
+
 		data->port_enable[portidx] = false;
+	}
 
 	if (portidx == WSA881X_PORT_BOOST) /* Boost Switch */
 		wsa881x_boost_ctrl(comp, data->port_enable[portidx]);
 
-	return 0;
+	return 1;
 }
 
 static const char * const smart_boost_lvl_text[] = {


