Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC6440525D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354311AbhIIMnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353621AbhIIMjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:39:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9B7561BE1;
        Thu,  9 Sep 2021 11:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188481;
        bh=U2Xdfcl5vcq/srV+eQa0soW0VkO6ChXX7XPzMXxIDQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOnhLeCext6TYpFU9ptx4aHzo518BxcsF39dp6Y43+PtJpE4zfC+jNrA8bVoXh4db
         hClezngyfjluScXW+eQFW1cX/sV8/NOgjbtlSOS6t3QZ2w4vWoMzv/26VD57Y3Tgz9
         GRJJAl76nBVjlUc5iphGViGt4rI2AD7UfHPb2Vb/W/lWHle1U4u2iIK50iFWB8uXXl
         k6H8fJh4t2DgkzuV+IBc/GNKlLFVwuQ/QMvPy8ME88eNeGntytbwEcdXcQ6UeaLdWA
         8ygOxGmhFtx5kjKw7kZ+CDlthMnW6swjyyUPfBY5AWfgsAjs4myzawf9ToDsuoKTU9
         mzHLI/3WTt+lA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaotan Luo <lxt@rock-chips.com>,
        Sugar Zhang <sugar.zhang@rock-chips.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 157/176] ASoC: rockchip: i2s: Fixup config for DAIFMT_DSP_A/B
Date:   Thu,  9 Sep 2021 07:50:59 -0400
Message-Id: <20210909115118.146181-157-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaotan Luo <lxt@rock-chips.com>

[ Upstream commit 1bf56843e664eef2525bdbfae6a561e98910f676 ]

- DSP_A: PCM delay 1 bit mode, L data MSB after FRM LRC
- DSP_B: PCM no delay mode, L data MSB during FRM LRC

Signed-off-by: Xiaotan Luo <lxt@rock-chips.com>
Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Link: https://lore.kernel.org/r/1629950562-14281-3-git-send-email-sugar.zhang@rock-chips.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 43522d7701e9..fa84ec695b52 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -233,12 +233,12 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	case SND_SOC_DAIFMT_I2S:
 		val = I2S_TXCR_IBM_NORMAL;
 		break;
-	case SND_SOC_DAIFMT_DSP_A: /* PCM no delay mode */
-		val = I2S_TXCR_TFS_PCM;
-		break;
-	case SND_SOC_DAIFMT_DSP_B: /* PCM delay 1 mode */
+	case SND_SOC_DAIFMT_DSP_A: /* PCM delay 1 bit mode */
 		val = I2S_TXCR_TFS_PCM | I2S_TXCR_PBM_MODE(1);
 		break;
+	case SND_SOC_DAIFMT_DSP_B: /* PCM no delay mode */
+		val = I2S_TXCR_TFS_PCM;
+		break;
 	default:
 		ret = -EINVAL;
 		goto err_pm_put;
@@ -257,12 +257,12 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	case SND_SOC_DAIFMT_I2S:
 		val = I2S_RXCR_IBM_NORMAL;
 		break;
-	case SND_SOC_DAIFMT_DSP_A: /* PCM no delay mode */
-		val = I2S_RXCR_TFS_PCM;
-		break;
-	case SND_SOC_DAIFMT_DSP_B: /* PCM delay 1 mode */
+	case SND_SOC_DAIFMT_DSP_A: /* PCM delay 1 bit mode */
 		val = I2S_RXCR_TFS_PCM | I2S_RXCR_PBM_MODE(1);
 		break;
+	case SND_SOC_DAIFMT_DSP_B: /* PCM no delay mode */
+		val = I2S_RXCR_TFS_PCM;
+		break;
 	default:
 		ret = -EINVAL;
 		goto err_pm_put;
-- 
2.30.2

