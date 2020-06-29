Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABB220DE53
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388976AbgF2UYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729388AbgF2TZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F024F25384;
        Mon, 29 Jun 2020 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445248;
        bh=PGOWm28fuz6FO8l/TArIiE7rQptK2L48gxEGamnWAAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xDutN+F1USTARgrmyfzgdb80UzuLlSmFQFehROKTHgDiV/1JoEGLefOmKcerMaY0
         WNbna1qBLRKPnvwF0YOpVomraaUPuKDYlzbOkUWWwb6iqE2/TEKuV0y/zM1LVhG+++
         YrPoly6CXI/0LU0ji6dRekQJXRSbyMyKlyY880P8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Stultz <john.stultz@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jiri Slaby <jslaby@suse.com>, linux-serial@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 031/191] serial: amba-pl011: Make sure we initialize the port.lock spinlock
Date:   Mon, 29 Jun 2020 11:37:27 -0400
Message-Id: <20200629154007.2495120-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index f6586a8681b9b..b3b9b3d2cddf9 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2524,6 +2524,7 @@ static int pl011_setup_port(struct device *dev, struct uart_amba_port *uap,
 	uap->port.fifosize = uap->fifosize;
 	uap->port.flags = UPF_BOOT_AUTOCONF;
 	uap->port.line = index;
+	spin_lock_init(&uap->port.lock);
 
 	amba_ports[index] = uap;
 
-- 
2.25.1

