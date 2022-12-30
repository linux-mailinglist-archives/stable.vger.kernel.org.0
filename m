Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CF4657856
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiL1Ot3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiL1Ot2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:49:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D47BCA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:49:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3227C6154E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40911C433D2;
        Wed, 28 Dec 2022 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238966;
        bh=JRxWHVBVIQ6ufwVmOjpFXPdDIPFiaZ45oLqRbVAYWfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raLd1G9GxO6zMbW1gL5vFdRSVdKG9GmjyFSULEi8glNEMvNdQZzpc1/d3ffHaTPWs
         Ol0LWjRA9w7H2glQMH11RBGKsabPwko59rxcJXUDeTg/gTsjOneyAi9N5JyZez1Yxb
         Oj67ifk2WRyb8RA+Z6bohlDj6c1AijCbsjwJNsrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Md Iqbal Hossain <md.iqbal.hossain@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/731] x86/sgx: Reduce delay and interference of enclave release
Date:   Wed, 28 Dec 2022 15:33:04 +0100
Message-Id: <20221228144258.784663406@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 7b72c823ddf8aaaec4e9fb28e6fbe4d511e7dad1 ]

commit 8795359e35bc ("x86/sgx: Silence softlockup detection when
releasing large enclaves") introduced a cond_resched() during enclave
release where the EREMOVE instruction is applied to every 4k enclave
page. Giving other tasks an opportunity to run while tearing down a
large enclave placates the soft lockup detector but Iqbal found
that the fix causes a 25% performance degradation of a workload
run using Gramine.

Gramine maintains a 1:1 mapping between processes and SGX enclaves.
That means if a workload in an enclave creates a subprocess then
Gramine creates a duplicate enclave for that subprocess to run in.
The consequence is that the release of the enclave used to run
the subprocess can impact the performance of the workload that is
run in the original enclave, especially in large enclaves when
SGX2 is not in use.

The workload run by Iqbal behaves as follows:
Create enclave (enclave "A")
/* Initialize workload in enclave "A" */
Create enclave (enclave "B")
/* Run subprocess in enclave "B" and send result to enclave "A" */
Release enclave (enclave "B")
/* Run workload in enclave "A" */
Release enclave (enclave "A")

The performance impact of releasing enclave "B" in the above scenario
is amplified when there is a lot of SGX memory and the enclave size
matches the SGX memory. When there is 128GB SGX memory and an enclave
size of 128GB, from the time enclave "B" starts the 128GB SGX memory
is oversubscribed with a combined demand for 256GB from the two
enclaves.

Before commit 8795359e35bc ("x86/sgx: Silence softlockup detection when
releasing large enclaves") enclave release was done in a tight loop
without giving other tasks a chance to run. Even though the system
experienced soft lockups the workload (run in enclave "A") obtained
good performance numbers because when the workload started running
there was no interference.

Commit 8795359e35bc ("x86/sgx: Silence softlockup detection when
releasing large enclaves") gave other tasks opportunity to run while an
enclave is released. The impact of this in this scenario is that while
enclave "B" is released and needing to access each page that belongs
to it in order to run the SGX EREMOVE instruction on it, enclave "A"
is attempting to run the workload needing to access the enclave
pages that belong to it. This causes a lot of swapping due to the
demand for the oversubscribed SGX memory. Longer latencies are
experienced by the workload in enclave "A" while enclave "B" is
released.

Improve the performance of enclave release while still avoiding the
soft lockup detector with two enhancements:
- Only call cond_resched() after XA_CHECK_SCHED iterations.
- Use the xarray advanced API to keep the xarray locked for
  XA_CHECK_SCHED iterations instead of locking and unlocking
  at every iteration.

This batching solution is copied from sgx_encl_may_map() that
also iterates through all enclave pages using this technique.

With this enhancement the workload experiences a 5%
performance degradation when compared to a kernel without
commit 8795359e35bc ("x86/sgx: Silence softlockup detection when
releasing large enclaves"), an improvement to the reported 25%
degradation, while still placating the soft lockup detector.

Scenarios with poor performance are still possible even with these
enhancements. For example, short workloads creating sub processes
while running in large enclaves. Further performance improvements
are pursued in user space through avoiding to create duplicate enclaves
for certain sub processes, and using SGX2 that will do lazy allocation
of pages as needed so enclaves created for sub processes start quickly
and release quickly.

Fixes: 8795359e35bc ("x86/sgx: Silence softlockup detection when releasing large enclaves")
Reported-by: Md Iqbal Hossain <md.iqbal.hossain@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Md Iqbal Hossain <md.iqbal.hossain@intel.com>
Link: https://lore.kernel.org/all/00efa80dd9e35dc85753e1c5edb0344ac07bb1f0.1667236485.git.reinette.chatre%40intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 19876ebfb504..fa5777af8da1 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -533,11 +533,15 @@ const struct vm_operations_struct sgx_vm_ops = {
 void sgx_encl_release(struct kref *ref)
 {
 	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
+	unsigned long max_page_index = PFN_DOWN(encl->base + encl->size - 1);
 	struct sgx_va_page *va_page;
 	struct sgx_encl_page *entry;
-	unsigned long index;
+	unsigned long count = 0;
+
+	XA_STATE(xas, &encl->page_array, PFN_DOWN(encl->base));
 
-	xa_for_each(&encl->page_array, index, entry) {
+	xas_lock(&xas);
+	xas_for_each(&xas, entry, max_page_index) {
 		if (entry->epc_page) {
 			/*
 			 * The page and its radix tree entry cannot be freed
@@ -552,9 +556,20 @@ void sgx_encl_release(struct kref *ref)
 		}
 
 		kfree(entry);
-		/* Invoke scheduler to prevent soft lockups. */
-		cond_resched();
+		/*
+		 * Invoke scheduler on every XA_CHECK_SCHED iteration
+		 * to prevent soft lockups.
+		 */
+		if (!(++count % XA_CHECK_SCHED)) {
+			xas_pause(&xas);
+			xas_unlock(&xas);
+
+			cond_resched();
+
+			xas_lock(&xas);
+		}
 	}
+	xas_unlock(&xas);
 
 	xa_destroy(&encl->page_array);
 
-- 
2.35.1



