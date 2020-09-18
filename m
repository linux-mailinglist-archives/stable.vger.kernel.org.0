Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C1726EEE4
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgIRCOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgIRCOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:14:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B205235F7;
        Fri, 18 Sep 2020 02:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395243;
        bh=l7eZ+IuUZr3FsHWocPjrOiHuzqlDZdcZ2YFLBf3I80U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYV4y29x9WI8Otos16K818cQiNIeRePdPnonKReXaSPFGzSZAebdB8eAofb7oRjKP
         6AdGh5/TUQ8+dTtxiglY95gsfVf4DT+CtqwqAlVbEj/35mXjnS1zhGsxc2n6MMLBc8
         uWRErpdCCbHAilpZGm+NGAfPZDCGsN7G7d3dUmXU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 086/127] serial: uartps: Wait for tx_empty in console setup
Date:   Thu, 17 Sep 2020 22:11:39 -0400
Message-Id: <20200918021220.2066485-86-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 81657f09761cd..00a740b8ad273 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1282,6 +1282,7 @@ static int cdns_uart_console_setup(struct console *co, char *options)
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
+	unsigned long time_out;
 
 	if (co->index < 0 || co->index >= CDNS_UART_NR_PORTS)
 		return -EINVAL;
@@ -1295,6 +1296,13 @@ static int cdns_uart_console_setup(struct console *co, char *options)
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

