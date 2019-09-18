Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4A0B5C8B
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfIRG1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbfIRG1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6E321924;
        Wed, 18 Sep 2019 06:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788040;
        bh=BlZZyxwe1k/5J6YWXBAH1p9QSdMbz9nFu79JASgZdJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzZpZLOx4HFiKR62fqHdKDd0rRtRJlJ95TyjCVQBna/yLXZAgmiCbruNdb3DuzI22
         rmm5N+xJFhGl5qbX2pUsYIhREazyoZaBlzPekuB357vbl4d8uMaF3osByDIy7usuNv
         +KIjJ7uUKGbEMmUcwIAmvCtwJFctgUcRGZElDoRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Cheng <cj.chengjian@huawei.com>,
        Nadav Amit <namit@vmware.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.2 77/85] modules: fix BUG when load module with rodata=n
Date:   Wed, 18 Sep 2019 08:19:35 +0200
Message-Id: <20190918061237.825400850@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 2eef1399a866c57687962e15142b141a4f8e7862 upstream.

When loading a module with rodata=n, it causes an executing
NX-protected page BUG.

[   32.379191] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[   32.382917] BUG: unable to handle page fault for address: ffffffffc0005000
[   32.385947] #PF: supervisor instruction fetch in kernel mode
[   32.387662] #PF: error_code(0x0011) - permissions violation
[   32.389352] PGD 240c067 P4D 240c067 PUD 240e067 PMD 421a52067 PTE 8000000421a53063
[   32.391396] Oops: 0011 [#1] SMP PTI
[   32.392478] CPU: 7 PID: 2697 Comm: insmod Tainted: G           O      5.2.0-rc5+ #202
[   32.394588] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   32.398157] RIP: 0010:ko_test_init+0x0/0x1000 [ko_test]
[   32.399662] Code: Bad RIP value.
[   32.400621] RSP: 0018:ffffc900029f3ca8 EFLAGS: 00010246
[   32.402171] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   32.404332] RDX: 00000000000004c7 RSI: 0000000000000cc0 RDI: ffffffffc0005000
[   32.406347] RBP: ffffffffc0005000 R08: ffff88842fbebc40 R09: ffffffff810ede4a
[   32.408392] R10: ffffea00108e3480 R11: 0000000000000000 R12: ffff88842bee21a0
[   32.410472] R13: 0000000000000001 R14: 0000000000000001 R15: ffffc900029f3e78
[   32.412609] FS:  00007fb4f0c0a700(0000) GS:ffff88842fbc0000(0000) knlGS:0000000000000000
[   32.414722] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.416290] CR2: ffffffffc0004fd6 CR3: 0000000421a90004 CR4: 0000000000020ee0
[   32.418471] Call Trace:
[   32.419136]  do_one_initcall+0x41/0x1df
[   32.420199]  ? _cond_resched+0x10/0x40
[   32.421433]  ? kmem_cache_alloc_trace+0x36/0x160
[   32.422827]  do_init_module+0x56/0x1f7
[   32.423946]  load_module+0x1e67/0x2580
[   32.424947]  ? __alloc_pages_nodemask+0x150/0x2c0
[   32.426413]  ? map_vm_area+0x2d/0x40
[   32.427530]  ? __vmalloc_node_range+0x1ef/0x260
[   32.428850]  ? __do_sys_init_module+0x135/0x170
[   32.430060]  ? _cond_resched+0x10/0x40
[   32.431249]  __do_sys_init_module+0x135/0x170
[   32.432547]  do_syscall_64+0x43/0x120
[   32.433853]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Because if rodata=n, set_memory_x() can't be called, fix this by
calling set_memory_x in complete_formation();

Fixes: f2c65fb3221a ("x86/modules: Avoid breaking W^X while loading modules")
Suggested-by: Jian Cheng <cj.chengjian@huawei.com>
Reviewed-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1961,13 +1961,9 @@ void module_enable_ro(const struct modul
 	set_vm_flush_reset_perms(mod->core_layout.base);
 	set_vm_flush_reset_perms(mod->init_layout.base);
 	frob_text(&mod->core_layout, set_memory_ro);
-	frob_text(&mod->core_layout, set_memory_x);
 
 	frob_rodata(&mod->core_layout, set_memory_ro);
-
 	frob_text(&mod->init_layout, set_memory_ro);
-	frob_text(&mod->init_layout, set_memory_x);
-
 	frob_rodata(&mod->init_layout, set_memory_ro);
 
 	if (after_init)
@@ -2030,6 +2026,12 @@ void set_all_modules_text_ro(void)
 static void module_enable_nx(const struct module *mod) { }
 #endif
 
+static void module_enable_x(const struct module *mod)
+{
+	frob_text(&mod->core_layout, set_memory_x);
+	frob_text(&mod->init_layout, set_memory_x);
+}
+
 #ifdef CONFIG_LIVEPATCH
 /*
  * Persist Elf information about a module. Copy the Elf header,
@@ -3626,6 +3628,7 @@ static int complete_formation(struct mod
 
 	module_enable_ro(mod, false);
 	module_enable_nx(mod);
+	module_enable_x(mod);
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */


