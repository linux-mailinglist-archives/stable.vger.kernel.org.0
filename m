Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE44F11324D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbfLDSHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730737AbfLDSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:18 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B090020675;
        Wed,  4 Dec 2019 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482837;
        bh=XOT+X/DKPEi5dZaEYS+gn3/ARlU0Jl/JFo1hv2SUL3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDCZe4hy0JCCggl8/0GCLeCOzypJVFbuslUzE/g2dK6VGwl+WezOCZDLlpJ/F3evA
         A4o3KRqKGUKc/D3GGib2pNjvhXo5UtONfceY4Cv0tcHn51CIdaUzh9oUxg0ylsusvX
         SGsaFj3zoGVSpqtGbo/776hpMoKHie289ENqS+lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 155/209] mm, gup: add missing refcount overflow checks on s390
Date:   Wed,  4 Dec 2019 18:56:07 +0100
Message-Id: <20191204175334.154600538@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
overflowing page refcount") was backported to 4.14.y stable as commit
04198de24771. The backport however missed that in 4.14, there are several
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
index 05c8abd864f1d..9bce54eac0b07 100644
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



