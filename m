Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7414054CC
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351368AbhIINDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356250AbhIIM7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8531C6326F;
        Thu,  9 Sep 2021 11:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188731;
        bh=AsS5IWO2I9ueUInU05sg4o6O+dRha59amT68ELM+6WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeQO7icV1LFuTGpSYRtRQS2Bh+jWCMq3JBHjKt3vQmyRLUwOj6eSw5FppkabXli/d
         +AkZZ7jiUJQL/nc7zRfJkBTivXZgskhAfxXYTwnasdA3n/+JcVERKgK5d5NhP2Trrc
         sNcMEE3tdJUw+YPwQB+749dp9Hz6zBVCEhANMS5TSSbugl1HJxavWIKJvCljAma5O3
         vaQLcU3M0UsVVyvd9HS6yQFwisEsTmApzEyHhvH61jjVEU7Oi1Ex5gHLEpyEs8ZMFD
         k2t28m/TIrs/CjOAOZDfIXgvRwXdZyVUcEXHL5H/mNoL+jx6KywsIeupcfH1OmHeUD
         M/DB/989f1vLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sugar Zhang <sugar.zhang@rock-chips.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 68/74] ASoC: rockchip: i2s: Fix regmap_ops hang
Date:   Thu,  9 Sep 2021 07:57:20 -0400
Message-Id: <20210909115726.149004-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sugar Zhang <sugar.zhang@rock-chips.com>

[ Upstream commit 53ca9b9777b95cdd689181d7c547e38dc79adad0 ]

API 'set_fmt' maybe called when PD is off, in the situation,
any register access will hang the system. so, enable PD
before r/w register.

Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Link: https://lore.kernel.org/r/1629950520-14190-4-git-send-email-sugar.zhang@rock-chips.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index b86f76c3598c..cab381c9dea1 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -189,7 +189,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 {
 	struct rk_i2s_dev *i2s = to_info(cpu_dai);
 	unsigned int mask = 0, val = 0;
+	int ret = 0;
 
+	pm_runtime_get_sync(cpu_dai->dev);
 	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
@@ -202,7 +204,8 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 		i2s->is_master_mode = false;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_CKR, mask, val);
@@ -216,7 +219,8 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 		val = I2S_CKR_CKP_POS;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_CKR, mask, val);
@@ -239,7 +243,8 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 		val = I2S_TXCR_TFS_PCM | I2S_TXCR_PBM_MODE(1);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_TXCR, mask, val);
@@ -262,12 +267,16 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 		val = I2S_RXCR_TFS_PCM | I2S_RXCR_PBM_MODE(1);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_RXCR, mask, val);
 
-	return 0;
+err_pm_put:
+	pm_runtime_put(cpu_dai->dev);
+
+	return ret;
 }
 
 static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
-- 
2.30.2

