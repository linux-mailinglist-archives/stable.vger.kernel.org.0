Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB81540A8D2
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhINIJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230263AbhINIIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:08:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C871B60EB6;
        Tue, 14 Sep 2021 08:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631606817;
        bh=kJN245f6DIgjmM5SMwmC5MgJ2yQJHzow8IVWlEekWxQ=;
        h=Subject:To:From:Date:From;
        b=HRobH/mq0/iPIlt2I0Bh9GkYGR9NNtYFThyNO5K1uw11ICf1m1FMAURBigSSGK0PX
         I/Q219YrjrwX9SjaUJKNue16WFHbjsykC04SIxKC9T7MZncYpQ1+S0ELv1o8J8iaOs
         lXvXbQ2u6KQGg7brFN+dOovTycGE5hYW8Sl/JtZM=
Subject: patch "serial: 8250: 8250_omap: Fix RX_LVL register offset" added to tty-linus
To:     nm@ti.com, gregkh@linuxfoundation.org, jan.kiszka@siemens.com,
        stable@vger.kernel.org, vigneshr@ti.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:06:55 +0200
Message-ID: <16316068156654@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250: 8250_omap: Fix RX_LVL register offset

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 79e9e30a9292a62d25ab75488d3886108db1eaad Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Fri, 3 Sep 2021 00:05:50 -0500
Subject: serial: 8250: 8250_omap: Fix RX_LVL register offset

Commit b67e830d38fa ("serial: 8250: 8250_omap: Fix possible interrupt
storm on K3 SoCs") introduced fixup including a register read to
RX_LVL, however, we should be using word offset than byte offset
since our registers are on 4 byte boundary (port.regshift = 2) for
8250_omap.

Fixes: b67e830d38fa ("serial: 8250: 8250_omap: Fix possible interrupt storm on K3 SoCs")
Cc: stable <stable@vger.kernel.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210903050550.29050-1-nm@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 891fd8345e25..73e5f1dbd075 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -106,7 +106,7 @@
 #define UART_OMAP_EFR2_TIMEOUT_BEHAVE	BIT(6)
 
 /* RX FIFO occupancy indicator */
-#define UART_OMAP_RX_LVL		0x64
+#define UART_OMAP_RX_LVL		0x19
 
 struct omap8250_priv {
 	int line;
-- 
2.33.0


