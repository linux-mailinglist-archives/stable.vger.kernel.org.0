Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE2B68D27E
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjBGJSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbjBGJSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:18:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B99238008
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0298B8184D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C35AC433EF;
        Tue,  7 Feb 2023 09:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675761475;
        bh=+2qLGsyHim/zQtDxzYEWaFIeIlbY84IwyzFDHdGzuG0=;
        h=Subject:To:Cc:From:Date:From;
        b=AkWNX46yTohlYte2kaNAo7KE7ZN2HllC9837ys/yeFp81BiQBNxQA7Y9/f2tYgMcV
         dcQOVn5khiD2JDcm4B7JCGl0ev2uLt4C7YkLisTcS4mBJMqG0w4UdSndTASN7Y6yo1
         fjikmu0eQ1aEFnMupLi5XgdIzfiUSjtlS+NrzxyE=
Subject: FAILED: patch "[PATCH] serial: 8250_dma: Fix DMA Rx completion race" failed to apply to 4.14-stable tree
To:     ilpo.jarvinen@linux.intel.com, gilles.buloz@kontron.com,
        gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:17:43 +0100
Message-ID: <167576146323678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

31352811e13d ("serial: 8250_dma: Fix DMA Rx completion race")
56dc5074cbec ("serial: 8250_dma: Rearm DMA Rx if more data is pending")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 31352811e13dc2313f101b890fd4b1ce760b5fe7 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 30 Jan 2023 13:48:40 +0200
Subject: [PATCH] serial: 8250_dma: Fix DMA Rx completion race
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Link: https://lore.kernel.org/r/20230130114841.25749-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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

