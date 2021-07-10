Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076C13C2EBE
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhGJC2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233686AbhGJC1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59C19613EB;
        Sat, 10 Jul 2021 02:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883882;
        bh=pIwBGZLcAwHPab1BmjIP3lOqixEZ9GBTnCHdnSwJV9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDVS/FGgTlEo9Zj5EvjWe/0v1O4dPHbQ1xN1FuHE1/M585beN3+k5u+4YoW3Ilfk0
         7pJpXtbyX7SiGer8gA8bmb76fUdxmkXSUB6HP7FyMYOfelZLU5lurz8FEhkj+0B10g
         +D6PuBT4tRsbey+dEt3AlGJ2zLNZytUV7pBXoTQfetDSHkjq3Scn40ka6ATUG31ozx
         CtnEI2ABpkXCEH4zEgAFt6y3GRjTM4ItDUwQ4ADwHIPMKdPqZA+J8MulJW66VmIeNp
         3opxxMPdGBCcq7/HA3XJCKlMtVtz2wSqXIodZOHREDhkpzTPmGjYUMK3ppLjPluV5B
         Og54+5gxUq0pA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Quinlan <jim2101024@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/93] serial: 8250: of: Check for CONFIG_SERIAL_8250_BCM7271
Date:   Fri,  9 Jul 2021 22:23:04 -0400
Message-Id: <20210710022428.3169839-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Quinlan <jim2101024@gmail.com>

[ Upstream commit f5b08386dee439c7a9e60ce0a4a4a705f3a60dff ]

Our SoC's have always had a NS16650A UART core and older SoC's would
have a compatible string of: 'compatible = ""ns16550a"' and use the
8250_of driver. Our newer SoC's have added enhancements to the base
core to add support for DMA and accurate high speed baud rates and use
this newer 8250_bcm7271 driver. The Device Tree node for our enhanced
UARTs has a compatible string of: 'compatible = "brcm,bcm7271-uart",
"ns16550a"''. With both drivers running and the link order setup so
that the 8250_bcm7217 driver is initialized before the 8250_of driver,
we should bind the 8250_bcm7271 driver to the enhanced UART, or for
upstream kernels that don't have the 8250_bcm7271 driver, we bind to
the 8250_of driver.

The problem is that when both the 8250_of and 8250_bcm7271 drivers
were running, occasionally the 8250_of driver would be bound to the
enhanced UART instead of the 8250_bcm7271 driver. This was happening
because we use SCMI based clocks which come up late in initialization
and cause probe DEFER's when the two drivers get their clocks.

Occasionally the SCMI clock would become ready between the 8250_bcm7271
probe and the 8250_of probe and the 8250_of driver would be bound. To
fix this we decided to config only our 8250_bcm7271 driver and added
"ns16665a0" to the compatible string so the driver would work on our
older system.

This commit has of_platform_serial_probe() check specifically for the
"brcm,bcm7271-uart" and whether its companion driver is enabled. If it
is the case, and the clock provider is not ready, we want to make sure
that when the 8250_bcm7271.c driver returns EPROBE_DEFER, we are not
getting the UART registered via 8250_of.c.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210423183206.3917725-1-f.fainelli@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index 65e9045dafe6..aa458f3c6644 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -192,6 +192,10 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 	u32 tx_threshold;
 	int ret;
 
+	if (IS_ENABLED(CONFIG_SERIAL_8250_BCM7271) &&
+	    of_device_is_compatible(ofdev->dev.of_node, "brcm,bcm7271-uart"))
+		return -ENODEV;
+
 	port_type = (unsigned long)of_device_get_match_data(&ofdev->dev);
 	if (port_type == PORT_UNKNOWN)
 		return -EINVAL;
-- 
2.30.2

