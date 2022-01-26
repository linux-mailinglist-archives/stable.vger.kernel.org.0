Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3264F49CB57
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbiAZNvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbiAZNvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:51:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0447AC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:51:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98AD961536
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 13:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D6BC340E3;
        Wed, 26 Jan 2022 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643205074;
        bh=a6HuJ7MAoDibJu1uXvfJQ2r/V6xNeHjuJq1TmzyFKdY=;
        h=Subject:To:From:Date:From;
        b=wQNTdOMVc2SGQP4u5BWg+lEsMSQB6/3r8ubk3O3pjuqAZXv1L9Ue/Zu4lEZ+dlPvJ
         WqV0nGVJAYq0HH2HsEncgnBHtmcLjlm8wK5nFW2Wn2fZ1B96snZLCjvLjFI5ObFqyQ
         N/yjLNrV4svBxuAwn8cGmsFbuN6+FUYL3V/rD0XI=
Subject: patch "serial: 8250: of: Fix mapped region size when using reg-offset" added to tty-linus
To:     robert.hancock@calian.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 14:51:03 +0100
Message-ID: <164320506323438@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250: of: Fix mapped region size when using reg-offset

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d06b1cf28297e27127d3da54753a3a01a2fa2f28 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Wed, 12 Jan 2022 13:42:14 -0600
Subject: serial: 8250: of: Fix mapped region size when using reg-offset
 property

8250_of supports a reg-offset property which is intended to handle
cases where the device registers start at an offset inside the region
of memory allocated to the device. The Xilinx 16550 UART, for which this
support was initially added, requires this. However, the code did not
adjust the overall size of the mapped region accordingly, causing the
driver to request an area of memory past the end of the device's
allocation. For example, if the UART was allocated an address of
0xb0130000, size of 0x10000 and reg-offset of 0x1000 in the device
tree, the region of memory reserved was b0131000-b0140fff, which caused
the driver for the region starting at b0140000 to fail to probe.

Fix this by subtracting reg-offset from the mapped region size.

Fixes: b912b5e2cfb3 ([POWERPC] Xilinx: of_serial support for Xilinx uart 16550.)
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220112194214.881844-1-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_of.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index bce28729dd7b..be8626234627 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -83,8 +83,17 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 		port->mapsize = resource_size(&resource);
 
 		/* Check for shifted address mapping */
-		if (of_property_read_u32(np, "reg-offset", &prop) == 0)
+		if (of_property_read_u32(np, "reg-offset", &prop) == 0) {
+			if (prop >= port->mapsize) {
+				dev_warn(&ofdev->dev, "reg-offset %u exceeds region size %pa\n",
+					 prop, &port->mapsize);
+				ret = -EINVAL;
+				goto err_unprepare;
+			}
+
 			port->mapbase += prop;
+			port->mapsize -= prop;
+		}
 
 		port->iotype = UPIO_MEM;
 		if (of_property_read_u32(np, "reg-io-width", &prop) == 0) {
-- 
2.35.0


