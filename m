Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A702EA8E1
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbhAEKeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729286AbhAEKeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:34:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7828C061793;
        Tue,  5 Jan 2021 02:33:25 -0800 (PST)
Date:   Tue, 05 Jan 2021 10:33:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1609842803;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyHdgLBHIEj9JYFxRruai+YHlB2CHkyzn762qs1f/tA=;
        b=wHhP6ZKt6AkmTtxWgdZZgmOhg2p2oRBMn0MT4+TRIQ05101dM7Or33kYwnhOXK2rMxtC9A
        7ECvjz5tdBr5g/TX1uGNwqpRjtRxt63LcXRYfVrfOH8l5cjqjiHYgvqU3tSEVS9RzGpFeA
        CRj8b1IE4u+h0sY/LqUrnkeJUOwnxuSoAuQ6Yl4OkuwQYH7xj36C+zGe2HoSZpj5sVA8Iw
        fCacY8wbf1AHKbp0bs7BkiuZ94WceEiecwRhZO491DG2hJHVSQj6tlxL/7rqbFS6oCfiUd
        eD+xWLgVQ8YZV9gOYoTvCn+7bA4Nfb1AojMFJaJJmA1QgiY8GZ14N+qrGEbyfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1609842803;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyHdgLBHIEj9JYFxRruai+YHlB2CHkyzn762qs1f/tA=;
        b=32TRGuONYj0QDr0HnZ0avkZ9KJ7uQYsYU1yiSGfbHwU5DUgpPFHZZVb6rWJ/KNW5bhoZJ7
        sb/LIpHe1gDnHhCA==
From:   "tip-bot2 for Dan Williams" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm: Fix leak of pmd ptlock
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>, Yi Zhang <yi.zhang@redhat.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C160697689204=2E605323=2E17629854984697045602=2Es?=
 =?utf-8?q?tgit=40dwillia2-desk3=2Eamr=2Ecorp=2Eintel=2Ecom=3E?=
References: =?utf-8?q?=3C160697689204=2E605323=2E17629854984697045602=2Est?=
 =?utf-8?q?git=40dwillia2-desk3=2Eamr=2Ecorp=2Eintel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <160984280139.414.600325623903793598.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     1bd3d9c593211e09771562b464028d3ab7e05b3a
Gitweb:        https://git.kernel.org/tip/1bd3d9c593211e09771562b464028d3ab7e05b3a
Author:        Dan Williams <dan.j.williams@intel.com>
AuthorDate:    Wed, 02 Dec 2020 22:28:12 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 05 Jan 2021 11:17:21 +01:00

x86/mm: Fix leak of pmd ptlock

Commit

  28ee90fe6048 ("x86/mm: implement free pmd/pte page interfaces")

introduced a new location where a pmd was released, but neglected to
run the pmd page destructor. In fact, this happened previously for a
different pmd release path and was fixed by commit:

  c283610e44ec ("x86, mm: do not leak page->ptl for pmd page tables").

This issue was hidden until recently because the failure mode is silent,
but commit:

  b2b29d6d0119 ("mm: account PMD tables like PTE tables")

turns the failure mode into this signature:

 BUG: Bad page state in process lt-pmem-ns  pfn:15943d
 page:000000007262ed7b refcount:0 mapcount:-1024 mapping:0000000000000000 index:0x0 pfn:0x15943d
 flags: 0xaffff800000000()
 raw: 00affff800000000 dead000000000100 0000000000000000 0000000000000000
 raw: 0000000000000000 ffff913a029bcc08 00000000fffffbff 0000000000000000
 page dumped because: nonzero mapcount
 [..]
  dump_stack+0x8b/0xb0
  bad_page.cold+0x63/0x94
  free_pcp_prepare+0x224/0x270
  free_unref_page+0x18/0xd0
  pud_free_pmd_page+0x146/0x160
  ioremap_pud_range+0xe3/0x350
  ioremap_page_range+0x108/0x160
  __ioremap_caller.constprop.0+0x174/0x2b0
  ? memremap+0x7a/0x110
  memremap+0x7a/0x110
  devm_memremap+0x53/0xa0
  pmem_attach_disk+0x4ed/0x530 [nd_pmem]
  ? __devm_release_region+0x52/0x80
  nvdimm_bus_probe+0x85/0x210 [libnvdimm]

Given this is a repeat occurrence it seemed prudent to look for other
places where this destructor might be missing and whether a better
helper is needed. try_to_free_pmd_page() looks like a candidate, but
testing with setting up and tearing down pmd mappings via the dax unit
tests is thus far not triggering the failure.

As for a better helper pmd_free() is close, but it is a messy fit
due to requiring an @mm arg. Also, ___pmd_free_tlb() wants to call
paravirt_tlb_remove_table() instead of free_page(), so open-coded
pgtable_pmd_page_dtor() seems the best way forward for now.

Debugged together with Matthew Wilcox <willy@infradead.org>.

Fixes: 28ee90fe6048 ("x86/mm: implement free pmd/pte page interfaces")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/160697689204.605323.17629854984697045602.stgit@dwillia2-desk3.amr.corp.intel.com
---
 arch/x86/mm/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index dfd82f5..f6a9e2e 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -829,6 +829,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 	}
 
 	free_page((unsigned long)pmd_sv);
+
+	pgtable_pmd_page_dtor(virt_to_page(pmd));
 	free_page((unsigned long)pmd);
 
 	return 1;
