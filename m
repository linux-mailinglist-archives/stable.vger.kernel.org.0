Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA63ED5E7
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239383AbhHPNPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239763AbhHPNOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00AFD632A6;
        Mon, 16 Aug 2021 13:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119485;
        bh=tJxGGleBcbwFGf5JhTliPn7y6Vgz9a2kMMcdLXH8eAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MVmpgxobH6af0i0rClrpU7zbTN73TgrCO9kSWnoZ/+xuEYNbLXG/MBfu10GUjOAZ
         Hoj2IVcc8CkoTeIRz6eEO/0BOY+sUuegx3AnulZjMDSbVSztKG9+N1EFveOWhRi6Rn
         7FpHxo6tWzDP34TFkNCgcB+6aGS1llmteeClTudI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 044/151] ASoC: cs42l42: Dont allow SND_SOC_DAIFMT_LEFT_J
Date:   Mon, 16 Aug 2021 15:01:14 +0200
Message-Id: <20210816125445.521455939@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 64324bac750b84ca54711fb7d332132fcdb87293 ]

The driver has no support for left-justified protocol so it should
not have been allowing this to be passed to cs42l42_set_dai_fmt().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20210729170929.6589-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 3956912e23ac..0d31c84b0445 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -778,7 +778,6 @@ static int cs42l42_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-	case SND_SOC_DAIFMT_LEFT_J:
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2



