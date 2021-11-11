Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C11944DB35
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhKKRrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 12:47:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhKKRrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 12:47:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 115F861268;
        Thu, 11 Nov 2021 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636652660;
        bh=9Gq0v0p33pbfM5GnyjHDOkIzDG8zl78YxZZdO6V/SAo=;
        h=From:To:Cc:Subject:Date:From;
        b=ACl630hv72QwnL86vhB9yF7sypTrTSmWzpgqFQ+a9kIDxyiEpKURrCOJVrC/DDS1W
         rklqg+8BIOiHAhLDV2SQCKFZOc+QDG8DjCXYIAKRYKqAPfvmE8PYtuGWFJKYbSVz1F
         RnODRi4csuSnOsrozx6N4lc40x4lt2tcacxbJu7cnIyjurgxn85Is7ze3yvB+aYqbF
         0rJbGgUa+gzrYGl5ZjOPjC2po0G3TvI3zZTqL9PFAmqQ9dvheguJ2PPDz4WhX+nci4
         yeSDnGwG5S0/yXcufhU0u/0RsAc+j3JUkPuxC80aALGhjX2e+L35P/Gw1jtYHdmEeg
         n+aw+cx+7NQDg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86/sgx: Free backing memory after faulting the enclave page
Date:   Thu, 11 Nov 2021 19:44:01 +0200
Message-Id: <20211111174401.865493-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
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
2.32.0

