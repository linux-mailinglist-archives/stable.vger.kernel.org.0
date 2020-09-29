Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEC127CD42
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbgI2Mm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbgI2LKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:10:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916D321941;
        Tue, 29 Sep 2020 11:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377800;
        bh=Dd2IIfqWNOxZS/KJqjmO+3MX84wfs40Ps0T9VYm1znU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNVmMkK43tEauOVWMUok8K4dEx1bwKCtBYTw2DlQdDnGDygrTeQUFTVOS+wOzgsqt
         sKFxaCzuUjxTaj9XZ1U3WZCxPVLLRKt7vTqHzTNo9CLroDO7E0TS+sFW99rl3fRPk6
         gH5GnSO/PYW1NU9R2EKzH8SZCGmZN7uZuMsngop8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 076/121] serial: uartps: Wait for tx_empty in console setup
Date:   Tue, 29 Sep 2020 13:00:20 +0200
Message-Id: <20200929105933.946548718@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
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
 drivers/tty/serial/xilinx_uartps.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1274,6 +1274,7 @@ static int cdns_uart_console_setup(struc
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
+	unsigned long time_out;
 
 	if (co->index < 0 || co->index >= CDNS_UART_NR_PORTS)
 		return -EINVAL;
@@ -1287,6 +1288,13 @@ static int cdns_uart_console_setup(struc
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
 


