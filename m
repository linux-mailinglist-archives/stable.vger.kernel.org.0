Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8C335BE6A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbhDLI6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238546AbhDLI42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445C461279;
        Mon, 12 Apr 2021 08:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217769;
        bh=3M81bUulRZ1OJ8K1jzIUjMAQrCb+nJsOaPN0EFVYXos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i79D2BNQO5MhVkkeuyzqcaIoU6wwDWbsIqJ1wXzdiImQ454WXKdeoFvAN8CWnMvIN
         XIL8wypSzwAO+XT+IPt0OlOJKaBfibI4ZU0xUT2YxwpiN1KjtWfcH1TO67mX7X8Yi+
         1TG1fd42Dlywfk+qhitlkkA8ui95MDpZ3NehJBjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/188] ASoC: wm8960: Fix wrong bclk and lrclk with pll enabled for some chips
Date:   Mon, 12 Apr 2021 10:40:17 +0200
Message-Id: <20210412084017.077179484@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index 660ec46eecf2..ceaf3bbb18e6 100644
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



