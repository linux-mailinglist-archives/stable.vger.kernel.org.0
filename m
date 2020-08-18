Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072EB2483F1
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 13:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHRLfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 07:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgHRLdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 07:33:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB009205CB;
        Tue, 18 Aug 2020 11:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597750392;
        bh=w1spHmsLGnmBuFMgWn45ulhif+nNBMDndtky+6rf9iM=;
        h=Subject:To:From:Date:From;
        b=JVuD3t9fkSBT1xZ2B5D1xPIFa68Jnc/3rGnOS7jlL7mnxRHgXV9YzeovzGovJR3mn
         +ji872fB5pKf1gVKumULb+vqRdL09d+cTKF1xnBbNtsSL4nL4zl9C8gUhSB47bl8Wf
         srHQcv6a3zX23+VwfEBQbebX69k+L81IgdMVyFcc=
Subject: patch "serial: stm32: avoid kernel warning on absence of optional IRQ" added to tty-linus
To:     h.assmann@pengutronix.de, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 13:33:33 +0200
Message-ID: <159775041358166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: stm32: avoid kernel warning on absence of optional IRQ

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fdf16d78941b4f380753053d229955baddd00712 Mon Sep 17 00:00:00 2001
From: Holger Assmann <h.assmann@pengutronix.de>
Date: Thu, 13 Aug 2020 17:27:57 +0200
Subject: serial: stm32: avoid kernel warning on absence of optional IRQ

stm32_init_port() of the stm32-usart may trigger a warning in
platform_get_irq() when the device tree specifies no wakeup interrupt.

The wakeup interrupt is usually a board-specific GPIO and the driver
functions correctly in its absence. The mainline stm32mp151.dtsi does
not specify it, so all mainline device trees trigger an unnecessary
kernel warning. Use of platform_get_irq_optional() avoids this.

Fixes: 2c58e56096dd ("serial: stm32: fix the get_irq error case")
Signed-off-by: Holger Assmann <h.assmann@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200813152757.32751-1-h.assmann@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 143300a80090..ba503dd04ce2 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -970,7 +970,7 @@ static int stm32_init_port(struct stm32_port *stm32port,
 		return ret;
 
 	if (stm32port->info->cfg.has_wakeup) {
-		stm32port->wakeirq = platform_get_irq(pdev, 1);
+		stm32port->wakeirq = platform_get_irq_optional(pdev, 1);
 		if (stm32port->wakeirq <= 0 && stm32port->wakeirq != -ENXIO)
 			return stm32port->wakeirq ? : -ENODEV;
 	}
-- 
2.28.0


