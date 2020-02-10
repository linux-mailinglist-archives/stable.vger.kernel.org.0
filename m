Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617B015812B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 18:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgBJRSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 12:18:31 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34112 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgBJRSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 12:18:31 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so4026474pfc.1
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 09:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v1m3szixNNxqjJUkavyYJIqiPZ7qr/6fxUicwspS2io=;
        b=Ida80gId7m9pRTcadNu1W/yKqwdtw5HjP69hchYyNRMQBGhdtRVz5RU2Qn3LzcVjsN
         O7mjhrKWpBoAk3U5Lb8uaaNL5A7ZQJh6GPq/NkBYpYDXbaMasKse5Vx6y4WCnsERhGBG
         D4ge1l4m66JEAfEs4kQajXzWp6YGfHOM7EdKAefI7TFWIcaI0aaVEkQnp2XMvz4dFh0E
         eITuZeCX6Vh0hFuZVwqeDV7e8nwjsLKsGkbjDCUFyvYp/K5ewyvbfmlwVEmR/3EFH3R4
         DYrbch5xhMIeYtSE9RC5rpkVm+Fz9uQ1Ma2q/8OtINR2aMztLUn76HEODyv0xKkfhJeL
         5J6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v1m3szixNNxqjJUkavyYJIqiPZ7qr/6fxUicwspS2io=;
        b=WNURhXfm3PO2t+qJXKKZ7+kXpiORHdJyeW3+H7AbQbj/3ES0/y7f7HCC0oGC9zIuH5
         To9x6Jc7+k2ChscMMJUr2yK8rSTshnZp3D3Qy6rlNmGL/67Uaa+8UGQJDs+zpysc/Ufh
         77OWZ4dksusYl/WSANTwiXWFiIom/ck7qZ7HDCFbviakiizOItYwLX0QPIHq5YHj339z
         8zNjvIjlEu+A0X//jFNlnMWtcnK0lNhHH8W2/DKpgiNqM5x+hzxEdkOz86mGCrofKra+
         agMtdJXS4jnuLVL4d+LzqyYvwxn9WoO+t/drmk+I2xUtjqRaWzZ+4bwlfhsqR1ePjyOc
         Q87A==
X-Gm-Message-State: APjAAAX3ekJXjBxdES3CjupGYHyUxR42Nz6ff4ghEqZBS/XaisEPotUk
        kNPUKPYk49ZJ+FV0UryN0ttXPdrruuw=
X-Google-Smtp-Source: APXvYqw/ziNSHg8r1MM+SH4sKafoKXakim4EOt5afmfAk2LloHapG11eVkwxVMeDNH0OQNwK4CLHEg==
X-Received: by 2002:a62:53c3:: with SMTP id h186mr2089100pfb.118.1581355110168;
        Mon, 10 Feb 2020 09:18:30 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u12sm927912pfm.165.2020.02.10.09.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 09:18:29 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [stable 4.19][PATCH 1/3] serial: uartps: Add a timeout to the tx empty wait
Date:   Mon, 10 Feb 2020 10:18:25 -0700
Message-Id: <20200210171827.29693-2-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200210171827.29693-1-mathieu.poirier@linaro.org>
References: <20200210171827.29693-1-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

commit 277375b864e8147975b064b513f491e2a910e66a upstream

In case the cable is not connected then the target gets into
an infinite wait for tx empty.
Add a timeout to the tx empty wait.

Reported-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/tty/serial/xilinx_uartps.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 66d49d511885..7cbee19ea93d 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -26,6 +26,7 @@
 #include <linux/of.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
+#include <linux/iopoll.h>
 
 #define CDNS_UART_TTY_NAME	"ttyPS"
 #define CDNS_UART_NAME		"xuartps"
@@ -34,6 +35,7 @@
 #define CDNS_UART_NR_PORTS	2
 #define CDNS_UART_FIFO_SIZE	64	/* FIFO size */
 #define CDNS_UART_REGISTER_SPACE	0x1000
+#define TX_TIMEOUT		500000
 
 /* Rx Trigger level */
 static int rx_trigger_level = 56;
@@ -681,16 +683,20 @@ static void cdns_uart_set_termios(struct uart_port *port,
 	unsigned int cval = 0;
 	unsigned int baud, minbaud, maxbaud;
 	unsigned long flags;
-	unsigned int ctrl_reg, mode_reg;
+	unsigned int ctrl_reg, mode_reg, val;
+	int err;
 
 	spin_lock_irqsave(&port->lock, flags);
 
 	/* Wait for the transmit FIFO to empty before making changes */
 	if (!(readl(port->membase + CDNS_UART_CR) &
 				CDNS_UART_CR_TX_DIS)) {
-		while (!(readl(port->membase + CDNS_UART_SR) &
-				CDNS_UART_SR_TXEMPTY)) {
-			cpu_relax();
+		err = readl_poll_timeout(port->membase + CDNS_UART_SR,
+					 val, (val & CDNS_UART_SR_TXEMPTY),
+					 1000, TX_TIMEOUT);
+		if (err) {
+			dev_err(port->dev, "timed out waiting for tx empty");
+			return;
 		}
 	}
 
-- 
2.20.1

