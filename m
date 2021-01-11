Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A437D2F146E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbhAKNRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:17:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732617AbhAKNRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 820B82250F;
        Mon, 11 Jan 2021 13:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371027;
        bh=+pecJYo9xzO5xwLkoFM7mTiEqH6XONzcqbtZGX7VWVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEXsDedpM2/ReY6Gsu97lgLMLhAMam0j+ho3iD65lunZyGBfdnBI0P6kMbcMlHvhq
         dMqwOB3Vc/l08R4SI27t/yhFBiyFsuqfhWddPLCwQLNyIp8aizRBivmLnrVDFDCfWx
         nSeFIGspPv+QJvJ9K2AXU+DctcxPS0MJZgLY3Lpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>, Yi Zhang <yi.zhang@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 110/145] x86/mm: Fix leak of pmd ptlock
Date:   Mon, 11 Jan 2021 14:02:14 +0100
Message-Id: <20210111130053.813985590@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit d1c5246e08eb64991001d97a3bd119c93edbc79a upstream.

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
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/160697689204.605323.17629854984697045602.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/pgtable.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -829,6 +829,8 @@ int pud_free_pmd_page(pud_t *pud, unsign
 	}
 
 	free_page((unsigned long)pmd_sv);
+
+	pgtable_pmd_page_dtor(virt_to_page(pmd));
 	free_page((unsigned long)pmd);
 
 	return 1;


