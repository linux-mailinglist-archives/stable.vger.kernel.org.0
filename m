Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AAB3C245F
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhGINW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232287AbhGINWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67C4F613BC;
        Fri,  9 Jul 2021 13:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836774;
        bh=13fLalwGyjAXfWQRKG4fhgYKFlwATWbaXJDl28AEiBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KBsqyGczc6avhagmiOIC9L+LENpnDjB8GqE34x3nOsvCpY2bqrarwmIxXuA7Kwo9
         hphzRbi1X5+5ipU5lNtHua4tKQB5Y0wSRP4ZeL8rKYpMDUdIHD1ik0Yj4x1RyIWbRg
         7EIQAUhD1llXTd6iJwLlu9KAmcDOXvHOpdEhy9gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/25] mm: page_vma_mapped_walk(): crossing page table boundary
Date:   Fri,  9 Jul 2021 15:18:44 +0200
Message-Id: <20210709131635.677301580@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 448282487483d6fa5b2eeeafaa0acc681e544a9c ]

page_vma_mapped_walk() cleanup: adjust the test for crossing page table
boundary - I believe pvmw->address is always page-aligned, but nothing
else here assumed that; and remember to reset pvmw->pte to NULL after
unmapping the page table, though I never saw any bug from that.

Link: https://lkml.kernel.org/r/799b3f9c-2a9e-dfef-5d89-26e9f76fd97@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_vma_mapped.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 92d7f574b8ab..2463ba78959b 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -239,16 +239,16 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			if (pvmw->address >= end)
 				return not_found(pvmw);
 			/* Did we cross page table boundary? */
-			if (pvmw->address % PMD_SIZE == 0) {
-				pte_unmap(pvmw->pte);
+			if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
 				if (pvmw->ptl) {
 					spin_unlock(pvmw->ptl);
 					pvmw->ptl = NULL;
 				}
+				pte_unmap(pvmw->pte);
+				pvmw->pte = NULL;
 				goto restart;
-			} else {
-				pvmw->pte++;
 			}
+			pvmw->pte++;
 		} while (pte_none(*pvmw->pte));
 
 		if (!pvmw->ptl) {
-- 
2.30.2



