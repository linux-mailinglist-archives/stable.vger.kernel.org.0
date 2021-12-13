Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F9247275D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbhLMKAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:00:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44714 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236336AbhLMJ6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFC25B80E7F;
        Mon, 13 Dec 2021 09:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA963C34601;
        Mon, 13 Dec 2021 09:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389496;
        bh=EUrFmyZfPd6lDLgotjYjhCq6dQ/9VTl4agq8A+F+6EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3/9yVGgeUD/jOp1Fid9zOa/v0QFFSMvmXMWZ4TWIyxIAZm2DVVmrWapyEALZZqmf
         Xp3JuhXchBepvvl7NFNhKd94MCK1rYny6B+YvKHfEaWFpuk7+R2tBEvLl7kLZKyYpY
         BLPRX5l+t6ZHq4quX4wnCB8J8+F9jWHWD5FmPORM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 112/171] ASoC: codecs: wcd934x: return correct value from mixer put
Date:   Mon, 13 Dec 2021 10:30:27 +0100
Message-Id: <20211213092948.828971436@linuxfoundation.org>
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

commit d9be0ff4796d1b6f5ee391c1b7e3653a43cedfab upstream.

wcd934x_compander_set() currently returns zero eventhough it changes the value.
Fix this, so that change notifications are sent correctly.

Fixes: 1cde8b822332 ("ASoC: wcd934x: add basic controls")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211130160507.22180-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -3256,6 +3256,9 @@ static int wcd934x_compander_set(struct
 	int value = ucontrol->value.integer.value[0];
 	int sel;
 
+	if (wcd->comp_enabled[comp] == value)
+		return 0;
+
 	wcd->comp_enabled[comp] = value;
 	sel = value ? WCD934X_HPH_GAIN_SRC_SEL_COMPANDER :
 		WCD934X_HPH_GAIN_SRC_SEL_REGISTER;
@@ -3279,10 +3282,10 @@ static int wcd934x_compander_set(struct
 	case COMPANDER_8:
 		break;
 	default:
-		break;
+		return 0;
 	}
 
-	return 0;
+	return 1;
 }
 
 static int wcd934x_rx_hph_mode_get(struct snd_kcontrol *kc,


