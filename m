Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DBB2E3B62
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406138AbgL1Nt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404792AbgL1Nt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E8DE20791;
        Mon, 28 Dec 2020 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163326;
        bh=6o3XupmLAtC3tpGC443htSCvpFxQJu7C/2yQnxxqyLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdiezY7A7AwCnzvMcK7rUBLPDxv/h5R+Yud6fqkqLBFwrOSDFvYIGOiBBRsVLYlZY
         +Hql9nFt2RvNe5dtREc56F/EoOK6imWmZRQbqXz8oIeASxHQb3wICWPgF6k55np+yO
         BCf42uoNTLgEKEQPjSQVbT1HIpFs0ENdf2Cs/MYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 248/453] ASoC: amd: change clk_get() to devm_clk_get() and add missed checks
Date:   Mon, 28 Dec 2020 13:48:04 +0100
Message-Id: <20201228124949.161693753@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index f4ee6798154af..1612ec65aaf66 100644
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



