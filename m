Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D8680C6F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 12:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbjA3Ltk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 06:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbjA3Lte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 06:49:34 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591F72E0E2;
        Mon, 30 Jan 2023 03:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675079341; x=1706615341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bYJP1A6JkuOysLMcEjWclQ2PMsPwKTj9ekGqoouYmnY=;
  b=GEJY6wHSyRzjQ4y+np20FcBDixZ92effQSMs/lUwBZjdQUqmVbsna7xc
   zY07IZmnUBWQiX27XqyHvdd8hMvlE3vrTNDFPi5dUzm9OLnCsetdwY0aC
   rq0dnWDUQ7JORtMJ9Ry7BczOhRBYhYl7uyCQKD7WAsdvvilxWNj2JTdI4
   Mkc5EXPY87xvLOcqIaTbioUCg/u1npykoj7VtikkRyOaL2R3TdhinxXu7
   deRFLUBjv4dJjsQgykA980CzmDAYcjTdKs8szIMr3KZ1nwysadDr7zLpe
   36/5vCtpWNynFnfld2oSgY+sJgkn7C/d/4LCW5ZWzozJtNwI6WUiQNTEQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="307882359"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="307882359"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 03:49:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="732672116"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="732672116"
Received: from nbelenko-mobl.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.251.210.56])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 03:48:57 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-serial@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Gilles BULOZ <gilles.buloz@kontron.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] serial: 8250_dma: Fix DMA Rx rearm race
Date:   Mon, 30 Jan 2023 13:48:41 +0200
Message-Id: <20230130114841.25749-3-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230130114841.25749-1-ilpo.jarvinen@linux.intel.com>
References: <20230130114841.25749-1-ilpo.jarvinen@linux.intel.com>
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

As DMA Rx can be completed from two places, it is possible that DMA Rx
completes before DMA completion callback had a chance to complete it.
Once the previous DMA Rx has been completed, a new one can be started
on the next UART interrupt. The following race is possible
(uart_unlock_and_check_sysrq_irqrestore() replaced with
spin_unlock_irqrestore() for simplicity/clarity):

CPU0					CPU1
					dma_rx_complete()
serial8250_handle_irq()
  spin_lock_irqsave(&port->lock)
  handle_rx_dma()
    serial8250_rx_dma_flush()
      __dma_rx_complete()
        dma->rx_running = 0
        // Complete DMA Rx
  spin_unlock_irqrestore(&port->lock)

serial8250_handle_irq()
  spin_lock_irqsave(&port->lock)
  handle_rx_dma()
    serial8250_rx_dma()
      dma->rx_running = 1
      // Setup a new DMA Rx
  spin_unlock_irqrestore(&port->lock)

					  spin_lock_irqsave(&port->lock)
					  // sees dma->rx_running = 1
					  __dma_rx_complete()
					    dma->rx_running = 0
					    // Incorrectly complete
					    // running DMA Rx

This race seems somewhat theoretical to occur for real but handle it
correctly regardless. Check what is the DMA status before complething
anything in __dma_rx_complete().

Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
Fixes: 9ee4b83e51f7 ("serial: 8250: Add support for dmaengine")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dma.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 5594883a96f8..7fa66501792d 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -43,15 +43,23 @@ static void __dma_rx_complete(struct uart_8250_port *p)
 	struct uart_8250_dma	*dma = p->dma;
 	struct tty_port		*tty_port = &p->port.state->port;
 	struct dma_tx_state	state;
+	enum dma_status		dma_status;
 	int			count;
 
-	dma->rx_running = 0;
-	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	/*
+	 * New DMA Rx can be started during the completion handler before it
+	 * could acquire port's lock and it might still be ongoing. Don't to
+	 * anything in such case.
+	 */
+	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	if (dma_status == DMA_IN_PROGRESS)
+		return;
 
 	count = dma->rx_size - state.residue;
 
 	tty_insert_flip_string(tty_port, dma->rx_buf, count);
 	p->port.icount.rx += count;
+	dma->rx_running = 0;
 
 	tty_flip_buffer_push(tty_port);
 }
-- 
2.30.2

