Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216AA453B96
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 22:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhKPV2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 16:28:13 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55162 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhKPV2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 16:28:13 -0500
Date:   Tue, 16 Nov 2021 21:25:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637097914;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nxUrK/hTSDv6R/0wGYisup3X3LUWG1GgdUO+2f8fwE=;
        b=Ubas76CGF44ySGXKpCXPuSMV+NroD8jvIqUWJNjf/n/LaEQ4Za7lzH7lAx2SuwGD7BKVTJ
        trOzZn7Bl91tj8WZp+VEocZU0gaJT4vXMnew3CxrxXN2yJ8gccigO6lCGYeXaAnoqLiNDA
        jYK2RYLFYrujSAYh8RFRkWC9qX8/EaVZBuqY82t66w9V4p6MIDcEn3dbxJL0upnZ/xZ8Y+
        ikUKZ14JWZaktL8EZ8ywiMTejeljwkAwHKGBhKkM8fyACLdIN2tegVsOyvGKIt/hh0DJ0m
        kgbC7hDT83JuPcKgSPeDfYYW6FX3C962Xn/zX4I5Zc/z1jVFwPY5GiE7NyGAHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637097914;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nxUrK/hTSDv6R/0wGYisup3X3LUWG1GgdUO+2f8fwE=;
        b=34KDUw1o+oFgFlPussrsI4iKylROsqomJUI8gfBhb3KfKh7G+TegQMayzGWdqNdlLB4CK2
        uock7EvweU7XKpDw==
From:   "tip-bot2 for Reinette Chatre" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sgx: Fix free page accounting
Cc:     stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3Ca95a40743bbd3f795b465f30922dde7f1ea9e0eb=2E16370?=
 =?utf-8?q?04094=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
References: =?utf-8?q?=3Ca95a40743bbd3f795b465f30922dde7f1ea9e0eb=2E163700?=
 =?utf-8?q?4094=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <163709791320.414.3161205179225001373.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     ac5d272a0ad0419f52e08c91953356e32b075af7
Gitweb:        https://git.kernel.org/tip/ac5d272a0ad0419f52e08c91953356e32b075af7
Author:        Reinette Chatre <reinette.chatre@intel.com>
AuthorDate:    Mon, 15 Nov 2021 11:29:04 -08:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Tue, 16 Nov 2021 11:17:43 -08:00

x86/sgx: Fix free page accounting

The SGX driver maintains a single global free page counter,
sgx_nr_free_pages, that reflects the number of free pages available
across all NUMA nodes. Correspondingly, a list of free pages is
associated with each NUMA node and sgx_nr_free_pages is updated
every time a page is added or removed from any of the free page
lists. The main usage of sgx_nr_free_pages is by the reclaimer
that runs when it (sgx_nr_free_pages) goes below a watermark
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

Since sgx_nr_free_pages may be protected by different spin locks
while being modified from different CPUs, the following scenario
is possible:

      CPU_A                                CPU_B
      -----                                -----
{sgx_nr_free_pages = 100}
 spin_lock(&nodeA->lock);              spin_lock(&nodeB->lock);
 sgx_nr_free_pages--;                  sgx_nr_free_pages--;
 /* LOAD sgx_nr_free_pages = 100 */    /* LOAD sgx_nr_free_pages = 100 */
 /* sgx_nr_free_pages--          */    /* sgx_nr_free_pages--          */
 /* STORE sgx_nr_free_pages = 99 */    /* STORE sgx_nr_free_pages = 99 */
 spin_unlock(&nodeA->lock);            spin_unlock(&nodeB->lock);

In the above scenario, sgx_nr_free_pages is decremented from two CPUs
but instead of sgx_nr_free_pages ending with a value that is two less
than it started with, it was only decremented by one while the number
of free pages were actually reduced by two. The consequence of
sgx_nr_free_pages not being protected is that its value may not
accurately reflect the actual number of free pages on the system,
impacting the availability of free pages in support of many flows.

The problematic scenario is when the reclaimer does not run because it
believes there to be sufficient free pages while any attempt to allocate
a page fails because there are no free pages available. In the SGX driver
the reclaimer's watermark is only 32 pages so after encountering the
above example scenario 32 times a user space hang is possible when there
are no more free pages because of repeated page faults caused by no
free pages made available.

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
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lkml.kernel.org/r/a95a40743bbd3f795b465f30922dde7f1ea9e0eb.1637004094.git.reinette.chatre@intel.com
---
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de0..8471a8b 100644
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
@@ -403,14 +402,15 @@ skip:
 
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
