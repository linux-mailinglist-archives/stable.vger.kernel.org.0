Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5149D814
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 03:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiA0CcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 21:32:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40796 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiA0CcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 21:32:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14836B820FA;
        Thu, 27 Jan 2022 02:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA264C340E7;
        Thu, 27 Jan 2022 02:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643250724;
        bh=YzlRjD2NwJvgx9dl0mMJbAjpAx04oz+MwQOeOlUhor8=;
        h=Date:From:To:Subject:From;
        b=QJA54a8C01Z6XZd08K+E5O89ChSt6dp5euvREGYksNFxeSXRnVUIppKVLwtV2Vkid
         yKHWiVcNAM0OgiVhlqL0YgcSqitVEl3QgExt1xLqLZWWT4UWRA9E6w2mEz1uFQiGlI
         CoHu++xZsBfuUCAEM8G2ApRA2cptFL/a5kb4aa4Y=
Date:   Wed, 26 Jan 2022 18:32:04 -0800
From:   akpm@linux-foundation.org
To:     khalid.aziz@oracle.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, stable@vger.kernel.org, stettberger@dokucode.de
Subject:  +
 mm-pgtable-define-pte_index-so-that-preprocessor-could-recognize-it.patch
 added to -mm tree
Message-ID: <20220127023204.YhI-sD-TA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/pgtable: define pte_index so that preprocessor could recognize it
has been added to the -mm tree.  Its filename is
     mm-pgtable-define-pte_index-so-that-preprocessor-could-recognize-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pgtable-define-pte_index-so-that-preprocessor-could-recognize-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pgtable-define-pte_index-so-that-preprocessor-could-recognize-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/pgtable: define pte_index so that preprocessor could recognize it

Since commit 974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*()
definitions") pte_index is a static inline and there is no define for it
that can be recognized by the preprocessor.  As a result,
vm_insert_pages() uses slower loop over vm_insert_page() instead of
insert_pages() that amortizes the cost of spinlock operations when
inserting multiple pages.

Link: https://lkml.kernel.org/r/20220111145457.20748-1-rppt@kernel.org
Fixes: 974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*() definitions")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Christian Dietrich <stettberger@dokucode.de>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/pgtable.h~mm-pgtable-define-pte_index-so-that-preprocessor-could-recognize-it
+++ a/include/linux/pgtable.h
@@ -62,6 +62,7 @@ static inline unsigned long pte_index(un
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
+#define pte_index pte_index
 
 #ifndef pmd_index
 static inline unsigned long pmd_index(unsigned long address)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-pgtable-define-pte_index-so-that-preprocessor-could-recognize-it.patch

