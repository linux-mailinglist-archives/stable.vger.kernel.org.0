Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D558B5939AA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243864AbiHOT2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344344AbiHOT0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CAD2F025;
        Mon, 15 Aug 2022 11:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A74161120;
        Mon, 15 Aug 2022 18:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE78C433C1;
        Mon, 15 Aug 2022 18:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588955;
        bh=FpJB5bvoHtxoOMqSH9y0L+Uu18qnX9Iul8pE4PGs3mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuA5Y0/N9rXxyGKIVSMwsLk/tQUA7oy+DbimA+0eGD3a761bqlfrQ9jLs7GNA10Aw
         yeSISY2ecr/NwHq3QVezL2SEYsn9Nod+uMehF1/A6I2GnE9/qxaT5eYVFGhSVA50+/
         vRFnroH4mapjs4bUSaJRykAh4PY2aDGO8HGtHZ7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 568/779] serial: 8250: Export ICR access helpers for internal use
Date:   Mon, 15 Aug 2022 20:03:32 +0200
Message-Id: <20220815180401.606383226@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit cb5a40e3143bc64437858b337273fd63cc42e9c2 ]

Make ICR access helpers available outside 8250_port.c, however retain
them as ordinary static functions so as not to regress code generation.

This is because `serial_icr_write' is currently automatically inlined by
GCC, however `serial_icr_read' is not.  Making them both static inline
would grow code produced, e.g.:

$ i386-linux-gnu-size --format=gnu 8250_port-{old,new}.o
      text       data        bss      total filename
     15065       3378          0      18443 8250_port-old.o
     15289       3378          0      18667 8250_port-new.o

and:

$ riscv64-linux-gnu-size --format=gnu 8250_port-{old,new}.o
      text       data        bss      total filename
     16980       5306          0      22286 8250_port-old.o
     17124       5306          0      22430 8250_port-new.o

while making them external would needlessly add a new module interface
and lose the benefit from `serial_icr_write' getting inlined outside
8250_port.o.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2204181517500.9383@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h      | 22 ++++++++++++++++++++++
 drivers/tty/serial/8250/8250_port.c | 21 ---------------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 6473361525d1..0efe4df24622 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -120,6 +120,28 @@ static inline void serial_out(struct uart_8250_port *up, int offset, int value)
 	up->port.serial_out(&up->port, offset, value);
 }
 
+/*
+ * For the 16C950
+ */
+static void serial_icr_write(struct uart_8250_port *up, int offset, int value)
+{
+	serial_out(up, UART_SCR, offset);
+	serial_out(up, UART_ICR, value);
+}
+
+static unsigned int __maybe_unused serial_icr_read(struct uart_8250_port *up,
+						   int offset)
+{
+	unsigned int value;
+
+	serial_icr_write(up, UART_ACR, up->acr | UART_ACR_ICRRD);
+	serial_out(up, UART_SCR, offset);
+	value = serial_in(up, UART_ICR);
+	serial_icr_write(up, UART_ACR, up->acr);
+
+	return value;
+}
+
 void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p);
 
 static inline int serial_dl_read(struct uart_8250_port *up)
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 4f66825abe67..a5496bd1b650 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -537,27 +537,6 @@ serial_port_out_sync(struct uart_port *p, int offset, int value)
 	}
 }
 
-/*
- * For the 16C950
- */
-static void serial_icr_write(struct uart_8250_port *up, int offset, int value)
-{
-	serial_out(up, UART_SCR, offset);
-	serial_out(up, UART_ICR, value);
-}
-
-static unsigned int serial_icr_read(struct uart_8250_port *up, int offset)
-{
-	unsigned int value;
-
-	serial_icr_write(up, UART_ACR, up->acr | UART_ACR_ICRRD);
-	serial_out(up, UART_SCR, offset);
-	value = serial_in(up, UART_ICR);
-	serial_icr_write(up, UART_ACR, up->acr);
-
-	return value;
-}
-
 /*
  * FIFO support.
  */
-- 
2.35.1



