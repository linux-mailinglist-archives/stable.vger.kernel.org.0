Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA64A56065
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfFZDpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbfFZDpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:45:45 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7882082F;
        Wed, 26 Jun 2019 03:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520744;
        bh=odmqd7N0vyTbULHtnRfBWJqYVpmDph2GFtV1HpPQYlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiT1EYZUPzK6G/WgcLPn7TVYjCVHvyLcz6/ofsfZ/+ygrAmSJa8K3plZ0rhMCoks2
         3H/nzsEqvLDqzarCSYKjS/W//1ux/TXPpQtF7Y7ILaDRRwZGLEkvg0uVHy++IR3lQA
         zTv5TzUucEYjKs6TiZ5yBTJvHv24VjXxpeO7QlI0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 14/21] SoC: rt274: Fix internal jack assignment in set_jack callback
Date:   Tue, 25 Jun 2019 23:44:59 -0400
Message-Id: <20190626034506.24125-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034506.24125-1-sashal@kernel.org>
References: <20190626034506.24125-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 04268bf2757a125616b6c2140e6250f43b7b737a ]

When we call snd_soc_component_set_jack(component, NULL, NULL) we should
set rt274->jack to passed jack, so when interrupt is triggered it calls
snd_soc_jack_report(rt274->jack, ...) with proper value.

This fixes problem in machine where in register, we call
snd_soc_register(component, &headset, NULL), which just calls
rt274_mic_detect via callback.
Now when machine driver is removed "headset" will be gone, so we
need to tell codec driver that it's gone with:
snd_soc_register(component, NULL, NULL), but we also need to be able
to handle NULL jack argument here gracefully.
If we don't set it to NULL, next time the rt274_irq runs it will call
snd_soc_jack_report with first argument being invalid pointer and there
will be Oops.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt274.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt274.c b/sound/soc/codecs/rt274.c
index cd048df76232..43086ac9ffec 100644
--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -398,6 +398,8 @@ static int rt274_mic_detect(struct snd_soc_codec *codec,
 {
 	struct rt274_priv *rt274 = snd_soc_codec_get_drvdata(codec);
 
+	rt274->jack = jack;
+
 	if (jack == NULL) {
 		/* Disable jack detection */
 		regmap_update_bits(rt274->regmap, RT274_EAPD_GPIO_IRQ_CTRL,
@@ -405,7 +407,6 @@ static int rt274_mic_detect(struct snd_soc_codec *codec,
 
 		return 0;
 	}
-	rt274->jack = jack;
 
 	regmap_update_bits(rt274->regmap, RT274_EAPD_GPIO_IRQ_CTRL,
 				RT274_IRQ_EN, RT274_IRQ_EN);
-- 
2.20.1

