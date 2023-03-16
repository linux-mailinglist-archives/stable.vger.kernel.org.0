Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27386BD0C4
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 14:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCPNZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 09:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjCPNZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 09:25:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D653D6153B;
        Thu, 16 Mar 2023 06:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678973109; x=1710509109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=caNHCSlVv04vW8WvdqMIWsxEprIGBrrELmdQAJ/JIYA=;
  b=ODb8F5tPaypLeU+lek2ibIsO+9nu+sVdvHeQhuA76WTrY88O3Gey7xr3
   Tzlo5Ko3+qdAzM4dJe7pu5e0CddMtBWdVoLZUAR2YTT/n3v6YoJnpoSHQ
   byOPnicQHjfQjWyWiB2N00f1d/5etty+DYFBYRvnNTyxVG6M8lVtL9qAw
   ebef0iIJHr9trCFhbV+GxkIpIMv4L5gE2ycp/+r3UGGTKaipGxpFQjYkH
   TXvu0jKj3JFpEiZU2/LWi4kYzhozzoFThgla1XxkdFiqa6wNDQYLlP5II
   r0frPhHKV51Y2J4faeOsrSomUxlIlQ7uMxznTXuhp0MwWoUzIhT/Np8I4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="338003211"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="338003211"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 06:25:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="710109180"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="710109180"
Received: from trybicki-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.63.119])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 06:25:07 -0700
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] serial: 8250: Fix serial8250_tx_empty() race with DMA Tx
Date:   Thu, 16 Mar 2023 15:24:52 +0200
Message-Id: <20230316132452.76478-3-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230316132452.76478-1-ilpo.jarvinen@linux.intel.com>
References: <20230316132452.76478-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/tty/serial/8250/8250_port.c |  7 ++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

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
index fa43df05342b..4954c4f15fb2 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2006,17 +2006,22 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned long flags;
+	bool dma_tx_running;
 	u16 lsr;
 
 	serial8250_rpm_get(up);
 
 	spin_lock_irqsave(&port->lock, flags);
 	lsr = serial_lsr_in(up);
+	dma_tx_running = serial8250_tx_dma_running(up);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	serial8250_rpm_put(up);
 
-	return uart_lsr_tx_empty(lsr) ? TIOCSER_TEMT : 0;
+	if (uart_lsr_tx_empty(lsr) && !dma_tx_running)
+		return TIOCSER_TEMT;
+
+	return 0;
 }
 
 unsigned int serial8250_do_get_mctrl(struct uart_port *port)
-- 
2.30.2

