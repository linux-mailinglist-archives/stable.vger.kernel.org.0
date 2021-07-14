Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A673C7B43
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 04:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbhGNCEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 22:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237371AbhGNCEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 22:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6082761361;
        Wed, 14 Jul 2021 02:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626228122;
        bh=bPWJ0dLIFUBw+gVCjZ80/KjoLEoAdk6ptA7xYcrYZP0=;
        h=Date:From:To:Subject:From;
        b=2Id4OgLBv0jGyaceBQ6YjUROnkha9axtkA/TnlQP/OxWhCajhg3GIayUNjGPhWlpF
         A3miUXhvUXLOvFyCKwRuvfv+AvBEkAI/Z3Azko+Kzz4bAxX7/SUQI292FZf2wblFDb
         akeVxjjdiXbkTYKEPtGx5SBkQTj+qObm0nhu32NQ=
Date:   Tue, 13 Jul 2021 19:02:00 -0700
From:   akpm@linux-foundation.org
To:     bowsingbetee@pm.me, glider@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, slyfox@gentoo.org,
        stable@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction.patch
 added to -mm tree
Message-ID: <20210714020200.R85HJRvC7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix page_poison=1 / INIT_ON_ALLOC_DEFAULT_ON interaction
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-page_poison%3D1-init_on_alloc_default_on-interaction.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-page_poison%3D1-init_on_alloc_default_on-interaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20210712215816.1512739-1-slyfox@gentoo.org
Fixes: 51cba1eb ("init_on_alloc: Optimize static branches")
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reported-by: <bowsingbetee@pm.me>
Reported-by: Mikhail Morfikov
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction
+++ a/mm/page_alloc.c
@@ -840,18 +840,22 @@ void init_mem_debugging_and_hardening(vo
 	}
 #endif
 
-	if (_init_on_alloc_enabled_early) {
-		if (page_poisoning_requested)
+	if (_init_on_alloc_enabled_early ||
+	    IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON)) {
+		if (page_poisoning_requested) {
 			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
 				"will take precedence over init_on_alloc\n");
-		else
+			static_branch_disable(&init_on_alloc);
+		} else
 			static_branch_enable(&init_on_alloc);
 	}
-	if (_init_on_free_enabled_early) {
-		if (page_poisoning_requested)
+	if (_init_on_free_enabled_early ||
+	    IS_ENABLED(CONFIG_INIT_ON_FREE_DEFAULT_ON)) {
+		if (page_poisoning_requested) {
 			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
 				"will take precedence over init_on_free\n");
-		else
+			static_branch_disable(&init_on_free);
+		} else
 			static_branch_enable(&init_on_free);
 	}
 
_

Patches currently in -mm which might be from slyfox@gentoo.org are

mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction.patch

