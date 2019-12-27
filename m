Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE4D12B8FD
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfL0RlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfL0RlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4252920740;
        Fri, 27 Dec 2019 17:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468464;
        bh=8enxHMK2nvjtUxxiMArkW5O/ABTFF34FRJEr3tTpn64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwLkGPJWR51QZoANdYZzqF0V4XSGODslCKQyDyNb1X3kBgks93ceDcgFD6+K4sKkL
         PLWrcynDWauLXFsqci9CYA5Fo+IIW6Kw8P3lo82rJZVr8gq7L4Y6ryZgWaVzhpV4W0
         HpuXuJPx+Lneg9C2OvKU10Owz8jM2K4LT/PCUMhU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 006/187] ASoC: max98090: exit workaround earlier if PLL is locked
Date:   Fri, 27 Dec 2019 12:37:54 -0500
Message-Id: <20191227174055.4923-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 6f49919d11690a9b5614445ba30fde18083fdd63 ]

According to the datasheet, PLL lock time typically takes 2 msec and
at most takes 7 msec.

Check the lock status every 1 msec and exit the workaround if PLL is
locked.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20191122073114.219945-3-tzungbi@google.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 12cb87c0d463..f531e5a11bdd 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2108,6 +2108,8 @@ static void max98090_pll_work(struct work_struct *work)
 	struct max98090_priv *max98090 =
 		container_of(work, struct max98090_priv, pll_work);
 	struct snd_soc_component *component = max98090->component;
+	unsigned int pll;
+	int i;
 
 	if (!snd_soc_component_is_active(component))
 		return;
@@ -2127,8 +2129,16 @@ static void max98090_pll_work(struct work_struct *work)
 	snd_soc_component_update_bits(component, M98090_REG_DEVICE_SHUTDOWN,
 			    M98090_SHDNN_MASK, M98090_SHDNN_MASK);
 
-	/* Give PLL time to lock */
-	msleep(10);
+	for (i = 0; i < 10; ++i) {
+		/* Give PLL time to lock */
+		usleep_range(1000, 1200);
+
+		/* Check lock status */
+		pll = snd_soc_component_read32(
+				component, M98090_REG_DEVICE_STATUS);
+		if (!(pll & M98090_ULK_MASK))
+			break;
+	}
 }
 
 static void max98090_jack_work(struct work_struct *work)
-- 
2.20.1

