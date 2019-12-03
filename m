Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884AD111DBA
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfLCW43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730434AbfLCW42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B505520866;
        Tue,  3 Dec 2019 22:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413788;
        bh=Z8aICHbrIM347DJ5/MBMdz5RRjHh6rlblcjp0EeSyYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CEQIKwYK3eOc16aO7G2BlbA0DK3N8Ea1bo8P2ukMElPkMFRe0sN1YCEIRv5m7kNM
         MiT/E4m8ytrxvZT++2i0hsVpiIO16hKmOmjnltwq8/bkionWHHJoD0eaH+niD6PNHE
         q+vJR6Ti2Y0MH0YMpWTP8Ze5HGaHLOl+ULGNzCmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 263/321] mm, gup: add missing refcount overflow checks on s390
Date:   Tue,  3 Dec 2019 23:35:29 +0100
Message-Id: <20191203223440.811248012@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

The mainline commit 8fde12ca79af ("mm: prevent get_user_pages() from
overflowing page refcount") was backported to 4.19.y stable as commit
d972ebbf42ba. The backport however missed that in 4.19, there are several
arch-specific gup.c versions with fast gup implementations, so these do not
prevent refcount overflow.

This stable-only commit fixes the s390 version, and is based on the backport in
SUSE SLES/openSUSE 4.12-based kernels.

The remaining architectures with own gup.c are sparc, mips, sh. It's unlikely
the known overflow scenario based on FUSE, which needs 140GB of RAM, is a
problem for those architectures, and I don't feel confident enough to patch
them.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/gup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 2809d11c7a283..9b5b866d8adf1 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -39,7 +39,8 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 		head = compound_head(page);
-		if (!page_cache_get_speculative(head))
+		if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+		    || !page_cache_get_speculative(head)))
 			return 0;
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_page(head);
@@ -77,7 +78,8 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
@@ -151,7 +153,8 @@ static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
-- 
2.20.1



