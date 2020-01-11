Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BA4137FA5
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgAKKVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:21:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730407AbgAKKVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:21:44 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 335FF20848;
        Sat, 11 Jan 2020 10:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738104;
        bh=9gpBHUXZ9nYOmx16165F46H63Tu2VFAWf/uzX9efg78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IuVyY4Q7BrP+9V/NKZkcyA1UZCBS3YXK39jwLZrrQd0Td8d4FT0FYS8yzgRA2IqT
         eR+OFhdTpZW44Wnh7Vs1335wuHBhNYKcEOxevZU4a1iyyxRdPWmBLDgFAhMY78PumC
         liYCMupO88j2SVJF92AgQbA6QYkIkpT0MZMeUTbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/165] spi: fsl: Handle the single hardwired chipselect case
Date:   Sat, 11 Jan 2020 10:48:48 +0100
Message-Id: <20200111094921.993197032@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ad1abea6e8b0..be7c6ba73072 100644
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



