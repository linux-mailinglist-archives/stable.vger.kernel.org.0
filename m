Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE7D3A8491
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhFOPvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhFOPvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B047615A0;
        Tue, 15 Jun 2021 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772129;
        bh=t09JVjnirc/tT6RKQHIthuXYKpJL3aQ83GPx+34JfW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5qPmPGXRzyyiRSNbEfm7YlxQAyxZxWcan3mVFHKRiFfzHSTgun4npsZKGeIbB4ox
         Tz00YENllnsCEmbh68Nwmfsq6G4QzVP6f0UcjAatjIEO3WADYsctSnDsCDhbFUIotT
         7wlSAmAlCOvqTNyW7Pq11RGyhPBDRK/ZsmVhEoycLCp9jvzJOw9xTWMR4qvubUibio
         bX4Z2zpdRQoHW2oM/oS4EW4mRvNtk1bPPB0VNb8r2/lmOH58ydzYp26Weg6IR8HASP
         iOHyXAbjBAThMww8y0KhMg1UEsMPyHbs9KGdfjSD9f/liBWs3U/dTsl7fGGCsFRAuY
         fN6+A6uWhweHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oder Chiou <oder_chiou@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 20/33] ASoC: rt5682: Fix the fast discharge for headset unplugging in soundwire mode
Date:   Tue, 15 Jun 2021 11:48:11 -0400
Message-Id: <20210615154824.62044-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 49783c6f4a4f49836b5a109ae0daf2f90b0d7713 ]

Based on ("5a15cd7fce20b1fd4aece6a0240e2b58cd6a225d"), the setting also
should be set in soundwire mode.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://lore.kernel.org/r/20210604063150.29925-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index b49f1e16125d..d1dd7f720ba4 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -462,7 +462,8 @@ static int rt5682_io_init(struct device *dev, struct sdw_slave *slave)
 
 	regmap_update_bits(rt5682->regmap, RT5682_CBJ_CTRL_2,
 		RT5682_EXT_JD_SRC, RT5682_EXT_JD_SRC_MANUAL);
-	regmap_write(rt5682->regmap, RT5682_CBJ_CTRL_1, 0xd042);
+	regmap_write(rt5682->regmap, RT5682_CBJ_CTRL_1, 0xd142);
+	regmap_update_bits(rt5682->regmap, RT5682_CBJ_CTRL_5, 0x0700, 0x0600);
 	regmap_update_bits(rt5682->regmap, RT5682_CBJ_CTRL_3,
 		RT5682_CBJ_IN_BUF_EN, RT5682_CBJ_IN_BUF_EN);
 	regmap_update_bits(rt5682->regmap, RT5682_SAR_IL_CMD_1,
-- 
2.30.2

