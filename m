Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CC0542411
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382354AbiFHBPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836555AbiFGX60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2566D274D65;
        Tue,  7 Jun 2022 12:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9686EB823CA;
        Tue,  7 Jun 2022 19:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72C0C385A5;
        Tue,  7 Jun 2022 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629830;
        bh=cP4duHiQlsYYKTcNjw0LjdVpL4shKbQ7EUNXNEjXYCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VH8Y3W9YxYKKcDstpkYNWBpgsv2W4V+hq/O2jiIPJBVDhiL3gBoOj3kIccFQiLFWP
         Vo+pVShUEKMXfCKfVzMIbe4VFflqtar+B13u58k7SBZNX5SgCXiP1ltwlvuuAs13BY
         k3+5KBPdzSCk439b6s1Z3y2dEuBYY918/5B/y1I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 832/879] hugetlb: fix huge_pmd_unshare address update
Date:   Tue,  7 Jun 2022 19:05:50 +0200
Message-Id: <20220607165027.006879939@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 48381273f8734d28ef56a5bdf1966dd8530111bc upstream.

The routine huge_pmd_unshare() is passed a pointer to an address
associated with an area which may be unshared.  If unshare is successful
this address is updated to 'optimize' callers iterating over huge page
addresses.  For the optimization to work correctly, address should be
updated to the last huge page in the unmapped/unshared area.  However, in
the common case where the passed address is PUD_SIZE aligned, the address
is incorrectly updated to the address of the preceding huge page.  That
wastes CPU cycles as the unmapped/unshared range is scanned twice.

Link: https://lkml.kernel.org/r/20220524205003.126184-1-mike.kravetz@oracle.com
Fixes: 39dde65c9940 ("shared page table for hugetlb page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6562,7 +6562,14 @@ int huge_pmd_unshare(struct mm_struct *m
 	pud_clear(pud);
 	put_page(virt_to_page(ptep));
 	mm_dec_nr_pmds(mm);
-	*addr = ALIGN(*addr, HPAGE_SIZE * PTRS_PER_PTE) - HPAGE_SIZE;
+	/*
+	 * This update of passed address optimizes loops sequentially
+	 * processing addresses in increments of huge page size (PMD_SIZE
+	 * in this case).  By clearing the pud, a PUD_SIZE area is unmapped.
+	 * Update address to the 'last page' in the cleared area so that
+	 * calling loop can move to first page past this area.
+	 */
+	*addr |= PUD_SIZE - PMD_SIZE;
 	return 1;
 }
 


