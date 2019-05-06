Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6599514CBE
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbfEFOn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbfEFOn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:43:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940802087F;
        Mon,  6 May 2019 14:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153807;
        bh=9gbumceD6ikjDbZK1PP/dlsoDdVo2qH76kCkoJBKes8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRcUnufjZDaSHLUyMxAIEfrlNL/3fCuVrPtx4tLfpKpm0WBazW5hW3dJ08iFUxU7e
         SrELkdwKMAdqEMJmKDY3UGAQbWvDWZ1evlos2bAKSl292QyQ8ICWm+QxtJLjzNMlLH
         5LUw0ehbqRpViMZ/l3fYpPrF0owzQeZUAi6N2gec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Borislav Petkov <bp@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>
Subject: [PATCH 4.19 96/99] x86/mm: Fix a crash with kmemleak_scan()
Date:   Mon,  6 May 2019 16:33:09 +0200
Message-Id: <20190506143102.536637385@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 0d02113b31b2017dd349ec9df2314e798a90fa6e upstream.

The first kmemleak_scan() call after boot would trigger the crash below
because this callpath:

  kernel_init
    free_initmem
      mem_encrypt_free_decrypted_mem
        free_init_pages

unmaps memory inside the .bss when DEBUG_PAGEALLOC=y.

kmemleak_init() will register the .data/.bss sections and then
kmemleak_scan() will scan those addresses and dereference them looking
for pointer references. If free_init_pages() frees and unmaps pages in
those sections, kmemleak_scan() will crash if referencing one of those
addresses:

  BUG: unable to handle kernel paging request at ffffffffbd402000
  CPU: 12 PID: 325 Comm: kmemleak Not tainted 5.1.0-rc4+ #4
  RIP: 0010:scan_block
  Call Trace:
   scan_gray_list
   kmemleak_scan
   kmemleak_scan_thread
   kthread
   ret_from_fork

Since kmemleak_free_part() is tolerant to unknown objects (not tracked
by kmemleak), it is fine to call it from free_init_pages() even if not
all address ranges passed to this function are known to kmemleak.

 [ bp: Massage. ]

Fixes: b3f0907c71e0 ("x86/mm: Add .bss..decrypted section to hold shared variables")
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190423165811.36699-1-cai@lca.pw
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/init.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -6,6 +6,7 @@
 #include <linux/bootmem.h>	/* for max_low_pfn */
 #include <linux/swapfile.h>
 #include <linux/swapops.h>
+#include <linux/kmemleak.h>
 
 #include <asm/set_memory.h>
 #include <asm/e820/api.h>
@@ -767,6 +768,11 @@ void free_init_pages(char *what, unsigne
 	if (debug_pagealloc_enabled()) {
 		pr_info("debug: unmapping init [mem %#010lx-%#010lx]\n",
 			begin, end - 1);
+		/*
+		 * Inform kmemleak about the hole in the memory since the
+		 * corresponding pages will be unmapped.
+		 */
+		kmemleak_free_part((void *)begin, end - begin);
 		set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 	} else {
 		/*


