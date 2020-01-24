Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5D5148E6F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 20:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403999AbgAXTLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 14:11:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43022 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403967AbgAXTLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 14:11:17 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iv4ML-0007d0-UM; Fri, 24 Jan 2020 20:11:14 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 6B7F41C1A66;
        Fri, 24 Jan 2020 20:11:10 +0100 (CET)
Date:   Fri, 24 Jan 2020 19:11:10 -0000
From:   "tip-bot2 for Kevin Hao" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] irqdomain: Fix a memory leak in irq_domain_push_irq()
Cc:     Kevin Hao <haokexin@gmail.com>, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200120043547.22271-1-haokexin@gmail.com>
References: <20200120043547.22271-1-haokexin@gmail.com>
MIME-Version: 1.0
Message-ID: <157989307023.396.17538071242529894019.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     0f394daef89b38d58c91118a2b08b8a1b316703b
Gitweb:        https://git.kernel.org/tip/0f394daef89b38d58c91118a2b08b8a1b316703b
Author:        Kevin Hao <haokexin@gmail.com>
AuthorDate:    Mon, 20 Jan 2020 12:35:47 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Mon, 20 Jan 2020 19:10:05 

irqdomain: Fix a memory leak in irq_domain_push_irq()

Fix a memory leak reported by kmemleak:
unreferenced object 0xffff000bc6f50e80 (size 128):
  comm "kworker/23:2", pid 201, jiffies 4294894947 (age 942.132s)
  hex dump (first 32 bytes):
    00 00 00 00 41 00 00 00 86 c0 03 00 00 00 00 00  ....A...........
    00 a0 b2 c6 0b 00 ff ff 40 51 fd 10 00 80 ff ff  ........@Q......
  backtrace:
    [<00000000e62d2240>] kmem_cache_alloc_trace+0x1a4/0x320
    [<00000000279143c9>] irq_domain_push_irq+0x7c/0x188
    [<00000000d9f4c154>] thunderx_gpio_probe+0x3ac/0x438
    [<00000000fd09ec22>] pci_device_probe+0xe4/0x198
    [<00000000d43eca75>] really_probe+0xdc/0x320
    [<00000000d3ebab09>] driver_probe_device+0x5c/0xf0
    [<000000005b3ecaa0>] __device_attach_driver+0x88/0xc0
    [<000000004e5915f5>] bus_for_each_drv+0x7c/0xc8
    [<0000000079d4db41>] __device_attach+0xe4/0x140
    [<00000000883bbda9>] device_initial_probe+0x18/0x20
    [<000000003be59ef6>] bus_probe_device+0x98/0xa0
    [<0000000039b03d3f>] deferred_probe_work_func+0x74/0xa8
    [<00000000870934ce>] process_one_work+0x1c8/0x470
    [<00000000e3cce570>] worker_thread+0x1f8/0x428
    [<000000005d64975e>] kthread+0xfc/0x128
    [<00000000f0eaa764>] ret_from_fork+0x10/0x18

Fixes: 495c38d3001f ("irqdomain: Add irq_domain_{push,pop}_irq() functions")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200120043547.22271-1-haokexin@gmail.com
---
 kernel/irq/irqdomain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7a8808c..7527e5e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1476,6 +1476,7 @@ int irq_domain_push_irq(struct irq_domain *domain, int virq, void *arg)
 	if (rv) {
 		/* Restore the original irq_data. */
 		*root_irq_data = *child_irq_data;
+		kfree(child_irq_data);
 		goto error;
 	}
 
