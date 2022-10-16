Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB75FFEEE
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 13:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiJPLRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 07:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJPLRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 07:17:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7903678E
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 04:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4306AB80C82
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 11:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F92C43470;
        Sun, 16 Oct 2022 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665919027;
        bh=m4KWY93UReSoeG/RyjEnxvdyIdvUrs3O81tmhma88jU=;
        h=Subject:To:Cc:From:Date:From;
        b=o6rjNeBM+dyiw0xmL7dQGCgDZVM107cn+gwcO2i+RvlyKp10qM13T7c2VYu/salwT
         R3nxbiv/1ag/IrXx4VgksLOpdYcv6s3SyJnLYxoc7pcugGgrlwbi8OtkYWr+8kDlHZ
         /+BoMqTJM+TaioP7LR5RQ8KX7rswOoCk8HsdxaUM=
Subject: FAILED: patch "[PATCH] serial: ar933x: Deassert Transmit Enable on ->rs485_config()" failed to apply to 5.15-stable tree
To:     lukas@wunner.de, daniel@makrotopia.org, gregkh@linuxfoundation.org,
        ilpo.jarvinen@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 13:17:49 +0200
Message-ID: <166591906918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3a939433ddc1 ("serial: ar933x: Deassert Transmit Enable on ->rs485_config()")
184842622c97 ("serial: ar933x: Remove superfluous code in ar933x_config_rs485()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a939433ddc1bab98be028903aaa286e5e7461d7 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Sun, 11 Sep 2022 11:12:15 +0200
Subject: [PATCH] serial: ar933x: Deassert Transmit Enable on ->rs485_config()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The ar933x_uart driver neglects to deassert Transmit Enable when
->rs485_config() is invoked.  Fix it.

Fixes: 9be1064fe524 ("serial: ar933x_uart: add RS485 support")
Cc: stable@vger.kernel.org # v5.7+
Cc: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/5b36af26e57553f084334666e7d24c7fd131a01e.1662887231.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 0a4020dba165..925484a42c82 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -583,6 +583,13 @@ static const struct uart_ops ar933x_uart_ops = {
 static int ar933x_config_rs485(struct uart_port *port, struct ktermios *termios,
 				struct serial_rs485 *rs485conf)
 {
+	struct ar933x_uart_port *up =
+			container_of(port, struct ar933x_uart_port, port);
+
+	if (port->rs485.flags & SER_RS485_ENABLED)
+		gpiod_set_value(up->rts_gpiod,
+			!!(rs485conf->flags & SER_RS485_RTS_AFTER_SEND));
+
 	return 0;
 }
 

