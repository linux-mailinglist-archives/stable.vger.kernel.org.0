Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CCA35BD64
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbhDLIvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238030AbhDLItE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D460D61286;
        Mon, 12 Apr 2021 08:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217280;
        bh=9g/bVRJ1aoldgEKD3LoXYipmQ7cfIU+mi+YDdBADxgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYqRbk1ZymRhOqa2deqYyxgONKlCb9vu+7sg7ilMFzdHJD2ApTvSXAoUXryb4MySX
         9PMJog+rrfSZA+nxI/gIG2w0Pv7RR75Bz5WWqr0QYLwx2UWp/YKOYtLPLUT/Vco0uY
         BxMRXkAjaMty5/G8aAj3yoapfYlM8cSCh8rEPWzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/111] ASoC: wm8960: Fix wrong bclk and lrclk with pll enabled for some chips
Date:   Mon, 12 Apr 2021 10:40:29 +0200
Message-Id: <20210412084005.963420648@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 16b82e75c15a7dbd564ea3654f3feb61df9e1e6f ]

The input MCLK is 12.288MHz, the desired output sysclk is 11.2896MHz
and sample rate is 44100Hz, with the configuration pllprescale=2,
postscale=sysclkdiv=1, some chip may have wrong bclk
and lrclk output with pll enabled in master mode, but with the
configuration pllprescale=1, postscale=2, the output clock is correct.

>From Datasheet, the PLL performs best when f2 is between
90MHz and 100MHz when the desired sysclk output is 11.2896MHz
or 12.288MHz, so sysclkdiv = 2 (f2/8) is the best choice.

So search available sysclk_divs from 2 to 1 other than from 1 to 2.

Fixes: 84fdc00d519f ("ASoC: codec: wm9860: Refactor PLL out freq search")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/1616150926-22892-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8960.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 6cf0f6612bda..708fc4ed54ed 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -707,7 +707,13 @@ int wm8960_configure_pll(struct snd_soc_component *component, int freq_in,
 	best_freq_out = -EINVAL;
 	*sysclk_idx = *dac_idx = *bclk_idx = -1;
 
-	for (i = 0; i < ARRAY_SIZE(sysclk_divs); ++i) {
+	/*
+	 * From Datasheet, the PLL performs best when f2 is between
+	 * 90MHz and 100MHz, the desired sysclk output is 11.2896MHz
+	 * or 12.288MHz, then sysclkdiv = 2 is the best choice.
+	 * So search sysclk_divs from 2 to 1 other than from 1 to 2.
+	 */
+	for (i = ARRAY_SIZE(sysclk_divs) - 1; i >= 0; --i) {
 		if (sysclk_divs[i] == -1)
 			continue;
 		for (j = 0; j < ARRAY_SIZE(dac_divs); ++j) {
-- 
2.30.2



