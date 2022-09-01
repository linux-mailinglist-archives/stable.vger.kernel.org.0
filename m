Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB17A5A9A9A
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 16:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiIAOkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 10:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiIAOj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 10:39:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF37E5FBA;
        Thu,  1 Sep 2022 07:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662043197; x=1693579197;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jlOuWqXv3W1+nK5gEHgXZ0S9vII+w0v5W+k4c+5u558=;
  b=LWhEGaS192pV68s6tvCPsqbsL/IGxA/QTx1mPdDSZG3eqDxvRjzoJycv
   EGLzvzK+wRwAbffRygl45L+gvsOx5q2rBUdFdIdWYgCV/K7PI1eyBF/Pf
   5UThP9xQ619moO/1feja22r7CIwRyKoDxmwH2RyBlTmvulShIxMxrGUuZ
   J4ukkmY8KHtVQzJmdKmOX8aFkBt7M7G1gaPt6o+j2mfnrRTT60K2xiQjr
   hqSS7p2MQ/L+gQLPDX0lLG74H/cRqtan4km3ByYFcDib/U9M1dgs7gA8v
   4dmUgBxo7kBPWNdtti+MSMY6B3wY9UGsgvB410NTzbMGZt3XL62iErFit
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="359690403"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="359690403"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 07:39:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="642356668"
Received: from rmalliu-mobl.amr.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.249.44.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 07:39:50 -0700
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alan Cox <alan@linux.intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v2 RESEND 2/3] serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting
Date:   Thu,  1 Sep 2022 17:39:33 +0300
Message-Id: <20220901143934.8850-3-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901143934.8850-1-ilpo.jarvinen@linux.intel.com>
References: <20220901143934.8850-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DMA complete & stop paths did not correctly account Tx'ed characters
into icount.tx. Using uart_xmit_advance() fixes the problem.

Cc: <stable@vger.kernel.org> # serial: Create uart_xmit_advance()
Fixes: e9ea096dd225 ("serial: tegra: add serial driver")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/serial/serial-tegra.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index ad4f3567ff90..a5748e41483b 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -525,7 +525,7 @@ static void tegra_uart_tx_dma_complete(void *args)
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
 	spin_lock_irqsave(&tup->uport.lock, flags);
-	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uart_xmit_advance(&tup->uport, count);
 	tup->tx_in_progress = 0;
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&tup->uport);
@@ -613,7 +613,6 @@ static unsigned int tegra_uart_tx_empty(struct uart_port *u)
 static void tegra_uart_stop_tx(struct uart_port *u)
 {
 	struct tegra_uart_port *tup = to_tegra_uport(u);
-	struct circ_buf *xmit = &tup->uport.state->xmit;
 	struct dma_tx_state state;
 	unsigned int count;
 
@@ -624,7 +623,7 @@ static void tegra_uart_stop_tx(struct uart_port *u)
 	dmaengine_tx_status(tup->tx_dma_chan, tup->tx_cookie, &state);
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
-	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uart_xmit_advance(&tup->uport, count);
 	tup->tx_in_progress = 0;
 }
 
-- 
2.30.2

