Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382BA47FB8
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 12:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfFQKcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 06:32:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45341 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFQKcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 06:32:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id a14so15392812edv.12
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 03:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=+IsA7g8VrQi1p6+0rUAfrYHbZxeNW1x5cdILWDPWHeM=;
        b=CXjiCRQZbi5X8btQTrOIGbRQXdZX3a8516roFkgeXdsCioqn/JwMFSuGg2Ey5MbZ+O
         5DhR02+EU919lh2z1jxpjoUPE67XvKqzxK2aJjiQFhp4NJAlkF/3S1GTkzmV+ClxXvYt
         iISU9Omk8RM9Y44LEGHLrFDKScsh6qZwSRjith6zHSKhN/u0H02S8HlmiVfUSa5NdXI+
         nCXNb2oGzOspj8ri4JiC67txEYRkq3j2a2zE3mZ7C8J03QbaCg7S/VGRVCRS7ykTOLfH
         JL1hBaAL++VxYzI4BSL1Ssr/8l2/P4BwsaMuICH0qqUo75MYmy6GfUiNd6/VpYRbAp8E
         U2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=+IsA7g8VrQi1p6+0rUAfrYHbZxeNW1x5cdILWDPWHeM=;
        b=tLObSOH7XT06i5QWnxuX4NSD7OrOZT2TvS/0TY12HkBiIl0HE57NHw4+FUrvIs3SYl
         G8RW/gLpkL6D7P75+7bxbjPEj0oAUHpwTOKyPeD+MbVvqvDw1D38CWmtASCYDClp+XtG
         2q17ht+KW6LMfWbwEByv0msTePf8sD0SVhO6zQFI4Li4YLlkHCq357vSsYMJhN9LINoi
         ZAKB51nkNaNlymGFSRpgfm3Ee9cVvh9yUjIq3TMnhcZMnWlacIegd1uZztiQ8cKrNUpX
         6iFJVp4c5jti4Q3TmIWUxRYP5SZeqoQX+qrPovDFbwb1EgvCq71GiriwYzXY0dK4hnr8
         1B/g==
X-Gm-Message-State: APjAAAV5H7dKTEnCutzWDQRUaxvA6LPRVjVi1bP6u/dYbobb2SKzgOnn
        OEz/eJMqVs2juKB4ItfCoW6gpw==
X-Google-Smtp-Source: APXvYqwnU3Jslq6jxVegXAsmGj8PvJyDKbQzfvMcZlBL0H3PtYK1yRgW/NRELzzJ/8NU2HNPYZcqnw==
X-Received: by 2002:a50:b566:: with SMTP id z35mr84088733edd.129.1560767570383;
        Mon, 17 Jun 2019 03:32:50 -0700 (PDT)
Received: from localhost ([81.92.102.43])
        by smtp.gmail.com with ESMTPSA id z3sm3637022edd.72.2019.06.17.03.32.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 03:32:49 -0700 (PDT)
Date:   Mon, 17 Jun 2019 03:32:49 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     ShihPo Hung <shihpo.hung@sifive.com>
cc:     linux-riscv@lists.infradead.org, stable@vger.kernel.org,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH v2] riscv: mm: synchronize MMU after pte change
In-Reply-To: <CALoQrwdLANaOaYiGvFxt23PBdHcgcc_LWVFORNwrAXWBhOyJsA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.9999.1906170328330.19994@viisi.sifive.com>
References: <CALoQrwdLANaOaYiGvFxt23PBdHcgcc_LWVFORNwrAXWBhOyJsA@mail.gmail.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi ShihPo,

On Mon, 17 Jun 2019, ShihPo Hung wrote:

> Because RISC-V compliant implementations can cache invalid entries
> in TLB, an SFENCE.VMA is necessary after changes to the page table.
> This patch adds an SFENCE.vma for the vmalloc_fault path.
> 
> Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
> Cc: Palmer Dabbelt <palmer@sifive.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: linux-riscv@lists.infradead.org
> Cc: stable@vger.kernel.org

Looks like something in your patch flow converted tabs to whitespace, so 
the patch doesn't apply.  Then, with the tabs fixed, the comment text 
exceeds 80 columns.

I've fixed those issues by hand for this patch (revised patch below, as 
queued for v5.2-rc), but could you please fix these issues for future 
patches?  Running checkpatch.pl --strict should help identify these issues 
before posting.


thanks,

- Paul


From: ShihPo Hung <shihpo.hung@sifive.com>
Date: Mon, 17 Jun 2019 12:26:17 +0800
Subject: [PATCH] [PATCH v2] riscv: mm: synchronize MMU after pte change

Because RISC-V compliant implementations can cache invalid entries
in TLB, an SFENCE.VMA is necessary after changes to the page table.
This patch adds an SFENCE.vma for the vmalloc_fault path.

Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
[paul.walmsley@sifive.com: reversed tab->whitespace conversion,
 wrapped comment lines]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: linux-riscv@lists.infradead.org
Cc: stable@vger.kernel.org
---
 arch/riscv/mm/fault.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index cec8be9e2d6a..5b72e60c5a6b 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -29,6 +29,7 @@
 
 #include <asm/pgalloc.h>
 #include <asm/ptrace.h>
+#include <asm/tlbflush.h>
 
 /*
  * This routine handles page faults.  It determines the address and the
@@ -278,6 +279,18 @@ asmlinkage void do_page_fault(struct pt_regs *regs)
 		pte_k = pte_offset_kernel(pmd_k, addr);
 		if (!pte_present(*pte_k))
 			goto no_context;
+
+		/*
+		 * The kernel assumes that TLBs don't cache invalid
+		 * entries, but in RISC-V, SFENCE.VMA specifies an
+		 * ordering constraint, not a cache flush; it is
+		 * necessary even after writing invalid entries.
+		 * Relying on flush_tlb_fix_spurious_fault would
+		 * suffice, but the extra traps reduce
+		 * performance. So, eagerly SFENCE.VMA.
+		 */
+		local_flush_tlb_page(addr);
+
 		return;
 	}
 }
-- 
2.20.1

