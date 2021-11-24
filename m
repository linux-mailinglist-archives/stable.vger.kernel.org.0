Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5249745C442
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345473AbhKXNq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350380AbhKXNoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:44:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7881E619EA;
        Wed, 24 Nov 2021 13:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758819;
        bh=bjPXB5HH1GtIMshiC2IBO4Pln2KOJyhpk465bQoQ92w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZGBIGM2xBRzYxZOqRu1dymmrCvnxMnBurjWUGKeN8oJq1yAzHqhscZQkn5nrXRQN
         KUU3AhKLRZr+6YcFoVMAG6u1dP7pHCETl6wgovSvQRzP3BvzXGjwun+EBjqnTMGiS/
         KhGnRHTIC8jrXcTx9ju5/Nl3YOpCWFTl6HvHG5UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/279] ASoC: es8316: Use IRQF_NO_AUTOEN when requesting the IRQ
Date:   Wed, 24 Nov 2021 12:55:26 +0100
Message-Id: <20211124115720.078533813@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



