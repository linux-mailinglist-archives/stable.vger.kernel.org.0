Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC52E472694
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhLMJxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:53:32 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41352 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbhLMJt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:49:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31CF3CE0EAA;
        Mon, 13 Dec 2021 09:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D011CC341D0;
        Mon, 13 Dec 2021 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388995;
        bh=v+Q53ycCzyppq4mqsNOESY4g7QbRHJedhxxSpjX9nfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IX6Bfkxdn/K4zHc6zqbgOIxa40/D8Gqnt2WKvefl0j+HE2GXkhm33EurIuF4yrl1p
         G9djUYKLlZSEcqZOjnkv99sTwI2+cMB5QC0+fi9MVIP4LZYRrIHwmQAgXOIB+5mE3l
         kRuLH+8Gf9sQ3uuCOWh8mVu3Qes2FgFEjpOL2TD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 080/132] ASoC: codecs: wcd934x: return correct value from mixer put
Date:   Mon, 13 Dec 2021 10:30:21 +0100
Message-Id: <20211213092941.866719279@linuxfoundation.org>
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
@@ -2470,6 +2470,9 @@ static int wcd934x_compander_set(struct
 	int value = ucontrol->value.integer.value[0];
 	int sel;
 
+	if (wcd->comp_enabled[comp] == value)
+		return 0;
+
 	wcd->comp_enabled[comp] = value;
 	sel = value ? WCD934X_HPH_GAIN_SRC_SEL_COMPANDER :
 		WCD934X_HPH_GAIN_SRC_SEL_REGISTER;
@@ -2493,10 +2496,10 @@ static int wcd934x_compander_set(struct
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


