Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B23A35CB2D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243300AbhDLQXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243371AbhDLQXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC6D961241;
        Mon, 12 Apr 2021 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244594;
        bh=Oq6q44LBvAj0lfK0gaUxdqUdFLMZsSm/bJnLTGpQ7g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XK8kBZtM2VzFxNvYw2nbhz+pSx0KzVFpfituDVs2HpFfFfETxKzSCvrhjJm7YYu3Q
         kbtdgB50nEJS2CTOpBvbW2cPfD3+PV0Lkptph3H4qClw7ejwofqCM5KLGgpHuEa+hN
         mynxk4V3QsEB5jPFyggoLer7bqaJBOFFOADy5o7V2HFRYfLr+KaeYHBJcfknmwigTv
         3O5Wlwil3AOrLmyK/XivFwBmnCm9qXTQIYcsXAd02Go06rP+AstU1xsib+Sd+b7vlu
         Y5YHTxhLjN0qnCwkHkgOpuDUzEP6+j3NgcplbDTUnBdzKrbWdIIP40Ix5HMxI87pAG
         8lQUiVTGHCRJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryan Lee <ryans.lee@maximintegrated.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 14/51] ASoC: max98373: Added 30ms turn on/off time delay
Date:   Mon, 12 Apr 2021 12:22:19 -0400
Message-Id: <20210412162256.313524-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Lee <ryans.lee@maximintegrated.com>

[ Upstream commit 3a27875e91fb9c29de436199d20b33f9413aea77 ]

Amp requires 10 ~ 30ms for the power ON and OFF.
Added 30ms delay for stability.

Signed-off-by: Ryan Lee <ryans.lee@maximintegrated.com>
Link: https://lore.kernel.org/r/20210325033555.29377-2-ryans.lee@maximintegrated.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98373.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/max98373.c b/sound/soc/codecs/max98373.c
index 746c829312b8..1346a98ce8a1 100644
--- a/sound/soc/codecs/max98373.c
+++ b/sound/soc/codecs/max98373.c
@@ -28,11 +28,13 @@ static int max98373_dac_event(struct snd_soc_dapm_widget *w,
 		regmap_update_bits(max98373->regmap,
 			MAX98373_R20FF_GLOBAL_SHDN,
 			MAX98373_GLOBAL_EN_MASK, 1);
+		usleep_range(30000, 31000);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		regmap_update_bits(max98373->regmap,
 			MAX98373_R20FF_GLOBAL_SHDN,
 			MAX98373_GLOBAL_EN_MASK, 0);
+		usleep_range(30000, 31000);
 		max98373->tdm_mode = false;
 		break;
 	default:
-- 
2.30.2

