Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842A3594DC1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiHPAmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244919AbiHPAjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:39:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31CAD34F9;
        Mon, 15 Aug 2022 13:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C6898CE12C6;
        Mon, 15 Aug 2022 20:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EE5C433C1;
        Mon, 15 Aug 2022 20:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595920;
        bh=wiCUhAHDhxGJi4ufS9Hr7pAE+pr7JKbHhtWjygcB68g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTyNcYHoAvXzX4Xb6P/G5omJcdat1toIjRbjvzAnEw6tR1k7NFzfBmxSP5g9tsoZH
         iBKuLkwhGrwtN5awWwifJ82p0OPESw73EuQlLlkjL5qh30Wp4DtvDgP+NsQicHoNH0
         6YHmm2xQtSg3LVoiD/6+6Aq/sOs1b8vTlei0hCN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0899/1157] serial: 8250: Create serial_lsr_in()
Date:   Mon, 15 Aug 2022 20:04:15 +0200
Message-Id: <20220815180515.413383265@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit bdb70c424df1543bc02ee2639aecebd20318c599 ]

LSR register readers need to be careful in order to not lose bits that
are not preserved across reads. Create a helper that takes care of
storing the non-preserved bits into lsr_save_flags.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220608095431.18376-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h      | 20 ++++++++++++++++++++
 drivers/tty/serial/8250/8250_core.c |  3 +--
 drivers/tty/serial/8250/8250_port.c | 15 ++++-----------
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 696030cfcb09..c89cb881d9b0 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -123,6 +123,26 @@ static inline void serial_out(struct uart_8250_port *up, int offset, int value)
 	up->port.serial_out(&up->port, offset, value);
 }
 
+/**
+ *	serial_lsr_in - Read LSR register and preserve flags across reads
+ *	@up:	uart 8250 port
+ *
+ *	Read LSR register and handle saving non-preserved flags across reads.
+ *	The flags that are not preserved across reads are stored into
+ *	up->lsr_saved_flags.
+ *
+ *	Returns LSR value or'ed with the preserved flags (if any).
+ */
+static inline unsigned int serial_lsr_in(struct uart_8250_port *up)
+{
+	unsigned int lsr = up->lsr_saved_flags;
+
+	lsr |= serial_in(up, UART_LSR);
+	up->lsr_saved_flags = lsr & LSR_SAVE_FLAGS;
+
+	return lsr;
+}
+
 /*
  * For the 16C950
  */
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 3f56dbc9432b..82726cda6066 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -277,8 +277,7 @@ static void serial8250_backup_timeout(struct timer_list *t)
 	 * the "Diva" UART used on the management processor on many HP
 	 * ia64 and parisc boxes.
 	 */
-	lsr = serial_in(up, UART_LSR);
-	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+	lsr = serial_lsr_in(up);
 	if ((iir & UART_IIR_NO_INT) && (up->ier & UART_IER_THRI) &&
 	    (!uart_circ_empty(&up->port.state->xmit) || up->port.x_char) &&
 	    (lsr & UART_LSR_THRE)) {
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 3c36a06a20b0..c9d8c0de56e5 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1514,11 +1514,9 @@ static inline void __stop_tx(struct uart_8250_port *p)
 	struct uart_8250_em485 *em485 = p->em485;
 
 	if (em485) {
-		unsigned char lsr = serial_in(p, UART_LSR);
+		unsigned char lsr = serial_lsr_in(p);
 		u64 stop_delay = 0;
 
-		p->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
-
 		if (!(lsr & UART_LSR_THRE))
 			return;
 		/*
@@ -1573,10 +1571,8 @@ static inline void __start_tx(struct uart_port *port)
 
 	if (serial8250_set_THRI(up)) {
 		if (up->bugs & UART_BUG_TXEN) {
-			unsigned char lsr;
+			unsigned char lsr = serial_lsr_in(up);
 
-			lsr = serial_in(up, UART_LSR);
-			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 			if (lsr & UART_LSR_THRE)
 				serial8250_tx_chars(up);
 		}
@@ -2007,8 +2003,7 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 	serial8250_rpm_get(up);
 
 	spin_lock_irqsave(&port->lock, flags);
-	lsr = serial_port_in(port, UART_LSR);
-	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+	lsr = serial_lsr_in(up);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	serial8250_rpm_put(up);
@@ -2084,9 +2079,7 @@ static void wait_for_lsr(struct uart_8250_port *up, int bits)
 
 	/* Wait up to 10ms for the character(s) to be sent. */
 	for (;;) {
-		status = serial_in(up, UART_LSR);
-
-		up->lsr_saved_flags |= status & LSR_SAVE_FLAGS;
+		status = serial_lsr_in(up);
 
 		if ((status & bits) == bits)
 			break;
-- 
2.35.1



