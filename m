Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56936BE861
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 12:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCQLhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 07:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCQLhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 07:37:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2C27DF99;
        Fri, 17 Mar 2023 04:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679053019; x=1710589019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oj+MDhOnw3pN6BYpBSobzTzyxp4QKVLPwC+c/f3C9wg=;
  b=TGaXS/+BP1wf0f9KWFAnwausPPIEDwCtfDqBL2gnXlOeGvg9tdqhZZDy
   4NehVAfBIgxZCGBdETFphH59IREBKEk+46Lt1C4pqbQQgwrcuQ1Coafhe
   nl9XiGgXYabYMEeQ9dF5liGxXH1z3bDbkvhZwhTOBssikgD3aU8pbFgaP
   c7AXSZSWzfIjYBciSTFEtinh2GjiOVLsUxSZ5vuvFqFwEhdzHC/FXZVWJ
   D7NZIUWTgN4A4PwNx9JMYpZTrRtgUhbzOLbY8ml3YzxKahByJwUtOogGy
   DTy8U0UPBayjz4lu8MyH7knvrYwK5v1TviD2tcnV6FKl7dPnRlAe5dgEZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339779175"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339779175"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 04:33:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="680270128"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="680270128"
Received: from bstach-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.251.221.222])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 04:33:34 -0700
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] serial: 8250: Fix serial8250_tx_empty() race with DMA Tx
Date:   Fri, 17 Mar 2023 13:33:18 +0200
Message-Id: <20230317113318.31327-3-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230317113318.31327-1-ilpo.jarvinen@linux.intel.com>
References: <20230317113318.31327-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's a potential race before THRE/TEMT deasserts when DMA Tx is
starting up (or the next batch of continuous Tx is being submitted).
This can lead to misdetecting Tx empty condition.

It is entirely normal for THRE/TEMT to be set for some time after the
DMA Tx had been setup in serial8250_tx_dma(). As Tx side is definitely
not empty at that point, it seems incorrect for serial8250_tx_empty()
claim Tx is empty.

Fix the race by also checking in serial8250_tx_empty() whether there's
DMA Tx active.

Note: This fix only addresses in-kernel race mainly to make using
TCSADRAIN/FLUSH robust. Userspace can still cause other races but they
seem userspace concurrency control problems.

Fixes: 9ee4b83e51f74 ("serial: 8250: Add support for dmaengine")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/serial/8250/8250.h      | 12 ++++++++++++
 drivers/tty/serial/8250/8250_port.c |  7 ++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 287153d32536..1e8fe44a7099 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -365,6 +365,13 @@ static inline void serial8250_do_prepare_rx_dma(struct uart_8250_port *p)
 	if (dma->prepare_rx_dma)
 		dma->prepare_rx_dma(p);
 }
+
+static inline bool serial8250_tx_dma_running(struct uart_8250_port *p)
+{
+	struct uart_8250_dma *dma = p->dma;
+
+	return dma && dma->tx_running;
+}
 #else
 static inline int serial8250_tx_dma(struct uart_8250_port *p)
 {
@@ -380,6 +387,11 @@ static inline int serial8250_request_dma(struct uart_8250_port *p)
 	return -1;
 }
 static inline void serial8250_release_dma(struct uart_8250_port *p) { }
+
+static inline bool serial8250_tx_dma_running(struct uart_8250_port *p)
+{
+	return false;
+}
 #endif
 
 static inline int ns16550a_goto_highspeed(struct uart_8250_port *up)
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index fa43df05342b..107bcdfb119c 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2005,18 +2005,19 @@ static int serial8250_tx_threshold_handle_irq(struct uart_port *port)
 static unsigned int serial8250_tx_empty(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
+	unsigned int result = 0;
 	unsigned long flags;
-	u16 lsr;
 
 	serial8250_rpm_get(up);
 
 	spin_lock_irqsave(&port->lock, flags);
-	lsr = serial_lsr_in(up);
+	if (!serial8250_tx_dma_running(up) && uart_lsr_tx_empty(serial_lsr_in(up)))
+		result = TIOCSER_TEMT;
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	serial8250_rpm_put(up);
 
-	return uart_lsr_tx_empty(lsr) ? TIOCSER_TEMT : 0;
+	return result;
 }
 
 unsigned int serial8250_do_get_mctrl(struct uart_port *port)
-- 
2.30.2

