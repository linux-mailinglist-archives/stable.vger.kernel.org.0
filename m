Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEED47271F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbhLMJ6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237681AbhLMJwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:52:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB034C08ECB2;
        Mon, 13 Dec 2021 01:44:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72953B80E24;
        Mon, 13 Dec 2021 09:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E14DC341C5;
        Mon, 13 Dec 2021 09:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388676;
        bh=UVHcb43j39Lc9B+5S7oGKiajT5/IKtFEZycUpsqB/IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNUsKDjcsizpIBmYdQjhB4Gmd7r13w34YosdHpy9TDZ/oxya+deQbgEGpu7wE5sDO
         1VRms0ao2EjFJJ3ahH5oe7wkFkQksw7f9vFpBlGs9kTvucYRfaEO+GV4yR0VnXptJN
         rezl8hjobZ8Nl7DTnxh2xS77xJCujqQIWr2y7isY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 51/88] ASoC: qdsp6: q6routing: Fix return value from msm_routing_put_audio_mixer
Date:   Mon, 13 Dec 2021 10:30:21 +0100
Message-Id: <20211213092935.026801364@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
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
 


