Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5C4541176
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355929AbiFGThu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356496AbiFGTgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:36:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6E11ACE7A;
        Tue,  7 Jun 2022 11:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DCD66006F;
        Tue,  7 Jun 2022 18:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342F3C385A2;
        Tue,  7 Jun 2022 18:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625606;
        bh=/CyJwoKVuBaWLWd1+cNI4FVcV/PQuwuPI5jlFRzY3CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4Wh2wmDfZPIH8ez8ChT5BdwcGE0wiEOB2/3bk/nNdAdhH8vravSiCmAm9/KZRhkc
         /Hjm2zq2nOnWaYbmz3oUicIG17Klz6TvUnz4Gb5e24P5XNvfY4KE+oS7gZMrd6GhkW
         Wz2NN2sv0egeGYu1Wss7FyHXHq2E/WwGYGqqw/LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH 5.17 037/772] x86/sgx: Set active memcg prior to shmem allocation
Date:   Tue,  7 Jun 2022 18:53:49 +0200
Message-Id: <20220607164950.117359893@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristen Carlson Accardi <kristen@linux.intel.com>

commit 0c9782e204d3cc5625b9e8bf4e8625d38dfe0139 upstream.

When the system runs out of enclave memory, SGX can reclaim EPC pages
by swapping to normal RAM. These backing pages are allocated via a
per-enclave shared memory area. Since SGX allows unlimited over
commit on EPC memory, the reclaimer thread can allocate a large
number of backing RAM pages in response to EPC memory pressure.

When the shared memory backing RAM allocation occurs during
the reclaimer thread context, the shared memory is charged to
the root memory control group, and the shmem usage of the enclave
is not properly accounted for, making cgroups ineffective at
limiting the amount of RAM an enclave can consume.

For example, when using a cgroup to launch a set of test
enclaves, the kernel does not properly account for 50% - 75% of
shmem page allocations on average. In the worst case, when
nearly all allocations occur during the reclaimer thread, the
kernel accounts less than a percent of the amount of shmem used
by the enclave's cgroup to the correct cgroup.

SGX stores a list of mm_structs that are associated with
an enclave. Pick one of them during reclaim and charge that
mm's memcg with the shmem allocation. The one that gets picked
is arbitrary, but this list almost always only has one mm. The
cases where there is more than one mm with different memcg's
are not worth considering.

Create a new function - sgx_encl_alloc_backing(). This function
is used whenever a new backing storage page needs to be
allocated. Previously the same function was used for page
allocation as well as retrieving a previously allocated page.
Prior to backing page allocation, if there is a mm_struct associated
with the enclave that is requesting the allocation, it is set
as the active memory control group.

[ dhansen: - fix merge conflict with ELDU fixes
           - check against actual ksgxd_tsk, not ->mm ]

Cc: stable@vger.kernel.org
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Link: https://lkml.kernel.org/r/20220520174248.4918-1-kristen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/encl.c |  105 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.h |    7 +-
 arch/x86/kernel/cpu/sgx/main.c |    9 ++-
 3 files changed, 115 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -152,7 +152,7 @@ static int __sgx_encl_eldu(struct sgx_en
 
 	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 
-	ret = sgx_encl_get_backing(encl, page_index, &b);
+	ret = sgx_encl_lookup_backing(encl, page_index, &b);
 	if (ret)
 		return ret;
 
@@ -718,7 +718,7 @@ static struct page *sgx_encl_get_backing
  *   0 on success,
  *   -errno otherwise.
  */
-int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
+static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing)
 {
 	pgoff_t page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
@@ -743,6 +743,107 @@ int sgx_encl_get_backing(struct sgx_encl
 	return 0;
 }
 
+/*
+ * When called from ksgxd, returns the mem_cgroup of a struct mm stored
+ * in the enclave's mm_list. When not called from ksgxd, just returns
+ * the mem_cgroup of the current task.
+ */
+static struct mem_cgroup *sgx_encl_get_mem_cgroup(struct sgx_encl *encl)
+{
+	struct mem_cgroup *memcg = NULL;
+	struct sgx_encl_mm *encl_mm;
+	int idx;
+
+	/*
+	 * If called from normal task context, return the mem_cgroup
+	 * of the current task's mm. The remainder of the handling is for
+	 * ksgxd.
+	 */
+	if (!current_is_ksgxd())
+		return get_mem_cgroup_from_mm(current->mm);
+
+	/*
+	 * Search the enclave's mm_list to find an mm associated with
+	 * this enclave to charge the allocation to.
+	 */
+	idx = srcu_read_lock(&encl->srcu);
+
+	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+		if (!mmget_not_zero(encl_mm->mm))
+			continue;
+
+		memcg = get_mem_cgroup_from_mm(encl_mm->mm);
+
+		mmput_async(encl_mm->mm);
+
+		break;
+	}
+
+	srcu_read_unlock(&encl->srcu, idx);
+
+	/*
+	 * In the rare case that there isn't an mm associated with
+	 * the enclave, set memcg to the current active mem_cgroup.
+	 * This will be the root mem_cgroup if there is no active
+	 * mem_cgroup.
+	 */
+	if (!memcg)
+		return get_mem_cgroup_from_mm(NULL);
+
+	return memcg;
+}
+
+/**
+ * sgx_encl_alloc_backing() - allocate a new backing storage page
+ * @encl:	an enclave pointer
+ * @page_index:	enclave page index
+ * @backing:	data for accessing backing storage for the page
+ *
+ * When called from ksgxd, sets the active memcg from one of the
+ * mms in the enclave's mm_list prior to any backing page allocation,
+ * in order to ensure that shmem page allocations are charged to the
+ * enclave.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno otherwise.
+ */
+int sgx_encl_alloc_backing(struct sgx_encl *encl, unsigned long page_index,
+			   struct sgx_backing *backing)
+{
+	struct mem_cgroup *encl_memcg = sgx_encl_get_mem_cgroup(encl);
+	struct mem_cgroup *memcg = set_active_memcg(encl_memcg);
+	int ret;
+
+	ret = sgx_encl_get_backing(encl, page_index, backing);
+
+	set_active_memcg(memcg);
+	mem_cgroup_put(encl_memcg);
+
+	return ret;
+}
+
+/**
+ * sgx_encl_lookup_backing() - retrieve an existing backing storage page
+ * @encl:	an enclave pointer
+ * @page_index:	enclave page index
+ * @backing:	data for accessing backing storage for the page
+ *
+ * Retrieve a backing page for loading data back into an EPC page with ELDU.
+ * It is the caller's responsibility to ensure that it is appropriate to use
+ * sgx_encl_lookup_backing() rather than sgx_encl_alloc_backing(). If lookup is
+ * not used correctly, this will cause an allocation which is not accounted for.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno otherwise.
+ */
+int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_index,
+			   struct sgx_backing *backing)
+{
+	return sgx_encl_get_backing(encl, page_index, backing);
+}
+
 /**
  * sgx_encl_put_backing() - Unpin the backing storage
  * @backing:	data for accessing backing storage for the page
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -103,10 +103,13 @@ static inline int sgx_encl_find(struct m
 int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 		     unsigned long end, unsigned long vm_flags);
 
+bool current_is_ksgxd(void);
 void sgx_encl_release(struct kref *ref);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
-int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
-			 struct sgx_backing *backing);
+int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_index,
+			    struct sgx_backing *backing);
+int sgx_encl_alloc_backing(struct sgx_encl *encl, unsigned long page_index,
+			   struct sgx_backing *backing);
 void sgx_encl_put_backing(struct sgx_backing *backing);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -313,7 +313,7 @@ static void sgx_reclaimer_write(struct s
 	sgx_encl_put_backing(backing);
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
-		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
+		ret = sgx_encl_alloc_backing(encl, PFN_DOWN(encl->size),
 					   &secs_backing);
 		if (ret)
 			goto out;
@@ -384,7 +384,7 @@ static void sgx_reclaim_pages(void)
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
 
 		mutex_lock(&encl_page->encl->lock);
-		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
+		ret = sgx_encl_alloc_backing(encl_page->encl, page_index, &backing[i]);
 		if (ret) {
 			mutex_unlock(&encl_page->encl->lock);
 			goto skip;
@@ -475,6 +475,11 @@ static bool __init sgx_page_reclaimer_in
 	return true;
 }
 
+bool current_is_ksgxd(void)
+{
+	return current == ksgxd_tsk;
+}
+
 static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 {
 	struct sgx_numa_node *node = &sgx_numa_nodes[nid];


