Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AE323404
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387948AbfETMWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387702AbfETMWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:22:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C10205ED;
        Mon, 20 May 2019 12:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354951;
        bh=SLAe6/IoBPDUbYUdq+rzQEmI9w4plC6PgcfwdwJjL3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwtZG3qWOmRvUCzM/dhCOZd62OOGWwITAJnh+HSF5iginAqcixYRZGf3+iTEjH+Vg
         Kh4hCSuVafnpS6NX4Ivx0TTtls6GN4PCJQVH1eizXq5xu8YWmgQysS0jnvs/vi08Fe
         JQTEaa3PBHz6sMVQFrNal6Mno2jqIeL0JDYniRvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 039/105] ASoC: max98090: Fix restore of DAPM Muxes
Date:   Mon, 20 May 2019 14:13:45 +0200
Message-Id: <20190520115249.728131204@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit ecb2795c08bc825ebd604997e5be440b060c5b18 upstream.

The max98090 driver defines 3 DAPM muxes; one for the right line output
(LINMOD Mux), one for the left headphone mixer source (MIXHPLSEL Mux)
and one for the right headphone mixer source (MIXHPRSEL Mux). The same
bit is used for the mux as well as the DAPM enable, and although the mux
can be correctly configured, after playback has completed, the mux will
be reset during the disable phase. This is preventing the state of these
muxes from being saved and restored correctly on system reboot. Fix this
by marking these muxes as SND_SOC_NOPM.

Note this has been verified this on the Tegra124 Nyan Big which features
the MAX98090 codec.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98090.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1209,14 +1209,14 @@ static const struct snd_soc_dapm_widget
 		&max98090_right_rcv_mixer_controls[0],
 		ARRAY_SIZE(max98090_right_rcv_mixer_controls)),
 
-	SND_SOC_DAPM_MUX("LINMOD Mux", M98090_REG_LOUTR_MIXER,
-		M98090_LINMOD_SHIFT, 0, &max98090_linmod_mux),
+	SND_SOC_DAPM_MUX("LINMOD Mux", SND_SOC_NOPM, 0, 0,
+		&max98090_linmod_mux),
 
-	SND_SOC_DAPM_MUX("MIXHPLSEL Mux", M98090_REG_HP_CONTROL,
-		M98090_MIXHPLSEL_SHIFT, 0, &max98090_mixhplsel_mux),
+	SND_SOC_DAPM_MUX("MIXHPLSEL Mux", SND_SOC_NOPM, 0, 0,
+		&max98090_mixhplsel_mux),
 
-	SND_SOC_DAPM_MUX("MIXHPRSEL Mux", M98090_REG_HP_CONTROL,
-		M98090_MIXHPRSEL_SHIFT, 0, &max98090_mixhprsel_mux),
+	SND_SOC_DAPM_MUX("MIXHPRSEL Mux", SND_SOC_NOPM, 0, 0,
+		&max98090_mixhprsel_mux),
 
 	SND_SOC_DAPM_PGA("HP Left Out", M98090_REG_OUTPUT_ENABLE,
 		M98090_HPLEN_SHIFT, 0, NULL, 0),


