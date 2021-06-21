Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E643AEF16
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhFUQfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhFUQeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 874506140F;
        Mon, 21 Jun 2021 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292804;
        bh=afjJnfrjpo4SGRDumAJ7mvbEE5onHssv9v2ffyWrkdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXpe7bHJ0xg8nohyRggK/gtAmkR2o/03JmhiQpksUoKq+VlPufJvYU84jxULyxmUb
         S2EVfhA7dlWdINp1lwtobv3LPsykkZ8jLD8wJFbCOApJsoUsmTpWB7gpjWzhpnIsy6
         2cv3Yyy6YPxXJs81oQsuuh3EuPOfuCocAWrJZm+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 136/146] mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare
Date:   Mon, 21 Jun 2021 18:16:06 +0200
Message-Id: <20210621154920.247823951@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 099dd6878b9b12d6bbfa6bf29ce0c8ddd38f6901 upstream.

I found it by pure code review, that pte_same_as_swp() of unuse_vma()
didn't take uffd-wp bit into account when comparing ptes.
pte_same_as_swp() returning false negative could cause failure to
swapoff swap ptes that was wr-protected by userfaultfd.

Link: https://lkml.kernel.org/r/20210603180546.9083-1-peterx@redhat.com
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>	[5.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/swapops.h |   15 +++++++++++----
 mm/swapfile.c           |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -23,6 +23,16 @@
 #define SWP_TYPE_SHIFT	(BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
 #define SWP_OFFSET_MASK	((1UL << SWP_TYPE_SHIFT) - 1)
 
+/* Clear all flags but only keep swp_entry_t related information */
+static inline pte_t pte_swp_clear_flags(pte_t pte)
+{
+	if (pte_swp_soft_dirty(pte))
+		pte = pte_swp_clear_soft_dirty(pte);
+	if (pte_swp_uffd_wp(pte))
+		pte = pte_swp_clear_uffd_wp(pte);
+	return pte;
+}
+
 /*
  * Store a type+offset into a swp_entry_t in an arch-independent format
  */
@@ -66,10 +76,7 @@ static inline swp_entry_t pte_to_swp_ent
 {
 	swp_entry_t arch_entry;
 
-	if (pte_swp_soft_dirty(pte))
-		pte = pte_swp_clear_soft_dirty(pte);
-	if (pte_swp_uffd_wp(pte))
-		pte = pte_swp_clear_uffd_wp(pte);
+	pte = pte_swp_clear_flags(pte);
 	arch_entry = __pte_to_swp_entry(pte);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1903,7 +1903,7 @@ unsigned int count_swap_pages(int type,
 
 static inline int pte_same_as_swp(pte_t pte, pte_t swp_pte)
 {
-	return pte_same(pte_swp_clear_soft_dirty(pte), swp_pte);
+	return pte_same(pte_swp_clear_flags(pte), swp_pte);
 }
 
 /*


