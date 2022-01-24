Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6250499FE3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842300AbiAXXBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382470AbiAXWrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:47:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCCAC058CA7;
        Mon, 24 Jan 2022 13:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A0B3B8105C;
        Mon, 24 Jan 2022 21:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B18CC340E5;
        Mon, 24 Jan 2022 21:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058414;
        bh=euvV2qblln196cQvs0sdoJbEw5S8kf4Gg7n8AGEG8qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlYddX6MY+4ZHcrDGJRw02u/07UI034w8aMA6ZETUlSN1Dt//pGbEvWFd9jWcR2y7
         BRMk/nih7E0mdpDvTnjpt0L7bGrHcZwcwg6jF1yskvyGmha+5Z0Id0nwO0Lzsg4qZw
         ELmdbMboqqh2AC/KSdzXkzDLNz7ASHVGm+EkOhvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0281/1039] spi: Fix incorrect cs_setup delay handling
Date:   Mon, 24 Jan 2022 19:34:30 +0100
Message-Id: <20220124184134.731725722@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 95c07247399536f83b89dc60cfe7b279d17e69f6 ]

Move the cs_setup delay to the end of spi_set_cs.

>From include/linux/spi/spi.h:

 * @cs_setup: delay to be introduced by the controller after CS is
   asserted

The cs_setup delay needs to happen *after* CS is asserted, that is, at
the end of spi_set_cs, not at the beginning. Otherwise we're just
delaying before the SPI transaction starts at all, which isn't very
useful.

No drivers use this right now, but that is likely to change soon with an
upcoming Apple SPI HID transport driver.

Fixes: 25093bdeb6bc ("spi: implement SW control for CS times")
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20211210170534.177139-1-marcan@marcan.st
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index fdd530b150a7a..8ba87b7f8f1a8 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -947,12 +947,9 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 	spi->controller->last_cs_enable = enable;
 	spi->controller->last_cs_mode_high = spi->mode & SPI_CS_HIGH;
 
-	if (spi->cs_gpiod || gpio_is_valid(spi->cs_gpio) ||
-	    !spi->controller->set_cs_timing) {
-		if (activate)
-			spi_delay_exec(&spi->cs_setup, NULL);
-		else
-			spi_delay_exec(&spi->cs_hold, NULL);
+	if ((spi->cs_gpiod || gpio_is_valid(spi->cs_gpio) ||
+	    !spi->controller->set_cs_timing) && !activate) {
+		spi_delay_exec(&spi->cs_hold, NULL);
 	}
 
 	if (spi->mode & SPI_CS_HIGH)
@@ -994,7 +991,9 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 
 	if (spi->cs_gpiod || gpio_is_valid(spi->cs_gpio) ||
 	    !spi->controller->set_cs_timing) {
-		if (!activate)
+		if (activate)
+			spi_delay_exec(&spi->cs_setup, NULL);
+		else
 			spi_delay_exec(&spi->cs_inactive, NULL);
 	}
 }
-- 
2.34.1



