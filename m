Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D94D462771
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbhK2XFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbhK2XFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D1BC1A1960;
        Mon, 29 Nov 2021 10:37:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD14EB815DD;
        Mon, 29 Nov 2021 18:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064D4C53FC7;
        Mon, 29 Nov 2021 18:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211042;
        bh=whD1537B5Z1ojwLblZZJ3InBWYpILqmISDqRoZ27ZSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2pkHPB8haQzDzciqgCHQzzy3jsaEsvCZCt+eNBuUul/x1rTq1rBQZu4i5bMkLSAA
         cLuw8u9b+eLHWaWL/ufR0zzilmAIIeKingToaOdI95BVedeq5+08dGSNz99LJZ0NhL
         nNG4tAFequgQxmv7irlbySbWq3tME51/Yc9akYIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/179] ASoC: stm32: i2s: fix 32 bits channel length without mclk
Date:   Mon, 29 Nov 2021 19:17:57 +0100
Message-Id: <20211129181721.670611949@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 424fe7edbed18d47f7b97f7e1322a6f8969b77ae ]

Fix divider calculation in the case of 32 bits channel
configuration, when no master clock is used.

Fixes: e4e6ec7b127c ("ASoC: stm32: Add I2S driver")

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20211117104404.3832-1-olivier.moysan@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 6254bacad6eb7..717f45a83445c 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -700,7 +700,7 @@ static int stm32_i2s_configure_clock(struct snd_soc_dai *cpu_dai,
 		if (ret < 0)
 			return ret;
 
-		nb_bits = frame_len * ((cgfr & I2S_CGFR_CHLEN) + 1);
+		nb_bits = frame_len * (FIELD_GET(I2S_CGFR_CHLEN, cgfr) + 1);
 		ret = stm32_i2s_calc_clk_div(i2s, i2s_clock_rate,
 					     (nb_bits * rate));
 		if (ret)
-- 
2.33.0



