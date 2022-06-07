Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A1F53CF2A
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345682AbiFCRyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347226AbiFCRwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48ED7F25;
        Fri,  3 Jun 2022 10:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BAFDB823B0;
        Fri,  3 Jun 2022 17:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677A7C385A9;
        Fri,  3 Jun 2022 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278652;
        bh=0prqloLrALboBqYx7GfVhCOuXhFihqnnhoizcnn15Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lo/x2PSzYmImbEn+IGYQwxaCQyDiPB4HA6nCecSe7VA91IuvWs6oQuewqCYXQMu26
         fSlpCLmZRvR6plPajG8S023X/ySIK1zWMvSHJhlIgZkqpjLZxw6wzJr3hKM/t+w/bs
         85JirLI7qBU75kkyZ7FO+e0iKiAANjgoKy5kMjqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@intel.com>
Subject: [PATCH 5.15 50/66] x86/sgx: Disconnect backing page references from dirty status
Date:   Fri,  3 Jun 2022 19:43:30 +0200
Message-Id: <20220603173822.111314857@linuxfoundation.org>
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

commit 6bd429643cc265e94a9d19839c771bcc5d008fa8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/encl.c |   10 ++--------
 arch/x86/kernel/cpu/sgx/encl.h |    2 +-
 arch/x86/kernel/cpu/sgx/main.c |    6 ++++--
 3 files changed, 7 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -94,7 +94,7 @@ static int __sgx_encl_eldu(struct sgx_en
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	sgx_encl_put_backing(&b, false);
+	sgx_encl_put_backing(&b);
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
@@ -645,15 +645,9 @@ int sgx_encl_get_backing(struct sgx_encl
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
 
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -170,6 +170,8 @@ static int __sgx_encl_ewb(struct sgx_epc
 			  backing->pcmd_offset;
 
 	ret = __ewb(&pginfo, sgx_get_epc_virt_addr(epc_page), va_slot);
+	set_page_dirty(backing->pcmd);
+	set_page_dirty(backing->contents);
 
 	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
 					      backing->pcmd_offset));
@@ -299,7 +301,7 @@ static void sgx_reclaimer_write(struct s
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
-		sgx_encl_put_backing(&secs_backing, true);
+		sgx_encl_put_backing(&secs_backing);
 	}
 
 out:
@@ -392,7 +394,7 @@ skip:
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i], true);
+		sgx_encl_put_backing(&backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;


