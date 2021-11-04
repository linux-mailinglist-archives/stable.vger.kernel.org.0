Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E284459BB
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhKDSbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:31:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:10292 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230504AbhKDSbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 14:31:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10158"; a="255413144"
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="255413144"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 11:29:10 -0700
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="668001627"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 11:29:10 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org
Cc:     seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] x86/sgx: Fix free page accounting
Date:   Thu,  4 Nov 2021 11:28:54 -0700
Message-Id: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
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
that will run when the total free pages go below a watermark to
ensure that there are always some free pages available to, for
example, support efficient page faults.

With sgx_nr_free_pages accessed and modified from a few places
it is essential to ensure that these accesses are done safely but
this is not the case. sgx_nr_free_pages is sometimes accessed
without any protection and when it is protected it is done
inconsistently with any one of the spin locks associated with the
individual NUMA nodes.

The consequence of sgx_nr_free_pages not being protected is that
its value may not accurately reflect the actual number of free
pages on the system, impacting the availability of free pages in
support of many flows. The problematic scenario is when the
reclaimer never runs because it believes there to be sufficient
free pages while any attempt to allocate a page fails because there
are no free pages available. The worst scenario observed was a
user space hang because of repeated page faults caused by
no free pages ever made available.

Change the global free page counter to an atomic type that
ensures simultaneous updates are done safely. While doing so, move
the updating of the variable outside of the spin lock critical
section to which it does not belong.

Cc: stable@vger.kernel.org
Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..8558d7d5f3e7 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -28,8 +28,7 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
-/* The free page list lock protected variables prepend the lock. */
-static unsigned long sgx_nr_free_pages;
+atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
 
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

