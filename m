Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5F455FDD
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfFZDmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfFZDmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:42:51 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A0B1208CB;
        Wed, 26 Jun 2019 03:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520570;
        bh=d2mos+JEfbQZ2N1S1mqLaKmvyRthD8wQuPYK08TlLjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxNqB5i0MeO+XvgRgzwxQyn2jipAvo/0an2DKWotdf8G1jEQsxo9oZDg0mtZu8P4v
         8r5UQRmqotMOfk9ARfmAjToMJoLOFTbHF9SGOCQh3s5pKCyH5gBC4DarIdjgxPiFw9
         bD1y+eBAR1NG+pDOWIApJEhjkdDXGjxVCGgqD9YA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 33/51] SoC: rt274: Fix internal jack assignment in set_jack callback
Date:   Tue, 25 Jun 2019 23:40:49 -0400
Message-Id: <20190626034117.23247-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
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
index adf59039a3b6..cdd312db3e78 100644
--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -405,6 +405,8 @@ static int rt274_mic_detect(struct snd_soc_component *component,
 {
 	struct rt274_priv *rt274 = snd_soc_component_get_drvdata(component);
 
+	rt274->jack = jack;
+
 	if (jack == NULL) {
 		/* Disable jack detection */
 		regmap_update_bits(rt274->regmap, RT274_EAPD_GPIO_IRQ_CTRL,
@@ -412,7 +414,6 @@ static int rt274_mic_detect(struct snd_soc_component *component,
 
 		return 0;
 	}
-	rt274->jack = jack;
 
 	regmap_update_bits(rt274->regmap, RT274_EAPD_GPIO_IRQ_CTRL,
 				RT274_IRQ_EN, RT274_IRQ_EN);
-- 
2.20.1

