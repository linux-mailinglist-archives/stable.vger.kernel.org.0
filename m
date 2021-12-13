Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D554727E2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbhLMKF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241026AbhLMKC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:02:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D05C03460D;
        Mon, 13 Dec 2021 01:49:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5CF3ECE0E7A;
        Mon, 13 Dec 2021 09:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0862AC341CB;
        Mon, 13 Dec 2021 09:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388989;
        bh=oVI2L5Y/QgONeFmQaI1+k95QDY05CDNeV1WSyGyDTeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcsJ+xEEq9kU7BN0ZzEeXZ0h7O7rwKdEmd9jOCp+xCFaWI9mwayIPYB4WtNYRZhgc
         /WlC18KYNt/fdcKfH1QXOk1hhdlXMzi/sQBYqz/YBx454dWHNRMLYMdtxLZQZEChuE
         P6daJW9WG3zmGVxa15cQ8FAg+5mQKdCtR4nsXj6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 078/132] ASoC: codecs: wsa881x: fix return values from kcontrol put
Date:   Mon, 13 Dec 2021 10:30:19 +0100
Message-Id: <20211213092941.795150118@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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


