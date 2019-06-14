Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DE14611C
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 16:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfFNOk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 10:40:27 -0400
Received: from terminus.zytor.com ([198.137.202.136]:37211 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbfFNOk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 10:40:26 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x5EEeDX21735706
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 14 Jun 2019 07:40:13 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5EEeDX21735706
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019051801; t=1560523213;
        bh=MTIomEjR0QGw2Y/B1esgMdBm8zLW2TjMINe9+/UbZw8=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=dKcaYIc8B3jJkXC26NehlU+BlKN/18Sn83o6rZT+Sgw0mA6B21TVcF3xeJu9xqNt2
         LfszzEOdPOz2Ub7jkKtA1C9L1gPkForhBSv1j04JzzyHDnDovgEFpRASi9MagWMQ0R
         OZpgbiqpQxXQu5CHeK/T6C3/blbi4xw3aZbhhjj6TYhKZtvjLQfOaEBTV6J2SoOw7B
         2CtOKJrPTvdeZmo76nvX7VmG+oW3MGAD93Q8lSULAPl6tikwyaAEex6K95ibsGYFO2
         nbKitfAqr+BrmYxOMPIMnkgM4PfThQdVM/ibfQJ2MDTJvVCcbY9yFQE8d4PaaJj80J
         6noge/6ltFrFg==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x5EEeCAi1735701;
        Fri, 14 Jun 2019 07:40:12 -0700
Date:   Fri, 14 Jun 2019 07:40:12 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Andrey Ryabinin <tipbot@zytor.com>
Message-ID: <tip-f3176ec9420de0c385023afa3e4970129444ac2f@git.kernel.org>
Cc:     bp@alien8.de, linux-kernel@vger.kernel.org, mingo@kernel.org,
        dvyukov@google.com, tglx@linutronix.de, kirill@shutemov.name,
        stable@vger.kernel.org, aryabinin@virtuozzo.com, glider@google.com,
        hpa@zytor.com
Reply-To: hpa@zytor.com, glider@google.com, stable@vger.kernel.org,
          aryabinin@virtuozzo.com, kirill@shutemov.name,
          tglx@linutronix.de, mingo@kernel.org, dvyukov@google.com,
          linux-kernel@vger.kernel.org, bp@alien8.de
In-Reply-To: <20190614143149.2227-1-aryabinin@virtuozzo.com>
References: <20190614143149.2227-1-aryabinin@virtuozzo.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/kasan: Fix boot with 5-level paging and KASAN
Git-Commit-ID: f3176ec9420de0c385023afa3e4970129444ac2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        T_DATE_IN_FUTURE_96_Q autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  f3176ec9420de0c385023afa3e4970129444ac2f
Gitweb:     https://git.kernel.org/tip/f3176ec9420de0c385023afa3e4970129444ac2f
Author:     Andrey Ryabinin <aryabinin@virtuozzo.com>
AuthorDate: Fri, 14 Jun 2019 17:31:49 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 14 Jun 2019 16:37:30 +0200

x86/kasan: Fix boot with 5-level paging and KASAN

Since commit d52888aa2753 ("x86/mm: Move LDT remap out of KASLR region on
5-level paging") kernel doesn't boot with KASAN on 5-level paging machines.
The bug is actually in early_p4d_offset() and introduced by commit
12a8cc7fcf54 ("x86/kasan: Use the same shadow offset for 4- and 5-level paging")

early_p4d_offset() tries to convert pgd_val(*pgd) value to a physical
address. This doesn't make sense because pgd_val() already contains the
physical address.

It did work prior to commit d52888aa2753 because the result of
"__pa_nodebug(pgd_val(*pgd)) & PTE_PFN_MASK" was the same as "pgd_val(*pgd)
& PTE_PFN_MASK". __pa_nodebug() just set some high bits which were masked
out by applying PTE_PFN_MASK.

After the change of the PAGE_OFFSET offset in commit d52888aa2753
__pa_nodebug(pgd_val(*pgd)) started to return a value with more high bits
set and PTE_PFN_MASK wasn't enough to mask out all of them. So it returns a
wrong not even canonical address and crashes on the attempt to dereference
it.

Switch back to pgd_val() & PTE_PFN_MASK to cure the issue.

Fixes: 12a8cc7fcf54 ("x86/kasan: Use the same shadow offset for 4- and 5-level paging")
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kasan-dev@googlegroups.com
Cc: stable@vger.kernel.org
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190614143149.2227-1-aryabinin@virtuozzo.com

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
