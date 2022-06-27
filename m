Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46B155D899
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbiF0JoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 05:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiF0JoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 05:44:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E90663C5
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 02:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F92E61299
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 09:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E70C3411D;
        Mon, 27 Jun 2022 09:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656323061;
        bh=vkmniVptYhw+zuLx83xjqnhmRFIEJ7aE9wd40TwAOIA=;
        h=Subject:To:Cc:From:Date:From;
        b=dVKTqt/X97/rRS0aXIm+VjAXgc0JzQKY2B3bjYb6GtYyD27frZx9CqULo9r4GjyUw
         seFHZtm89MzxPH3VeiBi8UnEnzsw3fTxgIOoUGi+Pg2hblygs/Dx3KNLyL6b9vGPnB
         NS4+keh3m7V28SYPEtOsrsykCYv1IoFxV6wPbG+w=
Subject: FAILED: patch "[PATCH] mm/memory-failure: disable unpoison once hw error happens" failed to apply to 5.15-stable tree
To:     pizhenwei@bytedance.com, akpm@linux-foundation.org,
        david@redhat.com, gregkh@linuxfoundation.org, linmiaohe@huawei.com,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 11:44:18 +0200
Message-ID: <1656323058129229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 67f22ba7750f940bcd7e1b12720896c505c2d63f Mon Sep 17 00:00:00 2001
From: zhenwei pi <pizhenwei@bytedance.com>
Date: Wed, 15 Jun 2022 17:32:09 +0800
Subject: [PATCH] mm/memory-failure: disable unpoison once hw error happens

Currently unpoison_memory(unsigned long pfn) is designed for soft
poison(hwpoison-inject) only.  Since 17fae1294ad9d, the KPTE gets cleared
on a x86 platform once hardware memory corrupts.

Unpoisoning a hardware corrupted page puts page back buddy only, the
kernel has a chance to access the page with *NOT PRESENT* KPTE.  This
leads BUG during accessing on the corrupted KPTE.

Suggested by David&Naoya, disable unpoison mechanism when a real HW error
happens to avoid BUG like this:

 Unpoison: Software-unpoisoned page 0x61234
 BUG: unable to handle page fault for address: ffff888061234000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 2c01067 P4D 2c01067 PUD 107267063 PMD 10382b063 PTE 800fffff9edcb062
 Oops: 0002 [#1] PREEMPT SMP NOPTI
 CPU: 4 PID: 26551 Comm: stress Kdump: loaded Tainted: G   M       OE     5.18.0.bm.1-amd64 #7
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996) ...
 RIP: 0010:clear_page_erms+0x7/0x10
 Code: ...
 RSP: 0000:ffffc90001107bc8 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000901 RCX: 0000000000001000
 RDX: ffffea0001848d00 RSI: ffffea0001848d40 RDI: ffff888061234000
 RBP: ffffea0001848d00 R08: 0000000000000901 R09: 0000000000001276
 R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000001
 R13: 0000000000000000 R14: 0000000000140dca R15: 0000000000000001
 FS:  00007fd8b2333740(0000) GS:ffff88813fd00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffff888061234000 CR3: 00000001023d2005 CR4: 0000000000770ee0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
  prep_new_page+0x151/0x170
  get_page_from_freelist+0xca0/0xe20
  ? sysvec_apic_timer_interrupt+0xab/0xc0
  ? asm_sysvec_apic_timer_interrupt+0x1b/0x20
  __alloc_pages+0x17e/0x340
  __folio_alloc+0x17/0x40
  vma_alloc_folio+0x84/0x280
  __handle_mm_fault+0x8d4/0xeb0
  handle_mm_fault+0xd5/0x2a0
  do_user_addr_fault+0x1d0/0x680
  ? kvm_read_and_reset_apf_flags+0x3b/0x50
  exc_page_fault+0x78/0x170
  asm_exc_page_fault+0x27/0x30

Link: https://lkml.kernel.org/r/20220615093209.259374-2-pizhenwei@bytedance.com
Fixes: 847ce401df392 ("HWPOISON: Add unpoisoning support")
Fixes: 17fae1294ad9d ("x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned")
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>	[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/Documentation/vm/hwpoison.rst b/Documentation/vm/hwpoison.rst
index c742de1769d1..b9d5253c1305 100644
--- a/Documentation/vm/hwpoison.rst
+++ b/Documentation/vm/hwpoison.rst
@@ -120,7 +120,8 @@ Testing
   unpoison-pfn
 	Software-unpoison page at PFN echoed into this file. This way
 	a page can be reused again.  This only works for Linux
-	injected failures, not for real memory failures.
+	injected failures, not for real memory failures. Once any hardware
+	memory failure happens, this feature is disabled.
 
   Note these injection interfaces are not stable and might change between
   kernel versions
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 084d67fd55cc..bc60c9cd3230 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -558,7 +558,7 @@ static ssize_t hard_offline_page_store(struct device *dev,
 	if (kstrtoull(buf, 0, &pfn) < 0)
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
-	ret = memory_failure(pfn, 0);
+	ret = memory_failure(pfn, MF_SW_SIMULATED);
 	if (ret == -EOPNOTSUPP)
 		ret = 0;
 	return ret ? ret : count;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 781fae17177d..cf3d0d673f6b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3232,6 +3232,7 @@ enum mf_flags {
 	MF_MUST_KILL = 1 << 2,
 	MF_SOFT_OFFLINE = 1 << 3,
 	MF_UNPOISON = 1 << 4,
+	MF_SW_SIMULATED = 1 << 5,
 };
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index 5c0cddd81505..65e242b5a432 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -48,7 +48,7 @@ static int hwpoison_inject(void *data, u64 val)
 
 inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
-	err = memory_failure(pfn, 0);
+	err = memory_failure(pfn, MF_SW_SIMULATED);
 	return (err == -EOPNOTSUPP) ? 0 : err;
 }
 
diff --git a/mm/madvise.c b/mm/madvise.c
index d7b4f2602949..0316bbc6441b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1112,7 +1112,7 @@ static int madvise_inject_error(int behavior,
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			ret = memory_failure(pfn, MF_COUNT_INCREASED);
+			ret = memory_failure(pfn, MF_COUNT_INCREASED | MF_SW_SIMULATED);
 			if (ret == -EOPNOTSUPP)
 				ret = 0;
 		}
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b85661cbdc4a..da39ec8afca8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -69,6 +69,8 @@ int sysctl_memory_failure_recovery __read_mostly = 1;
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
+static bool hw_memory_failure __read_mostly = false;
+
 static bool __page_handle_poison(struct page *page)
 {
 	int ret;
@@ -1768,6 +1770,9 @@ int memory_failure(unsigned long pfn, int flags)
 
 	mutex_lock(&mf_mutex);
 
+	if (!(flags & MF_SW_SIMULATED))
+		hw_memory_failure = true;
+
 	p = pfn_to_online_page(pfn);
 	if (!p) {
 		res = arch_memory_failure(pfn, flags);
@@ -2103,6 +2108,13 @@ int unpoison_memory(unsigned long pfn)
 
 	mutex_lock(&mf_mutex);
 
+	if (hw_memory_failure) {
+		unpoison_pr_info("Unpoison: Disabled after HW memory failure %#lx\n",
+				 pfn, &unpoison_rs);
+		ret = -EOPNOTSUPP;
+		goto unlock_mutex;
+	}
+
 	if (!PageHWPoison(p)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);

