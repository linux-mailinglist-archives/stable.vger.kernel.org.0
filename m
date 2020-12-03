Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5668C2CCF3C
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 07:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgLCG2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 01:28:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:9697 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgLCG2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 01:28:53 -0500
IronPort-SDR: YPCOd+iSU1/nozAEaBfC/L0aYaH8kAj7tGPMuwILBKDdXay4/5FBVdnJ1PaXsYq8ZJPMKdIsqh
 Ab/0eQ9LZjUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="152395954"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="152395954"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 22:28:12 -0800
IronPort-SDR: V9bG7QRBSc2woj2zV/e/nSnVoGB8yHdfSnQfplYsXbynws+qCgBnX2Wzarb5Taf0f6umx9AglE
 hQzNRhfpDdlg==
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="481845558"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 22:28:12 -0800
Subject: [PATCH] x86/mm: Fix leak of pmd ptlock
From:   Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Cc:     stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Yi Zhang <yi.zhang@redhat.com>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        willy@infradead.org
Date:   Wed, 02 Dec 2020 22:28:12 -0800
Message-ID: <160697689204.605323.17629854984697045602.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 28ee90fe6048 ("x86/mm: implement free pmd/pte page interfaces")
introduced a new location where a pmd was released, but neglected to run
the pmd page destructor. In fact, this happened previously for a
different pmd release path and was fixed by commit:

c283610e44ec ("x86, mm: do not leak page->ptl for pmd page tables").

This issue was hidden until recently because the failure mode is silent,
but commit:

b2b29d6d0119 ("mm: account PMD tables like PTE tables")

...turns the failure mode into this signature:

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
tests is thus far not triggering the failure. As for a better helper
pmd_free() is close, but it is a messy fit due to requiring an @mm arg.
Also, ___pmd_free_tlb() wants to call paravirt_tlb_remove_table()
instead of free_page(), so open-coded pgtable_pmd_page_dtor() seems the
best way forward for now.

Fixes: 28ee90fe6048 ("x86/mm: implement free pmd/pte page interfaces")
Cc: <stable@vger.kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Co-debugged-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/mm/pgtable.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index dfd82f51ba66..f6a9e2e36642 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -829,6 +829,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 	}
 
 	free_page((unsigned long)pmd_sv);
+
+	pgtable_pmd_page_dtor(virt_to_page(pmd));
 	free_page((unsigned long)pmd);
 
 	return 1;

