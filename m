Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673275EA35C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiIZLYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiIZLXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:23:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B825726AE7;
        Mon, 26 Sep 2022 03:40:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCECDB801BF;
        Mon, 26 Sep 2022 10:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D684C433C1;
        Mon, 26 Sep 2022 10:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188800;
        bh=DoyjJPRgE81u2h5r3ajYpubUne6Xk3znZRS03RjWaLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+69XJeX0ziMd4tPUlRUPzDashhb9aKYO7twXu55r665FbCiAtkgXIs9BRGWXMUHa
         LEJRZzxHQ/kAqqObc6jfHYbaPp4+M07CWzCcw8PupfqvnfcYWflj1qOzBAiDeAh7n0
         VppWxB0q+aAk18YuDE7i7S5viI7j15BLe/mTKESs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.15 118/148] serial: fsl_lpuart: Reset prior to registration
Date:   Mon, 26 Sep 2022 12:12:32 +0200
Message-Id: <20220926100800.561048554@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 60f361722ad2ae5ee667d0b0545d40c42f754daf upstream.

Since commit bd5305dcabbc ("tty: serial: fsl_lpuart: do software reset
for imx7ulp and imx8qxp"), certain i.MX UARTs are reset after they've
already been registered.  Register state may thus be clobbered after
user space has begun to open and access the UART.

Avoid by performing the reset prior to registration.

Fixes: bd5305dcabbc ("tty: serial: fsl_lpuart: do software reset for imx7ulp and imx8qxp")
Cc: stable@vger.kernel.org # v5.15+
Cc: Fugang Duan <fugang.duan@nxp.com>
Cc: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/72fb646c1b0b11c989850c55f52f9ff343d1b2fa.1662884345.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2726,14 +2726,15 @@ static int lpuart_probe(struct platform_
 		lpuart_reg.cons = LPUART_CONSOLE;
 		handler = lpuart_int;
 	}
-	ret = uart_add_one_port(&lpuart_reg, &sport->port);
-	if (ret)
-		goto failed_attach_port;
 
 	ret = lpuart_global_reset(sport);
 	if (ret)
 		goto failed_reset;
 
+	ret = uart_add_one_port(&lpuart_reg, &sport->port);
+	if (ret)
+		goto failed_attach_port;
+
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2756,9 +2757,9 @@ static int lpuart_probe(struct platform_
 
 failed_irq_request:
 failed_get_rs485:
-failed_reset:
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
+failed_reset:
 	lpuart_disable_clks(sport);
 	return ret;
 }


