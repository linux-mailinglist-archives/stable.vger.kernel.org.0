Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F916E6BF7
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 20:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjDRSTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 14:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjDRSTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 14:19:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06B830E0;
        Tue, 18 Apr 2023 11:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8057B62ACA;
        Tue, 18 Apr 2023 18:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD57C433D2;
        Tue, 18 Apr 2023 18:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681841988;
        bh=29ajqJRLNPNoffHneH7ZbptdS5eJrZj8BSmoXeWrWoY=;
        h=Date:To:From:Subject:From;
        b=XDXT7v59G/OXHJiJ/I65qUj3WQNUlry5na/fJbmrfEz7spaiIWn1bjya5aDitOcmJ
         hfwyPM++5uCkpAx4euMhZuu8DfpolxgpZZriZXJ6S0Fr3WCS9F7LpYtM8/sRgB6DpK
         tiu9fAHqy7rL5eM1aty0JS0Lz+qeHV+UoBurMw18=
Date:   Tue, 18 Apr 2023 11:19:48 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com, mark.rutland@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-hw_tags-avoid-invalid-virt_to_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20230418181948.DBD57C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan: hw_tags: avoid invalid virt_to_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-hw_tags-avoid-invalid-virt_to_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-hw_tags-avoid-invalid-virt_to_page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: kasan: hw_tags: avoid invalid virt_to_page()
Date: Tue, 18 Apr 2023 17:42:12 +0100

When booting with 'kasan.vmalloc=off', a kernel configured with support
for KASAN_HW_TAGS will explode at boot time due to bogus use of
virt_to_page() on a vmalloc adddress.  With CONFIG_DEBUG_VIRTUAL selected
this will be reported explicitly, and with or without CONFIG_DEBUG_VIRTUAL
the kernel will dereference a bogus address:

| ------------[ cut here ]------------
| virt_to_phys used for non-linear address: (____ptrval____) (0xffff800008000000)
| WARNING: CPU: 0 PID: 0 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0x78/0x80
| Modules linked in:
| CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.3.0-rc3-00073-g83865133300d-dirty #4
| Hardware name: linux,dummy-virt (DT)
| pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : __virt_to_phys+0x78/0x80
| lr : __virt_to_phys+0x78/0x80
| sp : ffffcd076afd3c80
| x29: ffffcd076afd3c80 x28: 0068000000000f07 x27: ffff800008000000
| x26: fffffbfff0000000 x25: fffffbffff000000 x24: ff00000000000000
| x23: ffffcd076ad3c000 x22: fffffc0000000000 x21: ffff800008000000
| x20: ffff800008004000 x19: ffff800008000000 x18: ffff800008004000
| x17: 666678302820295f x16: ffffffffffffffff x15: 0000000000000004
| x14: ffffcd076b009e88 x13: 0000000000000fff x12: 0000000000000003
| x11: 00000000ffffefff x10: c0000000ffffefff x9 : 0000000000000000
| x8 : 0000000000000000 x7 : 205d303030303030 x6 : 302e30202020205b
| x5 : ffffcd076b41d63f x4 : ffffcd076afd3827 x3 : 0000000000000000
| x2 : 0000000000000000 x1 : ffffcd076afd3a30 x0 : 000000000000004f
| Call trace:
|  __virt_to_phys+0x78/0x80
|  __kasan_unpoison_vmalloc+0xd4/0x478
|  __vmalloc_node_range+0x77c/0x7b8
|  __vmalloc_node+0x54/0x64
|  init_IRQ+0x94/0xc8
|  start_kernel+0x194/0x420
|  __primary_switched+0xbc/0xc4
| ---[ end trace 0000000000000000 ]---
| Unable to handle kernel paging request at virtual address 03fffacbe27b8000
| Mem abort info:
|   ESR = 0x0000000096000004
|   EC = 0x25: DABT (current EL), IL = 32 bits
|   SET = 0, FnV = 0
|   EA = 0, S1PTW = 0
|   FSC = 0x04: level 0 translation fault
| Data abort info:
|   ISV = 0, ISS = 0x00000004
|   CM = 0, WnR = 0
| swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000041bc5000
| [03fffacbe27b8000] pgd=0000000000000000, p4d=0000000000000000
| Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
| Modules linked in:
| CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W          6.3.0-rc3-00073-g83865133300d-dirty #4
| Hardware name: linux,dummy-virt (DT)
| pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : __kasan_unpoison_vmalloc+0xe4/0x478
| lr : __kasan_unpoison_vmalloc+0xd4/0x478
| sp : ffffcd076afd3ca0
| x29: ffffcd076afd3ca0 x28: 0068000000000f07 x27: ffff800008000000
| x26: 0000000000000000 x25: 03fffacbe27b8000 x24: ff00000000000000
| x23: ffffcd076ad3c000 x22: fffffc0000000000 x21: ffff800008000000
| x20: ffff800008004000 x19: ffff800008000000 x18: ffff800008004000
| x17: 666678302820295f x16: ffffffffffffffff x15: 0000000000000004
| x14: ffffcd076b009e88 x13: 0000000000000fff x12: 0000000000000001
| x11: 0000800008000000 x10: ffff800008000000 x9 : ffffb2f8dee00000
| x8 : 000ffffb2f8dee00 x7 : 205d303030303030 x6 : 302e30202020205b
| x5 : ffffcd076b41d63f x4 : ffffcd076afd3827 x3 : 0000000000000000
| x2 : 0000000000000000 x1 : ffffcd076afd3a30 x0 : ffffb2f8dee00000
| Call trace:
|  __kasan_unpoison_vmalloc+0xe4/0x478
|  __vmalloc_node_range+0x77c/0x7b8
|  __vmalloc_node+0x54/0x64
|  init_IRQ+0x94/0xc8
|  start_kernel+0x194/0x420
|  __primary_switched+0xbc/0xc4
| Code: d34cfc08 aa1f03fa 8b081b39 d503201f (f9400328)
| ---[ end trace 0000000000000000 ]---
| Kernel panic - not syncing: Attempted to kill the idle task!

This is because init_vmalloc_pages() erroneously calls virt_to_page() on
a vmalloc address, while virt_to_page() is only valid for addresses in
the linear/direct map. Since init_vmalloc_pages() expects virtual
addresses in the vmalloc range, it must use vmalloc_to_page() rather
than virt_to_page().

We call init_vmalloc_pages() from __kasan_unpoison_vmalloc(), where we
check !is_vmalloc_or_module_addr(), suggesting that we might encounter a
non-vmalloc address. Luckily, this never happens. By design, we only
call __kasan_unpoison_vmalloc() on pointers in the vmalloc area, and I
have verified that we don't violate that expectation. Given that,
is_vmalloc_or_module_addr() must always be true for any legitimate
argument to __kasan_unpoison_vmalloc().

Correct init_vmalloc_pages() to use vmalloc_to_page(), and remove the
redundant and misleading use of is_vmalloc_or_module_addr() in
__kasan_unpoison_vmalloc().

Link: https://lkml.kernel.org/r/20230418164212.1775741-1-mark.rutland@arm.com
Fixes: 6c2f761dad7851d8 ("kasan: fix zeroing vmalloc memory with HW_TAGS")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-hw_tags-avoid-invalid-virt_to_page
+++ a/mm/kasan/hw_tags.c
@@ -285,7 +285,7 @@ static void init_vmalloc_pages(const voi
 	const void *addr;
 
 	for (addr = start; addr < start + size; addr += PAGE_SIZE) {
-		struct page *page = virt_to_page(addr);
+		struct page *page = vmalloc_to_page(addr);
 
 		clear_highpage_kasan_tagged(page);
 	}
@@ -297,7 +297,7 @@ void *__kasan_unpoison_vmalloc(const voi
 	u8 tag;
 	unsigned long redzone_start, redzone_size;
 
-	if (!kasan_vmalloc_enabled() || !is_vmalloc_or_module_addr(start)) {
+	if (!kasan_vmalloc_enabled()) {
 		if (flags & KASAN_VMALLOC_INIT)
 			init_vmalloc_pages(start, size);
 		return (void *)start;
_

Patches currently in -mm which might be from mark.rutland@arm.com are

kasan-hw_tags-avoid-invalid-virt_to_page.patch

