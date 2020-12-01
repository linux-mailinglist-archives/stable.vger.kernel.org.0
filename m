Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D712C9A70
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387824AbgLAI53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387820AbgLAI52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:57:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66D49221FF;
        Tue,  1 Dec 2020 08:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813033;
        bh=xAvtOPo+1aD8OKAoFXnfVNisW8FaKh66GWPB90bydHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fN6e9V2C6+4UAMpZGrxnlykNQ8SlGF0iqA5UDvfVfndPRLbRqEV3rAbhUft5UBY0N
         8uCJDkcGnP62LZHnoj5LO+mpZDxiDaqTd4RM5tCQg8lQVd2TFzziNMUx6SnNe/8hSU
         Ay2F8td6F+PLpKkRx/fcYBYH2ZQyHMFy1J/5EJEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.14 10/50] arm64: pgtable: Fix pte_accessible()
Date:   Tue,  1 Dec 2020 09:53:09 +0100
Message-Id: <20201201084646.164174753@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 07509e10dcc77627f8b6a57381e878fe269958d3 upstream.

pte_accessible() is used by ptep_clear_flush() to figure out whether TLB
invalidation is necessary when unmapping pages for reclaim. Although our
implementation is correct according to the architecture, returning true
only for valid, young ptes in the absence of racing page-table
modifications, this is in fact flawed due to lazy invalidation of old
ptes in ptep_clear_flush_young() where we elide the expensive DSB
instruction for completing the TLB invalidation.

Rather than penalise the aging path, adjust pte_accessible() to return
true for any valid pte, even if the access flag is cleared.

Cc: <stable@vger.kernel.org>
Fixes: 76c714be0e5e ("arm64: pgtable: implement pte_accessible()")
Reported-by: Yu Zhao <yuzhao@google.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20201120143557.6715-2-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -92,8 +92,6 @@ extern unsigned long empty_zero_page[PAG
 #define pte_valid(pte)		(!!(pte_val(pte) & PTE_VALID))
 #define pte_valid_not_user(pte) \
 	((pte_val(pte) & (PTE_VALID | PTE_USER)) == PTE_VALID)
-#define pte_valid_young(pte) \
-	((pte_val(pte) & (PTE_VALID | PTE_AF)) == (PTE_VALID | PTE_AF))
 #define pte_valid_user(pte) \
 	((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER))
 
@@ -101,9 +99,12 @@ extern unsigned long empty_zero_page[PAG
  * Could the pte be present in the TLB? We must check mm_tlb_flush_pending
  * so that we don't erroneously return false for pages that have been
  * remapped as PROT_NONE but are yet to be flushed from the TLB.
+ * Note that we can't make any assumptions based on the state of the access
+ * flag, since ptep_clear_flush_young() elides a DSB when invalidating the
+ * TLB.
  */
 #define pte_accessible(mm, pte)	\
-	(mm_tlb_flush_pending(mm) ? pte_present(pte) : pte_valid_young(pte))
+	(mm_tlb_flush_pending(mm) ? pte_present(pte) : pte_valid(pte))
 
 /*
  * p??_access_permitted() is true for valid user mappings (subject to the


