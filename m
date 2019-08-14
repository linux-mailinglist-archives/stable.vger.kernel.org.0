Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEBFE8C940
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfHNCMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbfHNCMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5CB42133F;
        Wed, 14 Aug 2019 02:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748752;
        bh=G/bm9sqvpxQSi87WzIc0dDnkfdLJB3LAYin9F0lnpWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2npYDljvVIKSnVDBJ9psrUtHSAUJa6w+Dn5mmtBLo/YQX+SOS3vMySaGWrWZuK4K
         WHtcv0FYZIkzqXtnXtP22Rg7k8SyVqFWMa8jESmDg3WZ191fkWxtiVJ85UbJuT7OaV
         0b3CbSBpKis3MJYELJTv31g5FBqM6CXsmKuZJKO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cheng-Yi Chiang <cychiang@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 047/123] ASoC: rockchip: Fix mono capture
Date:   Tue, 13 Aug 2019 22:09:31 -0400
Message-Id: <20190814021047.14828-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng-Yi Chiang <cychiang@chromium.org>

[ Upstream commit 789e162a6255325325bd321ab0cd51dc7e285054 ]

This reverts commit db51707b9c9aeedd310ebce60f15d5bb006567e0.
Revert "ASoC: rockchip: i2s: Support mono capture"

Previous discussion in

https://patchwork.kernel.org/patch/10147153/

explains the issue of the patch.
While device is configured as 1-ch, hardware is still
generating a 2-ch stream.
When user space reads the data and assumes it is a 1-ch stream,
the rate will be slower by 2x.

Revert the change so 1-ch is not supported.
User space can selectively take one channel data out of two channel
if 1-ch is preferred.
Currently, both channels record identical data.

Signed-off-by: Cheng-Yi Chiang <cychiang@chromium.org>
Link: https://lore.kernel.org/r/20190726044202.26866-1-cychiang@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 0a34d0eb8dba9..88ebaf6e1880a 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -326,7 +326,6 @@ static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
 		val |= I2S_CHN_4;
 		break;
 	case 2:
-	case 1:
 		val |= I2S_CHN_2;
 		break;
 	default:
@@ -459,7 +458,7 @@ static struct snd_soc_dai_driver rockchip_i2s_dai = {
 	},
 	.capture = {
 		.stream_name = "Capture",
-		.channels_min = 1,
+		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_192000,
 		.formats = (SNDRV_PCM_FMTBIT_S8 |
@@ -659,7 +658,7 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 	}
 
 	if (!of_property_read_u32(node, "rockchip,capture-channels", &val)) {
-		if (val >= 1 && val <= 8)
+		if (val >= 2 && val <= 8)
 			soc_dai->capture.channels_max = val;
 	}
 
-- 
2.20.1

