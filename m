Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DF1675976
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 17:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjATQDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 11:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjATQDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 11:03:44 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EF9366A1;
        Fri, 20 Jan 2023 08:03:43 -0800 (PST)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 7964E8543D;
        Fri, 20 Jan 2023 17:03:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1674230621;
        bh=7iwSVJjWAqytyJHFAvrWcuyVaAWRsRuLmc4hzjx3SH4=;
        h=From:To:Cc:Subject:Date:From;
        b=u4ucBSHkvElRXE7poayhV2cS1jbQdSrPpppaO5iY8Rod6E/jTl91xwwAGKn+4BRmS
         R9RFuro0SPbq1h7t4MCcJEHJqFKVh3sgOmaa9uEge6nffl4kLBjVMjhvfEWTFsCjxp
         sczbtXmiACT8DUB1zPWc4ms0ebuFOFOE866bXu4UBvxSiT3uLaBRUQjI4ki7mJ+ako
         zqvGgyceWd3U1O03hsmvMVCzbVCNU2uH2pm/7289vBdhnAr80k64K7VjIEeoA2ISYw
         FTorpQrE3GEv4mLzBmCAwXoyMhi4kLy44vXsVpq226rsMXubfLJL1fgL6J27/jNBsR
         86rz1V7tQlhcQ==
From:   Marek Vasut <marex@denx.de>
To:     linux-serial@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Caron <valentin.caron@foss.st.com>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Erwan Le Ray <erwan.leray@foss.st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v6] serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler
Date:   Fri, 20 Jan 2023 17:03:32 +0100
Message-Id: <20230120160332.57930-1-marex@denx.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Requesting an interrupt with IRQF_ONESHOT will run the primary handler
in the hard-IRQ context even in the force-threaded mode. The
force-threaded mode is used by PREEMPT_RT in order to avoid acquiring
sleeping locks (spinlock_t) in hard-IRQ context. This combination
makes it impossible and leads to "sleeping while atomic" warnings.

Use one interrupt handler for both handlers (primary and secondary)
and drop the IRQF_ONESHOT flag which is not needed.

Fixes: e359b4411c283 ("serial: stm32: fix threaded interrupt handling")
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Valentin Caron <valentin.caron@foss.st.com> # V3
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
---
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Erwan Le Ray <erwan.leray@foss.st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Caron <valentin.caron@foss.st.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-serial@vger.kernel.org
---
V2: - Update patch subject, was:
      serial: stm32: Move hard IRQ handling to threaded interrupt context
    - Use request_irq() instead, rename the IRQ handler function
V3: - Update the commit message per suggestion from Sebastian
    - Add RB from Sebastian
    - Add Fixes tag
V4: - Remove uart_console() deadlock check from
      stm32_usart_of_dma_rx_probe()
    - Use plain spin_lock()/spin_unlock() instead of the
      _irqsave/_irqrestore variants in IRQ handler
    - Add TB from Valentin
V5: - Add CC stable@
    - Do not move the sr variable, removes one useless hunk from the patch
V6: - Replace uart_unlock_and_check_sysrq_irqrestore with uart_unlock_and_check_sysrq
      and drop last instance of flags
---
 drivers/tty/serial/stm32-usart.c | 33 +++++---------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index a1490033aa164..409e91d6829a5 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -797,25 +797,11 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 		spin_unlock(&port->lock);
 	}
 
-	if (stm32_usart_rx_dma_enabled(port))
-		return IRQ_WAKE_THREAD;
-	else
-		return IRQ_HANDLED;
-}
-
-static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
-{
-	struct uart_port *port = ptr;
-	struct tty_port *tport = &port->state->port;
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	unsigned int size;
-	unsigned long flags;
-
 	/* Receiver timeout irq for DMA RX */
-	if (!stm32_port->throttled) {
-		spin_lock_irqsave(&port->lock, flags);
+	if (stm32_usart_rx_dma_enabled(port) && !stm32_port->throttled) {
+		spin_lock(&port->lock);
 		size = stm32_usart_receive_chars(port, false);
-		uart_unlock_and_check_sysrq_irqrestore(port, flags);
+		uart_unlock_and_check_sysrq(port);
 		if (size)
 			tty_flip_buffer_push(tport);
 	}
@@ -1015,10 +1001,8 @@ static int stm32_usart_startup(struct uart_port *port)
 	u32 val;
 	int ret;
 
-	ret = request_threaded_irq(port->irq, stm32_usart_interrupt,
-				   stm32_usart_threaded_interrupt,
-				   IRQF_ONESHOT | IRQF_NO_SUSPEND,
-				   name, port);
+	ret = request_irq(port->irq, stm32_usart_interrupt,
+			  IRQF_NO_SUSPEND, name, port);
 	if (ret)
 		return ret;
 
@@ -1601,13 +1585,6 @@ static int stm32_usart_of_dma_rx_probe(struct stm32_port *stm32port,
 	struct dma_slave_config config;
 	int ret;
 
-	/*
-	 * Using DMA and threaded handler for the console could lead to
-	 * deadlocks.
-	 */
-	if (uart_console(port))
-		return -ENODEV;
-
 	stm32port->rx_buf = dma_alloc_coherent(dev, RX_BUF_L,
 					       &stm32port->rx_dma_buf,
 					       GFP_KERNEL);
-- 
2.39.0

