Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F377213697
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 10:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgGCIkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 04:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgGCIkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 04:40:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C51B206DF;
        Fri,  3 Jul 2020 08:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593765636;
        bh=243PRYAOPo4i4MFtzoY/gzIgRaerq9i5wrYyn7O6l4I=;
        h=Subject:To:From:Date:From;
        b=y2kFin/qcrSsVoqwvDaHOjKOcbTaGVw00AQNzKFSMaKwg99/uK4hB9yvdqIab5/mt
         Ai/2X17dQtp2lBRh43O+BGsycN6OGMl/P1H786Fr2H9JaVECT6V1QUM+UMJ8+k+EdE
         owqDsy3JSo3N91OSATTLFDo4qyIIAKr6+1j5EGkM=
Subject: patch "serial: sh-sci: Initialize spinlock for uart console" added to tty-linus
To:     prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jul 2020 10:40:40 +0200
Message-ID: <1593765640253201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: sh-sci: Initialize spinlock for uart console

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f38278e9b810b06aff2981d505267be984423ba3 Mon Sep 17 00:00:00 2001
From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Date: Wed, 1 Jul 2020 16:41:40 +0100
Subject: serial: sh-sci: Initialize spinlock for uart console

serial core expects the spinlock to be initialized by the controller
driver for serial console, this patch makes sure the spinlock is
initialized, fixing the below issue:

[    0.865928] BUG: spinlock bad magic on CPU#0, swapper/0/1
[    0.865945]  lock: sci_ports+0x0/0x4c80, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[    0.865955] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.8.0-rc1+ #112
[    0.865961] Hardware name: HopeRun HiHope RZ/G2H with sub board (DT)
[    0.865968] Call trace:
[    0.865979]  dump_backtrace+0x0/0x1d8
[    0.865985]  show_stack+0x14/0x20
[    0.865996]  dump_stack+0xe8/0x130
[    0.866006]  spin_dump+0x6c/0x88
[    0.866012]  do_raw_spin_lock+0xb0/0xf8
[    0.866023]  _raw_spin_lock_irqsave+0x80/0xa0
[    0.866032]  uart_add_one_port+0x3a4/0x4e0
[    0.866039]  sci_probe+0x504/0x7c8
[    0.866048]  platform_drv_probe+0x50/0xa0
[    0.866059]  really_probe+0xdc/0x330
[    0.866066]  driver_probe_device+0x58/0xb8
[    0.866072]  device_driver_attach+0x6c/0x90
[    0.866078]  __driver_attach+0x88/0xd0
[    0.866085]  bus_for_each_dev+0x74/0xc8
[    0.866091]  driver_attach+0x20/0x28
[    0.866098]  bus_add_driver+0x14c/0x1f8
[    0.866104]  driver_register+0x60/0x110
[    0.866109]  __platform_driver_register+0x40/0x48
[    0.866119]  sci_init+0x2c/0x34
[    0.866127]  do_one_initcall+0x88/0x428
[    0.866137]  kernel_init_freeable+0x2c0/0x328
[    0.866143]  kernel_init+0x10/0x108
[    0.866150]  ret_from_fork+0x10/0x18

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1593618100-2151-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index e1179e74a2b8..204bb68ce3ca 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3301,6 +3301,9 @@ static int sci_probe_single(struct platform_device *dev,
 		sciport->port.flags |= UPF_HARD_FLOW;
 	}
 
+	if (sci_uart_driver.cons->index == sciport->port.line)
+		spin_lock_init(&sciport->port.lock);
+
 	ret = uart_add_one_port(&sci_uart_driver, &sciport->port);
 	if (ret) {
 		sci_cleanup_single(sciport);
-- 
2.27.0


