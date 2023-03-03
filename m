Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723C56AA21B
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjCCVpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjCCVom (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:44:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65756426C;
        Fri,  3 Mar 2023 13:43:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A41EE61943;
        Fri,  3 Mar 2023 21:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC920C4339B;
        Fri,  3 Mar 2023 21:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879817;
        bh=ym3+Gg0aSijOjQS5EHK6YUaEmp1V3AItcjtX2kDux0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKF2ihWgK96KKzKSmYfjZT74vPWBAbpzCRxUDAX9sWfdVaWZqPGa0gREWnJzmwMoU
         6ZaPUAfFh5NLwQmH4BOxRGdToepb+UVu585MZ8wShIc/6VYqcWCS8wxkNdB/iRO9b4
         xkVCNEFF4pu4ksT1njewaZMwyQlpq/T8z2YZ9fmG02NJpVwxr6kUnkgYQh2ssgndu2
         rYXTo2uA/suP3F/JV+2jgruHJ9KMbXkBGbwCu3c6NLgGOgzzzxiW8rB9U4SxlrlrVN
         V7t4ViPFCgrLM6kV7NNd3xDvHoGf3DjgEPyUxFh7slwTqwLmfdfIyVAjhpgAZH88I3
         1B3Jf96BRI2cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 13/60] tty: serial: fsl_lpuart: disable the CTS when send break signal
Date:   Fri,  3 Mar 2023 16:42:27 -0500
Message-Id: <20230303214315.1447666-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit c4c81db5cf8bc53d6160c3abf26d382c841aa434 ]

LPUART IP has a bug that it treats the CTS as higher priority than the
break signal, which cause the break signal sending through UARTCTRL_SBK
may impacted by the CTS input if the HW flow control is enabled.

Add this workaround patch to fix the IP bug, we can disable CTS before
asserting SBK to avoid any interference from CTS, and re-enable it when
break off.

Such as for the bluetooth chip power save feature, host can let the BT
chip get into sleep state by sending a UART break signal, and wake it up
by turning off the UART break. If the BT chip enters the sleep mode
successfully, it will pull up the CTS line, if the BT chip is woken up,
it will pull down the CTS line. If without this workaround patch, the
UART TX pin cannot send the break signal successfully as it affected by
the BT CTS pin. After adding this patch, the BT power save feature can
work well.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221214031137.28815-2-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 888e01fbd9c5f..8af4f6bb66509 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1468,12 +1468,32 @@ static void lpuart_break_ctl(struct uart_port *port, int break_state)
 
 static void lpuart32_break_ctl(struct uart_port *port, int break_state)
 {
-	unsigned long temp;
+	unsigned long temp, modem;
+	struct tty_struct *tty;
+	unsigned int cflag = 0;
+
+	tty = tty_port_tty_get(&port->state->port);
+	if (tty) {
+		cflag = tty->termios.c_cflag;
+		tty_kref_put(tty);
+	}
 
 	temp = lpuart32_read(port, UARTCTRL) & ~UARTCTRL_SBK;
+	modem = lpuart32_read(port, UARTMODIR);
 
-	if (break_state != 0)
+	if (break_state != 0) {
 		temp |= UARTCTRL_SBK;
+		/*
+		 * LPUART CTS has higher priority than SBK, need to disable CTS before
+		 * asserting SBK to avoid any interference if flow control is enabled.
+		 */
+		if (cflag & CRTSCTS && modem & UARTMODIR_TXCTSE)
+			lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
+	} else {
+		/* Re-enable the CTS when break off. */
+		if (cflag & CRTSCTS && !(modem & UARTMODIR_TXCTSE))
+			lpuart32_write(port, modem | UARTMODIR_TXCTSE, UARTMODIR);
+	}
 
 	lpuart32_write(port, temp, UARTCTRL);
 }
-- 
2.39.2

