Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5902B52DEEF
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 23:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbiESVF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 17:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiESVF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 17:05:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC26EC3EE;
        Thu, 19 May 2022 14:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652994325; x=1684530325;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=U6UsIdGTHLgWMAOYHVDYKn5sAd/vxVp2U4dAWVH7xCI=;
  b=YHH3hzej1Uc6M1QoiEMDRc481ozhpaX4s9AnG/MabxlTIYxp9b7uabw1
   XazOxgKi7ApVo/C4uptaHNN4ygoeSdNvVEI+dwYd60gIQKpSyRHueF0ec
   oG2ScvcjiWwQVsyzmZQCD6H2LkcE3z8ppj9lY+l4X6Afpnz4yLpfIRSTG
   GeN0KgGR6h+qTy4610RIcCV4ewfHG76+WOtp3SYZPNeti3HwU2q9xmsPq
   LiiiNYT60n2m7na1xmWIklKrq5lGYUJ06T4hpDPyZbr7XseutwcrRuekz
   MoW1chBzWbKdOUAxXglZSpkQG37FgE1PXWqFfrK1fLFF6CD/PHhTwMa6o
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="252895819"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="252895819"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 14:05:25 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="598800580"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.148.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 14:05:23 -0700
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mhocko@suse.com, roman.gushchin@linux.dev,
        hannes@cmpxchg.org, shakeelb@google.com,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH v2] x86/sgx: Set active memcg prior to shmem allocation
Date:   Thu, 19 May 2022 14:04:45 -0700
Message-Id: <20220519210445.5310-1-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
V1 -> V2:
 Changed sgx_encl_set_active_memcg() to simply return the correct
 memcg for the enclave and renamed to sgx_encl_get_mem_cgroup().

 Created helper function current_is_ksgxd() to improve readability.

 Use mmget_not_zero()/mmput_async() when searching mm_list.

 Move call to set_active_memcg() to sgx_encl_alloc_backing() and
 use mem_cgroup_put() to avoid leaking a memcg reference.

 Address review feedback regarding comments and commit log.

 arch/x86/kernel/cpu/sgx/encl.c | 109 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.h |  11 +++-
 arch/x86/kernel/cpu/sgx/main.c |   4 +-
 3 files changed, 118 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 001808e3901c..6d10202612d6 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -32,7 +32,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	else
 		page_index = PFN_DOWN(encl->size);
 
-	ret = sgx_encl_get_backing(encl, page_index, &b);
+	ret = sgx_encl_lookup_backing(encl, page_index, &b);
 	if (ret)
 		return ret;
 
@@ -574,7 +574,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
  *   0 on success,
  *   -errno otherwise.
  */
-int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
+static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing)
 {
 	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
@@ -601,6 +601,111 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
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
+	struct mem_cgroup *memcg, *old_memcg;
+	int ret;
+
+	memcg = sgx_encl_get_mem_cgroup(encl);
+
+	old_memcg = set_active_memcg(memcg);
+
+	ret = sgx_encl_get_backing(encl, page_index, backing);
+
+	set_active_memcg(old_memcg);
+
+	mem_cgroup_put(memcg);
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
index fec43ca65065..2de3b150ab00 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -100,13 +100,20 @@ static inline int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
 	return 0;
 }
 
+static inline bool current_is_ksgxd(void)
+{
+	return current->mm ? false : true;
+}
+
 int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 		     unsigned long end, unsigned long vm_flags);
 
 void sgx_encl_release(struct kref *ref);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
-int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
-			 struct sgx_backing *backing);
+int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_index,
+			    struct sgx_backing *backing);
+int sgx_encl_alloc_backing(struct sgx_encl *encl, unsigned long page_index,
+			   struct sgx_backing *backing);
 void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4b41efc9e367..7d41c8538795 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -310,7 +310,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	encl->secs_child_cnt--;
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
-		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
+		ret = sgx_encl_alloc_backing(encl, PFN_DOWN(encl->size),
 					   &secs_backing);
 		if (ret)
 			goto out;
@@ -381,7 +381,7 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
-		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
+		ret = sgx_encl_alloc_backing(encl_page->encl, page_index, &backing[i]);
 		if (ret)
 			goto skip;
 
-- 
2.20.1

