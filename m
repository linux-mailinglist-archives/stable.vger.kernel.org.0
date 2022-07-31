Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F247585E76
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 12:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiGaKo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 06:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiGaKo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 06:44:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644C711177
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 03:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 007F2601D8
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 10:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04183C433D6;
        Sun, 31 Jul 2022 10:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659264296;
        bh=FQJ4/GLbhxEbZTqqosR+ZkF2IQDuBE52DfkUQpeDSjY=;
        h=Subject:To:Cc:From:Date:From;
        b=bI3SFV6/wWsMzYsPtoJzSgAtKEfj7GjPd2hqkVtzEQWCrzfedm8pTqJ0sjhxGiYd/
         3z8puZTCTv8Ey9OX0tGOmrL4QpH2t9p9S4ZWpdew52SdUIN+2A3w4b7DVb4as2p8B2
         XZSOnJguXGU+nMSJ5KLgPNF11R89m0edJC8hMd+8=
Subject: FAILED: patch "[PATCH] mm/hmm: fault non-owner device private entries" failed to apply to 5.10-stable tree
To:     rcampbell@nvidia.com, Philip.Yang@amd.com,
        akpm@linux-foundation.org, apopple@nvidia.com,
        felix.kuehling@amd.com, jgg@nvidia.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jul 2022 12:44:53 +0200
Message-ID: <1659264293247125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8a295dbbaf7292c582a40ce469c326f472d51f66 Mon Sep 17 00:00:00 2001
From: Ralph Campbell <rcampbell@nvidia.com>
Date: Mon, 25 Jul 2022 11:36:14 -0700
Subject: [PATCH] mm/hmm: fault non-owner device private entries

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

diff --git a/mm/hmm.c b/mm/hmm.c
index 3fd3242c5e50..f2aa63b94d9b 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -212,14 +212,6 @@ int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
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
@@ -252,10 +244,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
@@ -273,6 +267,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (!non_swap_entry(entry))
 			goto fault;
 
+		if (is_device_private_entry(entry))
+			goto fault;
+
 		if (is_device_exclusive_entry(entry))
 			goto fault;
 

