Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D59E6843
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbfJ0VWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732227AbfJ0VWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:47 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6093D21D81;
        Sun, 27 Oct 2019 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211365;
        bh=p8TQo0aB/eU1a0RImXzGrF98fzdSnVnNJ7C/l+abCjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/aeJxsUZE+OM9qQRMokAKY3PvGrm/2SXQB/XLXEdqTGoFm0Vav2S/7og6I8b/MeS
         r4DMLJKXnvMt6FeXEkOf4aXktQfQGC2JoskghzizV2BUAX0CTwKNoW3qBMM++J9Fz9
         KYL/aTIgBkBqdkNTJrV5+ISsnVP/V7pz7Zyxo3Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 089/197] netdevsim: Fix error handling in nsim_fib_init and nsim_fib_exit
Date:   Sun, 27 Oct 2019 22:00:07 +0100
Message-Id: <20191027203356.553994320@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 33902b4a4227877896dd9368ac10f4ca0d100de5 ]

In nsim_fib_init(), if register_fib_notifier failed, nsim_fib_net_ops
should be unregistered before return.

In nsim_fib_exit(), unregister_fib_notifier should be called before
nsim_fib_net_ops be unregistered, otherwise may cause use-after-free:

BUG: KASAN: use-after-free in nsim_fib_event_nb+0x342/0x570 [netdevsim]
Read of size 8 at addr ffff8881daaf4388 by task kworker/0:3/3499

CPU: 0 PID: 3499 Comm: kworker/0:3 Not tainted 5.3.0-rc7+ #30
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
Workqueue: ipv6_addrconf addrconf_dad_work [ipv6]
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xa9/0x10e lib/dump_stack.c:113
 print_address_description+0x65/0x380 mm/kasan/report.c:351
 __kasan_report+0x149/0x18d mm/kasan/report.c:482
 kasan_report+0xe/0x20 mm/kasan/common.c:618
 nsim_fib_event_nb+0x342/0x570 [netdevsim]
 notifier_call_chain+0x52/0xf0 kernel/notifier.c:95
 __atomic_notifier_call_chain+0x78/0x140 kernel/notifier.c:185
 call_fib_notifiers+0x30/0x60 net/core/fib_notifier.c:30
 call_fib6_entry_notifiers+0xc1/0x100 [ipv6]
 fib6_add+0x92e/0x1b10 [ipv6]
 __ip6_ins_rt+0x40/0x60 [ipv6]
 ip6_ins_rt+0x84/0xb0 [ipv6]
 __ipv6_ifa_notify+0x4b6/0x550 [ipv6]
 ipv6_ifa_notify+0xa5/0x180 [ipv6]
 addrconf_dad_completed+0xca/0x640 [ipv6]
 addrconf_dad_work+0x296/0x960 [ipv6]
 process_one_work+0x5c0/0xc00 kernel/workqueue.c:2269
 worker_thread+0x5c/0x670 kernel/workqueue.c:2415
 kthread+0x1d7/0x200 kernel/kthread.c:255
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 3388:
 save_stack+0x19/0x80 mm/kasan/common.c:69
 set_track mm/kasan/common.c:77 [inline]
 __kasan_kmalloc.constprop.3+0xa0/0xd0 mm/kasan/common.c:493
 kmalloc include/linux/slab.h:557 [inline]
 kzalloc include/linux/slab.h:748 [inline]
 ops_init+0xa9/0x220 net/core/net_namespace.c:127
 __register_pernet_operations net/core/net_namespace.c:1135 [inline]
 register_pernet_operations+0x1d4/0x420 net/core/net_namespace.c:1212
 register_pernet_subsys+0x24/0x40 net/core/net_namespace.c:1253
 nsim_fib_init+0x12/0x70 [netdevsim]
 veth_get_link_ksettings+0x2b/0x50 [veth]
 do_one_initcall+0xd4/0x454 init/main.c:939
 do_init_module+0xe0/0x330 kernel/module.c:3490
 load_module+0x3c2f/0x4620 kernel/module.c:3841
 __do_sys_finit_module+0x163/0x190 kernel/module.c:3931
 do_syscall_64+0x72/0x2e0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 3534:
 save_stack+0x19/0x80 mm/kasan/common.c:69
 set_track mm/kasan/common.c:77 [inline]
 __kasan_slab_free+0x130/0x180 mm/kasan/common.c:455
 slab_free_hook mm/slub.c:1423 [inline]
 slab_free_freelist_hook mm/slub.c:1474 [inline]
 slab_free mm/slub.c:3016 [inline]
 kfree+0xe9/0x2d0 mm/slub.c:3957
 ops_free net/core/net_namespace.c:151 [inline]
 ops_free_list.part.7+0x156/0x220 net/core/net_namespace.c:184
 ops_free_list net/core/net_namespace.c:182 [inline]
 __unregister_pernet_operations net/core/net_namespace.c:1165 [inline]
 unregister_pernet_operations+0x221/0x2a0 net/core/net_namespace.c:1224
 unregister_pernet_subsys+0x1d/0x30 net/core/net_namespace.c:1271
 nsim_fib_exit+0x11/0x20 [netdevsim]
 nsim_module_exit+0x16/0x21 [netdevsim]
 __do_sys_delete_module kernel/module.c:1015 [inline]
 __se_sys_delete_module kernel/module.c:958 [inline]
 __x64_sys_delete_module+0x244/0x330 kernel/module.c:958
 do_syscall_64+0x72/0x2e0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 59c84b9fcf42 ("netdevsim: Restore per-network namespace accounting for fib entries")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/fib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -241,8 +241,8 @@ static struct pernet_operations nsim_fib
 
 void nsim_fib_exit(void)
 {
-	unregister_pernet_subsys(&nsim_fib_net_ops);
 	unregister_fib_notifier(&nsim_fib_nb);
+	unregister_pernet_subsys(&nsim_fib_net_ops);
 }
 
 int nsim_fib_init(void)
@@ -258,6 +258,7 @@ int nsim_fib_init(void)
 	err = register_fib_notifier(&nsim_fib_nb, nsim_fib_dump_inconsistent);
 	if (err < 0) {
 		pr_err("Failed to register fib notifier\n");
+		unregister_pernet_subsys(&nsim_fib_net_ops);
 		goto err_out;
 	}
 


