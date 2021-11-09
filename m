Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F7B44B5B1
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343492AbhKIWWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236159AbhKIWUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 985CD61881;
        Tue,  9 Nov 2021 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496278;
        bh=bjPXB5HH1GtIMshiC2IBO4Pln2KOJyhpk465bQoQ92w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayaUmjoyzxm5pgETBYilkWZRSomnrY9+0LuEZ8TrC9rXvSuBg/Kd0+02rfeyoajLM
         Pk3QXGLuSa2LyokuGE2Hpgr6tNjD9aQTzk4e8cdNR7GQbz9XQs05CNxquTybuyw7tA
         As07Ig1G80/L4fX0NtHwX4ygRjKwKx1JPj9iPhopSnz5DkujAtBurm9DULjRADv2Ns
         DvKr3DbJaV0RJWCfm+402Xp6hLljqMNlzmvOdj78fVAMdHYhWqJ8isg4fGj7y6XuMJ
         fI+YNB1+qSwCI8kL6oqX6ocdpYESI4Jo16G2rAir8aknDrcqYybTGeimdqkmrgH7Y4
         ByPY/mHtQnphg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 40/82] ASoC: es8316: Use IRQF_NO_AUTOEN when requesting the IRQ
Date:   Tue,  9 Nov 2021 17:15:58 -0500
Message-Id: <20211109221641.1233217-40-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1cf2aa665901054b140eb71748661ceae99b6b5a ]

Use the new IRQF_NO_AUTOEN flag when requesting the IRQ, rather then
disabling it immediately after requesting it.

This fixes a possible race where the IRQ might trigger between requesting
and disabling it; and this also leads to a small code cleanup.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211003132255.31743-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index 067757d1d70a3..5fb02635c1406 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -811,12 +811,9 @@ static int es8316_i2c_probe(struct i2c_client *i2c_client,
 	mutex_init(&es8316->lock);
 
 	ret = devm_request_threaded_irq(dev, es8316->irq, NULL, es8316_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_TRIGGER_HIGH | IRQF_ONESHOT | IRQF_NO_AUTOEN,
 					"es8316", es8316);
-	if (ret == 0) {
-		/* Gets re-enabled by es8316_set_jack() */
-		disable_irq(es8316->irq);
-	} else {
+	if (ret) {
 		dev_warn(dev, "Failed to get IRQ %d: %d\n", es8316->irq, ret);
 		es8316->irq = -ENXIO;
 	}
-- 
2.33.0

