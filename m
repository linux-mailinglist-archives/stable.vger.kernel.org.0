Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE34714C35
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfEFOhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfEFOhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B236521655;
        Mon,  6 May 2019 14:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153458;
        bh=04rM0I+qMJMAKWuL5WnxMkTzXm+eljTfA/ntXWA47nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBh5hlK9VG/lKzFtol2QbJdWRGQ4NWp0+LGSJ7hYNz+H7DaY1Lek07q83Zk+8dX7a
         Np7MMDMh8IkaFcz6iCJs6ELqwFIfA8cC6UW5Mr8L3aYxwccbzSErMmy5oqDBm0Uq3k
         AXnoNHy2AA1Ta4ccPzLq7cpkBAplxTmchhDMoMh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.0 096/122] ASoC: sunxi: sun50i-codec-analog: Rename hpvcc regulator supply to cpvdd
Date:   Mon,  6 May 2019 16:32:34 +0200
Message-Id: <20190506143103.415299937@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

commit 5fd812e6f5ae0376134234ceb70e8de541ccb10d upstream.

The A64 datasheet lists the supply rail for the headphone amp's charge
pump as "CPVDD". cpvdd-supply is the name of the property for this power
rail specified in the device tree bindings. "HPVCC" was the name used in
the A33 datasheet for the same function.

Rename the supply so it matches the datasheet, bindings, and the subject
from the original commit.

Fixes: ca0412a05756 ("ASoC: sunxi: sun50i-codec-analog: Add support for cpvdd regulator supply")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sunxi/sun50i-codec-analog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/sunxi/sun50i-codec-analog.c
+++ b/sound/soc/sunxi/sun50i-codec-analog.c
@@ -274,7 +274,7 @@ static const struct snd_soc_dapm_widget
 	 * stream widgets at the card level.
 	 */
 
-	SND_SOC_DAPM_REGULATOR_SUPPLY("hpvcc", 0, 0),
+	SND_SOC_DAPM_REGULATOR_SUPPLY("cpvdd", 0, 0),
 	SND_SOC_DAPM_MUX("Headphone Source Playback Route",
 			 SND_SOC_NOPM, 0, 0, sun50i_codec_hp_src),
 	SND_SOC_DAPM_OUT_DRV("Headphone Amp", SUN50I_ADDA_HP_CTRL,
@@ -362,7 +362,7 @@ static const struct snd_soc_dapm_route s
 	{ "Headphone Source Playback Route", "Mixer", "Left Mixer" },
 	{ "Headphone Source Playback Route", "Mixer", "Right Mixer" },
 	{ "Headphone Amp", NULL, "Headphone Source Playback Route" },
-	{ "Headphone Amp", NULL, "hpvcc" },
+	{ "Headphone Amp", NULL, "cpvdd" },
 	{ "HP", NULL, "Headphone Amp" },
 
 	/* Microphone Routes */


