Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782A115BED
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfEGF7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbfEGFhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0794B21655;
        Tue,  7 May 2019 05:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207420;
        bh=jv5sLOOrWk1SbFGvZzGcNY8fisqZ8uWYRa6eu+j6bS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPk4bcMdT0hhWbXSMmFKdHMNPdYspXBElLKZ6z39ks/DzehLMznt8ReZgrwb73axJ
         NyDwHwdnkD2RUAKjDfroD/yZieoDRssRmfZOmw9lTbnvYN2bM249W/Lq2yapTbfJOD
         olUM0cRu5g+7DezBR5eD6Kw8jr932tJXLOoLEeps=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nadav Amit <namit@vmware.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 32/81] x86/mm/tlb: Revert "x86/mm: Align TLB invalidation info"
Date:   Tue,  7 May 2019 01:35:03 -0400
Message-Id: <20190507053554.30848-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 780e0106d468a2962b16b52fdf42898f2639e0a0 ]

Revert the following commit:

  515ab7c41306: ("x86/mm: Align TLB invalidation info")

I found out (the hard way) that under some .config options (notably L1_CACHE_SHIFT=7)
and compiler combinations this on-stack alignment leads to a 320 byte
stack usage, which then triggers a KASAN stack warning elsewhere.

Using 320 bytes of stack space for a 40 byte structure is ludicrous and
clearly not right.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Nadav Amit <namit@vmware.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 515ab7c41306 ("x86/mm: Align TLB invalidation info")
Link: http://lkml.kernel.org/r/20190416080335.GM7905@worktop.programming.kicks-ass.net
[ Minor changelog edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index a6d1b0241aea..a6836ab0fcc7 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -694,7 +694,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 {
 	int cpu;
 
-	struct flush_tlb_info info __aligned(SMP_CACHE_BYTES) = {
+	struct flush_tlb_info info = {
 		.mm = mm,
 	};
 
-- 
2.20.1

