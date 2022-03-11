Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DA24D5669
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 01:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344882AbiCKAQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 19:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbiCKAQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 19:16:55 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EDAAB44E;
        Thu, 10 Mar 2022 16:15:53 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:15:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646957749;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yt3MkfBwVR8zjm6WcsY98Muh80Kn70Hk+yeL0BKwiYA=;
        b=e4K6j03iGP91fXsy3bOvYKrUe12hzhw/9oAb1Ereto6MLLKwlXfMMhoeqxB5X7E2hLY2i8
        bakmTl7ZJcFUypvhmSDrCdxENe4GTzXNe4RZp7MRabq6uBesdl1eB5ESProx6SzHTSU9Tl
        el0nhvtvf/Qp0uTt7Mm+z2wtDbkkTRR/9iwQEcTSViB2K6nsvwQS3jQIPX42dHs84tihGK
        pp0D4W6A0ZlVYXQkncXBkaQj8tBsE7YpcpRVWqmHBq9WHFW+toCFJFmd3OMChouC8IXuHw
        x/EC46OqfWoJPcFgoy4s3v/P2EKKLZ7SFlC528Tq5tOeZjxCxrMjmfqlFkEUuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646957749;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yt3MkfBwVR8zjm6WcsY98Muh80Kn70Hk+yeL0BKwiYA=;
        b=+UpFYVAxgUBIrhbEjkm9etTDLnwDnNPfynQ03jhhGlFWrs9f0Gyj/ZzQ5pnJzIN3V5LA/r
        bKjb4GV0qJPGfGAg==
From:   "tip-bot2 for Jarkko Sakkinen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/sgx] x86/sgx: Free backing memory after faulting the enclave page
Cc:     stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220303223859.273187-1-jarkko@kernel.org>
References: <20220303223859.273187-1-jarkko@kernel.org>
MIME-Version: 1.0
Message-ID: <164695774789.16921.7875752361736095667.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/sgx branch of tip:

Commit-ID:     ed83935a9af088439462ef3f2efcf1ef62b05dfd
Gitweb:        https://git.kernel.org/tip/ed83935a9af088439462ef3f2efcf1ef62b05dfd
Author:        Jarkko Sakkinen <jarkko@kernel.org>
AuthorDate:    Fri, 04 Mar 2022 00:38:58 +02:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Thu, 10 Mar 2022 16:09:40 -08:00

x86/sgx: Free backing memory after faulting the enclave page

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

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20220303223859.273187-1-jarkko@kernel.org
---
 arch/x86/kernel/cpu/sgx/encl.c | 57 +++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 001808e..6fa3d0a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -13,6 +13,30 @@
 #include "sgx.h"
 
 /*
+ * Calculate byte offset of a PCMD struct associated with an enclave page. PCMD's
+ * follow right after the EPC data in the backing storage. In addition to the
+ * visible enclave pages, there's one extra page slot for SECS, before PCMD
+ * structs.
+ */
+static inline pgoff_t sgx_encl_get_backing_page_pcmd_offset(struct sgx_encl *encl,
+							    unsigned long page_index)
+{
+	pgoff_t epc_end_off = encl->size + sizeof(struct sgx_secs);
+
+	return epc_end_off + page_index * sizeof(struct sgx_pcmd);
+}
+
+/*
+ * Free a page from the backing storage in the given page index.
+ */
+static inline void sgx_encl_truncate_backing_page(struct sgx_encl *encl, unsigned long page_index)
+{
+	struct inode *inode = file_inode(encl->backing);
+
+	shmem_truncate_range(inode, PFN_PHYS(page_index), PFN_PHYS(page_index) + PAGE_SIZE - 1);
+}
+
+/*
  * ELDU: Load an EPC page as unblocked. For more info, see "OS Management of EPC
  * Pages" in the SDM.
  */
@@ -22,9 +46,11 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 {
 	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
 	struct sgx_encl *encl = encl_page->encl;
+	pgoff_t page_index, page_pcmd_off;
 	struct sgx_pageinfo pginfo;
 	struct sgx_backing b;
-	pgoff_t page_index;
+	bool pcmd_page_empty;
+	u8 *pcmd_page;
 	int ret;
 
 	if (secs_page)
@@ -32,14 +58,16 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	else
 		page_index = PFN_DOWN(encl->size);
 
+	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
+
 	ret = sgx_encl_get_backing(encl, page_index, &b);
 	if (ret)
 		return ret;
 
 	pginfo.addr = encl_page->desc & PAGE_MASK;
 	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
-	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
-			  b.pcmd_offset;
+	pcmd_page = kmap_atomic(b.pcmd);
+	pginfo.metadata = (unsigned long)pcmd_page + b.pcmd_offset;
 
 	if (secs_page)
 		pginfo.secs = (u64)sgx_get_epc_virt_addr(secs_page);
@@ -55,11 +83,24 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
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
 
+	sgx_encl_truncate_backing_page(encl, page_index);
+
+	if (pcmd_page_empty)
+		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
+
 	return ret;
 }
 
@@ -577,7 +618,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
 int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing)
 {
-	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
+	pgoff_t page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 	struct page *contents;
 	struct page *pcmd;
 
@@ -585,7 +626,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 	if (IS_ERR(contents))
 		return PTR_ERR(contents);
 
-	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
+	pcmd = sgx_encl_get_backing_page(encl, PFN_DOWN(page_pcmd_off));
 	if (IS_ERR(pcmd)) {
 		put_page(contents);
 		return PTR_ERR(pcmd);
@@ -594,9 +635,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 	backing->page_index = page_index;
 	backing->contents = contents;
 	backing->pcmd = pcmd;
-	backing->pcmd_offset =
-		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
-		sizeof(struct sgx_pcmd);
+	backing->pcmd_offset = page_pcmd_off & (PAGE_SIZE - 1);
 
 	return 0;
 }
