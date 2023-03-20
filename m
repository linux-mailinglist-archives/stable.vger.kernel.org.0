Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800C46C0CD4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCTJMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCTJMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:12:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C6212F2A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:12:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF61D612AB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0196C433EF;
        Mon, 20 Mar 2023 09:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303534;
        bh=H0MY2KF0IkQ6/DPdjnXv5xs4do7f5be+R3EZNKHN/4g=;
        h=Subject:To:Cc:From:Date:From;
        b=0iP6r+nrs7HH0jAZyfVv3sHguIV+RARO0YHxOq/xg7W17WVZASIwLVo1waV5UWMQj
         aqYe7tOHO2dpmH1ItQAdvz6qwbOF/Te7xyS0wKydBMw//05Tc/8/qva8VUdkVt5MqM
         I6L09/1u3atLiQL1Aj3kzoOCMP2tN+FoXAM21c8E=
Subject: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: fix race on RX DMA shutdown" failed to apply to 5.4-stable tree
To:     alexander.sverdlin@siemens.com, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:11:55 +0100
Message-ID: <1679303515186114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 1be6f2b15f902c02e055ae0b419ca789200473c9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679303515186114@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

1be6f2b15f90 ("tty: serial: fsl_lpuart: fix race on RX DMA shutdown")
8682ab0eea89 ("tty: serial: fsl_lpuart: switch to new dmaengine_terminate_* API")
4f5cb8c5e915 ("tty: serial: fsl_lpuart: enable wakeup source for lpuart")
374e01fa1304 ("serial: fsl_lpuart: Fix comment typo")
b14109f302d0 ("tty: serial: fsl_lpuart: Use __maybe_unused instead of #if CONFIG_PM_SLEEP")
810bc0a5fafb ("tty: serial: fsl_lpuart: make coverity happy")
d0e7600b914c ("tty: serial: fsl_lpuart: move dma_request_chan()")
c2f448cff22a ("tty: serial: fsl_lpuart: add LS1028A support")
a092ab25fdaa ("tty: serial: fsl_lpuart: fix DMA mapping")
159381df1442 ("tty: serial: fsl_lpuart: fix DMA operation when using IOMMU")
487ee861de17 ("tty: serial: fsl_lpuart: use the sg count from dma_map_sg")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1be6f2b15f902c02e055ae0b419ca789200473c9 Mon Sep 17 00:00:00 2001
From: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Date: Thu, 9 Mar 2023 14:43:02 +0100
Subject: [PATCH] tty: serial: fsl_lpuart: fix race on RX DMA shutdown

From time to time DMA completion can come in the middle of DMA shutdown:

<process ctx>:				<IRQ>:
lpuart32_shutdown()
  lpuart_dma_shutdown()
    del_timer_sync()
					lpuart_dma_rx_complete()
					  lpuart_copy_rx_to_tty()
					    mod_timer()
    lpuart_dma_rx_free()

When the timer fires a bit later, sport->dma_rx_desc is NULL:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
pc : lpuart_copy_rx_to_tty+0xcc/0x5bc
lr : lpuart_timer_func+0x1c/0x2c
Call trace:
 lpuart_copy_rx_to_tty
 lpuart_timer_func
 call_timer_fn
 __run_timers.part.0
 run_timer_softirq
 __do_softirq
 __irq_exit_rcu
 irq_exit
 handle_domain_irq
 gic_handle_irq
 call_on_irq_stack
 do_interrupt_handler
 ...

To fix this fold del_timer_sync() into lpuart_dma_rx_free() after
dmaengine_terminate_sync() to make sure timer will not be re-started in
lpuart_copy_rx_to_tty() <= lpuart_dma_rx_complete().

Fixes: 4a8588a1cf86 ("serial: fsl_lpuart: delete timer on shutdown")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20230309134302.74940-2-alexander.sverdlin@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index f9e164abf920..56e6ba3250cd 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1354,6 +1354,7 @@ static void lpuart_dma_rx_free(struct uart_port *port)
 	struct dma_chan *chan = sport->dma_rx_chan;
 
 	dmaengine_terminate_sync(chan);
+	del_timer_sync(&sport->lpuart_timer);
 	dma_unmap_sg(chan->device->dev, &sport->rx_sgl, 1, DMA_FROM_DEVICE);
 	kfree(sport->rx_ring.buf);
 	sport->rx_ring.tail = 0;
@@ -1813,7 +1814,6 @@ static int lpuart32_startup(struct uart_port *port)
 static void lpuart_dma_shutdown(struct lpuart_port *sport)
 {
 	if (sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
 		lpuart_dma_rx_free(&sport->port);
 		sport->lpuart_dma_rx_use = false;
 	}
@@ -1973,10 +1973,8 @@ lpuart_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Since timer function acqures sport->port.lock, need to stop before
 	 * acquring same lock because otherwise del_timer_sync() can deadlock.
 	 */
-	if (old && sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
+	if (old && sport->lpuart_dma_rx_use)
 		lpuart_dma_rx_free(&sport->port);
-	}
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -2210,10 +2208,8 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Since timer function acqures sport->port.lock, need to stop before
 	 * acquring same lock because otherwise del_timer_sync() can deadlock.
 	 */
-	if (old && sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
+	if (old && sport->lpuart_dma_rx_use)
 		lpuart_dma_rx_free(&sport->port);
-	}
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -3020,7 +3016,6 @@ static int lpuart_suspend(struct device *dev)
 			 * cannot resume as expected, hence gracefully release the
 			 * Rx DMA path before suspend and start Rx DMA path on resume.
 			 */
-			del_timer_sync(&sport->lpuart_timer);
 			lpuart_dma_rx_free(&sport->port);
 
 			/* Disable Rx DMA to use UART port as wakeup source */

