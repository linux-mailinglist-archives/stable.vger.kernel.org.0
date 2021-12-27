Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA518480394
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhL0TER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbhL0TEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB488C06175B;
        Mon, 27 Dec 2021 11:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECFCF61162;
        Mon, 27 Dec 2021 19:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA0EC36AE7;
        Mon, 27 Dec 2021 19:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631846;
        bh=fuMYfb0IYmmBVxSL96C3xw8C5+KKXqJcSnJcZGylg0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tbearw7hXnu1vjih7N/hudI+0O0vbqEE+TT/Boit6pT/Df8rZbjFADQNR+R/ZYnZl
         rO0bhkSscz+2qz3x4m5AbuSiDClqtGlfMYRXiYCjQOIvv8OFgzU0okJVMWtU7P4KmI
         X4JWt9JQKouhLOBJnNteOoxakqSyC8tZ1gSTLypATU3CeFY2aoOSNUu+QesiAr7rhI
         QmNGxs3sLFKn7gvh7Sn3w2KLULqZ20cTYibV/cKzCyxyzNuV0DdnbulOlTKS7vvJUS
         ytuBLAcBDxaR6hz/fPVtZQqlGwn//JRet4iQ+uLnGc4KHBv7mzlakvvyCi3021fu1s
         wKeAQUIScIJog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 09/26] ASoC: rt5682: fix the wrong jack type detected
Date:   Mon, 27 Dec 2021 14:03:10 -0500
Message-Id: <20211227190327.1042326-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 8deb34a90f06374fd26f722c2a79e15160f66be7 ]

Some powers were changed during the jack insert detection
and clk's enable/disable in CCF.
If in parallel, the influence has a chance to detect
the wrong jack type, so add a lock.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20211214105033.471-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 5ac2b1444694d..757d1362b5f48 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -927,6 +927,8 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 	unsigned int val, count;
 
 	if (jack_insert) {
+		snd_soc_dapm_mutex_lock(dapm);
+
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_1,
 			RT5682_PWR_VREF2 | RT5682_PWR_MB,
 			RT5682_PWR_VREF2 | RT5682_PWR_MB);
@@ -973,6 +975,8 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		snd_soc_component_update_bits(component, RT5682_MICBIAS_2,
 			RT5682_PWR_CLK25M_MASK | RT5682_PWR_CLK1M_MASK,
 			RT5682_PWR_CLK25M_PU | RT5682_PWR_CLK1M_PU);
+
+		snd_soc_dapm_mutex_unlock(dapm);
 	} else {
 		rt5682_enable_push_button_irq(component, false);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
-- 
2.34.1

