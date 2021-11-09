Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D09344B5B6
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344015AbhKIWWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:22:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343543AbhKIWVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:21:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCDEC6108C;
        Tue,  9 Nov 2021 22:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496280;
        bh=7+BMEBjdSqQa1qVGB+Y4ucwGefWzUaTFb879pgxxR2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLaQuWH2UInRcE5ZXMqE58ijtOUzYVUDtjZmQUylPXmERi1vDdrxzKpASowHXLoSZ
         QJXsHVKpvM3ZoLLR6RlmeU4ikJYO19jPuojw66tP+vzxatMCPc9xLUwTjWOycYekJE
         6Y1w72xCTXKpDDVtkx6cpbVjuN5EzEo0QOiANIutzqDKnzMrVUYy7tUC9wCzQI9arQ
         E2+kS32zoDxk89fnNE5Rdce/mPFHDt94Q1+6UqbqBhrOEZWNs3sIUfj4bHIcRDEmUS
         rKPLZDYdphPLoaTSeOupZ5moMkubGz0yD43CwUhcKj1ptHPXTEJZSwPnIhMjNJ4d3f
         gPcSUNxcHc4hA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bardliao@realtek.com,
        oder_chiou@realtek.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 41/82] ASoC: rt5651: Use IRQF_NO_AUTOEN when requesting the IRQ
Date:   Tue,  9 Nov 2021 17:15:59 -0500
Message-Id: <20211109221641.1233217-41-sashal@kernel.org>
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

[ Upstream commit 6e037b72cf4ea6c28a131ea021d63ee4e7e6fa64 ]

Use the new IRQF_NO_AUTOEN flag when requesting the IRQ, rather then
disabling it immediately after requesting it.

This fixes a possible race where the IRQ might trigger between requesting
and disabling it; and this also leads to a small code cleanup.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211003132255.31743-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5651.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/rt5651.c b/sound/soc/codecs/rt5651.c
index fc0c83b73f099..93820561b9f5d 100644
--- a/sound/soc/codecs/rt5651.c
+++ b/sound/soc/codecs/rt5651.c
@@ -2261,11 +2261,8 @@ static int rt5651_i2c_probe(struct i2c_client *i2c,
 
 	ret = devm_request_irq(&i2c->dev, rt5651->irq, rt5651_irq,
 			       IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
-			       | IRQF_ONESHOT, "rt5651", rt5651);
-	if (ret == 0) {
-		/* Gets re-enabled by rt5651_set_jack() */
-		disable_irq(rt5651->irq);
-	} else {
+			       | IRQF_ONESHOT | IRQF_NO_AUTOEN, "rt5651", rt5651);
+	if (ret) {
 		dev_warn(&i2c->dev, "Failed to reguest IRQ %d: %d\n",
 			 rt5651->irq, ret);
 		rt5651->irq = -ENXIO;
-- 
2.33.0

