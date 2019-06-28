Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898125A45E
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfF1SmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:42:16 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:48116 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbfF1SmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:42:16 -0400
Received: from [4.30.142.84] (helo=[127.0.1.1])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hgvp9-000Swq-Hb; Fri, 28 Jun 2019 14:42:15 -0400
Subject: [4.19.y PATCH 1/3] efi/x86/Add missing error handling to old_memmap
 1:1 mapping code
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Bradford <robert.bradford@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        akaher@vmware.com, srinidhir@vmware.com, bvikas@vmware.com,
        amakhalov@vmware.com, srivatsab@vmware.com, srivatsa@csail.mit.edu
Date:   Fri, 28 Jun 2019 11:42:13 -0700
Message-ID: <156174732219.34985.6679541271840078416.stgit@srivatsa-ubuntu>
In-Reply-To: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

commit 4e78921ba4dd0aca1cc89168f45039add4183f8e upstream.

The old_memmap flow in efi_call_phys_prolog() performs numerous memory
allocations, and either does not check for failure at all, or it does
but fails to propagate it back to the caller, which may end up calling
into the firmware with an incomplete 1:1 mapping.

So let's fix this by returning NULL from efi_call_phys_prolog() on
memory allocation failures only, and by handling this condition in the
caller. Also, clean up any half baked sets of page tables that we may
have created before returning with a NULL return value.

Note that any failure at this level will trigger a panic() two levels
up, so none of this makes a huge difference, but it is a nice cleanup
nonetheless.

[ardb: update commit log, add efi_call_phys_epilog() call on error path]

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rob Bradford <robert.bradford@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20190525112559.7917-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
---

 arch/x86/platform/efi/efi.c    |    2 ++
 arch/x86/platform/efi/efi_64.c |    9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 9061bab..353019d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -86,6 +86,8 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	pgd_t *save_pgd;
 
 	save_pgd = efi_call_phys_prolog();
+	if (!save_pgd)
+		return EFI_ABORTED;
 
 	/* Disable interrupts around EFI calls: */
 	local_irq_save(flags);
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ee5d08f..dfc809b 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -84,13 +84,15 @@ pgd_t * __init efi_call_phys_prolog(void)
 
 	if (!efi_enabled(EFI_OLD_MEMMAP)) {
 		efi_switch_mm(&efi_mm);
-		return NULL;
+		return efi_mm.pgd;
 	}
 
 	early_code_mapping_set_exec(1);
 
 	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
 	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
+	if (!save_pgd)
+		return NULL;
 
 	/*
 	 * Build 1:1 identity mapping for efi=old_map usage. Note that
@@ -138,10 +140,11 @@ pgd_t * __init efi_call_phys_prolog(void)
 		pgd_offset_k(pgd * PGDIR_SIZE)->pgd &= ~_PAGE_NX;
 	}
 
-out:
 	__flush_tlb_all();
-
 	return save_pgd;
+out:
+	efi_call_phys_epilog(save_pgd);
+	return NULL;
 }
 
 void __init efi_call_phys_epilog(pgd_t *save_pgd)

