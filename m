Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE5E3C2E26
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhGJC0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhGJCZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 791F7613F7;
        Sat, 10 Jul 2021 02:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883780;
        bh=qGZ/XPXWZNsgiZS33sYC3mAXAM5fqIhgEEX1RPAfsW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pp7TFt1AoJ8YHn19hqBR3ZPJExBsRokqSGlO0GJf8yCqjoulK3QrvCXsPQVwi37Qs
         DuaXydeiswhoLa+Ix/WmKEpOH4FJjbg2W/t/H8cNI7O3HF2KqRFZeHk6VV2ktx3qHQ
         +DH0AsoazMmm5UNI6wa766h6l/gayAfFc/GdnncFb+x1aI+m1VCCTT9OYYpXXu9+Qt
         ac98uPOVSTUvT1HKeo/qMK/UxdPETp1ZNLFCzJQhh5afPKpGxkzmu3yFcff30I344E
         1wB/mPnNeUOt02gvGifs17nOuHQVL0gJv0/xe6bJnjW1x2JTjpi17HdChGVAHqqL6K
         7lUjwGJaURZmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Ivan Jelincic <parazyd@dyne.org>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        "Sicelo A . Mhlongo" <absicsz@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 048/104] mfd: cpcap: Fix cpcap dmamask not set warnings
Date:   Fri,  9 Jul 2021 22:21:00 -0400
Message-Id: <20210710022156.3168825-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 0b7cbe811ca524295ea43d9a4d73d3427e419c54 ]

We have started to get a bunch of pointless dmamask not set warnings
that makes the output of dmesg -l err,warn hard to read with many
extra warnings:

cpcap-regulator cpcap-regulator.0: DMA mask not set
cpcap_adc cpcap_adc.0: DMA mask not set
cpcap_battery cpcap_battery.0: DMA mask not set
cpcap-charger cpcap-charger.0: DMA mask not set
cpcap-pwrbutton cpcap-pwrbutton.0: DMA mask not set
cpcap-led cpcap-led.0: DMA mask not set
cpcap-led cpcap-led.1: DMA mask not set
cpcap-led cpcap-led.2: DMA mask not set
cpcap-led cpcap-led.3: DMA mask not set
cpcap-led cpcap-led.4: DMA mask not set
cpcap-rtc cpcap-rtc.0: DMA mask not set
cpcap-usb-phy cpcap-usb-phy.0: DMA mask not set

This seems to have started with commit 4d8bde883bfb ("OF: Don't set
default coherent DMA mask"). We have the parent SPI controller use
DMA, while CPCAP driver and it's children do not. For audio, the
DMA is handled over I2S bus with the McBSP driver.

Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Ivan Jelincic <parazyd@dyne.org>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sicelo A. Mhlongo <absicsz@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/motorola-cpcap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/motorola-cpcap.c b/drivers/mfd/motorola-cpcap.c
index 30d82bfe5b02..6fb206da2729 100644
--- a/drivers/mfd/motorola-cpcap.c
+++ b/drivers/mfd/motorola-cpcap.c
@@ -327,6 +327,10 @@ static int cpcap_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
+	/* Parent SPI controller uses DMA, CPCAP and child devices do not */
+	spi->dev.coherent_dma_mask = 0;
+	spi->dev.dma_mask = &spi->dev.coherent_dma_mask;
+
 	return devm_mfd_add_devices(&spi->dev, 0, cpcap_mfd_devices,
 				    ARRAY_SIZE(cpcap_mfd_devices), NULL, 0, NULL);
 }
-- 
2.30.2

