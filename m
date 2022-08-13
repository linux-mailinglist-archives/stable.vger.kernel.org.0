Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4299591B06
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 16:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiHMOf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 10:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiHMOfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 10:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B202F664
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481C360E2C
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 14:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257EEC433D6;
        Sat, 13 Aug 2022 14:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660401337;
        bh=A2wZcr+QvTS5l9kvqO3Bhlj5o9meVpg/ZT/KmYUXN7I=;
        h=Subject:To:Cc:From:Date:From;
        b=J6NEOYxUfWmuuLYuDIGn5q5f/LuYosCdykdz3dBq9LJXYtbR+JZpeQ9CbYpRTANpd
         RVtjF7aBoWvMOMrVHcHIT4rDlTaguzxuobJfAf9CBM9c5kYdTgc5P/1p1CawMj1kll
         5TtMq81dxpFEDEW0KBEf+c8FwzUWpcNcHniHUmRg=
Subject: FAILED: patch "[PATCH] serial: mvebu-uart: uart2 error bits clearing" failed to apply to 4.9-stable tree
To:     nhadke@marvell.com, gregkh@linuxfoundation.org, nadavh@marvell.com,
        pali@kernel.org, yi.guo@cavium.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 16:35:35 +0200
Message-ID: <16604013350223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a7209541239e5dd44d981289e5f9059222d40fd1 Mon Sep 17 00:00:00 2001
From: Narendra Hadke <nhadke@marvell.com>
Date: Tue, 26 Jul 2022 11:12:21 +0200
Subject: [PATCH] serial: mvebu-uart: uart2 error bits clearing
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For mvebu uart2, error bits are not cleared on buffer read.
This causes interrupt loop and system hang.

Cc: stable@vger.kernel.org
Reviewed-by: Yi Guo <yi.guo@cavium.com>
Reviewed-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Narendra Hadke <nhadke@marvell.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20220726091221.12358-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 0429c2a54290..ff61a8d00014 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -265,6 +265,7 @@ static void mvebu_uart_rx_chars(struct uart_port *port, unsigned int status)
 	struct tty_port *tport = &port->state->port;
 	unsigned char ch = 0;
 	char flag = 0;
+	int ret;
 
 	do {
 		if (status & STAT_RX_RDY(port)) {
@@ -277,6 +278,16 @@ static void mvebu_uart_rx_chars(struct uart_port *port, unsigned int status)
 				port->icount.parity++;
 		}
 
+		/*
+		 * For UART2, error bits are not cleared on buffer read.
+		 * This causes interrupt loop and system hang.
+		 */
+		if (IS_EXTENDED(port) && (status & STAT_BRK_ERR)) {
+			ret = readl(port->membase + UART_STAT);
+			ret |= STAT_BRK_ERR;
+			writel(ret, port->membase + UART_STAT);
+		}
+
 		if (status & STAT_BRK_DET) {
 			port->icount.brk++;
 			status &= ~(STAT_FRM_ERR | STAT_PAR_ERR);

