Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56E14A9E68
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377196AbiBDR5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:57:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiBDR5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:57:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F02961B48;
        Fri,  4 Feb 2022 17:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FE5C004E1;
        Fri,  4 Feb 2022 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643997423;
        bh=MDHhps9eYNeO/cKBYWhXRHb++o+a0biupbPiV5wilT0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=yXuE4lfRaXcYFYVr51iwEB8rRXAZHvdMod62wlg2NKww9Y532DBCEdT2liumH2Rnt
         GawJB4yxNLlfPQUoJOn8AmC0RBddUn7XcHWH7DW1iPMMxn4ZNjmxSwt7lB+QLSGwKM
         3tmdfbicYFUi2n+VEmsQCDzxOtUKKn7nWLr0Ukz8=
Received: by hp1 (sSMTP sendmail emulation); Fri, 04 Feb 2022 09:57:02 -0800
Date:   Fri, 04 Feb 2022 09:57:02 -0800
To:     stettberger@dokucode.de, stable@vger.kernel.org,
        khalid.aziz@oracle.com, rppt@linux.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 06/10] mm/pgtable: define pte_index so that preprocessor could recognize it
Message-Id: <20220204175702.86FE5C004E1@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
