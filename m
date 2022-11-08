Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6541621438
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiKHN6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiKHN6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:58:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD9E528B1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:58:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DDA8B81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46598C433D6;
        Tue,  8 Nov 2022 13:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915921;
        bh=htpuGu9/8XgyTOFdAcP/5Nz/v92jtKvltu2Qnj9LrIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3Tko53nPmCbIvfF2CxrbsRiix/SSOV7JqtzE0RsTmN5SdxUoJKm7Q+2DxapLu71g
         qQGEyBxpAmAIjFS7spQ24TaCSkL3aeaoeY9upuGeNM1ql7EzFaf3b9i+2QczN5ge8Y
         K8VegCnIAOr6OnNVKjQpR3ep+OsH+ae3SU6o62+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Golle <daniel@makrotopia.org>,
        =?UTF-8?q?Ilpo=20J=C3=83=E2=82=ACrvinen?= 
        <ilpo.jarvinen@linux.intel.com>, Lukas Wunner <lukas@wunner.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/144] serial: ar933x: Deassert Transmit Enable on ->rs485_config()
Date:   Tue,  8 Nov 2022 14:38:01 +0100
Message-Id: <20221108133345.532078595@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 3a939433ddc1bab98be028903aaa286e5e7461d7 upstream.

The ar933x_uart driver neglects to deassert Transmit Enable when
->rs485_config() is invoked.  Fix it.

Fixes: 9be1064fe524 ("serial: ar933x_uart: add RS485 support")
Cc: stable@vger.kernel.org # v5.7+
Cc: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Ilpo JÃ€rvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ar933x_uart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 4379ca4842ae..0f2677695b52 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -591,6 +591,11 @@ static int ar933x_config_rs485(struct uart_port *port,
 		dev_err(port->dev, "RS485 needs rts-gpio\n");
 		return 1;
 	}
+
+	if (rs485conf->flags & SER_RS485_ENABLED)
+		gpiod_set_value(up->rts_gpiod,
+			!!(rs485conf->flags & SER_RS485_RTS_AFTER_SEND));
+
 	port->rs485 = *rs485conf;
 	return 0;
 }
-- 
2.35.1



