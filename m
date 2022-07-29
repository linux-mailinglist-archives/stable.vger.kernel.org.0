Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D5C585520
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 20:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbiG2Ss0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 14:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiG2SsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 14:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134D566108;
        Fri, 29 Jul 2022 11:48:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A35F561F86;
        Fri, 29 Jul 2022 18:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5C0C433D6;
        Fri, 29 Jul 2022 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659120504;
        bh=Jw+MS2XOzOX9nlcY9Y+hYRSD0w/LI06xyzjZ9Lduzjs=;
        h=Date:To:From:Subject:From;
        b=x6E0xov5bfzfjLXivgp9lekAXF82voEucSRiW0H3M4cKWDZFfMQJ//ptuMvpLsOLZ
         U2D+xvlsSxrs5LfzIZjl02XHdxCAPUmlgu03GpFp1WvnLuWFwr8lmjfuYyL/6zrtnW
         sb5nqxwcO4BcSxp6nP6NFfEa8ueg806ENGaRPQfc=
Date:   Fri, 29 Jul 2022 11:48:23 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Philip.Yang@amd.com, jgg@nvidia.com, felix.kuehling@amd.com,
        apopple@nvidia.com, rcampbell@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hmm-fault-non-owner-device-private-entries.patch removed from -mm tree
Message-Id: <20220729184823.EF5C0C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hmm: fault non-owner device private entries
has been removed from the -mm tree.  Its filename was
     mm-hmm-fault-non-owner-device-private-entries.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: fault non-owner device private entries
Date: Mon, 25 Jul 2022 11:36:14 -0700

If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
device private PTE is found, the hmm_range::dev_private_owner page is used
to determine if the device private page should not be faulted in. 
However, if the device private page is not owned by the caller,
hmm_range_fault() returns an error instead of calling migrate_to_ram() to
fault in the page.

For example, if a page is migrated to GPU private memory and a RDMA fault
capable NIC tries to read the migrated page, without this patch it will
get an error.  With this patch, the page will be migrated back to system
memory and the NIC will be able to read the data.

Link: https://lkml.kernel.org/r/20220727000837.4128709-2-rcampbell@nvidia.com
Link: https://lkml.kernel.org/r/20220725183615.4118795-2-rcampbell@nvidia.com
Fixes: 08ddddda667b ("mm/hmm: check the device private page owner in hmm_range_fault()")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reported-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/mm/hmm.c~mm-hmm-fault-non-owner-device-private-entries
+++ a/mm/hmm.c
@@ -212,14 +212,6 @@ int hmm_vma_handle_pmd(struct mm_walk *w
 		unsigned long end, unsigned long hmm_pfns[], pmd_t pmd);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline bool hmm_is_device_private_entry(struct hmm_range *range,
-		swp_entry_t entry)
-{
-	return is_device_private_entry(entry) &&
-		pfn_swap_entry_to_page(entry)->pgmap->owner ==
-		range->dev_private_owner;
-}
-
 static inline unsigned long pte_to_hmm_pfn_flags(struct hmm_range *range,
 						 pte_t pte)
 {
@@ -252,10 +244,12 @@ static int hmm_vma_handle_pte(struct mm_
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
 		/*
-		 * Never fault in device private pages, but just report
-		 * the PFN even if not present.
+		 * Don't fault in device private pages owned by the caller,
+		 * just report the PFN.
 		 */
-		if (hmm_is_device_private_entry(range, entry)) {
+		if (is_device_private_entry(entry) &&
+		    pfn_swap_entry_to_page(entry)->pgmap->owner ==
+		    range->dev_private_owner) {
 			cpu_flags = HMM_PFN_VALID;
 			if (is_writable_device_private_entry(entry))
 				cpu_flags |= HMM_PFN_WRITE;
@@ -273,6 +267,9 @@ static int hmm_vma_handle_pte(struct mm_
 		if (!non_swap_entry(entry))
 			goto fault;
 
+		if (is_device_private_entry(entry))
+			goto fault;
+
 		if (is_device_exclusive_entry(entry))
 			goto fault;
 
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-hmm-add-a-test-for-cross-device-private-faults.patch

