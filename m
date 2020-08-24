Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A4F250511
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgHXRLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728403AbgHXQh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:37:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A65A23100;
        Mon, 24 Aug 2020 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287035;
        bh=q88Q+P2+4EgBQdQl1eeHV49GcwL+Mnk0zzT6hd6Yes8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouaGDcHcPL5nS7mjjef5hGCGtVbQfleBdZ7bW2c+n7zWYQ8LhEfFaVuQxhd4riOG9
         uvfOuCNu7lVbT5R61L9+90qy5a7KDrOsKr+xYz0dnrBUmOcY2so9tEKw1xpCUnq+cP
         NWFgdymfYGf5/sljDgxAjQI3avx+ETE47iGBj1N0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 30/54] ASoC: wm8994: Avoid attempts to read unreadable registers
Date:   Mon, 24 Aug 2020 12:36:09 -0400
Message-Id: <20200824163634.606093-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
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

