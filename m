Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872323D431C
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhGWWJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 18:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233043AbhGWWJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 18:09:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A62E760F39;
        Fri, 23 Jul 2021 22:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080624;
        bh=XPuY6WB50iMeNxQ+cTgj9lpNoLm2mQbkHwGqXwFAk3k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o0z/AvBCLxw1AsQcWQK+on2baAr1jlra+iDqAOmuJ5DeRj801NHPb+YQPfx4HMs58
         pJAIgxuuer43ScS/zFAfpHbHhy1XVFykirzhGv/fijGJZ8QY9WvTVBgAaRQq/zARlW
         BdMkKBGlwA3eVxZTXXEgidCUMj4t385ePXhXOSio=
Date:   Fri, 23 Jul 2021 15:50:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bowsingbetee@pm.me,
        bowsingbetee@protonmail.com, david@redhat.com, glider@google.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mmorfikov@gmail.com, slyfox@gentoo.org,
        stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 08/15] mm: page_alloc: fix page_poison=1 /
 INIT_ON_ALLOC_DEFAULT_ON interaction
Message-ID: <20210723225023.n4WMfVPQg%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_alloc: fix page_poison=1 / INIT_ON_ALLOC_DEFAULT_ON interaction

To reproduce the failure we need the following system:
  - kernel command: page_poison=1 init_on_free=0 init_on_alloc=0
  - kernel config:
    * CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
    * CONFIG_INIT_ON_FREE_DEFAULT_ON=y
    * CONFIG_PAGE_POISONING=y

    0000000085629bdd: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    0000000022861832: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00000000c597f5b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    CPU: 11 PID: 15195 Comm: bash Kdump: loaded Tainted: G     U     O      5.13.1-gentoo-x86_64 #1
    Hardware name: System manufacturer System Product Name/PRIME Z370-A, BIOS 2801 01/13/2021
    Call Trace:
     dump_stack+0x64/0x7c
     __kernel_unpoison_pages.cold+0x48/0x84
     post_alloc_hook+0x60/0xa0
     get_page_from_freelist+0xdb8/0x1000
     __alloc_pages+0x163/0x2b0
     __get_free_pages+0xc/0x30
     pgd_alloc+0x2e/0x1a0
     ? dup_mm+0x37/0x4f0
     mm_init+0x185/0x270
     dup_mm+0x6b/0x4f0
     ? __lock_task_sighand+0x35/0x70
     copy_process+0x190d/0x1b10
     kernel_clone+0xba/0x3b0
     __do_sys_clone+0x8f/0xb0
     do_syscall_64+0x68/0x80
     ? do_syscall_64+0x11/0x80
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Before the 51cba1eb ("init_on_alloc: Optimize static branches")
init_on_alloc never enabled static branch by default.  It could only be
enabed explicitly by init_mem_debugging_and_hardening().

But after the 51cba1eb static branch could already be enabled by default. 
There was no code to ever disable it.  That caused page_poison=1 /
init_on_free=1 conflict.

This change extends init_mem_debugging_and_hardening() to also disable
static branch disabling.

Link: https://lkml.kernel.org/r/20210714031935.4094114-1-keescook@chromium.org
Link: https://lore.kernel.org/r/20210712215816.1512739-1-slyfox@gentoo.org
Fixes: 51cba1ebc60d ("init_on_alloc: Optimize static branches")
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Kees Cook <keescook@chromium.org>
Reported-by: Mikhail Morfikov <mmorfikov@gmail.com>
Reported-by: <bowsingbetee@pm.me>
Tested-by: <bowsingbetee@protonmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction
+++ a/mm/page_alloc.c
@@ -840,21 +840,24 @@ void init_mem_debugging_and_hardening(vo
 	}
 #endif
 
-	if (_init_on_alloc_enabled_early) {
-		if (page_poisoning_requested)
-			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
-				"will take precedence over init_on_alloc\n");
-		else
-			static_branch_enable(&init_on_alloc);
-	}
-	if (_init_on_free_enabled_early) {
-		if (page_poisoning_requested)
-			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
-				"will take precedence over init_on_free\n");
-		else
-			static_branch_enable(&init_on_free);
+	if ((_init_on_alloc_enabled_early || _init_on_free_enabled_early) &&
+	    page_poisoning_requested) {
+		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
+			"will take precedence over init_on_alloc and init_on_free\n");
+		_init_on_alloc_enabled_early = false;
+		_init_on_free_enabled_early = false;
 	}
 
+	if (_init_on_alloc_enabled_early)
+		static_branch_enable(&init_on_alloc);
+	else
+		static_branch_disable(&init_on_alloc);
+
+	if (_init_on_free_enabled_early)
+		static_branch_enable(&init_on_free);
+	else
+		static_branch_disable(&init_on_free);
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	if (!debug_pagealloc_enabled())
 		return;
_
