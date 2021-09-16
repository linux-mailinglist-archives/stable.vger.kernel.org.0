Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B840E7F5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349963AbhIPRn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354328AbhIPRjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4938063240;
        Thu, 16 Sep 2021 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811040;
        bh=7znTvPL8pBcDv4O+L3rPJsoXndPJdGh5ym7doU5Uw0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6P7dewjOLPAMoEAw64yG75xnzjHFf0n434rfutCK/1xkywYYpfKxUVLQ6t95GSEp
         xhZE7ELe2+ZdLGXtaHPYE4hkZTjuyMG7yvkt71SkB8hkITcv+wY5wh1UHAie59E42T
         dugnPKqnIB46ZpOJr8cKk15hqLKzYGb1ggMbpSco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaotan Luo <lxt@rock-chips.com>,
        Sugar Zhang <sugar.zhang@rock-chips.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 361/432] ASoC: rockchip: i2s: Fixup config for DAIFMT_DSP_A/B
Date:   Thu, 16 Sep 2021 18:01:50 +0200
Message-Id: <20210916155823.042816397@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1fd47e56c77f..b65dfbc3545b 100644
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



