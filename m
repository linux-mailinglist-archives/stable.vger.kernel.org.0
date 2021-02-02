Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C97B30C079
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhBBN66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233324AbhBBN44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A01CB64F70;
        Tue,  2 Feb 2021 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273519;
        bh=eg5nSV8N4BnM0ipc96ORmLCq/o/UWuqc+M126ugyla0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7NpZmA/XDMFUnjRFW5EhplbXXXh94nM+laYXEsLg4T+3x5bCZpPuwSaANUlsKos0
         y/Vs/IBW/7fFYE54Gv7XjUq9L1+tpiNih/cbDX8pHo/RM9BqHH2Dtdr9KuKS2FeVz0
         j1jiTu8e2mNhyq0orZBNrHuNgwPJdlYJJvftGTpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 136/142] ASoC: mediatek: mt8183-mt6358: ignore TDM DAI link by default
Date:   Tue,  2 Feb 2021 14:38:19 +0100
Message-Id: <20210202133003.301095478@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

commit 5ac154443e686b06242aa49de30a12b74ea9ca98 upstream.

hdmi-codec is an optional property.  Ignore to bind TDM DAI link
if the property isn't specified.

Fixes: f2024dc55fcb ("ASoC: mediatek: mt8183: use hdmi-codec")
Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20210120092237.1553938-2-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
@@ -515,6 +515,7 @@ static struct snd_soc_dai_link mt8183_mt
 		.ignore_suspend = 1,
 		.be_hw_params_fixup = mt8183_i2s_hw_params_fixup,
 		.ops = &mt8183_mt6358_tdm_ops,
+		.ignore = 1,
 		.init = mt8183_mt6358_ts3a227_max98357_hdmi_init,
 		SND_SOC_DAILINK_REG(tdm),
 	},
@@ -661,8 +662,10 @@ mt8183_mt6358_ts3a227_max98357_dev_probe
 						    SND_SOC_DAIFMT_CBM_CFM;
 		}
 
-		if (hdmi_codec && strcmp(dai_link->name, "TDM") == 0)
+		if (hdmi_codec && strcmp(dai_link->name, "TDM") == 0) {
 			dai_link->codecs->of_node = hdmi_codec;
+			dai_link->ignore = 0;
+		}
 
 		if (!dai_link->platforms->name)
 			dai_link->platforms->of_node = platform_node;


