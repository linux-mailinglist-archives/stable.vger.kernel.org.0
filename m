Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075153BAFB6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhGDXG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhGDXG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:06:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C98761405;
        Sun,  4 Jul 2021 23:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439862;
        bh=5yUg5wOmp/ooQBzVsDBqRDV5kFFOr5/xpPbxRuXueVg=;
        h=From:To:Cc:Subject:Date:From;
        b=Tk4YqEn2+hGZym/8IxSDpRYYkiAgBBVreM6ydoIZ2D8gHJYaptSuOOodQ/sRhnjoT
         BI5bjCtcImlScl5uoAin78pEO6cUm1ZOaTKZdPOK+cHZMtXWutvDq4Q2wQiYQu5ioG
         ZP3bKjD0XeOAGp+1AyUefH0EDGGuiPzfHe7QzbaHkqTOffjcWdZS2DgoQTao3oqgrp
         1BfmH9YH3XiTfWy6I3hV97zVH6rnJKF2axALWqGFGbfVN862WHJiTaR8n7YF/+6DS6
         RyccWDU5us1hFz1XhVVCS0wSTbZMBINSMZfUfEJFUJAqHhzl+EcWB1M8vrq2GTHDGA
         JjrE2fSXiCs7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 01/85] spi: Make of_register_spi_device also set the fwnode
Date:   Sun,  4 Jul 2021 19:02:56 -0400
Message-Id: <20210704230420.1488358-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 0e793ba77c18382f08e440260fe72bc6fce2a3cb ]

Currently, the SPI core doesn't set the struct device fwnode pointer
when it creates a new SPI device. This means when the device is
registered the fwnode is NULL and the check in device_add which sets
the fwnode->dev pointer is skipped. This wasn't previously an issue,
however these two patches:

commit 4731210c09f5 ("gpiolib: Bind gpio_device to a driver to enable
fw_devlink=on by default")
commit ced2af419528 ("gpiolib: Don't probe gpio_device if it's not the
primary device")

Added some code to the GPIO core which relies on using that
fwnode->dev pointer to determine if a driver is bound to the fwnode
and if not bind a stub GPIO driver. This means the GPIO providers
behind SPI will get both the expected driver and this stub driver
causing the stub driver to fail if it attempts to request any pin
configuration. For example on my system:

madera-pinctrl madera-pinctrl: pin gpio5 already requested by madera-pinctrl; cannot claim for gpiochip3
madera-pinctrl madera-pinctrl: pin-4 (gpiochip3) status -22
madera-pinctrl madera-pinctrl: could not request pin 4 (gpio5) from group aif1  on device madera-pinctrl
gpio_stub_drv gpiochip3: Error applying setting, reverse things back
gpio_stub_drv: probe of gpiochip3 failed with error -22

The firmware node on the device created by the GPIO framework is set
through the of_node pointer hence things generally actually work,
however that fwnode->dev is never set, as the check was skipped at
device_add time. This fix appears to match how the I2C subsystem
handles the same situation.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210421101402.8468-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index e353b7a9e54e..d83f91a6ab13 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2057,6 +2057,7 @@ of_register_spi_device(struct spi_controller *ctlr, struct device_node *nc)
 	/* Store a pointer to the node in the device structure */
 	of_node_get(nc);
 	spi->dev.of_node = nc;
+	spi->dev.fwnode = of_fwnode_handle(nc);
 
 	/* Register the new device */
 	rc = spi_add_device(spi);
-- 
2.30.2

