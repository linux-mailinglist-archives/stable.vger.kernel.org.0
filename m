Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDED44F312E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241758AbiDEIfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbiDEIUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7F3C12EF;
        Tue,  5 Apr 2022 01:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AECB60AFB;
        Tue,  5 Apr 2022 08:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1553AC385A0;
        Tue,  5 Apr 2022 08:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146330;
        bh=n3nkzgpEB47HhE4UFNhS1KreV0bT9i5sQEKLdpiP0Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoHDEoN/s0AgchJ9jeaLxRQRHzedHZUBiYbU4T9KSxZBdSpneTSuI6EWGfUYQH4jt
         u7PqcKPZ/HES543jWZkvckSpuYKDSjC8mFg2c3hyGiOtJpqngWcXFMpCfJhfqmKb+e
         hQWA3XbgW+NICLkTMOS2XHEtgrKI8IrS6nZzJL5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Aladyshev <aladyshev22@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Zev Weiss <zev@bewilderbeest.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0726/1126] serial: 8250_aspeed_vuart: add PORT_ASPEED_VUART port type
Date:   Tue,  5 Apr 2022 09:24:33 +0200
Message-Id: <20220405070428.902570342@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit a603ca60cebff8589882427a67f870ed946b3fc8 ]

Commit 54da3e381c2b ("serial: 8250_aspeed_vuart: use UPF_IOREMAP to
set up register mapping") fixed a bug that had, as a side-effect,
prevented the 8250_aspeed_vuart driver from enabling the VUART's
FIFOs.  However, fixing that (and hence enabling the FIFOs) has in
turn revealed what appears to be a hardware bug in the ASPEED VUART in
which the host-side THRE bit doesn't get if the BMC-side receive FIFO
trigger level is set to anything but one byte.  This causes problems
for polled-mode writes from the host -- for example, Linux kernel
console writes proceed at a glacial pace (less than 100 bytes per
second) because the write path waits for a 10ms timeout to expire
after every character instead of being able to continue on to the next
character upon seeing THRE asserted.  (GRUB behaves similarly.)

As a workaround, introduce a new port type for the ASPEED VUART that's
identical to PORT_16550A as it had previously been using, but with
UART_FCR_R_TRIG_00 instead to set the receive FIFO trigger level to
one byte, which (experimentally) seems to avoid the problematic THRE
behavior.

Fixes: 54da3e381c2b ("serial: 8250_aspeed_vuart: use UPF_IOREMAP to set up register mapping")
Tested-by: Konstantin Aladyshev <aladyshev22@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Link: https://lore.kernel.org/r/20220211004203.14915-1-zev@bewilderbeest.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_aspeed_vuart.c | 2 +-
 drivers/tty/serial/8250/8250_port.c         | 8 ++++++++
 include/uapi/linux/serial_core.h            | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_aspeed_vuart.c b/drivers/tty/serial/8250/8250_aspeed_vuart.c
index 2350fb3bb5e4..c2cecc6f47db 100644
--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -487,7 +487,7 @@ static int aspeed_vuart_probe(struct platform_device *pdev)
 	port.port.irq = irq_of_parse_and_map(np, 0);
 	port.port.handle_irq = aspeed_vuart_handle_irq;
 	port.port.iotype = UPIO_MEM;
-	port.port.type = PORT_16550A;
+	port.port.type = PORT_ASPEED_VUART;
 	port.port.uartclk = clk;
 	port.port.flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
 		| UPF_FIXED_PORT | UPF_FIXED_TYPE | UPF_NO_THRE_TEST;
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 3b12bfc1ed67..973870ebff69 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -307,6 +307,14 @@ static const struct serial8250_config uart_config[] = {
 		.rxtrig_bytes	= {1, 32, 64, 112},
 		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
+	[PORT_ASPEED_VUART] = {
+		.name		= "ASPEED VUART",
+		.fifo_size	= 16,
+		.tx_loadsz	= 16,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_00,
+		.rxtrig_bytes	= {1, 4, 8, 14},
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 /* Uart divisor latch read */
diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
index c4042dcfdc0c..8885e69178bd 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -68,6 +68,9 @@
 /* NVIDIA Tegra Combined UART */
 #define PORT_TEGRA_TCU	41
 
+/* ASPEED AST2x00 virtual UART */
+#define PORT_ASPEED_VUART	42
+
 /* Intel EG20 */
 #define PORT_PCH_8LINE	44
 #define PORT_PCH_2LINE	45
-- 
2.34.1



