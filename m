Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EFF6DC4F9
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 11:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDJJRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 05:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjDJJRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 05:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DE65587
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 02:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 711A2619EC
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 09:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D7CC433D2;
        Mon, 10 Apr 2023 09:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681118243;
        bh=AWL1A9+GqrrM5hgEuiZblzrDgkfvoWbHcvpeReFbMZw=;
        h=Subject:To:Cc:From:Date:From;
        b=D84bbeijL4DmmLxO5L2Oy0glBTQ4oTQ9+BzmCBMRSCk863dlfWCtUKqQk0qPLYuQl
         LDpryjeqt1SuQmkcWhNlRzTarvfqvAzX8nwHAuOGljOVPz5jqXx0V4KGkliULafdtn
         daf+uSDUMwA/fcgHzFfMSb5gvF+urTc/itIXOsIk=
Subject: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: avoid checking for transfer complete" failed to apply to 4.14-stable tree
To:     sherry.sun@nxp.com, gregkh@linuxfoundation.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Apr 2023 11:17:12 +0200
Message-ID: <2023041012-drippy-italics-387e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 9425914f3de6febbd6250395f56c8279676d9c3c
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041012-drippy-italics-387e@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

9425914f3de6 ("tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty")
46dd6d779dcc ("serial: fsl_lpuart: consider TX FIFO too in lpuart32_tx_empty")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9425914f3de6febbd6250395f56c8279676d9c3c Mon Sep 17 00:00:00 2001
From: Sherry Sun <sherry.sun@nxp.com>
Date: Thu, 23 Mar 2023 13:44:15 +0800
Subject: [PATCH] tty: serial: fsl_lpuart: avoid checking for transfer complete
 when UARTCTRL_SBK is asserted in lpuart32_tx_empty

According to LPUART RM, Transmission Complete Flag becomes 0 if queuing
a break character by writing 1 to CTRL[SBK], so here need to avoid
checking for transmission complete when UARTCTRL_SBK is asserted,
otherwise the lpuart32_tx_empty may never get TIOCSER_TEMT.

Commit 2411fd94ceaa("tty: serial: fsl_lpuart: skip waiting for
transmission complete when UARTCTRL_SBK is asserted") only fix it in
lpuart32_set_termios(), here also fix it in lpuart32_tx_empty().

Fixes: 380c966c093e ("tty: serial: fsl_lpuart: add 32-bit register interface support")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230323054415.20363-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 56e6ba3250cd..edc6e35b701a 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -858,11 +858,17 @@ static unsigned int lpuart32_tx_empty(struct uart_port *port)
 			struct lpuart_port, port);
 	unsigned long stat = lpuart32_read(port, UARTSTAT);
 	unsigned long sfifo = lpuart32_read(port, UARTFIFO);
+	unsigned long ctrl = lpuart32_read(port, UARTCTRL);
 
 	if (sport->dma_tx_in_progress)
 		return 0;
 
-	if (stat & UARTSTAT_TC && sfifo & UARTFIFO_TXEMPT)
+	/*
+	 * LPUART Transmission Complete Flag may never be set while queuing a break
+	 * character, so avoid checking for transmission complete when UARTCTRL_SBK
+	 * is asserted.
+	 */
+	if ((stat & UARTSTAT_TC && sfifo & UARTFIFO_TXEMPT) || ctrl & UARTCTRL_SBK)
 		return TIOCSER_TEMT;
 
 	return 0;

