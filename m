Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DC85C02B4
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbiIUPyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiIUPx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3892F9F0F4;
        Wed, 21 Sep 2022 08:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61E6D63147;
        Wed, 21 Sep 2022 15:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6E2C433D6;
        Wed, 21 Sep 2022 15:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775358;
        bh=Jxgrg6W4341DNVv5KQzE6tPsH4Ks3+HSQEmFwxDq8PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I66HeRiDM871liZ2cP+GMQUkiibdyJPOFRidi7XI41XkXCGUWfwvs+RpEThsE+dzP
         roa49Fgs1Zqu34bBTmeD68e/r3sQccCP6aWOWMp+ExfFTrAoD7Ci9um29pjDolXeMy
         Txa6kJcd3pXnUAQNixTTRIEg/6vQR1SSwvgesQtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/45] serial: atmel: remove redundant assignment in rs485_config
Date:   Wed, 21 Sep 2022 17:45:53 +0200
Message-Id: <20220921153647.034378740@linuxfoundation.org>
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

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

[ Upstream commit 60efd0513916f195dd85bfbf21653f74f9ab019c ]

In uart_set_rs485_config() the serial core already assigns the passed
serial_rs485 struct to the uart port.

So remove the assignment from the drivers rs485_config() function to avoid
redundancy.

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Link: https://lore.kernel.org/r/20220410104642.32195-10-LinoSanfilippo@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 692a8ebcfc24 ("tty: serial: atmel: Preserve previous USART mode if RS485 disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/atmel_serial.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index dd350c590880..92383c8610ee 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -298,11 +298,9 @@ static int atmel_config_rs485(struct uart_port *port,
 	/* Resetting serial mode to RS232 (0x0) */
 	mode &= ~ATMEL_US_USMODE;
 
-	port->rs485 = *rs485conf;
-
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
-		if (port->rs485.flags & SER_RS485_RX_DURING_TX)
+		if (rs485conf->flags & SER_RS485_RX_DURING_TX)
 			atmel_port->tx_done_mask = ATMEL_US_TXRDY;
 		else
 			atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
-- 
2.35.1



