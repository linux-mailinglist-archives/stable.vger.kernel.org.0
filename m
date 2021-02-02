Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC36F30CBBF
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbhBBTeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:34:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233373AbhBBN4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF9964F69;
        Tue,  2 Feb 2021 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273516;
        bh=7ASq83ZX7i1Zyd3PI0RCUDI3bn2LF60PGiU8lALbhKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/Uy4cGaWr3gfmEI+qsTdHw9ep71rMYnW6qLBZ8atdveMkMb97Na9O8JCxVGT7H8W
         SYV+D+RRHwsZSR2st3NzX/ZY71T9tHOReLFSvvdLp8SlzkwP9sw/CeuvEOoyqr87Ro
         BG5sx5ip79v+Idi+ahCs1ee//GyVatYR/tjHO/nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 135/142] ASoC: mediatek: mt8183-da7219: ignore TDM DAI link by default
Date:   Tue,  2 Feb 2021 14:38:18 +0100
Message-Id: <20210202133003.261667568@linuxfoundation.org>
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

commit 4d36ed8eb0f749c9e781e0d3b041a7adeedcdaa9 upstream.

hdmi-codec is an optional property.  Ignore to bind TDM DAI link
if the property isn't specified.

Fixes: 5bdbe9771177 ("ASoC: mediatek: mt8183-da7219: use hdmi-codec")
Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20210120092237.1553938-3-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -532,6 +532,7 @@ static struct snd_soc_dai_link mt8183_da
 		.dpcm_playback = 1,
 		.ignore_suspend = 1,
 		.be_hw_params_fixup = mt8183_i2s_hw_params_fixup,
+		.ignore = 1,
 		.init = mt8183_da7219_max98357_hdmi_init,
 		SND_SOC_DAILINK_REG(tdm),
 	},
@@ -754,8 +755,10 @@ static int mt8183_da7219_max98357_dev_pr
 			}
 		}
 
-		if (hdmi_codec && strcmp(dai_link->name, "TDM") == 0)
+		if (hdmi_codec && strcmp(dai_link->name, "TDM") == 0) {
 			dai_link->codecs->of_node = hdmi_codec;
+			dai_link->ignore = 0;
+		}
 
 		if (!dai_link->platforms->name)
 			dai_link->platforms->of_node = platform_node;


