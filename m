Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FF92ACD99
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbgKJED3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732819AbgKJDyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D30E207BC;
        Tue, 10 Nov 2020 03:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980484;
        bh=lCSQVerc+jJ4Piycr3n5lNXAN1aByZZN2bWhfq7Vax4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STXd2HFXNsagC0dTIZLsntmHKeaYMbj5m78gbGSOrBhvQj9BV9XnZNJQCy3n0EKMp
         +pUkKC5BNMxbd7dBCMin2Tl1w151Zw3+v+pEsK3P1ng0YIAzom+fc5BlT0D8XNMeHQ
         /2zX1rITEayGc4rl4Lrgu1CS/zkslzRVLwN4L1Hw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 02/42] ASoC: cs42l51: manage mclk shutdown delay
Date:   Mon,  9 Nov 2020 22:54:00 -0500
Message-Id: <20201110035440.424258-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

[ Upstream commit 20afe581c9b980848ad097c4d54dde9bec7593ef ]

A delay must be introduced before the shutdown down of the mclk,
as stated in CS42L51 datasheet. Otherwise the codec may
produce some noise after the end of DAPM power down sequence.
The delay between DAC and CLOCK_SUPPLY widgets is too short.
Add a delay in mclk shutdown request to manage the shutdown delay
explicitly. From experiments, at least 10ms delay is necessary.
Set delay to 20ms as recommended in Documentation/timers/timers-howto.rst
when using msleep().

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Link: https://lore.kernel.org/r/20201020150109.482-1-olivier.moysan@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l51.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 55408c8fcb4e3..cdd7ae90c2b59 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -247,8 +247,28 @@ static const struct snd_soc_dapm_widget cs42l51_dapm_widgets[] = {
 		&cs42l51_adcr_mux_controls),
 };
 
+static int mclk_event(struct snd_soc_dapm_widget *w,
+		      struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *comp = snd_soc_dapm_to_component(w->dapm);
+	struct cs42l51_private *cs42l51 = snd_soc_component_get_drvdata(comp);
+
+	switch (event) {
+	case SND_SOC_DAPM_PRE_PMU:
+		return clk_prepare_enable(cs42l51->mclk_handle);
+	case SND_SOC_DAPM_POST_PMD:
+		/* Delay mclk shutdown to fulfill power-down sequence requirements */
+		msleep(20);
+		clk_disable_unprepare(cs42l51->mclk_handle);
+		break;
+	}
+
+	return 0;
+}
+
 static const struct snd_soc_dapm_widget cs42l51_dapm_mclk_widgets[] = {
-	SND_SOC_DAPM_CLOCK_SUPPLY("MCLK")
+	SND_SOC_DAPM_SUPPLY("MCLK", SND_SOC_NOPM, 0, 0, mclk_event,
+			    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
 };
 
 static const struct snd_soc_dapm_route cs42l51_routes[] = {
-- 
2.27.0

