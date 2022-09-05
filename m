Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFAB5AD6F0
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 17:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIEPyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 11:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiIEPyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 11:54:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55044B1EB
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 08:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F099B811F3
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 15:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724F4C433C1;
        Mon,  5 Sep 2022 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662393279;
        bh=0JP9GgWU62jkTUBSdqC5SGvVMnljyyAFqzLavP7gm/U=;
        h=Subject:To:Cc:From:Date:From;
        b=MELMr0YSJoclB5rN4gfV1M+W2PbZlbvLa+tl6FxJyiTctQqzy5tFTllpxfn9HY906
         AgVmrIheHzOmlQxrmTt3TzUm3CazCRkK5aXybbTFw9s6hTrmiSq7e0sspBVQB7wiEu
         raMK+gaXSGGaLBd7fQnPsfFlZuV/IeNCsmZVhLlY=
Subject: FAILED: patch "[PATCH] tty: serial: lpuart: disable flow control while waiting for" failed to apply to 4.19-stable tree
To:     sherry.sun@nxp.com, gregkh@linuxfoundation.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Sep 2022 17:54:36 +0200
Message-ID: <16623932768494@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d5a2e0834364377a5d5a2fff1890a0b3f0bafd1f Mon Sep 17 00:00:00 2001
From: Sherry Sun <sherry.sun@nxp.com>
Date: Sun, 21 Aug 2022 18:15:27 +0800
Subject: [PATCH] tty: serial: lpuart: disable flow control while waiting for
 the transmit engine to complete

When the user initializes the uart port, and waits for the transmit
engine to complete in lpuart32_set_termios(), if the UART TX fifo has
dirty data and the UARTMODIR enable the flow control, the TX fifo may
never be empty. So here we should disable the flow control first to make
sure the transmit engin can complete.

Fixes: 380c966c093e ("tty: serial: fsl_lpuart: add 32-bit register interface support")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20220821101527.10066-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index e9ba0f0bd441..b20f6f2fa51c 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2191,6 +2191,7 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	uart_update_timeout(port, termios->c_cflag, baud);
 
 	/* wait transmit engin complete */
+	lpuart32_write(&sport->port, 0, UARTMODIR);
 	lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
 
 	/* disable transmit and receive */

