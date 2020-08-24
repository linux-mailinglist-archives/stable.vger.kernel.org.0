Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14F22505C9
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgHXRVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbgHXQfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA1A822D01;
        Mon, 24 Aug 2020 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286951;
        bh=q88Q+P2+4EgBQdQl1eeHV49GcwL+Mnk0zzT6hd6Yes8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvXCtnxJ/sgdWHBT7twgR5UfCYx34oOD9K+qhjthQPNLHqpakSVoeaFgrp2Emp2kL
         mxvI6ckkEZ0G63AbFz0F0S0bSuHh83juNUp0eKBttQB1Wl5ouZD0NLOaW2d53Zaa8T
         cTFv7G6fO9acyeiDK1psAt4ZMyMCP6sikEMQ1AE8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 35/63] ASoC: wm8994: Avoid attempts to read unreadable registers
Date:   Mon, 24 Aug 2020 12:34:35 -0400
Message-Id: <20200824163504.605538-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

[ Upstream commit f082bb59b72039a2326ec1a44496899fb8aa6d0e ]

The driver supports WM1811, WM8994, WM8958 devices but according to
documentation and the regmap definitions the WM8958_DSP2_* registers
are only available on WM8958. In current code these registers are
being accessed as if they were available on all the three chips.

When starting playback on WM1811 CODEC multiple errors like:
"wm8994-codec wm8994-codec: ASoC: error at soc_component_read_no_lock on wm8994-codec: -5"
can be seen, which is caused by attempts to read an unavailable
WM8958_DSP2_PROGRAM register. The issue has been uncovered by recent
commit "e2329ee ASoC: soc-component: add soc_component_err()".

This patch adds a check in wm8958_aif_ev() callback so the DSP2 handling
is only done for WM8958.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200731173834.23832-1-s.nawrocki@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8958-dsp2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/wm8958-dsp2.c b/sound/soc/codecs/wm8958-dsp2.c
index ca42445b649d4..b471892d84778 100644
--- a/sound/soc/codecs/wm8958-dsp2.c
+++ b/sound/soc/codecs/wm8958-dsp2.c
@@ -412,8 +412,12 @@ int wm8958_aif_ev(struct snd_soc_dapm_widget *w,
 		  struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+	struct wm8994 *control = dev_get_drvdata(component->dev->parent);
 	int i;
 
+	if (control->type != WM8958)
+		return 0;
+
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
 	case SND_SOC_DAPM_PRE_PMU:
-- 
2.25.1

