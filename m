Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8485F29BA
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiJCHYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiJCHXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479574B4A6;
        Mon,  3 Oct 2022 00:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3CCBB80E6B;
        Mon,  3 Oct 2022 07:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E128EC433D6;
        Mon,  3 Oct 2022 07:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781445;
        bh=Ep335t2I/xaHGQeJd/i5wb01J+lIvEjwZwn2VcHR79Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcFAUieFOPj1vEe/vfwrvP91635+QwDMBjq/k7y12SlxbYE2JsIII3mP2wRVUJAOV
         SJPW8M7KvxcnDuRnVhc9VXetw/wlthdY5YqM+9tsPgFv4Cwa+Vu85tTnEc8WZiFYfc
         3TIGRrkVXmSBCPDpX7XJ2BM7ObPwq6NvLmgKjMaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Yang Shi <shy828301@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Hugh Dickins <hughd@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 22/83] powerpc/64s/radix: dont need to broadcast IPI for radix pmd collapse flush
Date:   Mon,  3 Oct 2022 09:10:47 +0200
Message-Id: <20221003070722.545874809@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Yang Shi <shy828301@gmail.com>

commit bedf03416913d88c796288f9dca109a53608c745 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -954,15 +954,6 @@ pmd_t radix__pmdp_collapse_flush(struct
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


