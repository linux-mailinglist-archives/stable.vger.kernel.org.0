Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC445C026E
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiIUPwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiIUPve (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:51:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD689E884;
        Wed, 21 Sep 2022 08:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 782FD63141;
        Wed, 21 Sep 2022 15:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA3AC433D6;
        Wed, 21 Sep 2022 15:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775361;
        bh=8h1b+0s6o2B2gx/ZKPPZXC5/T0oHPjx9k7Z6hbcGS04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGQTafKXxuQtvjCMu8T8+TjlNB3uMV4Z8HNzWWXLnoNOSNE+htM5WsMVuG8FqQX5k
         8DcpFhTUEjiMBvjYTNiPr8ljXc7xpTOv50yKfyE1eqIaeOtm42M/oVQ56lGFJoEJiP
         LVBEqknV1lejqepn7qjJ74RUcdwU9B4pWUO4UI5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sergiu Moga <sergiu.moga@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/45] tty: serial: atmel: Preserve previous USART mode if RS485 disabled
Date:   Wed, 21 Sep 2022 17:45:54 +0200
Message-Id: <20220921153647.062857015@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 92383c8610ee..c0a86558ceaa 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -295,9 +295,6 @@ static int atmel_config_rs485(struct uart_port *port,
 
 	mode = atmel_uart_readl(port, ATMEL_US_MR);
 
-	/* Resetting serial mode to RS232 (0x0) */
-	mode &= ~ATMEL_US_USMODE;
-
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
 		if (rs485conf->flags & SER_RS485_RX_DURING_TX)
@@ -307,6 +304,7 @@ static int atmel_config_rs485(struct uart_port *port,
 
 		atmel_uart_writel(port, ATMEL_US_TTGR,
 				  rs485conf->delay_rts_after_send);
+		mode &= ~ATMEL_US_USMODE;
 		mode |= ATMEL_US_USMODE_RS485;
 	} else {
 		dev_dbg(port->dev, "Setting UART to RS232\n");
-- 
2.35.1



