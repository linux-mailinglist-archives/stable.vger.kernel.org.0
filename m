Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2837CD8A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245320AbhELQ4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243978AbhELQmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB1BD61CFA;
        Wed, 12 May 2021 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835749;
        bh=rXi98K+zzR9BBFgdVcDkydb4VQ4PO4oKUkprf8JqGnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEc+yfjRhXvfh+fRtacR3f1aR4qDOs8OMfe/wgm7opn+15eeeJE2f87URgt3ndfDR
         2wZeXkO1qw5zDzcjiVLeippjD2QxzGjm19xBflZmooGzx3HwPfjRBmqo92L72SFwZn
         IXnYvOhQs++8QVP0PwUbl9fumT70b+sxdQEvcO2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 469/677] ASoC: wm8960: Remove bitclk relax condition in wm8960_configure_sysclk
Date:   Wed, 12 May 2021 16:48:35 +0200
Message-Id: <20210512144852.943117647@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 99067c07e8d877035f6249d194a317c78b7d052d ]

The call sequence in wm8960_configure_clocking is

   ret = wm8960_configure_sysclk();
   if (ret >= 0)
        goto configure_clock;

   ....

   ret = wm8960_configure_pll();

configure_clock:
   ...

wm8960_configure_sysclk is called before wm8960_configure_pll, as
there is bitclk relax on both functions, so wm8960_configure_sysclk
always return success, then wm8960_configure_pll() never be called.

With this case:
aplay -Dhw:0,0 -d 5 -r 48000 -f S24_LE -c 2 audio48k24b2c.wav
the required bitclk is 48000 * 24 * 2 = 2304000, bitclk got from
wm8960_configure_sysclk is 3072000, but if go to wm8960_configure_pll.
it can get correct bitclk 2304000.

So bitclk relax condition should be removed in wm8960_configure_sysclk,
then wm8960_configure_pll can be called, and there is also bitclk relax
function in wm8960_configure_pll.

Fixes: 3c01b9ee2ab9 ("ASoC: codec: wm8960: Relax bit clock computation")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/1614740862-30196-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8960.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index cda9cd935d4f..9e621a254392 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -608,10 +608,6 @@ static const int bclk_divs[] = {
  *		- lrclk      = sysclk / dac_divs
  *		- 10 * bclk  = sysclk / bclk_divs
  *
- *	If we cannot find an exact match for (sysclk, lrclk, bclk)
- *	triplet, we relax the bclk such that bclk is chosen as the
- *	closest available frequency greater than expected bclk.
- *
  * @wm8960: codec private data
  * @mclk: MCLK used to derive sysclk
  * @sysclk_idx: sysclk_divs index for found sysclk
@@ -629,7 +625,7 @@ int wm8960_configure_sysclk(struct wm8960_priv *wm8960, int mclk,
 {
 	int sysclk, bclk, lrclk;
 	int i, j, k;
-	int diff, closest = mclk;
+	int diff;
 
 	/* marker for no match */
 	*bclk_idx = -1;
@@ -653,12 +649,6 @@ int wm8960_configure_sysclk(struct wm8960_priv *wm8960, int mclk,
 					*bclk_idx = k;
 					break;
 				}
-				if (diff > 0 && closest > diff) {
-					*sysclk_idx = i;
-					*dac_idx = j;
-					*bclk_idx = k;
-					closest = diff;
-				}
 			}
 			if (k != ARRAY_SIZE(bclk_divs))
 				break;
-- 
2.30.2



