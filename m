Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370915EA08E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbiIZKkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbiIZKiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:38:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E893953034;
        Mon, 26 Sep 2022 03:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3E5260AD6;
        Mon, 26 Sep 2022 10:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFCAC433D6;
        Mon, 26 Sep 2022 10:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187746;
        bh=u/QO94tfwEdDsCQx8IWsPMwtpNvAXeSMZ1eabfWH5WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eI378aZxilxDxUGOWLc4qqr8YmmSbtGG8MXY6mN6TRvsyrGC0KViotAUANAf2hFWi
         ktcjE5XjzPei6pz9KWFF/7L2gI7OG3Quo0VlnwZS7XPeftvuLrf79jAiCweG8wDoU9
         s6ILv38rPr0BNNB6Okp7hEthvbv7vJMpUaolB4qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sergiu Moga <sergiu.moga@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/120] tty: serial: atmel: Preserve previous USART mode if RS485 disabled
Date:   Mon, 26 Sep 2022 12:11:20 +0200
Message-Id: <20220926100752.470728066@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergiu Moga <sergiu.moga@microchip.com>

[ Upstream commit 692a8ebcfc24f4a5bea0eb2967e450f584193da6 ]

Whenever the atmel_rs485_config() driver method would be called,
the USART mode is reset to normal mode before even checking if
RS485 flag is set, thus resulting in losing the previous USART
mode in the case where the checking fails.

Some tools, such as `linux-serial-test`, lead to the driver calling
this method when doing the setup of the serial port: after setting the
port mode (Hardware Flow Control, Normal Mode, RS485 Mode, etc.),
`linux-serial-test` tries to enable/disable RS485 depending on
the commandline arguments that were passed.

Example of how this issue could reveal itself:
When doing a serial communication with Hardware Flow Control through
`linux-serial-test`, the tool would lead to the driver roughly doing
the following:
- set the corresponding bit to 1 (ATMEL_US_USMODE_HWHS bit in the
ATMEL_US_MR register) through the atmel_set_termios() to enable
Hardware Flow Control
- disable RS485 through the atmel_config_rs485() method
Thus, when the latter is called, the mode will be reset and the
previously set bit is unset, leaving USART in normal mode instead of
the expected Hardware Flow Control mode.

This fix ensures that this reset is only done if the checking for
RS485 succeeds and that the previous mode is preserved otherwise.

Fixes: e8faff7330a35 ("ARM: 6092/1: atmel_serial: support for RS485 communications")
Cc: stable <stable@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sergiu Moga <sergiu.moga@microchip.com>
Link: https://lore.kernel.org/r/20220824142902.502596-1-sergiu.moga@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/atmel_serial.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 44608a06bb2c..3bd93558b443 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -306,9 +306,6 @@ static int atmel_config_rs485(struct uart_port *port,
 
 	mode = atmel_uart_readl(port, ATMEL_US_MR);
 
-	/* Resetting serial mode to RS232 (0x0) */
-	mode &= ~ATMEL_US_USMODE;
-
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
 		if (rs485conf->flags & SER_RS485_RX_DURING_TX)
@@ -318,6 +315,7 @@ static int atmel_config_rs485(struct uart_port *port,
 
 		atmel_uart_writel(port, ATMEL_US_TTGR,
 				  rs485conf->delay_rts_after_send);
+		mode &= ~ATMEL_US_USMODE;
 		mode |= ATMEL_US_USMODE_RS485;
 	} else {
 		dev_dbg(port->dev, "Setting UART to RS232\n");
-- 
2.35.1



