Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A9553BE0F
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 20:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbiFBS1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 14:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiFBS1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 14:27:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3BF1CA5CC;
        Thu,  2 Jun 2022 11:27:11 -0700 (PDT)
Date:   Thu, 02 Jun 2022 18:27:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654194429;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FN+7csKYicW9pdCFmAWu30p2jRZ9WHNz+SNGKHVzuJQ=;
        b=0KPO0hgdzBTBhT90A5jH8g0l80I0TSVGEkb+ZKZLF/TuaZ05rHTeZU9H99Ps2KtnckoBUD
        47oOrCcXwZFJ4wXvX8Kjga/A5AZtu1C1Mhrv+xarfpnOUZC8I8aicNSsBZR/jqrgV68tGd
        ObCUpyzJNao1OKgRc0UNU/N9UK+rpxzoDWup1RujOxO7m+kPOpwKow19yhg0F4HBC/JgaZ
        ngxWsvvrAxz2YFl6M3XFY75YxRdZlF3B2Vi94clgG7y+hfZcWNDRe/Vsk14UrTDJaHAZGz
        eqWO9FTA/Ko+kHu3tNofLvgHxvRx4fzNSFapEFaOD3OP/ZBy6bF0P3aqPURWgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654194429;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FN+7csKYicW9pdCFmAWu30p2jRZ9WHNz+SNGKHVzuJQ=;
        b=AAs57Tm7F0DNuFOtXNuR+uGgFkNt1v5Xhn9bTx4nPJ325F4Ylmr6MG4G9Xhu9Ez6jwIHnt
        s0yZsQA2TAmglKBg==
From:   "tip-bot2 for Kristen Carlson Accardi" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sgx: Set active memcg prior to shmem allocation
Cc:     stable@vger.kernel.org,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220520174248.4918-1-kristen@linux.intel.com>
References: <20220520174248.4918-1-kristen@linux.intel.com>
MIME-Version: 1.0
Message-ID: <165419442842.4207.2566961916839377924.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     0c9782e204d3cc5625b9e8bf4e8625d38dfe0139
Gitweb:        https://git.kernel.org/tip/0c9782e204d3cc5625b9e8bf4e8625d38dfe0139
Author:        Kristen Carlson Accardi <kristen@linux.intel.com>
AuthorDate:    Fri, 20 May 2022 10:42:47 -07:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Thu, 02 Jun 2022 10:58:47 -07:00

x86/sgx: Set active memcg prior to shmem allocation

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
---
 arch/x86/kernel/cpu/sgx/encl.c | 105 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.h |   7 +-
 arch/x86/kernel/cpu/sgx/main.c |   9 ++-
 3 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 3c24e61..19876eb 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -152,7 +152,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 
-	ret = sgx_encl_get_backing(encl, page_index, &b);
+	ret = sgx_encl_lookup_backing(encl, page_index, &b);
 	if (ret)
 		return ret;
 
@@ -718,7 +718,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
  *   0 on success,
  *   -errno otherwise.
  */
-int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
+static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing)
 {
 	pgoff_t page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
@@ -743,6 +743,107 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
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
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index d44e737..332ef35 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -103,10 +103,13 @@ static inline int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
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
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ab4ec54..a78652d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -313,7 +313,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
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
@@ -475,6 +475,11 @@ static bool __init sgx_page_reclaimer_init(void)
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
