Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680834883E8
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 15:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiAHOFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 09:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiAHOFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 09:05:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46470C061574;
        Sat,  8 Jan 2022 06:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B040560765;
        Sat,  8 Jan 2022 14:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993B8C36AE9;
        Sat,  8 Jan 2022 14:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641650721;
        bh=tsd6QKgwnEqcOh0jtyyg+k1WJ1P/nOav/IHxxqAhnHQ=;
        h=From:To:Cc:Subject:Date:From;
        b=LjTx04+wRM6N2/WjYz1sAoYw0rzejzJ+8230soxINy64cj47AKDH4zFfoyiGX4FCu
         43hkF8Y0aRvGFtqSSQUdqOuo6KkhnvfO3qhGNDiJx57M9fHCAtVAuHoeIvDqa6C96B
         qEQKghUxZpy1qsfYpTgZqJzfqlC4ogRCVPFI4oeYI2Ep7VPRrzzvTuGr7/zChYG43g
         Ck8PJmma3ebCs4v5wxIsOP+q8iLY+A61yCM1TvyJZvJnlX156SQRfr++mdWcvHA4/x
         bLw670HMec32GyzmmoSXSgOtMlk959nYS/IOMC1a1iIvIQOQyEkp3Gq6xKz1RfykCc
         GvfHukmMLjt0w==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v3] x86/sgx: Free backing memory after faulting the enclave page
Date:   Sat,  8 Jan 2022 16:05:10 +0200
Message-Id: <20220108140510.76583-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a limited amount of SGX memory (EPC) on each system.  When that
memory is used up, SGX has its own swapping mechanism which is similar
in concept but totally separate from the core mm/* code.  Instead of
swapping to disk, SGX swaps from EPC to normal RAM.  That normal RAM
comes from a shared memory pseudo-file and can itself be swapped by the
core mm code.  There is a hierarchy like this:

	EPC <-> shmem <-> disk

After data is swapped back in from shmem to EPC, the shmem backing
storage needs to be freed.  Currently, the backing shmem is not freed.
This effectively wastes the shmem while the enclave is running.  The
memory is recovered when the enclave is destroyed and the backing
storage freed.

Sort this out by freeing memory with shmem_truncate_range(), as soon as
a page is faulted back to the EPC.  In addition, free the memory for
PCMD pages as soon as all PCMD's in a page have been marked as unused
by zeroing its contents.

Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v3:
* Resend.
v2:
* Rewrite commit message as proposed by Dave.
* Truncate PCMD pages (Dave).
---
 arch/x86/kernel/cpu/sgx/encl.c | 48 +++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 001808e3901c..ea43c10e5458 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -12,6 +12,27 @@
 #include "encls.h"
 #include "sgx.h"
 
+
+/*
+ * Get the page number of the page in the backing storage, which stores the PCMD
+ * of the enclave page in the given page index.  PCMD pages are located after
+ * the backing storage for the visible enclave pages and SECS.
+ */
+static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
+{
+	return PFN_DOWN(encl->size) + 1 + (index / sizeof(struct sgx_pcmd));
+}
+
+/*
+ * Free a page from the backing storage in the given page index.
+ */
+static inline void sgx_encl_truncate_backing_page(struct sgx_encl *encl, pgoff_t index)
+{
+	struct inode *inode = file_inode(encl->backing);
+
+	shmem_truncate_range(inode, PFN_PHYS(index), PFN_PHYS(index) + PAGE_SIZE - 1);
+}
+
 /*
  * ELDU: Load an EPC page as unblocked. For more info, see "OS Management of EPC
  * Pages" in the SDM.
@@ -24,7 +45,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_pageinfo pginfo;
 	struct sgx_backing b;
+	bool pcmd_page_empty;
 	pgoff_t page_index;
+	pgoff_t pcmd_index;
+	u8 *pcmd_page;
 	int ret;
 
 	if (secs_page)
@@ -38,8 +62,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	pginfo.addr = encl_page->desc & PAGE_MASK;
 	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
-	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
-			  b.pcmd_offset;
+	pcmd_page = kmap_atomic(b.pcmd);
+	pginfo.metadata = (unsigned long)pcmd_page + b.pcmd_offset;
 
 	if (secs_page)
 		pginfo.secs = (u64)sgx_get_epc_virt_addr(secs_page);
@@ -55,11 +79,27 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 		ret = -EFAULT;
 	}
 
-	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
+	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
+
+	/*
+	 * The area for the PCMD in the page was zeroed above.  Check if the
+	 * whole page is now empty meaning that all PCMD's have been zeroed:
+	 */
+	pcmd_page_empty = !memchr_inv(pcmd_page, 0, PAGE_SIZE);
+
+	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
 	sgx_encl_put_backing(&b, false);
 
+	/* Free the backing memory. */
+	sgx_encl_truncate_backing_page(encl, page_index);
+
+	if (pcmd_page_empty) {
+		pcmd_index = sgx_encl_get_backing_pcmd_nr(encl, page_index);
+		sgx_encl_truncate_backing_page(encl, pcmd_index);
+	}
+
 	return ret;
 }
 
@@ -577,7 +617,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
 int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing)
 {
-	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
+	pgoff_t pcmd_index = sgx_encl_get_backing_pcmd_nr(encl, page_index);
 	struct page *contents;
 	struct page *pcmd;
 
-- 
2.34.1

