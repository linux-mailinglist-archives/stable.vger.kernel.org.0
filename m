Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8ED227C8D4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbgI2ME6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730278AbgI2Lhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9943B23BDC;
        Tue, 29 Sep 2020 11:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379439;
        bh=t1/7PI1zWYp0da7HkWLYurYjOzus+3WqUlBZAjgUN6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqPPd0zw17ELK6s11LYF+7+9LJSpqOS+rQov6gB96c4fk0PDK1Ohulk93dq1qc8/2
         4XtBTjs0r4ROILBjliQ8uASZE8oT1YdWOQeycNQpDMiZ7XU4EUkPrIng2KxgW5HV/n
         8/CzMIWBGOh8ruXMHEakCJkYAm2MGRgkY6FPCqkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Yash Shah <yash.shah@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/388] tty: sifive: Finish transmission before changing the clock
Date:   Tue, 29 Sep 2020 12:58:15 +0200
Message-Id: <20200929110018.420385669@linuxfoundation.org>
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

From: Palmer Dabbelt <palmerdabbelt@google.com>

[ Upstream commit 4cbd7814bbd595061fcb6d6355d63f04179161cd ]

SiFive's UART has a software controller clock divider that produces the
final baud rate clock.  Whenever the clock that drives the UART is
changed this divider must be updated accordingly, and given that these
two events are controlled by software they cannot be done atomically.
During the period between updating the UART's driving clock and internal
divider the UART will transmit a different baud rate than what the user
has configured, which will probably result in a corrupted transmission
stream.

The SiFive UART has a FIFO, but due to an issue with the programming
interface there is no way to directly determine when the UART has
finished transmitting.  We're essentially restricted to dead reckoning
in order to figure that out: we can use the FIFO's TX busy register to
figure out when the last frame has begun transmission and just delay for
a long enough that the last frame is guaranteed to get out.

As far as the actual implementation goes: I've modified the existing
existing clock notifier function to drain both the FIFO and the shift
register in on PRE_RATE_CHANGE.  As far as I know there is no hardware
flow control in this UART, so there's no good way to ask the other end
to stop transmission while we can't receive (inserting software flow
control messages seems like a bad idea here).

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Tested-by: Yash Shah <yash.shah@sifive.com>
Link: https://lore.kernel.org/r/20200307042637.83728-1-palmer@dabbelt.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sifive.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index 38133eba83a87..b4343c6aa6512 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -618,10 +618,10 @@ static void sifive_serial_shutdown(struct uart_port *port)
  *
  * On the V0 SoC, the UART IP block is derived from the CPU clock source
  * after a synchronous divide-by-two divider, so any CPU clock rate change
- * requires the UART baud rate to be updated.  This presumably could corrupt any
- * serial word currently being transmitted or received.  It would probably
- * be better to stop receives and transmits, then complete the baud rate
- * change, then re-enable them.
+ * requires the UART baud rate to be updated.  This presumably corrupts any
+ * serial word currently being transmitted or received.  In order to avoid
+ * corrupting the output data stream, we drain the transmit queue before
+ * allowing the clock's rate to be changed.
  */
 static int sifive_serial_clk_notifier(struct notifier_block *nb,
 				      unsigned long event, void *data)
@@ -629,6 +629,26 @@ static int sifive_serial_clk_notifier(struct notifier_block *nb,
 	struct clk_notifier_data *cnd = data;
 	struct sifive_serial_port *ssp = notifier_to_sifive_serial_port(nb);
 
+	if (event == PRE_RATE_CHANGE) {
+		/*
+		 * The TX watermark is always set to 1 by this driver, which
+		 * means that the TX busy bit will lower when there are 0 bytes
+		 * left in the TX queue -- in other words, when the TX FIFO is
+		 * empty.
+		 */
+		__ssp_wait_for_xmitr(ssp);
+		/*
+		 * On the cycle the TX FIFO goes empty there is still a full
+		 * UART frame left to be transmitted in the shift register.
+		 * The UART provides no way for software to directly determine
+		 * when that last frame has been transmitted, so we just sleep
+		 * here instead.  As we're not tracking the number of stop bits
+		 * they're just worst cased here.  The rest of the serial
+		 * framing parameters aren't configurable by software.
+		 */
+		udelay(DIV_ROUND_UP(12 * 1000 * 1000, ssp->baud_rate));
+	}
+
 	if (event == POST_RATE_CHANGE && ssp->clkin_rate != cnd->new_rate) {
 		ssp->clkin_rate = cnd->new_rate;
 		__ssp_update_div(ssp);
-- 
2.25.1



