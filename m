Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9454A4250
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349512AbiAaLLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42612 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376636AbiAaLIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57AB861120;
        Mon, 31 Jan 2022 11:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE9CC340E8;
        Mon, 31 Jan 2022 11:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627325;
        bh=5tY0CAlJUzcoaiWnUY4WMVkJA9mAYKR3uGYW2xPE+5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmv09OoNkSMZkJoXhzH0aFGCkVvu+aih8uDhgGLEGY20jg4d99ljpTQQUDCF5kPVB
         lZt33Au0oxV6hZFlNuMUKn8++eU+XYWveJLTqzj7qcSUacEy0yyb0PrQzCx+U3XQ+O
         oFtl4rwrfsCV0Ud7+Q8QeX939Ycu16p7JqnhsUSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH 5.15 047/171] serial: 8250: of: Fix mapped region size when using reg-offset property
Date:   Mon, 31 Jan 2022 11:55:12 +0100
Message-Id: <20220131105231.618648179@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit d06b1cf28297e27127d3da54753a3a01a2fa2f28 upstream.

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
 drivers/tty/serial/8250/8250_of.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -83,8 +83,17 @@ static int of_platform_serial_setup(stru
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


