Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B86F15C51
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfEGFfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbfEGFfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 372BB20B7C;
        Tue,  7 May 2019 05:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207323;
        bh=i8CY65LK6Isnm5MVu32IgJ4xlKEoxA8v+lpkPc2ysys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rpj1QAHGbJjO6hLnT1G0JL8JIzH1ZnNU6R/WePokZ2LbJdKiC15RFp/99g8L8HkJ
         pFFb7fU9MwF8iimV6qIUwDBjzuXyQMD3j5G3+EL28UTJU61FlHEBpx/fJ+fJBIabO4
         tLOuxfyUCtsYCPnIH6mdMUsNJbVxrBjAW0aaFhOI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Borislav Petkov <bp@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 86/99] x86/mm: Fix a crash with kmemleak_scan()
Date:   Tue,  7 May 2019 01:32:20 -0400
Message-Id: <20190507053235.29900-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 0d02113b31b2017dd349ec9df2314e798a90fa6e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f905a2371080..8dacdb96899e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -5,6 +5,7 @@
 #include <linux/memblock.h>
 #include <linux/swapfile.h>
 #include <linux/swapops.h>
+#include <linux/kmemleak.h>
 
 #include <asm/set_memory.h>
 #include <asm/e820/api.h>
@@ -766,6 +767,11 @@ void free_init_pages(const char *what, unsigned long begin, unsigned long end)
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
-- 
2.20.1

