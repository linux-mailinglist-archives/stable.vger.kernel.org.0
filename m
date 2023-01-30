Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8212E680C6D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 12:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbjA3Lti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 06:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbjA3Lte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 06:49:34 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE13302AE;
        Mon, 30 Jan 2023 03:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675079340; x=1706615340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1aAVjEMEdMZvo9HiV4gShN/TM1rGG+YhOk2STJnCQV0=;
  b=P2pEL8qs2T43BEuNGhaK+sj+noDuIWlXHkA0aigKjZ5uc2MDvtYONBVn
   5mpytFK5uffHjZdg7c45Y3MHUwtLM230nG7oO8KGRapd/J3lchNj1s4qQ
   Th/dhJ+fDY70WhcS+rwBWc4nT6w+aee+4+itf83YJ12aECte6w633/Tap
   g5QKPCkVb/c7W99WfaBRN1be57UhL9wOXlWseeR5n7yI1nqxLhZnhm7Mr
   Yf0JfBDnSUEkWTxEsWLXPl0IQuEe0RucGpMheytfALAWOuuh5y/PvW556
   Uwe0fG5dqe7zwXPYN1eIfupEkW3PcbQIdBi1ei0xihskU9Bhh0Tfn7AuJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="307882349"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="307882349"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 03:48:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="732672101"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="732672101"
Received: from nbelenko-mobl.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.251.210.56])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 03:48:53 -0800
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
Subject: [PATCH 1/2] serial: 8250_dma: Fix DMA Rx completion race
Date:   Mon, 30 Jan 2023 13:48:40 +0200
Message-Id: <20230130114841.25749-2-ilpo.jarvinen@linux.intel.com>
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

__dma_rx_complete() is called from two places:
  - Through the DMA completion callback dma_rx_complete()
  - From serial8250_rx_dma_flush() after IIR_RLSI or IIR_RX_TIMEOUT
The former does not hold port's lock during __dma_rx_complete() which
allows these two to race and potentially insert the same data twice.

Extend port's lock coverage in dma_rx_complete() to prevent the race
and check if the DMA Rx is still pending completion before calling
into __dma_rx_complete().

Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
Fixes: 9ee4b83e51f7 ("serial: 8250: Add support for dmaengine")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 37d6af2ec427..5594883a96f8 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -62,9 +62,14 @@ static void dma_rx_complete(void *param)
 	struct uart_8250_dma *dma = p->dma;
 	unsigned long flags;
 
-	__dma_rx_complete(p);
-
 	spin_lock_irqsave(&p->port.lock, flags);
+	if (dma->rx_running)
+		__dma_rx_complete(p);
+
+	/*
+	 * Cannot be combined with the previous check because __dma_rx_complete()
+	 * changes dma->rx_running.
+	 */
 	if (!dma->rx_running && (serial_lsr_in(p) & UART_LSR_DR))
 		p->dma->rx_dma(p);
 	spin_unlock_irqrestore(&p->port.lock, flags);
-- 
2.30.2

