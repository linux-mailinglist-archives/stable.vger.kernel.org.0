Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D95E27FB79
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 10:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbgJAI3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 04:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730695AbgJAI3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 04:29:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A9902087E;
        Thu,  1 Oct 2020 08:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601540958;
        bh=c853Bw+zaqJUDyHefvutm1yLXg+Xr7c93l9SbLVxuuU=;
        h=Subject:To:From:Date:From;
        b=GnvNxV7PBiLz60fHBU2Xl1+f3FvkurrCCfwAHIkaV0ph93wN3mxJRdDi0Kp+U+tnr
         wETTvyn14EwrrAHq9cOAIP6Gd6wJZwSM/S+fNsEvA/4rbkI4j4zfcB5uo5WuUTcuMQ
         T5TUIsfbEXCPLF4cQgI8gff2Mcl2YZhErHYg7NMU=
Subject: patch "tty: serial: fsl_lpuart: fix lpuart32_poll_get_char" added to tty-next
To:     peng.fan@nxp.com, fugang.duan@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 01 Oct 2020 10:29:14 +0200
Message-ID: <160154095420297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 29788ab1d2bf26c130de8f44f9553ee78a27e8d5 Mon Sep 17 00:00:00 2001
From: Peng Fan <peng.fan@nxp.com>
Date: Tue, 29 Sep 2020 17:55:09 +0800
Subject: tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

The watermark is set to 1, so we need to input two chars to trigger RDRF
using the original logic. With the new logic, we could always get the
char when there is data in FIFO.

Suggested-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20200929095509.21680-1-peng.fan@nxp.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 645bbb24b433..590c901a1fc5 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -680,7 +680,7 @@ static void lpuart32_poll_put_char(struct uart_port *port, unsigned char c)
 
 static int lpuart32_poll_get_char(struct uart_port *port)
 {
-	if (!(lpuart32_read(port, UARTSTAT) & UARTSTAT_RDRF))
+	if (!(lpuart32_read(port, UARTWATER) >> UARTWATER_RXCNT_OFF))
 		return NO_POLL_CHAR;
 
 	return lpuart32_read(port, UARTDATA);
-- 
2.28.0


