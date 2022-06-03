Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FE853CF67
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345574AbiFCRyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347242AbiFCRwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB652BDE;
        Fri,  3 Jun 2022 10:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7DF7B823B0;
        Fri,  3 Jun 2022 17:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAB2C385A9;
        Fri,  3 Jun 2022 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278661;
        bh=gu/GON9TB219Xl36FcW1sJOa2e8mHgE4PmzKh6ejERI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+tjueWLKju94s11SxEEpQP7Qe7vN0rRo97FNIBDETYOzbu3jmM5KQDFvXLnkIXED
         PL36G5PdMFkrFUbV8zpfMnfQLLHVWSSqHMpBVgEduAfndOViuXamH58n9T//Uei1fH
         OEQt1EAxB0BQ2TzqqkP9/AnAUc8gfqTW/EspRCEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haitao Huang <haitao.huang@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 53/66] x86/sgx: Fix race between reclaimer and page fault handler
Date:   Fri,  3 Jun 2022 19:43:33 +0200
Message-Id: <20220603173822.195105971@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit af117837ceb9a78e995804ade4726ad2c2c8981f upstream.

Haitao reported encountering a WARN triggered by the ENCLS[ELDU]
instruction faulting with a #GP.

The WARN is encountered when the reclaimer evicts a range of
pages from the enclave when the same pages are faulted back right away.

Consider two enclave pages (ENCLAVE_A and ENCLAVE_B)
sharing a PCMD page (PCMD_AB). ENCLAVE_A is in the
enclave memory and ENCLAVE_B is in the backing store. PCMD_AB contains
just one entry, that of ENCLAVE_B.

Scenario proceeds where ENCLAVE_A is being evicted from the enclave
while ENCLAVE_B is faulted in.

sgx_reclaim_pages() {

  ...

  /*
   * Reclaim ENCLAVE_A
   */
  mutex_lock(&encl->lock);
  /*
   * Get a reference to ENCLAVE_A's
   * shmem page where enclave page
   * encrypted data will be stored
   * as well as a reference to the
   * enclave page's PCMD data page,
   * PCMD_AB.
   * Release mutex before writing
   * any data to the shmem pages.
   */
  sgx_encl_get_backing(...);
  encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
  mutex_unlock(&encl->lock);

                                    /*
                                     * Fault ENCLAVE_B
                                     */

                                    sgx_vma_fault() {

                                      mutex_lock(&encl->lock);
                                      /*
                                       * Get reference to
                                       * ENCLAVE_B's shmem page
                                       * as well as PCMD_AB.
                                       */
                                      sgx_encl_get_backing(...)
                                     /*
                                      * Load page back into
                                      * enclave via ELDU.
                                      */
                                     /*
                                      * Release reference to
                                      * ENCLAVE_B' shmem page and
                                      * PCMD_AB.
                                      */
                                     sgx_encl_put_backing(...);
                                     /*
                                      * PCMD_AB is found empty so
                                      * it and ENCLAVE_B's shmem page
                                      * are truncated.
                                      */
                                     /* Truncate ENCLAVE_B backing page */
                                     sgx_encl_truncate_backing_page();
                                     /* Truncate PCMD_AB */
                                     sgx_encl_truncate_backing_page();

                                     mutex_unlock(&encl->lock);

                                     ...
                                     }
  mutex_lock(&encl->lock);
  encl_page->desc &=
       ~SGX_ENCL_PAGE_BEING_RECLAIMED;
  /*
  * Write encrypted contents of
  * ENCLAVE_A to ENCLAVE_A shmem
  * page and its PCMD data to
  * PCMD_AB.
  */
  sgx_encl_put_backing(...)

  /*
   * Reference to PCMD_AB is
   * dropped and it is truncated.
   * ENCLAVE_A's PCMD data is lost.
   */
  mutex_unlock(&encl->lock);
}

What happens next depends on whether it is ENCLAVE_A being faulted
in or ENCLAVE_B being evicted - but both end up with ENCLS[ELDU] faulting
with a #GP.

If ENCLAVE_A is faulted then at the time sgx_encl_get_backing() is called
a new PCMD page is allocated and providing the empty PCMD data for
ENCLAVE_A would cause ENCLS[ELDU] to #GP

If ENCLAVE_B is evicted first then a new PCMD_AB would be allocated by the
reclaimer but later when ENCLAVE_A is faulted the ENCLS[ELDU] instruction
would #GP during its checks of the PCMD value and the WARN would be
encountered.

Noting that the reclaimer sets SGX_ENCL_PAGE_BEING_RECLAIMED at the time
it obtains a reference to the backing store pages of an enclave page it
is in the process of reclaiming, fix the race by only truncating the PCMD
page after ensuring that no page sharing the PCMD page is in the process
of being reclaimed.

Cc: stable@vger.kernel.org
Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
Reported-by: Haitao Huang <haitao.huang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Link: https://lkml.kernel.org/r/ed20a5db516aa813873268e125680041ae11dfcf.1652389823.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/encl.c |   94 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -12,6 +12,92 @@
 #include "encls.h"
 #include "sgx.h"
 
+#define PCMDS_PER_PAGE (PAGE_SIZE / sizeof(struct sgx_pcmd))
+/*
+ * 32 PCMD entries share a PCMD page. PCMD_FIRST_MASK is used to
+ * determine the page index associated with the first PCMD entry
+ * within a PCMD page.
+ */
+#define PCMD_FIRST_MASK GENMASK(4, 0)
+
+/**
+ * reclaimer_writing_to_pcmd() - Query if any enclave page associated with
+ *                               a PCMD page is in process of being reclaimed.
+ * @encl:        Enclave to which PCMD page belongs
+ * @start_addr:  Address of enclave page using first entry within the PCMD page
+ *
+ * When an enclave page is reclaimed some Paging Crypto MetaData (PCMD) is
+ * stored. The PCMD data of a reclaimed enclave page contains enough
+ * information for the processor to verify the page at the time
+ * it is loaded back into the Enclave Page Cache (EPC).
+ *
+ * The backing storage to which enclave pages are reclaimed is laid out as
+ * follows:
+ * Encrypted enclave pages:SECS page:PCMD pages
+ *
+ * Each PCMD page contains the PCMD metadata of
+ * PAGE_SIZE/sizeof(struct sgx_pcmd) enclave pages.
+ *
+ * A PCMD page can only be truncated if it is (a) empty, and (b) not in the
+ * process of getting data (and thus soon being non-empty). (b) is tested with
+ * a check if an enclave page sharing the PCMD page is in the process of being
+ * reclaimed.
+ *
+ * The reclaimer sets the SGX_ENCL_PAGE_BEING_RECLAIMED flag when it
+ * intends to reclaim that enclave page - it means that the PCMD page
+ * associated with that enclave page is about to get some data and thus
+ * even if the PCMD page is empty, it should not be truncated.
+ *
+ * Context: Enclave mutex (&sgx_encl->lock) must be held.
+ * Return: 1 if the reclaimer is about to write to the PCMD page
+ *         0 if the reclaimer has no intention to write to the PCMD page
+ */
+static int reclaimer_writing_to_pcmd(struct sgx_encl *encl,
+				     unsigned long start_addr)
+{
+	int reclaimed = 0;
+	int i;
+
+	/*
+	 * PCMD_FIRST_MASK is based on number of PCMD entries within
+	 * PCMD page being 32.
+	 */
+	BUILD_BUG_ON(PCMDS_PER_PAGE != 32);
+
+	for (i = 0; i < PCMDS_PER_PAGE; i++) {
+		struct sgx_encl_page *entry;
+		unsigned long addr;
+
+		addr = start_addr + i * PAGE_SIZE;
+
+		/*
+		 * Stop when reaching the SECS page - it does not
+		 * have a page_array entry and its reclaim is
+		 * started and completed with enclave mutex held so
+		 * it does not use the SGX_ENCL_PAGE_BEING_RECLAIMED
+		 * flag.
+		 */
+		if (addr == encl->base + encl->size)
+			break;
+
+		entry = xa_load(&encl->page_array, PFN_DOWN(addr));
+		if (!entry)
+			continue;
+
+		/*
+		 * VA page slot ID uses same bit as the flag so it is important
+		 * to ensure that the page is not already in backing store.
+		 */
+		if (entry->epc_page &&
+		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
+			reclaimed = 1;
+			break;
+		}
+	}
+
+	return reclaimed;
+}
+
 /*
  * Calculate byte offset of a PCMD struct associated with an enclave page. PCMD's
  * follow right after the EPC data in the backing storage. In addition to the
@@ -47,6 +133,7 @@ static int __sgx_encl_eldu(struct sgx_en
 	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
 	struct sgx_encl *encl = encl_page->encl;
 	pgoff_t page_index, page_pcmd_off;
+	unsigned long pcmd_first_page;
 	struct sgx_pageinfo pginfo;
 	struct sgx_backing b;
 	bool pcmd_page_empty;
@@ -58,6 +145,11 @@ static int __sgx_encl_eldu(struct sgx_en
 	else
 		page_index = PFN_DOWN(encl->size);
 
+	/*
+	 * Address of enclave page using the first entry within the PCMD page.
+	 */
+	pcmd_first_page = PFN_PHYS(page_index & ~PCMD_FIRST_MASK) + encl->base;
+
 	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 
 	ret = sgx_encl_get_backing(encl, page_index, &b);
@@ -99,7 +191,7 @@ static int __sgx_encl_eldu(struct sgx_en
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-	if (pcmd_page_empty)
+	if (pcmd_page_empty && !reclaimer_writing_to_pcmd(encl, pcmd_first_page))
 		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
 
 	return ret;


