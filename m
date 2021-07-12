Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4033C5566
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355660AbhGLIKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353613AbhGLICh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA1261CE6;
        Mon, 12 Jul 2021 07:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076557;
        bh=ehRpfKfH7BBIv3Z8i4w+1TvsMGvFDTXLdyXaaUQSr+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQALmorJ88y7MR0efC+Yzs6qZrtMr/bgnRThwXAUfV1E6bLd1lnJ036ZzkQ9Ohdy3
         uGHIFlcwqmbCun4pXvzdJO5NUodgJBI48m4vuRiCCAe+ZWjOFozYLoak3zbFXPxL2j
         DXQ2qnaACv73Q0uZaZQH7YIBzh8iP+2axF8lJtQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Yu <jack.yu@realtek.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 693/800] ASoC: rt715-sdca: fix clock stop prepare timeout issue
Date:   Mon, 12 Jul 2021 08:11:56 +0200
Message-Id: <20210712061040.564835763@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit e343d34a9c912fc5c321e2a9fbc02e9dc9534ade ]

Fix clock stop prepare timeout issue (#2853).
The trigger of internal circuit which belong to
“SDCA preset stuffs” was not set correctly in previous driver,
which could block clock_stop_preparation state.
Add the correct register setting to fix it.

Fixes: 20d17057f0a8c ('ASoC: rt715-sdca: Add RT715 sdca vendor-specific driver')
Signed-off-by: Jack Yu <jack.yu@realtek.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-12-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdca-sdw.c | 1 +
 sound/soc/codecs/rt715-sdca-sdw.h | 1 +
 sound/soc/codecs/rt715-sdca.c     | 3 +++
 sound/soc/codecs/rt715-sdca.h     | 1 +
 4 files changed, 6 insertions(+)

diff --git a/sound/soc/codecs/rt715-sdca-sdw.c b/sound/soc/codecs/rt715-sdca-sdw.c
index 7646bbe739f1..a5c673f43d82 100644
--- a/sound/soc/codecs/rt715-sdca-sdw.c
+++ b/sound/soc/codecs/rt715-sdca-sdw.c
@@ -70,6 +70,7 @@ static bool rt715_sdca_mbq_readable_register(struct device *dev, unsigned int re
 	case 0x2000036:
 	case 0x2000037:
 	case 0x2000039:
+	case 0x2000044:
 	case 0x6100000:
 		return true;
 	default:
diff --git a/sound/soc/codecs/rt715-sdca-sdw.h b/sound/soc/codecs/rt715-sdca-sdw.h
index cd365bb60747..0cbc14844f8c 100644
--- a/sound/soc/codecs/rt715-sdca-sdw.h
+++ b/sound/soc/codecs/rt715-sdca-sdw.h
@@ -113,6 +113,7 @@ static const struct reg_default rt715_mbq_reg_defaults_sdca[] = {
 	{ 0x2000036, 0x0000 },
 	{ 0x2000037, 0x0000 },
 	{ 0x2000039, 0xaa81 },
+	{ 0x2000044, 0x0202 },
 	{ 0x6100000, 0x0100 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_ADC8_9_VOL,
 		RT715_SDCA_FU_VOL_CTRL, CH_01), 0x00 },
diff --git a/sound/soc/codecs/rt715-sdca.c b/sound/soc/codecs/rt715-sdca.c
index d82166f1a378..66e166568c50 100644
--- a/sound/soc/codecs/rt715-sdca.c
+++ b/sound/soc/codecs/rt715-sdca.c
@@ -1054,6 +1054,9 @@ int rt715_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 		rt715_sdca_index_update_bits(rt715, RT715_VENDOR_REG,
 			RT715_REV_1, 0x40, 0x40);
 	}
+	/* DFLL Calibration trigger */
+	rt715_sdca_index_update_bits(rt715, RT715_VENDOR_REG,
+			RT715_DFLL_VAD, 0x1, 0x1);
 	/* trigger mode = VAD enable */
 	regmap_write(rt715->regmap,
 		SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_SMPU_TRIG_ST_EN,
diff --git a/sound/soc/codecs/rt715-sdca.h b/sound/soc/codecs/rt715-sdca.h
index 0c1fdd5bc7ca..90881b455ece 100644
--- a/sound/soc/codecs/rt715-sdca.h
+++ b/sound/soc/codecs/rt715-sdca.h
@@ -81,6 +81,7 @@ struct rt715_sdca_kcontrol_private {
 #define RT715_AD_FUNC_EN				0x36
 #define RT715_REV_1					0x37
 #define RT715_SDW_INPUT_SEL				0x39
+#define RT715_DFLL_VAD					0x44
 #define RT715_EXT_DMIC_CLK_CTRL2			0x54
 
 /* Index (NID:61h) */
-- 
2.30.2



