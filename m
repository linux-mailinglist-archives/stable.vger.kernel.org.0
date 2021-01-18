Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4E82F9E61
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390455AbhARLiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390380AbhARLiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9926F22227;
        Mon, 18 Jan 2021 11:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969791;
        bh=/djjC3kDdBNhUec3GnLY8X9oe6C7uFIRz0TdZsvwRRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDK7kmM4u77A/Qju8+Uc4/qvmbeXJpx1gilNtn7hZN8WcGa0Bg/Jr7UL26XBZKNZz
         wXhc1e9/HvoZM4x8tcvfatcjG/jvjIJAiBdkoRx5c6nFUobRYPZmySX03ec3TA61b/
         2ccC4hZneGpcE3Dxn0A1wYGAkhXK+R+BxNWyY1MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 27/43] ASoC: meson: axg-tdm-interface: fix loopback
Date:   Mon, 18 Jan 2021 12:34:50 +0100
Message-Id: <20210118113336.258258504@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit 671ee4db952449acde126965bf76817a3159040d upstream.

When the axg-tdm-interface was introduced, the backend DAI was marked as an
endpoint when DPCM was walking the DAPM graph to find a its BE.

It is no longer the case since this
commit 8dd26dff00c0 ("ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks")
Because of this, when DPCM finds a BE it does everything it needs on the
DAIs but it won't power up the widgets between the FE and the BE if there
is no actual endpoint after the BE.

On meson-axg HWs, the loopback is a special DAI of the tdm-interface BE.
It is only linked to the dummy codec since there no actual HW after it.
>From the DAPM perspective, the DAI has no endpoint. Because of this, the TDM
decoder, which is a widget between the FE and BE is not powered up.

>From the user perspective, everything seems fine but no data is produced.

Connecting the Loopback DAI to a dummy DAPM endpoint solves the problem.

Fixes: 8dd26dff00c0 ("ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks")
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201217150812.3247405-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/meson/axg-tdm-interface.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/sound/soc/meson/axg-tdm-interface.c
+++ b/sound/soc/meson/axg-tdm-interface.c
@@ -459,8 +459,20 @@ static int axg_tdm_iface_set_bias_level(
 	return ret;
 }
 
+static const struct snd_soc_dapm_widget axg_tdm_iface_dapm_widgets[] = {
+	SND_SOC_DAPM_SIGGEN("Playback Signal"),
+};
+
+static const struct snd_soc_dapm_route axg_tdm_iface_dapm_routes[] = {
+	{ "Loopback", NULL, "Playback Signal" },
+};
+
 static const struct snd_soc_component_driver axg_tdm_iface_component_drv = {
-	.set_bias_level	= axg_tdm_iface_set_bias_level,
+	.dapm_widgets		= axg_tdm_iface_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(axg_tdm_iface_dapm_widgets),
+	.dapm_routes		= axg_tdm_iface_dapm_routes,
+	.num_dapm_routes	= ARRAY_SIZE(axg_tdm_iface_dapm_routes),
+	.set_bias_level		= axg_tdm_iface_set_bias_level,
 };
 
 static const struct of_device_id axg_tdm_iface_of_match[] = {


