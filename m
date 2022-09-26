Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177475EB115
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIZTPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiIZTPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1125845076;
        Mon, 26 Sep 2022 12:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 47A65CE1331;
        Mon, 26 Sep 2022 19:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748E8C433D6;
        Mon, 26 Sep 2022 19:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219732;
        bh=ZbtLsjmOGUao3pSdSJ7N3QrZqrvDrpQHsRlEkglwHp8=;
        h=Date:To:From:Subject:From;
        b=mL8/sBBmmfod44Jxax62TBk1WQC6dD8FLGPcu3GmgHzADdtJ05XlyrasNvc02ZjcL
         PZGoQOBzylr7EeqF7KDy34FLKyNtp0teyyB/Lkv0FrWeJFXmEWM+SCue+NqlCBqKFA
         l0TfGdxkgl4VpxkdjV1NUThR00JoUoUo005aY2Xs=
Date:   Mon, 26 Sep 2022 12:15:31 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, npiggin@gmail.com, mpe@ellerman.id.au,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, david@redhat.com,
        christophe.leroy@csgroup.eu, aneesh.kumar@linux.ibm.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush.patch removed from -mm tree
Message-Id: <20220926191532.748E8C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush
has been removed from the -mm tree.  Its filename was
     powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush
Date: Wed, 7 Sep 2022 11:01:44 -0700

The IPI broadcast is used to serialize against fast-GUP, but fast-GUP will
move to use RCU instead of disabling local interrupts in fast-GUP.  Using
an IPI is the old-styled way of serializing against fast-GUP although it
still works as expected now.

And fast-GUP now fixed the potential race with THP collapse by checking
whether PMD is changed or not.  So IPI broadcast in radix pmd collapse
flush is not necessary anymore.  But it is still needed for hash TLB.

Link: https://lkml.kernel.org/r/20220907180144.555485-2-shy828301@gmail.com
Suggested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -937,15 +937,6 @@ pmd_t radix__pmdp_collapse_flush(struct
 	pmd = *pmdp;
 	pmd_clear(pmdp);
 
-	/*
-	 * pmdp collapse_flush need to ensure that there are no parallel gup
-	 * walk after this call. This is needed so that we can have stable
-	 * page ref count when collapsing a page. We don't allow a collapse page
-	 * if we have gup taken on the page. We can ensure that by sending IPI
-	 * because gup walk happens with IRQ disabled.
-	 */
-	serialize_against_pte_lookup(vma->vm_mm);
-
 	radix__flush_tlb_collapsed_pmd(vma->vm_mm, address);
 
 	return pmd;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-madv_collapse-refetch-vm_end-after-reacquiring-mmap_lock.patch

