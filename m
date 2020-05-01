Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F6E1C1429
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgEANgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730834AbgEANgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBA9724953;
        Fri,  1 May 2020 13:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340173;
        bh=2VDesztP2ROqSYYtOtZc+6miggIYCWfiwpKp5Wx5348=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OquBBcfw/zoh52OU6feCvt9ycaHwl6pFwMyxMN7Q3Xp3npeJEis1x3biATe3qjYax
         JY4QdBSYN0CW3wi0Ub0AC4gl+TW2auKAthDNVQQdTjdRE0ysdaW30CiFkU8/3CTpdA
         cze2dQsmUYg/fIKV/6tXOzu2N8NPjEzv9Rl12uyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 10/46] ASoC: wm8960: Fix wrong clock after suspend & resume
Date:   Fri,  1 May 2020 15:22:35 +0200
Message-Id: <20200501131502.636315379@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 1e060a453c8604311fb45ae2f84f67ed673329b4 upstream.

After suspend & resume, wm8960_hw_params may be called when
bias_level is not SND_SOC_BIAS_ON, then wm8960_configure_clocking
is not called. But if sample rate is changed at that time, then
the output clock rate will be not correct.

So judgement of bias_level is SND_SOC_BIAS_ON in wm8960_hw_params
is not necessary and it causes above issue.

Fixes: 3176bf2d7ccd ("ASoC: wm8960: update pll and clock setting function")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/1587468525-27514-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8960.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -863,8 +863,7 @@ static int wm8960_hw_params(struct snd_p
 
 	wm8960->is_stream_in_use[tx] = true;
 
-	if (snd_soc_component_get_bias_level(component) == SND_SOC_BIAS_ON &&
-	    !wm8960->is_stream_in_use[!tx])
+	if (!wm8960->is_stream_in_use[!tx])
 		return wm8960_configure_clocking(component);
 
 	return 0;


