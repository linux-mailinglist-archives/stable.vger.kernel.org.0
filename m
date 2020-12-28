Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AB42E40AA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441345AbgL1ORF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439596AbgL1ORD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC9021D94;
        Mon, 28 Dec 2020 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164983;
        bh=w4YmsWXHjdQPGZvq3Q0Eia9vzReOyT6SGDhhpyVpUww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4b5E7KeLODPE+kQWun1KmNPbavN0Q2b4TZ6R9+9cOSnyzXcv1VAJmEmjooIUiznR
         oMwFiDK4A+zJQdsOOW0LQIdJ/wB0Fow0CZmp7r4xQt4JKFBCDNn784XFOROUaNRemq
         F8+Wot23VqNnsuLjr7eVl7pbMf1a2GXnYCyasGow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/717] ASoC: amd: change clk_get() to devm_clk_get() and add missed checks
Date:   Mon, 28 Dec 2020 13:46:06 +0100
Message-Id: <20201228125038.638623156@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 95d3befbc5e1ee39fc8a78713924cf7ed2b3cabe ]

cz_da7219_init() does not check the return values of clk_get(),
while da7219_clk_enable() calls clk_set_rate() to dereference
the pointers.
Add checks to fix the problems.
Also, change clk_get() to devm_clk_get() to avoid data leak after
failures.

Fixes: bb24a31ed584 ("ASoC: AMD: Configure wclk and bclk of master codec")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20201204063610.513556-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-da7219-max98357a.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/amd/acp-da7219-max98357a.c b/sound/soc/amd/acp-da7219-max98357a.c
index a7702e64ec512..849288d01c6b4 100644
--- a/sound/soc/amd/acp-da7219-max98357a.c
+++ b/sound/soc/amd/acp-da7219-max98357a.c
@@ -73,8 +73,13 @@ static int cz_da7219_init(struct snd_soc_pcm_runtime *rtd)
 		return ret;
 	}
 
-	da7219_dai_wclk = clk_get(component->dev, "da7219-dai-wclk");
-	da7219_dai_bclk = clk_get(component->dev, "da7219-dai-bclk");
+	da7219_dai_wclk = devm_clk_get(component->dev, "da7219-dai-wclk");
+	if (IS_ERR(da7219_dai_wclk))
+		return PTR_ERR(da7219_dai_wclk);
+
+	da7219_dai_bclk = devm_clk_get(component->dev, "da7219-dai-bclk");
+	if (IS_ERR(da7219_dai_bclk))
+		return PTR_ERR(da7219_dai_bclk);
 
 	ret = snd_soc_card_jack_new(card, "Headset Jack",
 				SND_JACK_HEADSET | SND_JACK_LINEOUT |
-- 
2.27.0



