Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C4D12B8E9
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfL0RlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfL0RlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 306BD21582;
        Fri, 27 Dec 2019 17:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468470;
        bh=vyKkko4RjY1ywbE95vrfP1JTmbuE9LX0jGxvN//of38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OanEeDZ3n1wj6avgXkL6bl2GSBZxE5IghmNo+Tw1gmtCgxkUBm8Z0fdHe3az2CsBb
         QLd4G8xZw0J6m4QgcGfaY6N31zXiK7I8iq/tLpgbDj9FHW8BjYYmIAJSjfzVwMiEZz
         KtBZf8wC2elPn9PCYvoMFRJN2KqwR1By7RGAQxII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 012/187] spi: fsl: Handle the single hardwired chipselect case
Date:   Fri, 27 Dec 2019 12:38:00 -0500
Message-Id: <20191227174055.4923-12-sashal@kernel.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 7251953d784baf7e5416afabe030a0e81de1a938 ]

The Freescale MPC8xxx had a special quirk for handling a
single hardwired chipselect, the case when we're using neither
GPIO nor native chip select: when inspecting the device tree
and finding zero "cs-gpios" on the device node the code would
assume we have a single hardwired chipselect that leaves the
device always selected.

This quirk is not handled by the new core code, so we need
to check the "cs-gpios" explicitly in the driver and set
pdata->max_chipselect = 1 which will later fall through to
the SPI master ->num_chipselect.

Make sure not to assign the chip select handler in this
case: there is no handling needed since the chip is always
selected, and this is what the old code did as well.

Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Reported-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr> (No tested the
Link: https://lore.kernel.org/r/20191128083718.39177-3-linus.walleij@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 75b765f97df5..2155294eaaeb 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -729,8 +729,18 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 			}
 		}
 #endif
-
-		pdata->cs_control = fsl_spi_cs_control;
+		/*
+		 * Handle the case where we have one hardwired (always selected)
+		 * device on the first "chipselect". Else we let the core code
+		 * handle any GPIOs or native chip selects and assign the
+		 * appropriate callback for dealing with the CS lines. This isn't
+		 * supported on the GRLIB variant.
+		 */
+		ret = gpiod_count(dev, "cs");
+		if (ret <= 0)
+			pdata->max_chipselect = 1;
+		else
+			pdata->cs_control = fsl_spi_cs_control;
 	}
 
 	ret = of_address_to_resource(np, 0, &mem);
-- 
2.20.1

