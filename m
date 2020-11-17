Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309CA2B649B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbgKQNde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732044AbgKQNdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A2342469D;
        Tue, 17 Nov 2020 13:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620012;
        bh=Xk6afGxOhEefhhDTu11Tv5CbmYxiIZBgfet1Akd/Mbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcXVa82b+i46OM94R5cvRlcTlPIKV4imESXGywE0UxWv8fET3USMcDfKsFnfHQQ8K
         g0hnYK14jKdd8YI8P8xzQCAb9DvyV5ieaUyNRSNYMM9GC4JZiznkbrAe/6/wzJfacF
         fe7vSBNUTycUhEsW6veHGhjc1ax5d99hsALGtcZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 078/255] ASoC: cs42l51: manage mclk shutdown delay
Date:   Tue, 17 Nov 2020 14:03:38 +0100
Message-Id: <20201117122142.747438409@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 764f2ef8f59df..2b617993b0adb 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -245,8 +245,28 @@ static const struct snd_soc_dapm_widget cs42l51_dapm_widgets[] = {
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



