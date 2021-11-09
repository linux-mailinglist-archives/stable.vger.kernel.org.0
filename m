Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A9244B3AB
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 21:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244043AbhKIUDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 15:03:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:59920 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242871AbhKIUDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 15:03:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="256212988"
X-IronPort-AV: E=Sophos;i="5.87,221,1631602800"; 
   d="scan'208";a="256212988"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 12:01:04 -0800
X-IronPort-AV: E=Sophos;i="5.87,221,1631602800"; 
   d="scan'208";a="452039533"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 12:01:03 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org
Cc:     seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH V2] x86/sgx: Fix free page accounting
Date:   Tue,  9 Nov 2021 12:00:56 -0800
Message-Id: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SGX driver maintains a single global free page counter,
sgx_nr_free_pages, that reflects the number of free pages available
across all NUMA nodes. Correspondingly, a list of free pages is
associated with each NUMA node and sgx_nr_free_pages is updated
every time a page is added or removed from any of the free page
lists. The main usage of sgx_nr_free_pages is by the reclaimer
that will run when it (sgx_nr_free_pages) goes below a watermark
to ensure that there are always some free pages available to, for
example, support efficient page faults.

With sgx_nr_free_pages accessed and modified from a few places
it is essential to ensure that these accesses are done safely but
this is not the case. sgx_nr_free_pages is read without any
protection and updated with inconsistent protection by any one
of the spin locks associated with the individual NUMA nodes.
For example:

      CPU_A                                 CPU_B
      -----                                 -----
 spin_lock(&nodeA->lock);              spin_lock(&nodeB->lock);
 ...                                   ...
 sgx_nr_free_pages--;  /* NOT SAFE */  sgx_nr_free_pages--;

 spin_unlock(&nodeA->lock);            spin_unlock(&nodeB->lock);

The consequence of sgx_nr_free_pages not being protected is that
its value may not accurately reflect the actual number of free
pages on the system, impacting the availability of free pages in
support of many flows. The problematic scenario is when the
reclaimer does not run because it believes there to be sufficient
free pages while any attempt to allocate a page fails because there
are no free pages available.

The worst scenario observed was a user space hang because of
repeated page faults caused by no free pages made available.

The following flow was encountered:
asm_exc_page_fault
 ...
   sgx_vma_fault()
     sgx_encl_load_page()
       sgx_encl_eldu() // Encrypted page needs to be loaded from backing
                       // storage into newly allocated SGX memory page
         sgx_alloc_epc_page() // Allocate a page of SGX memory
           __sgx_alloc_epc_page() // Fails, no free SGX memory
           ...
           if (sgx_should_reclaim(SGX_NR_LOW_PAGES)) // Wake reclaimer
             wake_up(&ksgxd_waitq);
           return -EBUSY; // Return -EBUSY giving reclaimer time to run
       return -EBUSY;
     return -EBUSY;
   return VM_FAULT_NOPAGE;

The reclaimer is triggered in above flow with the following code:

static bool sgx_should_reclaim(unsigned long watermark)
{
        return sgx_nr_free_pages < watermark &&
               !list_empty(&sgx_active_page_list);
}

In the problematic scenario there were no free pages available yet the
value of sgx_nr_free_pages was above the watermark. The allocation of
SGX memory thus always failed because of a lack of free pages while no
free pages were made available because the reclaimer is never started
because of sgx_nr_free_pages' incorrect value. The consequence was that
user space kept encountering VM_FAULT_NOPAGE that caused the same
address to be accessed repeatedly with the same result.

Change the global free page counter to an atomic type that
ensures simultaneous updates are done safely. While doing so, move
the updating of the variable outside of the spin lock critical
section to which it does not belong.

Cc: stable@vger.kernel.org
Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

Changes since V1:
- V1:
  https://lore.kernel.org/lkml/373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com/
- Add static to definition of sgx_nr_free_pages (Tony).
- Add Tony's signature.
- Provide detail about error scenario in changelog (Jarkko).

 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..8471a8b9b48e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -28,8 +28,7 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
-/* The free page list lock protected variables prepend the lock. */
-static unsigned long sgx_nr_free_pages;
+static atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
 
 /* Nodes with one or more EPC sections. */
 static nodemask_t sgx_numa_mask;
@@ -403,14 +402,15 @@ static void sgx_reclaim_pages(void)
 
 		spin_lock(&node->lock);
 		list_add_tail(&epc_page->list, &node->free_page_list);
-		sgx_nr_free_pages++;
 		spin_unlock(&node->lock);
+		atomic_long_inc(&sgx_nr_free_pages);
 	}
 }
 
 static bool sgx_should_reclaim(unsigned long watermark)
 {
-	return sgx_nr_free_pages < watermark && !list_empty(&sgx_active_page_list);
+	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
+	       !list_empty(&sgx_active_page_list);
 }
 
 static int ksgxd(void *p)
@@ -471,9 +471,9 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 
 	page = list_first_entry(&node->free_page_list, struct sgx_epc_page, list);
 	list_del_init(&page->list);
-	sgx_nr_free_pages--;
 
 	spin_unlock(&node->lock);
+	atomic_long_dec(&sgx_nr_free_pages);
 
 	return page;
 }
@@ -625,9 +625,9 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	spin_lock(&node->lock);
 
 	list_add_tail(&page->list, &node->free_page_list);
-	sgx_nr_free_pages++;
 
 	spin_unlock(&node->lock);
+	atomic_long_inc(&sgx_nr_free_pages);
 }
 
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
-- 
2.25.1

