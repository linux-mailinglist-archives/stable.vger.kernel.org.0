Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E571314E24
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfEFO6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbfEFOna (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:43:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48C3021019;
        Mon,  6 May 2019 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153809;
        bh=e5OyHT0kIM9tCgtPrUtYgCVbFfRiUBN5ta8F6o2joag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsXscSj2T+78rgDrhkSbhQBmaYtlD0fV2A8EwBUJPJoBr1xTSBlyE06fg+EZQq8TX
         vBrwFoCEkYw/BrUS2U3S2E4RziqOlSjH4ZJGf16caBuPYe/o7Hcbzl4c2Y+owAvQbz
         U8iFyNjj7AIdRqgZ0lapmDT7MrAG/w3yyDrmKLpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nadav Amit <namit@vmware.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.19 97/99] x86/mm/tlb: Revert "x86/mm: Align TLB invalidation info"
Date:   Mon,  6 May 2019 16:33:10 +0200
Message-Id: <20190506143102.620292973@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 780e0106d468a2962b16b52fdf42898f2639e0a0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -694,7 +694,7 @@ void flush_tlb_mm_range(struct mm_struct
 {
 	int cpu;
 
-	struct flush_tlb_info info __aligned(SMP_CACHE_BYTES) = {
+	struct flush_tlb_info info = {
 		.mm = mm,
 	};
 


