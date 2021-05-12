Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7B837C630
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbhELPtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233629AbhELPnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:43:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A069611AD;
        Wed, 12 May 2021 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832932;
        bh=mziV3u7iRHMD1USzQx3wGZmMRtT/RfJGFzlXuai53fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vz26UzlXnryPF3fC1cHR113jZ10oLsPJF3Tc9zWmp/DX4vacyLR7LlZPHeciU4Iys
         9W4nwfzdPD6Y+BGHaUAMhAZlsybuENu4ZT3Phrrg5uSFG4ECgPNhSbWSAV0bNYaMWA
         +vEsT8EBDJptQMhusKKnTVyurASjuRx1d9YXWuhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 446/530] ASoC: ak5558: correct reset polarity
Date:   Wed, 12 May 2021 16:49:16 +0200
Message-Id: <20210512144834.430287633@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 0b93bbc977af55fd10687f2c96c807cba95cb927 ]

Reset (aka power off) happens when the reset gpio is made active.
The reset gpio is GPIO_ACTIVE_LOW

Fixes: 920884777480 ("ASoC: ak5558: Add support for AK5558 ADC driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1618382024-31725-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak5558.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak5558.c b/sound/soc/codecs/ak5558.c
index 65a248c92f66..adbdfdbc7a38 100644
--- a/sound/soc/codecs/ak5558.c
+++ b/sound/soc/codecs/ak5558.c
@@ -272,7 +272,7 @@ static void ak5558_power_off(struct ak5558_priv *ak5558)
 	if (!ak5558->reset_gpiod)
 		return;
 
-	gpiod_set_value_cansleep(ak5558->reset_gpiod, 0);
+	gpiod_set_value_cansleep(ak5558->reset_gpiod, 1);
 	usleep_range(1000, 2000);
 }
 
@@ -281,7 +281,7 @@ static void ak5558_power_on(struct ak5558_priv *ak5558)
 	if (!ak5558->reset_gpiod)
 		return;
 
-	gpiod_set_value_cansleep(ak5558->reset_gpiod, 1);
+	gpiod_set_value_cansleep(ak5558->reset_gpiod, 0);
 	usleep_range(1000, 2000);
 }
 
-- 
2.30.2



