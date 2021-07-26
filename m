Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C433D6254
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhGZPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237962AbhGZPe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32F2A604AC;
        Mon, 26 Jul 2021 16:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316125;
        bh=lSGfLFfWgF/AD7oUv4vpls8y7X7HBlublpm/Vgi1tBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPhwoe42Mmtjdf+vft7vnIjgcP/ll14pIlqzbzTM5uftGDX/XfR/mdUhpyCQg1eqe
         tIbydRw3CIXe/IIcmdfnFM8OXlDcjfsghzIAIOeQfp9fVREAI0ZGjiY94RR18JHb/y
         +updK6bFX63zYTx7iiHoWC1rRnJ3SUFysWmBYoEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Kees Cook <keescook@chromium.org>,
        Mikhail Morfikov <mmorfikov@gmail.com>, bowsingbetee@pm.me,
        bowsingbetee@protonmail.com, David Hildenbrand <david@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 199/223] mm: page_alloc: fix page_poison=1 / INIT_ON_ALLOC_DEFAULT_ON interaction
Date:   Mon, 26 Jul 2021 17:39:51 +0200
Message-Id: <20210726153852.709551804@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

commit 69e5d322a2fb86173fde8bad26e8eb38cad1b1e9 upstream.

To reproduce the failure we need the following system:

 - kernel command: page_poison=1 init_on_free=0 init_on_alloc=0

 - kernel config:
    * CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
    * CONFIG_INIT_ON_FREE_DEFAULT_ON=y
    * CONFIG_PAGE_POISONING=y

Resulting in:

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
     mm_init+0x185/0x270
     dup_mm+0x6b/0x4f0
     copy_process+0x190d/0x1b10
     kernel_clone+0xba/0x3b0
     __do_sys_clone+0x8f/0xb0
     do_syscall_64+0x68/0x80
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Before commit 51cba1ebc60d ("init_on_alloc: Optimize static branches")
init_on_alloc never enabled static branch by default.  It could only be
enabed explicitly by init_mem_debugging_and_hardening().

But after commit 51cba1ebc60d, a static branch could already be enabled
by default.  There was no code to ever disable it.  That caused
page_poison=1 / init_on_free=1 conflict.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -801,21 +801,24 @@ void init_mem_debugging_and_hardening(vo
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


