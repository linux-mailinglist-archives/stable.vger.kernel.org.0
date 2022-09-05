Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546775AD6C4
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 17:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiIEPnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 11:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIEPnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 11:43:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE86043337
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 08:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD0DB80EFB
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 15:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C32C433C1;
        Mon,  5 Sep 2022 15:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662392628;
        bh=zTUIQ0ZRfl5uhxW88AtH/GqYQ1mm10jC9MZvVA3LikU=;
        h=Subject:To:Cc:From:Date:From;
        b=BQrcfmxqIQOfe6KyLv99YfUS2Jp9+x6kZRam5/QFWSdjc10nh2N2bVcNrqpFafDC7
         MzQBJ35ol65T/5tL5X0d33m0H1wliNJe0Jxe0UdXqNC++99Sm9IJWikibHIz6lu8Ch
         xNztmI9N7253iLXpOcnNFoPtNAKOrruryVl0sMuM=
Subject: FAILED: patch "[PATCH] tty: serial: atmel: Preserve previous USART mode if RS485" failed to apply to 5.10-stable tree
To:     sergiu.moga@microchip.com, gregkh@linuxfoundation.org,
        ilpo.jarvinen@linux.intel.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Sep 2022 17:43:43 +0200
Message-ID: <16623926238365@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 692a8ebcfc24f4a5bea0eb2967e450f584193da6 Mon Sep 17 00:00:00 2001
From: Sergiu Moga <sergiu.moga@microchip.com>
Date: Wed, 24 Aug 2022 17:29:03 +0300
Subject: [PATCH] tty: serial: atmel: Preserve previous USART mode if RS485
 disabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 30ba9eef7b39..7450d3853031 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -294,9 +294,6 @@ static int atmel_config_rs485(struct uart_port *port, struct ktermios *termios,
 
 	mode = atmel_uart_readl(port, ATMEL_US_MR);
 
-	/* Resetting serial mode to RS232 (0x0) */
-	mode &= ~ATMEL_US_USMODE;
-
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
 		if (rs485conf->flags & SER_RS485_RX_DURING_TX)
@@ -306,6 +303,7 @@ static int atmel_config_rs485(struct uart_port *port, struct ktermios *termios,
 
 		atmel_uart_writel(port, ATMEL_US_TTGR,
 				  rs485conf->delay_rts_after_send);
+		mode &= ~ATMEL_US_USMODE;
 		mode |= ATMEL_US_USMODE_RS485;
 	} else {
 		dev_dbg(port->dev, "Setting UART to RS232\n");

