Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EE0603C32
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiJSIoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiJSIoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:44:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7DF82626;
        Wed, 19 Oct 2022 01:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F265617EF;
        Wed, 19 Oct 2022 08:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80708C433D6;
        Wed, 19 Oct 2022 08:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168904;
        bh=gp4XCDaj/ECkiOHH8Oy0tRGOZDp14WeL7Yte4jTXnp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbU/a/B9Sh8TRL5rbUpf7/yb3wSwEX496R/J6k1Wf0sS9opVr4fAJab8GjvlBvAxb
         E074FFMLfgghsZy4WpBcF2PhQHD0xQr/ifUdJzpp+faH8XYm1m4Oo3gR0W8t96Rz1s
         HMSBP2zv6ehn20aY+oq7Yz3PUcwh0Wkqu1dBhIRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.0 093/862] serial: ar933x: Deassert Transmit Enable on ->rs485_config()
Date:   Wed, 19 Oct 2022 10:23:00 +0200
Message-Id: <20221019083254.057777674@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lukas Wunner <lukas@wunner.de>

commit 3a939433ddc1bab98be028903aaa286e5e7461d7 upstream.

The ar933x_uart driver neglects to deassert Transmit Enable when
->rs485_config() is invoked.  Fix it.

Fixes: 9be1064fe524 ("serial: ar933x_uart: add RS485 support")
Cc: stable@vger.kernel.org # v5.7+
Cc: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/5b36af26e57553f084334666e7d24c7fd131a01e.1662887231.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/ar933x_uart.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -583,6 +583,13 @@ static const struct uart_ops ar933x_uart
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
 


