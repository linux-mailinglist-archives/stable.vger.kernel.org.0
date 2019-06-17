Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E3847954
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 06:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbfFQE0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 00:26:31 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40296 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfFQE0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 00:26:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so7492450wmj.5
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 21:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=RBNiMJD5FfAdQuk6MMHusz66jclF3VVqDvwsCd1pAGg=;
        b=H6vLyzbInHCY1xUpkq913lfehoCeZL9Ch5xgudduOvc8T5PqPja1Hb8gEDsgfgBsB4
         WBi2Ug5Z85Vp5bxFQX+9Nt7eZ73zO/5dMkuxaBzTFhaWScMjyzGmviDHhdVS306UPlfj
         87wBVYmFZuKRfMDyGs7+vPIP1sjfubEv3tyks8akIhAFz9sy3jdjLUoTzSGI7BW3TY6z
         eQv6Ynnd+z4reEF2/vn1NNTZbCsoRHhnhgCZFrA8ReRWBDle0zkTXHHnH0SbYYY+BpOd
         IcWWjpGSrLv6kP8Vl2kYtynWMsl19mcCuhtUqCYSIseX4olXR2oKohc151ETXlJBiA12
         HCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=RBNiMJD5FfAdQuk6MMHusz66jclF3VVqDvwsCd1pAGg=;
        b=WYpu9JxFkFLAtjAZj9KrRYSQJgQpuLfSBW3BYDt/64gpHVdh5Rge+n6lJT6VHHO/sC
         T58dDLuwHw+H0TqufgJiIOc/xPvXL2C45fVUTIAhssjjX/Wtfu2Bm74cGrGiWV8c+3m8
         GBcpEbwD7f4JA72Ojf4vhiV4sBoCREZtyjeK6Dsr6TrtnTgch/bHDpsXZyVgkMtISuv5
         UkV+v/QJBFHbxs8iIJGsnnWnLi/oU7foWkWAJzbk5TyRkJK5buMnY8MR5j0kfelEaS1w
         bI1jRBcGNR4KDmG4XMW2z56kEfJzVNEhZLhxOYeV9+eiovYinAZ4LaXn1FTW32LNkU2W
         IICw==
X-Gm-Message-State: APjAAAVnmmxL5RylJGhAvW++LrB16IBmFbZF1h06YSnvSNVUv00yOePp
        VovIqBoiygLXiuJbHecxTfOAyxLLidNrPZLbOz5KdQ==
X-Google-Smtp-Source: APXvYqzSynzNpnyLa4q/HvjF2nFLmH+26Y/dpEk9qn5KN4b9maokmZAJwlsF3d2RvAldzwhucwcvBCwose0vo0Qg5F4=
X-Received: by 2002:a1c:b604:: with SMTP id g4mr17371456wmf.111.1560745588799;
 Sun, 16 Jun 2019 21:26:28 -0700 (PDT)
MIME-Version: 1.0
From:   ShihPo Hung <shihpo.hung@sifive.com>
Date:   Mon, 17 Jun 2019 12:26:17 +0800
Message-ID: <CALoQrwdLANaOaYiGvFxt23PBdHcgcc_LWVFORNwrAXWBhOyJsA@mail.gmail.com>
Subject: [PATCH v2] riscv: mm: synchronize MMU after pte change
To:     linux-riscv@lists.infradead.org
Cc:     stable@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Because RISC-V compliant implementations can cache invalid entries
in TLB, an SFENCE.VMA is necessary after changes to the page table.
This patch adds an SFENCE.vma for the vmalloc_fault path.

Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: linux-riscv@lists.infradead.org
Cc: stable@vger.kernel.org
---
 arch/riscv/mm/fault.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 88401d5..a1c7b39 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -29,6 +29,7 @@

 #include <asm/pgalloc.h>
 #include <asm/ptrace.h>
+#include <asm/tlbflush.h>

 /*
  * This routine handles page faults.  It determines the address and the
@@ -281,6 +282,16 @@ asmlinkage void do_page_fault(struct pt_regs *regs)
        pte_k = pte_offset_kernel(pmd_k, addr);
        if (!pte_present(*pte_k))
            goto no_context;
+
+       /*
+        * The kernel assumes that TLBs don't cache invalid entries, but
+        * in RISC-V, SFENCE.VMA specifies an ordering constraint, not a
+        * cache flush; it is necessary even after writing invalid entries.
+        * Relying on flush_tlb_fix_spurious_fault would suffice, but
+        * the extra traps reduce performance.  So, eagerly SFENCE.VMA.
+        */
+       local_flush_tlb_page(addr);
+
        return;
    }
 }
--
2.7.4
