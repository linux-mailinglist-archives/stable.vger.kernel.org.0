Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB737C554
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhELPje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234523AbhELPdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:33:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC96B6197C;
        Wed, 12 May 2021 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832610;
        bh=vFwL//8IAML3PrJBbsuFnqiU1cS8K89YUhP45vQsHaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyqNbZWELHhoDVg1E5zvcXBkI8Kwc5JK6LTqxUk2/Qb5dqR4GRY7+1BZEUBKc5nAh
         dYjQDgfZhf6uu8G/1/SR7ahrRslExagri+MZJjrq3sd0e7gMMtIx7smjgyzM9a2evp
         jqOqdz46wYLClE4vpCTC+HHfQjerRjRxcpmIOLNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/530] ASoC: Intel: boards: sof-wm8804: add check for PLL setting
Date:   Wed, 12 May 2021 16:47:40 +0200
Message-Id: <20210512144831.285651293@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 1730ef62874dbdc53dc2abfa430f09f0b304bafc ]

Currently the return from snd_soc_dai_set_pll is not checking for
failure, this is the only driver in the kernel that ignores this,
so it probably should be added for sake of completeness.  Fix this
by adding an error return check.

Addresses-Coverity: ("Unchecked return value")
Fixes: f139546fb7d4 ("ASoC: Intel: boards: sof-wm8804: support for Hifiberry Digiplus boards")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210226185653.1071321-1-colin.king@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_wm8804.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_wm8804.c b/sound/soc/intel/boards/sof_wm8804.c
index a46ba13e8eb0..6a181e45143d 100644
--- a/sound/soc/intel/boards/sof_wm8804.c
+++ b/sound/soc/intel/boards/sof_wm8804.c
@@ -124,7 +124,11 @@ static int sof_wm8804_hw_params(struct snd_pcm_substream *substream,
 	}
 
 	snd_soc_dai_set_clkdiv(codec_dai, WM8804_MCLK_DIV, mclk_div);
-	snd_soc_dai_set_pll(codec_dai, 0, 0, sysclk, mclk_freq);
+	ret = snd_soc_dai_set_pll(codec_dai, 0, 0, sysclk, mclk_freq);
+	if (ret < 0) {
+		dev_err(rtd->card->dev, "Failed to set WM8804 PLL\n");
+		return ret;
+	}
 
 	ret = snd_soc_dai_set_sysclk(codec_dai, WM8804_TX_CLKSRC_PLL,
 				     sysclk, SND_SOC_CLOCK_OUT);
-- 
2.30.2



