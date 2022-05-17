Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E2A52AA4A
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352061AbiEQSN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352083AbiEQSME (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:12:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B851AF13;
        Tue, 17 May 2022 11:12:03 -0700 (PDT)
Date:   Tue, 17 May 2022 18:12:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652811122;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1C2Wvh34N4Xqv0tt6UpctC2XWk78/pMx89lsOdoGNJ4=;
        b=jdsbxDvapu353pPMRZzU9JaheJz+l1YStpfqmjGVbwR2AI64P5JcyNXaW2vpOQEwumGEKU
        fwGsn9fdelhgmifV5yiTrdESDR/fkJfq73dlLzLGBpm2cndr3saxIvB089WXeRrcn6kI8V
        yRsZ9QrjDpvpwGKFWRzsBecRSO17MjJTp/e2zBBuFIAZdANXXIw1EBeYt58pzH1J2bt/n0
        +gAd8jAxKP+IHpPWMMqVj9hXtDb3h2L/iujJh8NzVSpbTwMZboVsDvTWGdDeoktIAvC5ei
        cEm/z9DrN6hWOz4tExYwO0dCaLAnrgpGDFcqYbS6O3dPpmPEUayG7GXI9XxMfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652811122;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1C2Wvh34N4Xqv0tt6UpctC2XWk78/pMx89lsOdoGNJ4=;
        b=6D/ree/4FQwlHrNXs61seAv8khSoHu3+NkS/BjmU3TeF6tdgKnDCNp02UH0Kg6dDJPKY+9
        zRiko9ACxZLLxcCA==
From:   "tip-bot2 for Reinette Chatre" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/sgx] x86/sgx: Obtain backing storage page with enclave mutex held
Cc:     stable@vger.kernel.org, Haitao Huang <haitao.huang@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3Cfa2e04c561a8555bfe1f4e7adc37d60efc77387b=2E16523?=
 =?utf-8?q?89823=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
References: =?utf-8?q?=3Cfa2e04c561a8555bfe1f4e7adc37d60efc77387b=2E165238?=
 =?utf-8?q?9823=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <165281112134.4207.3233764010044485685.tip-bot2@tip-bot2>
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

Commit-ID:     0e4e729a830c1e7f31d3b3fbf8feb355a402b117
Gitweb:        https://git.kernel.org/tip/0e4e729a830c1e7f31d3b3fbf8feb355a402b117
Author:        Reinette Chatre <reinette.chatre@intel.com>
AuthorDate:    Thu, 12 May 2022 14:50:59 -07:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Mon, 16 May 2022 15:17:23 -07:00

x86/sgx: Obtain backing storage page with enclave mutex held

Haitao reported encountering a WARN triggered by the ENCLS[ELDU]
instruction faulting with a #GP.

The WARN is encountered when the reclaimer evicts a range of
pages from the enclave when the same pages are faulted back
right away.

The SGX backing storage is accessed on two paths: when there
are insufficient free pages in the EPC the reclaimer works
to move enclave pages to the backing storage and as enclaves
access pages that have been moved to the backing storage
they are retrieved from there as part of page fault handling.

An oversubscribed SGX system will often run the reclaimer and
page fault handler concurrently and needs to ensure that the
backing store is accessed safely between the reclaimer and
the page fault handler. This is not the case because the
reclaimer accesses the backing store without the enclave mutex
while the page fault handler accesses the backing store with
the enclave mutex.

Consider the scenario where a page is faulted while a page sharing
a PCMD page with the faulted page is being reclaimed. The
consequence is a race between the reclaimer and page fault
handler, the reclaimer attempting to access a PCMD at the
same time it is truncated by the page fault handler. This
could result in lost PCMD data. Data may still be
lost if the reclaimer wins the race, this is addressed in
the following patch.

The reclaimer accesses pages from the backing storage without
holding the enclave mutex and runs the risk of concurrently
accessing the backing storage with the page fault handler that
does access the backing storage with the enclave mutex held.

In the scenario below a PCMD page is truncated from the backing
store after all its pages have been loaded in to the enclave
at the same time the PCMD page is loaded from the backing store
when one of its pages are reclaimed:

sgx_reclaim_pages() {              sgx_vma_fault() {
                                     ...
                                     mutex_lock(&encl->lock);
                                     ...
                                     __sgx_encl_eldu() {
                                       ...
                                       if (pcmd_page_empty) {
/*
 * EPC page being reclaimed              /*
 * shares a PCMD page with an             * PCMD page truncated
 * enclave page that is being             * while requested from
 * faulted in.                            * reclaimer.
 */                                       */
sgx_encl_get_backing()  <---------->      sgx_encl_truncate_backing_page()
                                        }
                                       mutex_unlock(&encl->lock);
}                                    }

In this scenario there is a race between the reclaimer and the page fault
handler when the reclaimer attempts to get access to the same PCMD page
that is being truncated. This could result in the reclaimer writing to
the PCMD page that is then truncated, causing the PCMD data to be lost,
or in a new PCMD page being allocated. The lost PCMD data may still occur
after protecting the backing store access with the mutex - this is fixed
in the next patch. By ensuring the backing store is accessed with the mutex
held the enclave page state can be made accurate with the
SGX_ENCL_PAGE_BEING_RECLAIMED flag accurately reflecting that a page
is in the process of being reclaimed.

Consistently protect the reclaimer's backing store access with the
enclave's mutex to ensure that it can safely run concurrently with the
page fault handler.

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Reported-by: Haitao Huang <haitao.huang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Link: https://lkml.kernel.org/r/fa2e04c561a8555bfe1f4e7adc37d60efc77387b.1652389823.git.reinette.chatre@intel.com
---
 arch/x86/kernel/cpu/sgx/main.c |  9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index e71df40..ab4ec54 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -310,6 +310,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	sgx_encl_ewb(epc_page, backing);
 	encl_page->epc_page = NULL;
 	encl->secs_child_cnt--;
+	sgx_encl_put_backing(backing);
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
 		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
@@ -381,11 +382,14 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
+
+		mutex_lock(&encl_page->encl->lock);
 		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&encl_page->encl->lock);
 			goto skip;
+		}
 
-		mutex_lock(&encl_page->encl->lock);
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -413,7 +417,6 @@ skip:
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
