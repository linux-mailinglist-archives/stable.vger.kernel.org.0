Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A81BCD531
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfJFRdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729799AbfJFRdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:33:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFBFC21479;
        Sun,  6 Oct 2019 17:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383219;
        bh=JtWgIdPbrxTIzhHvd5RJChyICdzkwyKEP1/c3Lj8kLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/GoEa43Ip5rRzmwWquhfcgU3XZhzJ45ARBZPpw9KYVLIaIeN9ed1r9v01QJIk/59
         r0pABO3hCCNpWO3gpdDg/KxZnu5ITO3WQP0UktJ+Ia1wAbQZKYAiYbjOueeWirjExH
         xOeAkktlymWrL/2U32wULzvuh4XQzoDcCjNNYuKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 023/137] ptp_qoriq: Initialize the registers spinlock before calling ptp_qoriq_settime
Date:   Sun,  6 Oct 2019 19:20:07 +0200
Message-Id: <20191006171211.182422256@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit db34a4714c013b644eec2de0ec81b1f0373b8b93 ]

Because ptp_qoriq_settime is being called prior to spin_lock_init, the
following stack trace can be seen at driver probe time:

[    2.269117] the code is fine but needs lockdep annotation.
[    2.274569] turning off the locking correctness validator.
[    2.280027] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.3.0-rc7-01478-g01eaa67a4797 #263
[    2.288073] Hardware name: Freescale LS1021A
[    2.292337] [<c0313cb4>] (unwind_backtrace) from [<c030e11c>] (show_stack+0x10/0x14)
[    2.300045] [<c030e11c>] (show_stack) from [<c1219440>] (dump_stack+0xcc/0xf8)
[    2.307235] [<c1219440>] (dump_stack) from [<c03b9b44>] (register_lock_class+0x730/0x73c)
[    2.315372] [<c03b9b44>] (register_lock_class) from [<c03b6190>] (__lock_acquire+0x78/0x270c)
[    2.323856] [<c03b6190>] (__lock_acquire) from [<c03b90cc>] (lock_acquire+0xe0/0x22c)
[    2.331649] [<c03b90cc>] (lock_acquire) from [<c123c310>] (_raw_spin_lock_irqsave+0x54/0x68)
[    2.340048] [<c123c310>] (_raw_spin_lock_irqsave) from [<c0e73fe4>] (ptp_qoriq_settime+0x38/0x80)
[    2.348878] [<c0e73fe4>] (ptp_qoriq_settime) from [<c0e746d4>] (ptp_qoriq_init+0x1f8/0x484)
[    2.357189] [<c0e746d4>] (ptp_qoriq_init) from [<c0e74aac>] (ptp_qoriq_probe+0xd0/0x184)
[    2.365243] [<c0e74aac>] (ptp_qoriq_probe) from [<c0b0a07c>] (platform_drv_probe+0x48/0x9c)
[    2.373555] [<c0b0a07c>] (platform_drv_probe) from [<c0b07a14>] (really_probe+0x1c4/0x400)
[    2.381779] [<c0b07a14>] (really_probe) from [<c0b07e28>] (driver_probe_device+0x78/0x1b8)
[    2.390003] [<c0b07e28>] (driver_probe_device) from [<c0b081d0>] (device_driver_attach+0x58/0x60)
[    2.398832] [<c0b081d0>] (device_driver_attach) from [<c0b082d4>] (__driver_attach+0xfc/0x160)
[    2.407402] [<c0b082d4>] (__driver_attach) from [<c0b05a84>] (bus_for_each_dev+0x68/0xb4)
[    2.415539] [<c0b05a84>] (bus_for_each_dev) from [<c0b06b68>] (bus_add_driver+0x104/0x20c)
[    2.423763] [<c0b06b68>] (bus_add_driver) from [<c0b0909c>] (driver_register+0x78/0x10c)
[    2.431815] [<c0b0909c>] (driver_register) from [<c030313c>] (do_one_initcall+0x8c/0x3ac)
[    2.439954] [<c030313c>] (do_one_initcall) from [<c1f013f4>] (kernel_init_freeable+0x468/0x548)
[    2.448610] [<c1f013f4>] (kernel_init_freeable) from [<c12344d8>] (kernel_init+0x8/0x10c)
[    2.456745] [<c12344d8>] (kernel_init) from [<c03010b4>] (ret_from_fork+0x14/0x20)
[    2.464273] Exception stack(0xea89ffb0 to 0xea89fff8)
[    2.469297] ffa0:                                     00000000 00000000 00000000 00000000
[    2.477432] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.485566] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000

Fixes: ff54571a747b ("ptp_qoriq: convert to use ptp_qoriq_init/free")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_qoriq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -507,6 +507,8 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp
 		ptp_qoriq->regs.etts_regs = base + ETTS_REGS_OFFSET;
 	}
 
+	spin_lock_init(&ptp_qoriq->lock);
+
 	ktime_get_real_ts64(&now);
 	ptp_qoriq_settime(&ptp_qoriq->caps, &now);
 
@@ -514,7 +516,6 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp
 	  (ptp_qoriq->tclk_period & TCLK_PERIOD_MASK) << TCLK_PERIOD_SHIFT |
 	  (ptp_qoriq->cksel & CKSEL_MASK) << CKSEL_SHIFT;
 
-	spin_lock_init(&ptp_qoriq->lock);
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
 
 	regs = &ptp_qoriq->regs;


