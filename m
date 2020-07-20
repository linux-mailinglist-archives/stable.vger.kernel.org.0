Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEE6226856
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388312AbgGTQSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387844AbgGTQOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5E4D2064B;
        Mon, 20 Jul 2020 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261647;
        bh=IDWALL32/WD5RmizqctBoBElm3QSOBlZvqtulB53trc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kdsi8jqJLo96lq22iBcnBmvvxdBjeYUBQQE2gsaOEQg+uxYpe8lOritR0lf8UgxEn
         xKaPMC9cIqX71NPWzKrpqmu+SZtu745Ck9FlUpWjZpeZ7Y+qBnsTvOf/m0hnFdHD/h
         T670DVH/4FUxQu3InQVAdp5JFLVBz4bvOhGqRKPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 5.7 174/244] serial: sh-sci: Initialize spinlock for uart console
Date:   Mon, 20 Jul 2020 17:37:25 +0200
Message-Id: <20200720152834.113843439@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit f38278e9b810b06aff2981d505267be984423ba3 upstream.

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
 drivers/tty/serial/sh-sci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3301,6 +3301,9 @@ static int sci_probe_single(struct platf
 		sciport->port.flags |= UPF_HARD_FLOW;
 	}
 
+	if (sci_uart_driver.cons->index == sciport->port.line)
+		spin_lock_init(&sciport->port.lock);
+
 	ret = uart_add_one_port(&sci_uart_driver, &sciport->port);
 	if (ret) {
 		sci_cleanup_single(sciport);


