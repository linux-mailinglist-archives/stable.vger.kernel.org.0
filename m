Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258623BB29A
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhGDXP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234142AbhGDXOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF647619AA;
        Sun,  4 Jul 2021 23:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440285;
        bh=WU1bSrE8aufbaP+Iz2ayxRaykURKJQ0Z9dZKgWW19Jo=;
        h=From:To:Cc:Subject:Date:From;
        b=L7wefWDaW+GD6PuK7P7/UJhDUX8MW+rllGFKU22XBYwCOIlmuv2+N8nW54xS42PF0
         e95lkzAHzQPzzQCw40BXx9WaexLJHriniC6NVXcTKHuINJxQ920LwoLwSKTg4gNom4
         KCFgQZa/C+l3aFloYKis1HdhFuwLqi2TaCTT9lY8bs+bjo28mnKYu/c6c6CTZgtLId
         j/ZUDnv88kPIkYttF/FP6GSdWtUYy8eXgKgNupFi8B/bpW9ZMsEu2ojrXacpK6Rlm9
         XqlMjAtAVkhXSc94vrTRq5duHX5WkQw8VIvb4pZp6/XZf7D7itGtm89rgtwlPh2ugr
         qEJcJpHo9G0lQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/25] spi: Make of_register_spi_device also set the fwnode
Date:   Sun,  4 Jul 2021 19:10:59 -0400
Message-Id: <20210704231123.1491517-1-sashal@kernel.org>
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
index da71a53b0df7..71f74015efb9 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1670,6 +1670,7 @@ of_register_spi_device(struct spi_controller *ctlr, struct device_node *nc)
 	/* Store a pointer to the node in the device structure */
 	of_node_get(nc);
 	spi->dev.of_node = nc;
+	spi->dev.fwnode = of_fwnode_handle(nc);
 
 	/* Register the new device */
 	rc = spi_add_device(spi);
-- 
2.30.2

