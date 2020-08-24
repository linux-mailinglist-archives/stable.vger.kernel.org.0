Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE1624F5F1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgHXIza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730417AbgHXIz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCAD3204FD;
        Mon, 24 Aug 2020 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259327;
        bh=LehtCaV42rdQFo3R1F6wlwdqE9D0Rqqwrku+qzm3Gnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgLFu0qlzv/2bbLhlK98J54rISIAPYcbdSzXK7sg9hopUJt+0+tL0hU+AuzJeHF4/
         LoHMlK+f9awrnzDlAc75TtwgDQ7PmNvkr7mbwwDY15IsRobCVaF7j35CSmsi+FUG5o
         SSpF9gUzuvYtSEVPNq1jELk4+f6GkJF/K9nDkxEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xu Yu <xuyu@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Yang Shi <shy828301@gmail.com>
Subject: [PATCH 4.19 17/71] mm/memory.c: skip spurious TLB flush for retried page fault
Date:   Mon, 24 Aug 2020 10:31:08 +0200
Message-Id: <20200824082356.758044582@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit b7333b58f358f38d90d78e00c1ee5dec82df10ad upstream.

Recently we found regression when running will_it_scale/page_fault3 test
on ARM64.  Over 70% down for the multi processes cases and over 20% down
for the multi threads cases.  It turns out the regression is caused by
commit 89b15332af7c ("mm: drop mmap_sem before calling
balance_dirty_pages() in write fault").

The test mmaps a memory size file then write to the mapping, this would
make all memory dirty and trigger dirty pages throttle, that upstream
commit would release mmap_sem then retry the page fault.  The retried
page fault would see correct PTEs installed then just fall through to
spurious TLB flush.  The regression is caused by the excessive spurious
TLB flush.  It is fine on x86 since x86's spurious TLB flush is no-op.

We could just skip the spurious TLB flush to mitigate the regression.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Xu Yu <xuyu@linux.alibaba.com>
Debugged-by: Xu Yu <xuyu@linux.alibaba.com>
Tested-by: Xu Yu <xuyu@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4062,6 +4062,9 @@ static vm_fault_t handle_pte_fault(struc
 				vmf->flags & FAULT_FLAG_WRITE)) {
 		update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
 	} else {
+		/* Skip spurious TLB flush for retried page fault */
+		if (vmf->flags & FAULT_FLAG_TRIED)
+			goto unlock;
 		/*
 		 * This is needed only for protection faults but the arch code
 		 * is not yet telling us if this is a protection fault or not.


