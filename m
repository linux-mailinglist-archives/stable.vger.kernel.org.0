Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA0E52AA29
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351925AbiEQSMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352098AbiEQSMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:12:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC153A461;
        Tue, 17 May 2022 11:12:05 -0700 (PDT)
Date:   Tue, 17 May 2022 18:12:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652811124;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zT74IsFjaBGYnYr73/KQVUxvkSUQ5oNAQYBdO3Q7jRM=;
        b=N5JYoh+EFxF5TZv0a0WLc0vxD0lG1Zm39ojKLWmbG/2+lazu8MhUg99xUpteKUCf2V1V8m
        HYW6+td34S18aB6kX+kmdYkp5LKUYc03zy8KI2Gxw1wxvnCdRRY4317mu7GDEpZf0HzJ1z
        nyrMKJwyBrCa1Abm6m6NJDVhZUOvnGP53dGBg2dGhrhVe8ieQyvnsZqrhJtwPsHC3yB+uT
        xQ4OVAH8f10q5S5aj1OqmQ9Jpn2yRa2g5HOcOBcXWPCvBWHOqzKTi8q3qIAHPYbhwiBt9F
        gYT8JRhkuhKinfM51VnhryjswdYxq/EUMI3l62gQmQejhJlIGo33rbkhvAwEHw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652811124;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zT74IsFjaBGYnYr73/KQVUxvkSUQ5oNAQYBdO3Q7jRM=;
        b=heus7phjg9FxtT7scbZONDYtBAzzjB8PBfXUVt2QJfIRZSwhzeBpKaektsnJ86xnS5WFmz
        9mJ9SpNEcxK/dNAA==
From:   "tip-bot2 for Reinette Chatre" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/sgx] x86/sgx: Disconnect backing page references from dirty status
Cc:     stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3Cfa9f98986923f43e72ef4c6702a50b2a0b3c42e3=2E16523?=
 =?utf-8?q?89823=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
References: =?utf-8?q?=3Cfa9f98986923f43e72ef4c6702a50b2a0b3c42e3=2E165238?=
 =?utf-8?q?9823=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <165281112316.4207.7499265545931946668.tip-bot2@tip-bot2>
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

Commit-ID:     6bd429643cc265e94a9d19839c771bcc5d008fa8
Gitweb:        https://git.kernel.org/tip/6bd429643cc265e94a9d19839c771bcc5d008fa8
Author:        Reinette Chatre <reinette.chatre@intel.com>
AuthorDate:    Thu, 12 May 2022 14:50:57 -07:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Mon, 16 May 2022 15:15:51 -07:00

x86/sgx: Disconnect backing page references from dirty status

SGX uses shmem backing storage to store encrypted enclave pages
and their crypto metadata when enclave pages are moved out of
enclave memory. Two shmem backing storage pages are associated with
each enclave page - one backing page to contain the encrypted
enclave page data and one backing page (shared by a few
enclave pages) to contain the crypto metadata used by the
processor to verify the enclave page when it is loaded back into
the enclave.

sgx_encl_put_backing() is used to release references to the
backing storage and, optionally, mark both backing store pages
as dirty.

Managing references and dirty status together in this way results
in both backing store pages marked as dirty, even if only one of
the backing store pages are changed.

Additionally, waiting until the page reference is dropped to set
the page dirty risks a race with the page fault handler that
may load outdated data into the enclave when a page is faulted
right after it is reclaimed.

Consider what happens if the reclaimer writes a page to the backing
store and the page is immediately faulted back, before the reclaimer
is able to set the dirty bit of the page:

sgx_reclaim_pages() {                    sgx_vma_fault() {
  ...
  sgx_encl_get_backing();
  ...                                      ...
  sgx_reclaimer_write() {
    mutex_lock(&encl->lock);
    /* Write data to backing store */
    mutex_unlock(&encl->lock);
  }
                                           mutex_lock(&encl->lock);
                                           __sgx_encl_eldu() {
                                             ...
                                             /*
                                              * Enclave backing store
                                              * page not released
                                              * nor marked dirty -
                                              * contents may not be
                                              * up to date.
                                              */
                                              sgx_encl_get_backing();
                                              ...
                                              /*
                                               * Enclave data restored
                                               * from backing store
                                               * and PCMD pages that
                                               * are not up to date.
                                               * ENCLS[ELDU] faults
                                               * because of MAC or PCMD
                                               * checking failure.
                                               */
                                               sgx_encl_put_backing();
                                            }
                                            ...
  /* set page dirty */
  sgx_encl_put_backing();
  ...
                                            mutex_unlock(&encl->lock);
}                                        }

Remove the option to sgx_encl_put_backing() to set the backing
pages as dirty and set the needed pages as dirty right after
receiving important data while enclave mutex is held. This ensures that
the page fault handler can get up to date data from a page and prepares
the code for a following change where only one of the backing pages
need to be marked as dirty.

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Link: https://lore.kernel.org/linux-sgx/8922e48f-6646-c7cc-6393-7c78dcf23d23@intel.com/
Link: https://lkml.kernel.org/r/fa9f98986923f43e72ef4c6702a50b2a0b3c42e3.1652389823.git.reinette.chatre@intel.com
---
 arch/x86/kernel/cpu/sgx/encl.c | 10 ++--------
 arch/x86/kernel/cpu/sgx/encl.h |  2 +-
 arch/x86/kernel/cpu/sgx/main.c |  6 ++++--
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7c63a19..398695a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -94,7 +94,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	sgx_encl_put_backing(&b, false);
+	sgx_encl_put_backing(&b);
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
@@ -645,15 +645,9 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 /**
  * sgx_encl_put_backing() - Unpin the backing storage
  * @backing:	data for accessing backing storage for the page
- * @do_write:	mark pages dirty
  */
-void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
+void sgx_encl_put_backing(struct sgx_backing *backing)
 {
-	if (do_write) {
-		set_page_dirty(backing->pcmd);
-		set_page_dirty(backing->contents);
-	}
-
 	put_page(backing->pcmd);
 	put_page(backing->contents);
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index fec43ca..d44e737 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -107,7 +107,7 @@ void sgx_encl_release(struct kref *ref);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
 int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing);
-void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
+void sgx_encl_put_backing(struct sgx_backing *backing);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8e4bc64..e71df40 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -191,6 +191,8 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
 			  backing->pcmd_offset;
 
 	ret = __ewb(&pginfo, sgx_get_epc_virt_addr(epc_page), va_slot);
+	set_page_dirty(backing->pcmd);
+	set_page_dirty(backing->contents);
 
 	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
 					      backing->pcmd_offset));
@@ -320,7 +322,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
-		sgx_encl_put_backing(&secs_backing, true);
+		sgx_encl_put_backing(&secs_backing);
 	}
 
 out:
@@ -411,7 +413,7 @@ skip:
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i], true);
+		sgx_encl_put_backing(&backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
