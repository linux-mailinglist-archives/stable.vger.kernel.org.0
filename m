Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AB5461F16
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380486AbhK2Snt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:43:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45378 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378241AbhK2SkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA175B815DA;
        Mon, 29 Nov 2021 18:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262D0C53FC7;
        Mon, 29 Nov 2021 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211013;
        bh=r89LhmtnfAxeAtBP6DU/9hfGWRoXlp5G41Qo4nocGIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nu0FT60xcGEqMPMLiWKQhof1xocUkACFuU6G1wSlSr8CPpcWR5WN8fotxmb5gcHIr
         5BMxJYajxC2jYr2MdhBiCbxiY8dPZHIRSgwQoGGeNz3wainp8hr9WqGfG2OObdK6Ah
         j5fHKgh5S1D7A7yjiUSvudpUEOG55Js3LWBb5adc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/179] ASoC: qdsp6: q6routing: Conditionally reset FrontEnd Mixer
Date:   Mon, 29 Nov 2021 19:17:48 +0100
Message-Id: <20211129181721.393315855@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 861afeac7990587588d057b2c0b3222331c3da29 ]

Stream IDs are reused across multiple BackEnd mixers, do not reset the
stream mixers if they are not already set for that particular FrontEnd.

Ex:
amixer cset iface=MIXER,name='SLIMBUS_0_RX Audio Mixer MultiMedia1' 1

would set the MultiMedia1 steam for SLIMBUS_0_RX, however doing below
command will reset previously setup MultiMedia1 stream, because both of them
are using MultiMedia1 PCM stream.

amixer cset iface=MIXER,name='SLIMBUS_2_RX Audio Mixer MultiMedia1' 0

reset the FrontEnd Mixers conditionally to fix this issue.

This is more noticeable in desktop setup, where in alsactl tries to restore
the alsa state and overwriting the previous mixer settings.

Fixes: e3a33673e845 ("ASoC: qdsp6: q6routing: Add q6routing driver")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211116114721.12517-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6routing.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/qcom/qdsp6/q6routing.c b/sound/soc/qcom/qdsp6/q6routing.c
index 3390ebef9549d..243b8179e59df 100644
--- a/sound/soc/qcom/qdsp6/q6routing.c
+++ b/sound/soc/qcom/qdsp6/q6routing.c
@@ -495,7 +495,11 @@ static int msm_routing_put_audio_mixer(struct snd_kcontrol *kcontrol,
 		session->port_id = be_id;
 		snd_soc_dapm_mixer_update_power(dapm, kcontrol, 1, update);
 	} else {
-		session->port_id = -1;
+		if (session->port_id == be_id) {
+			session->port_id = -1;
+			return 0;
+		}
+
 		snd_soc_dapm_mixer_update_power(dapm, kcontrol, 0, update);
 	}
 
-- 
2.33.0



