Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593121CAFD4
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgEHNUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgEHMkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 083BA24968;
        Fri,  8 May 2020 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941645;
        bh=GAhhMdqrgFZU8SpPG7rrdyTmVQd/GoU+MPeuqMB9giM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFDtb04XZ7UevkdDEgYXKJGyhDZLKDRoYAvtZcBGoypgfjZIWXdRseXzo1p00o3H3
         jB7aLCSQdcl7I7wZn6uQiVSGgmm6BIQNYlZ+ojjTJNXOzbp89WBiceXrRk5qllW3XN
         mw0g5qQkHFuOpa6ZIAgsySfB0ZsEC9qKPp7jINSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ivan T. Ivanov" <iivanov.xz@gmail.com>,
        Matthew McClintock <mmcclint@codeaurora.org>,
        Stephen Boyd <stephen.boyd@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Cristian Prundeanu <cprundea@codeaurora.org>
Subject: [PATCH 4.4 116/312] tty: serial: msm: Support more bauds
Date:   Fri,  8 May 2020 14:31:47 +0200
Message-Id: <20200508123132.630817362@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <stephen.boyd@linaro.org>

commit 98952bf510d0c7cdfc284f098bbf4682dc47bc61 upstream.

The msm_find_best_baud() function is written with the assumption
that the port->uartclk rate is fixed to a particular rate at boot
time, but now this driver changes that clk rate at runtime when
the baud is changed.

The way the hardware works is that an input clk rate comes from
the clk controller into the uart hw block. That rate is typically
1843200 or 3686400 Hz. That rate can then be divided by an
internal divider in the hw block to achieve a particular baud on
the serial wire. msm_find_best_baud() is looking for that divider
value.

A few things are wrong with the way the code is written. First,
it assumes that the maximum baud that the uart can support if the
clk rate is fixed at boot is 460800, which would correspond to an
input clk rate of 230400 * 16 == 3686400 Hz.  Except some devices
have a boot rate of 1843200 Hz or max baud of 115200, so
achieving 230400 on those devices doesn't work at all because we
don't increase the clk rate unless max baud is 460800.

Second, we can't achieve bauds higher than 460800 that require
anything besides a divisor of 1, because we always call
msm_find_best_baud() with a fixed port->uartclk rate that will
eventually be changed after we calculate the divisor. So if we
need to get a baud of 500000, we'll just multiply that by 16 and
hope that the clk can give us 500000 * 16 == 8000000 Hz, which it
typically can't do. To really achieve 500000 baud, we need to get
an input clk rate of 24000000 Hz and then divide that by 3 inside
the uart hardware.

Finally, we return success for bauds even when we can't actually
achieve them. This means that when the user asks for 500000 baud,
we actually get 921600 right now, but the user doesn't know that.

Fix all of this by searching through the divisor and clk rate
space with a combination of clk_round_rate() and baud
calculations, keeping track of the best clk rate and divisor we
find if we can't get an exact match. Typically we can get an
exact match with a divisor of 1, but sometimes we need to keep
track and try more frequencies. On my msm8916 device, this
results in all standard bauds in baud_table being supported
except for 1800, 576000, 1152000, and 4000000.

Fixes: 850b37a71bde ("tty: serial: msm: Remove 115.2 Kbps maximum baud rate limitation")
Cc: "Ivan T. Ivanov" <iivanov.xz@gmail.com>
Cc: Matthew McClintock <mmcclint@codeaurora.org>
Signed-off-by: Stephen Boyd <stephen.boyd@linaro.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Andy Gross <andy.gross@linaro.org>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Cristian Prundeanu <cprundea@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/msm_serial.c |  101 ++++++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 34 deletions(-)

--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -872,37 +872,72 @@ struct msm_baud_map {
 };
 
 static const struct msm_baud_map *
-msm_find_best_baud(struct uart_port *port, unsigned int baud)
+msm_find_best_baud(struct uart_port *port, unsigned int baud,
+		   unsigned long *rate)
 {
-	unsigned int i, divisor;
-	const struct msm_baud_map *entry;
+	struct msm_port *msm_port = UART_TO_MSM(port);
+	unsigned int divisor, result;
+	unsigned long target, old, best_rate = 0, diff, best_diff = ULONG_MAX;
+	const struct msm_baud_map *entry, *end, *best;
 	static const struct msm_baud_map table[] = {
-		{ 1536, 0x00,  1 },
-		{  768, 0x11,  1 },
-		{  384, 0x22,  1 },
-		{  192, 0x33,  1 },
-		{   96, 0x44,  1 },
-		{   48, 0x55,  1 },
-		{   32, 0x66,  1 },
-		{   24, 0x77,  1 },
-		{   16, 0x88,  1 },
-		{   12, 0x99,  6 },
-		{    8, 0xaa,  6 },
-		{    6, 0xbb,  6 },
-		{    4, 0xcc,  6 },
-		{    3, 0xdd,  8 },
-		{    2, 0xee, 16 },
 		{    1, 0xff, 31 },
-		{    0, 0xff, 31 },
+		{    2, 0xee, 16 },
+		{    3, 0xdd,  8 },
+		{    4, 0xcc,  6 },
+		{    6, 0xbb,  6 },
+		{    8, 0xaa,  6 },
+		{   12, 0x99,  6 },
+		{   16, 0x88,  1 },
+		{   24, 0x77,  1 },
+		{   32, 0x66,  1 },
+		{   48, 0x55,  1 },
+		{   96, 0x44,  1 },
+		{  192, 0x33,  1 },
+		{  384, 0x22,  1 },
+		{  768, 0x11,  1 },
+		{ 1536, 0x00,  1 },
 	};
 
-	divisor = uart_get_divisor(port, baud);
-
-	for (i = 0, entry = table; i < ARRAY_SIZE(table); i++, entry++)
-		if (entry->divisor <= divisor)
-			break;
+	best = table; /* Default to smallest divider */
+	target = clk_round_rate(msm_port->clk, 16 * baud);
+	divisor = DIV_ROUND_CLOSEST(target, 16 * baud);
+
+	end = table + ARRAY_SIZE(table);
+	entry = table;
+	while (entry < end) {
+		if (entry->divisor <= divisor) {
+			result = target / entry->divisor / 16;
+			diff = abs(result - baud);
+
+			/* Keep track of best entry */
+			if (diff < best_diff) {
+				best_diff = diff;
+				best = entry;
+				best_rate = target;
+			}
+
+			if (result == baud)
+				break;
+		} else if (entry->divisor > divisor) {
+			old = target;
+			target = clk_round_rate(msm_port->clk, old + 1);
+			/*
+			 * The rate didn't get any faster so we can't do
+			 * better at dividing it down
+			 */
+			if (target == old)
+				break;
+
+			/* Start the divisor search over at this new rate */
+			entry = table;
+			divisor = DIV_ROUND_CLOSEST(target, 16 * baud);
+			continue;
+		}
+		entry++;
+	}
 
-	return entry; /* Default to smallest divider */
+	*rate = best_rate;
+	return best;
 }
 
 static int msm_set_baud_rate(struct uart_port *port, unsigned int baud,
@@ -911,22 +946,20 @@ static int msm_set_baud_rate(struct uart
 	unsigned int rxstale, watermark, mask;
 	struct msm_port *msm_port = UART_TO_MSM(port);
 	const struct msm_baud_map *entry;
-	unsigned long flags;
-
-	entry = msm_find_best_baud(port, baud);
-
-	msm_write(port, entry->code, UART_CSR);
-
-	if (baud > 460800)
-		port->uartclk = baud * 16;
+	unsigned long flags, rate;
 
 	flags = *saved_flags;
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	clk_set_rate(msm_port->clk, port->uartclk);
+	entry = msm_find_best_baud(port, baud, &rate);
+	clk_set_rate(msm_port->clk, rate);
+	baud = rate / 16 / entry->divisor;
 
 	spin_lock_irqsave(&port->lock, flags);
 	*saved_flags = flags;
+	port->uartclk = rate;
+
+	msm_write(port, entry->code, UART_CSR);
 
 	/* RX stale watermark */
 	rxstale = entry->rxstale;


