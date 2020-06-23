Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674C6206140
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391856AbgFWUh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391849AbgFWUh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:37:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91C6320836;
        Tue, 23 Jun 2020 20:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944647;
        bh=zZteOK6XHx+AHlW41GUxP2RgglAjneSsZP+q6Rbhu40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgjpylVWfwNwoOGz0VCFEXPpMRMfv4EB9HcCzDDVPg4VmhRoQbwxdnWk7mYTQFW2o
         g7WDsC8QiIVtjosEcBA0beqWlEgMMu21px6DrRfVF5Vl/TaDzCyqEfLIMpkItet+DW
         K9ByAlRD+wESqH5X556KN1jRAxPjInEmdcxVXS/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jiri Slaby <jslaby@suse.com>, linux-serial@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/206] serial: amba-pl011: Make sure we initialize the port.lock spinlock
Date:   Tue, 23 Jun 2020 21:56:39 +0200
Message-Id: <20200623195320.459730851@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

[ Upstream commit 8508f4cba308f785b2fd4b8c38849c117b407297 ]

Valentine reported seeing:

[    3.626638] INFO: trying to register non-static key.
[    3.626639] the code is fine but needs lockdep annotation.
[    3.626640] turning off the locking correctness validator.
[    3.626644] CPU: 7 PID: 51 Comm: kworker/7:1 Not tainted 5.7.0-rc2-00115-g8c2e9790f196 #116
[    3.626646] Hardware name: HiKey960 (DT)
[    3.626656] Workqueue: events deferred_probe_work_func
[    3.632476] sd 0:0:0:0: [sda] Optimal transfer size 8192 bytes not a multiple of physical block size (16384 bytes)
[    3.640220] Call trace:
[    3.640225]  dump_backtrace+0x0/0x1b8
[    3.640227]  show_stack+0x20/0x30
[    3.640230]  dump_stack+0xec/0x158
[    3.640234]  register_lock_class+0x598/0x5c0
[    3.640235]  __lock_acquire+0x80/0x16c0
[    3.640236]  lock_acquire+0xf4/0x4a0
[    3.640241]  _raw_spin_lock_irqsave+0x70/0xa8
[    3.640245]  uart_add_one_port+0x388/0x4b8
[    3.640248]  pl011_register_port+0x70/0xf0
[    3.640250]  pl011_probe+0x184/0x1b8
[    3.640254]  amba_probe+0xdc/0x180
[    3.640256]  really_probe+0xe0/0x338
[    3.640257]  driver_probe_device+0x60/0xf8
[    3.640259]  __device_attach_driver+0x8c/0xd0
[    3.640260]  bus_for_each_drv+0x84/0xd8
[    3.640261]  __device_attach+0xe4/0x140
[    3.640263]  device_initial_probe+0x1c/0x28
[    3.640265]  bus_probe_device+0xa4/0xb0
[    3.640266]  deferred_probe_work_func+0x7c/0xb8
[    3.640269]  process_one_work+0x2c0/0x768
[    3.640271]  worker_thread+0x4c/0x498
[    3.640272]  kthread+0x14c/0x158
[    3.640275]  ret_from_fork+0x10/0x1c

Which seems to be due to the fact that after allocating the uap
structure, nothing initializes the spinlock.

Its a little confusing, as uart_port_spin_lock_init() is one
place where the lock is supposed to be initialized, but it has
an exception for the case where the port is a console.

This makes it seem like a deeper fix is needed to properly
register the console, but I'm not sure what that entails, and
Andy suggested that this approach is less invasive.

Thus, this patch resolves the issue by initializing the spinlock
in the driver, and resolves the resulting warning.

Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: linux-serial@vger.kernel.org
Reported-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-and-tested-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lore.kernel.org/r/20200428184050.6501-1-john.stultz@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index af21122dfadec..1d501154e9f78 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2585,6 +2585,7 @@ static int pl011_setup_port(struct device *dev, struct uart_amba_port *uap,
 	uap->port.fifosize = uap->fifosize;
 	uap->port.flags = UPF_BOOT_AUTOCONF;
 	uap->port.line = index;
+	spin_lock_init(&uap->port.lock);
 
 	amba_ports[index] = uap;
 
-- 
2.25.1



