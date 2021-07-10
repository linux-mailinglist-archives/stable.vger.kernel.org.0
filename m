Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5539B3C301F
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhGJCd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234095AbhGJCbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:31:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2507C6142D;
        Sat, 10 Jul 2021 02:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884066;
        bh=0WSpC4dOuuA7TizWJx5jNXiXsDXdY7vk7rwBBTqBOu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8FT/yHt/tUN2ESa7ADurwINAP5enwzpiam+Ps/NL2OyBRkG1Le38CkiayjCyrjus
         GVckFdo8KcapZv5KbNw0zSH7j+F0cZz/6QGOO9hFnL7lF02ICMcqR/CNdTOiaNw/0f
         ggl9bycjwm/p3rj65lSLHZkrVGMtnbPuN0I3OsxdT+inRe6Zg37kfloEm2lQ7LWOKT
         uBC32zUKpNuR6AJvdQsbxh11/4ljTXpR6uM8YiZoVk3B7o+ToSlQNIsMR3FCRAjguZ
         i4bpBV8IZvWoy6J3gjmfb55t8UzKMQ2KzgI1rkFoB1JvIK1eVcwsCuf/Dpo5Dg5Y3R
         FDn8I+cxBvVCg==
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
Subject: [PATCH AUTOSEL 5.4 28/63] mfd: cpcap: Fix cpcap dmamask not set warnings
Date:   Fri,  9 Jul 2021 22:26:34 -0400
Message-Id: <20210710022709.3170675-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
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
index 52f38e57cdc1..1ae58c977e1b 100644
--- a/drivers/mfd/motorola-cpcap.c
+++ b/drivers/mfd/motorola-cpcap.c
@@ -305,6 +305,10 @@ static int cpcap_probe(struct spi_device *spi)
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

