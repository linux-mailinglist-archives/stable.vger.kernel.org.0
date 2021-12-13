Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CDB47253D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbhLMJnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34918 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbhLMJkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2CA2CE0E63;
        Mon, 13 Dec 2021 09:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B768C00446;
        Mon, 13 Dec 2021 09:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388414;
        bh=UVHcb43j39Lc9B+5S7oGKiajT5/IKtFEZycUpsqB/IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uz6UkgyplZUuCwAORY0pA0SCrBSvhBt24gfsHpI6uPUNgwHlGmQjxJf+8vuqq3OwW
         FJ2QojnBlE2nfvQy/72rrBkajq0I+hpDe4IH/z/MZl1xSU79dWGeV/GIfd47Yntw0c
         oEI9NO6VKazbMbwvtUv3WZw35BmINA5Ix5daiSZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 42/74] ASoC: qdsp6: q6routing: Fix return value from msm_routing_put_audio_mixer
Date:   Mon, 13 Dec 2021 10:30:13 +0100
Message-Id: <20211213092932.227726308@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 4739d88ad8e1900f809f8a5c98f3c1b65bf76220 upstream.

msm_routing_put_audio_mixer() can return incorrect value in various scenarios.

scenario 1:
amixer cset iface=MIXER,name='SLIMBUS_0_RX Audio Mixer MultiMedia1' 1
amixer cset iface=MIXER,name='SLIMBUS_0_RX Audio Mixer MultiMedia1' 0

return value is 0 instead of 1 eventhough value was changed

scenario 2:
amixer cset iface=MIXER,name='SLIMBUS_0_RX Audio Mixer MultiMedia1' 1
amixer cset iface=MIXER,name='SLIMBUS_0_RX Audio Mixer MultiMedia1' 1

return value is 1 instead of 0 eventhough the value was not changed

scenario 3:
amixer cset iface=MIXER,name='SLIMBUS_0_RX Audio Mixer MultiMedia1' 0
return value is 1 instead of 0 eventhough the value was not changed

Fix this by adding checks, so that change notifications are sent correctly.

Fixes: e3a33673e845 ("ASoC: qdsp6: q6routing: Add q6routing driver")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211130163110.5628-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6routing.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6routing.c
+++ b/sound/soc/qcom/qdsp6/q6routing.c
@@ -440,14 +440,16 @@ static int msm_routing_put_audio_mixer(s
 	struct session_data *session = &data->sessions[session_id];
 
 	if (ucontrol->value.integer.value[0]) {
+		if (session->port_id == be_id)
+			return 0;
+
 		session->port_id = be_id;
 		snd_soc_dapm_mixer_update_power(dapm, kcontrol, 1, update);
 	} else {
-		if (session->port_id == be_id) {
-			session->port_id = -1;
+		if (session->port_id == -1 || session->port_id != be_id)
 			return 0;
-		}
 
+		session->port_id = -1;
 		snd_soc_dapm_mixer_update_power(dapm, kcontrol, 0, update);
 	}
 


