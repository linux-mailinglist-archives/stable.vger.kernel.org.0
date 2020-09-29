Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A254D27C5F6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgI2Lkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbgI2Ljq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:39:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD86208FE;
        Tue, 29 Sep 2020 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379586;
        bh=m+xSef4FwMZXVWA4SuamimpYJjfqv4oVJa3zM60QY7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUQYnK1/v9wmpQ99/F54cMMMS64T71QNaAsaql/UlGOopnn3s0vCDLC6bN2he+Kv3
         DNks3U2J4BHGT1NPHapcP5Zx32pwpw6NrExHn7+Q6FiFOv+ckDZl+SPBot5mDIxQfr
         kTuWBYJ9g4pRcOHWpJJTw9yRFTiiJ44hNQkw4SVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/388] serial: uartps: Wait for tx_empty in console setup
Date:   Tue, 29 Sep 2020 12:59:21 +0200
Message-Id: <20200929110021.611317377@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raviteja Narayanam <raviteja.narayanam@xilinx.com>

[ Upstream commit 42e11948ddf68b9f799cad8c0ddeab0a39da33e8 ]

On some platforms, the log is corrupted while console is being
registered. It is observed that when set_termios is called, there
are still some bytes in the FIFO to be transmitted.

So, wait for tx_empty inside cdns_uart_console_setup before calling
set_termios.

Signed-off-by: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://lore.kernel.org/r/1586413563-29125-2-git-send-email-raviteja.narayanam@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/xilinx_uartps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 8948970f795e6..9359c80fbb9f5 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1248,6 +1248,7 @@ static int cdns_uart_console_setup(struct console *co, char *options)
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
+	unsigned long time_out;
 
 	if (!port->membase) {
 		pr_debug("console on " CDNS_UART_TTY_NAME "%i not present\n",
@@ -1258,6 +1259,13 @@ static int cdns_uart_console_setup(struct console *co, char *options)
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 
+	/* Wait for tx_empty before setting up the console */
+	time_out = jiffies + usecs_to_jiffies(TX_TIMEOUT);
+
+	while (time_before(jiffies, time_out) &&
+	       cdns_uart_tx_empty(port) != TIOCSER_TEMT)
+		cpu_relax();
+
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
-- 
2.25.1



