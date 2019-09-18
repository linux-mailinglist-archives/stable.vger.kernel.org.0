Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7250CB5CF7
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfIRGXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbfIRGXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:23:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7154C21924;
        Wed, 18 Sep 2019 06:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787818;
        bh=JtOqYrUH6zzRYfMai7toWxuN5Xgoj9Ulos6NPCPN6Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKZFTbXNKzN3NbbcXrIZaMHsst+lkUIOkvtSOoTnT+kvqprYOJVaXxg6BjBiNP3hF
         91kLA4RdhpPyOJuYtypbQwR9iIGnENGxN+W0XEA23igHeSEXgaFhYqpPuTA58e37zZ
         VYATM4yS94SQYrCG8j5PXspOhWzQy1Sd51jhdA7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Cheng <cj.chengjian@huawei.com>,
        Nadav Amit <namit@vmware.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.19 45/50] modules: fix BUG when load module with rodata=n
Date:   Wed, 18 Sep 2019 08:19:28 +0200
Message-Id: <20190918061228.224858339@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
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
@@ -1956,13 +1956,9 @@ void module_enable_ro(const struct modul
 		return;
 
 	frob_text(&mod->core_layout, set_memory_ro);
-	frob_text(&mod->core_layout, set_memory_x);
 
 	frob_rodata(&mod->core_layout, set_memory_ro);
-
 	frob_text(&mod->init_layout, set_memory_ro);
-	frob_text(&mod->init_layout, set_memory_x);
-
 	frob_rodata(&mod->init_layout, set_memory_ro);
 
 	if (after_init)
@@ -2049,6 +2045,12 @@ static void module_enable_nx(const struc
 static void module_disable_nx(const struct module *mod) { }
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
@@ -3604,6 +3606,7 @@ static int complete_formation(struct mod
 
 	module_enable_ro(mod, false);
 	module_enable_nx(mod);
+	module_enable_x(mod);
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */


