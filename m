Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D57460CD
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfFNOcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 10:32:06 -0400
Received: from relay.sw.ru ([185.231.240.75]:37964 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbfFNOcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 10:32:06 -0400
Received: from [172.16.25.12] (helo=i7.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hbnEw-0006yb-Sg; Fri, 14 Jun 2019 17:31:39 +0300
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc:     Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/kasan: Fix boot with 5-level paging and KASAN
Date:   Fri, 14 Jun 2019 17:31:49 +0300
Message-Id: <20190614143149.2227-1-aryabinin@virtuozzo.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612014526.jtklrc3okejm3e4t@box>
References: <20190612014526.jtklrc3okejm3e4t@box>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit d52888aa2753 ("x86/mm: Move LDT remap out of KASLR region on
5-level paging") kernel doesn't boot with KASAN on 5-level paging machines.
The bug is actually in early_p4d_offset() and introduced by commit
12a8cc7fcf54 ("x86/kasan: Use the same shadow offset for 4- and 5-level paging")

early_p4d_offset() tries to convert pgd_val(*pgd) value to physical
address. This doesn't make sense because pgd_val() already contains
physical address.

It did work prior to commit d52888aa2753 because the result of
"__pa_nodebug(pgd_val(*pgd)) & PTE_PFN_MASK" was the same as
"pgd_val(*pgd) & PTE_PFN_MASK". __pa_nodebug() just set some high bit
which were masked out by applying PTE_PFN_MASK.

After the change of the PAGE_OFFSET offset in commit d52888aa2753
__pa_nodebug(pgd_val(*pgd)) started to return value with more high bits
set and PTE_PFN_MASK wasn't enough to mask out all of them. So we've got
wrong not even canonical address and crash on the attempt to dereference it.

Fixes: 12a8cc7fcf54 ("x86/kasan: Use the same shadow offset for 4- and 5-level paging")
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/mm/kasan_init_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 8dc0fc0b1382..296da58f3013 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -199,7 +199,7 @@ static inline p4d_t *early_p4d_offset(pgd_t *pgd, unsigned long addr)
 	if (!pgtable_l5_enabled())
 		return (p4d_t *)pgd;
 
-	p4d = __pa_nodebug(pgd_val(*pgd)) & PTE_PFN_MASK;
+	p4d = pgd_val(*pgd) & PTE_PFN_MASK;
 	p4d += __START_KERNEL_map - phys_base;
 	return (p4d_t *)p4d + p4d_index(addr);
 }
-- 
2.21.0

