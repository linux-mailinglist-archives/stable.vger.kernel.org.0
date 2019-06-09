Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B943A82E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732781AbfFIQ5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733190AbfFIQ5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:57:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48F5C204EC;
        Sun,  9 Jun 2019 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099450;
        bh=SLAe6/IoBPDUbYUdq+rzQEmI9w4plC6PgcfwdwJjL3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GLFUIm4X61LnCam4APscpOzpAZiLD2A+3urlY7JXWUkQp2QGQ1ePaynW+iaOOaOz
         wPwU4s/LidygIFUcYJTs+ZTYXjJJDBzGWEoVDjfKWaUelRcL+s4e1cH1F5/VakgFDm
         It7isSuByOPMQ+dS2bcaWhVbJTAHD9hHrr5i+Yvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 010/241] ASoC: max98090: Fix restore of DAPM Muxes
Date:   Sun,  9 Jun 2019 18:39:12 +0200
Message-Id: <20190609164148.084676608@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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


