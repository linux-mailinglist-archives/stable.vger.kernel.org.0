Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1911B5CD7
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgDWNrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgDWNrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:47:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5752076C;
        Thu, 23 Apr 2020 13:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587649634;
        bh=+Vee8TKsu32GnsKJSfjdU/gxrPuGwR2/R8MmmZMeguk=;
        h=Subject:To:From:Date:From;
        b=b5EzvDiJK8KwzSmuTOzxGMrI8LOhN8W/AqKiY8DuA2q537u1LN2HlQ2+almAEdkYv
         B3qlg19cLhSAj/wMkkvtX9JfVnRtoa8MKG/vJnfoDkLhKw/8x/bv0yogqneBW5R+gI
         XVZ/lYUkRbkiD+2JopXVboNAvWtW5vQm6h0tp/RY=
Subject: patch "tty: serial: owl: add "much needed" clk_prepare_enable()" added to tty-linus
To:     amittomer25@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 15:47:04 +0200
Message-ID: <1587649624115211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: owl: add "much needed" clk_prepare_enable()

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From abf42d2f333b21bf8d33b2fbb8a85fa62037ac01 Mon Sep 17 00:00:00 2001
From: Amit Singh Tomar <amittomer25@gmail.com>
Date: Fri, 17 Apr 2020 01:41:57 +0530
Subject: tty: serial: owl: add "much needed" clk_prepare_enable()

commit 8ba92cf59335 ("arm64: dts: actions: s700: Add Clock Management Unit")
breaks the UART on Cubieboard7-lite (based on S700 SoC), This is due to the
fact that generic clk routine clk_disable_unused() disables the gate clks,
and that in turns disables OWL UART (but UART driver never enables it). To
prove this theory, Andre suggested to use "clk_ignore_unused" in kernel
commnd line and it worked (Kernel happily lands into RAMFS world :)).

This commit fix this up by adding clk_prepare_enable().

Fixes: 8ba92cf59335 ("arm64: dts: actions: s700: Add Clock Management Unit")
Signed-off-by: Amit Singh Tomar <amittomer25@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1587067917-1400-1-git-send-email-amittomer25@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/owl-uart.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/owl-uart.c b/drivers/tty/serial/owl-uart.c
index 42c8cc93b603..c149f8c30007 100644
--- a/drivers/tty/serial/owl-uart.c
+++ b/drivers/tty/serial/owl-uart.c
@@ -680,6 +680,12 @@ static int owl_uart_probe(struct platform_device *pdev)
 		return PTR_ERR(owl_port->clk);
 	}
 
+	ret = clk_prepare_enable(owl_port->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "could not enable clk\n");
+		return ret;
+	}
+
 	owl_port->port.dev = &pdev->dev;
 	owl_port->port.line = pdev->id;
 	owl_port->port.type = PORT_OWL;
@@ -712,6 +718,7 @@ static int owl_uart_remove(struct platform_device *pdev)
 
 	uart_remove_one_port(&owl_uart_driver, &owl_port->port);
 	owl_uart_ports[pdev->id] = NULL;
+	clk_disable_unprepare(owl_port->clk);
 
 	return 0;
 }
-- 
2.26.2


