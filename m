Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D8D328414
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhCAQ2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233651AbhCAQYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 884DD64EC6;
        Mon,  1 Mar 2021 16:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615650;
        bh=76pg7xbG8DWoXD649UkrvAPXyffMUB//uVU5LKz0qY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXqBx3TXRlY21TV1wuTDB9iA4ontKHfRtINRmFYlBqJHNYbw/Uhu50VUjTIUWA9mE
         fRDwgE0bGgfcDXmxVw/8AsIz5/8lRicq73S6SkZWruS7OYUd3/JfUdsZ5TKAFcAFeD
         /DuHD6g7FQ+aeeV5Mb3UH72UOv/zjWS2IbGWk3v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 012/134] mm, thp: make do_huge_pmd_wp_page() lock page for testing mapcount
Date:   Mon,  1 Mar 2021 17:11:53 +0100
Message-Id: <20210301161014.184679660@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

Jann reported [1] a race between __split_huge_pmd_locked() and
page_trans_huge_map_swapcount() which can result in a page to be reused
instead of COWed. This was later assigned CVE-2020-29368.

This was fixed by commit c444eb564fb1 ("mm: thp: make the THP mapcount atomic
against __split_huge_pmd_locked()") by doing the split under the page lock,
while all users of page_trans_huge_map_swapcount() were already also under page
lock. The fix was backported also to 4.9 stable series.

When testing the backport on a 4.12 based kernel, Nicolai noticed the POC from
[1] still reproduces after backporting c444eb564fb1 and identified a missing
page lock in do_huge_pmd_wp_page() around the call to
page_trans_huge_mapcount(). The page lock was only added in ba3c4ce6def4 ("mm,
THP, swap: make reuse_swap_page() works for THP swapped out") in 4.14. The
commit also wrapped page_trans_huge_mapcount() into
page_trans_huge_map_swapcount() for the purposes of COW decisions.

I have verified that 4.9.y indeed also reproduces with the POC. Backporting
ba3c4ce6def4 alone however is not possible as it's part of a larger effort of
optimizing THP swapping, which would be risky to backport fully.

Therefore this 4.9-stable-only patch just wraps page_trans_huge_mapcount()
in page_trans_huge_mapcount() under page lock the same way as ba3c4ce6def4
does, but without the page_trans_huge_map_swapcount() part. Other callers
of page_trans_huge_mapcount() are all under page lock already. I have verified
the POC no longer reproduces afterwards.

[1] https://bugs.chromium.org/p/project-zero/issues/detail?id=2045

Reported-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1022,6 +1022,19 @@ int do_huge_pmd_wp_page(struct fault_env
 	 * We can only reuse the page if nobody else maps the huge page or it's
 	 * part.
 	 */
+	if (!trylock_page(page)) {
+		get_page(page);
+		spin_unlock(fe->ptl);
+		lock_page(page);
+		spin_lock(fe->ptl);
+		if (unlikely(!pmd_same(*fe->pmd, orig_pmd))) {
+			unlock_page(page);
+			put_page(page);
+			goto out_unlock;
+		}
+		put_page(page);
+	}
+
 	if (page_trans_huge_mapcount(page, NULL) == 1) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
@@ -1029,8 +1042,10 @@ int do_huge_pmd_wp_page(struct fault_env
 		if (pmdp_set_access_flags(vma, haddr, fe->pmd, entry,  1))
 			update_mmu_cache_pmd(vma, fe->address, fe->pmd);
 		ret |= VM_FAULT_WRITE;
+		unlock_page(page);
 		goto out_unlock;
 	}
+	unlock_page(page);
 	get_page(page);
 	spin_unlock(fe->ptl);
 alloc:


