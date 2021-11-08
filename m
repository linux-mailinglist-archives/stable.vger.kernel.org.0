Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA85E44A068
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241521AbhKIBDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241625AbhKIBDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:03:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CC286134F;
        Tue,  9 Nov 2021 01:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419632;
        bh=TvmCK6lQ2hlYhAva3GZM/grX/Nr5WqkWiEZe0gfSME4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiOGqrFChLg/QzutIVWMs8CATacnR7PfS0IKRnz7O9IXXIVa+Z2nEVhwjhW6j7B0B
         hSWb3kCILQBSfZsgbRcev7uB/3KY1k1DxZmsXZ4Bc9FR5Q6JCpxYTLxMuGfb5pKoAi
         OiXrW8woozTKGJJ2kdqVgc/PL89gLLAPs+edk+fDrFGVgQQ0KCR/ZHrVzQllFQcMmA
         OwZ4cjzAsW9sXzPcrf5x63KtU1Ddb1y7TVkOll0V2gKFG5PeLN0dZYkLA2Q+OLKv01
         U0Tu0sZOR1WRCCNd0JssGAlus4FjqqYVUD7rT/1VuQiD+2sJn1nftIPd6foWeSrTQp
         B5qwJWes/9Lkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, adobriyan@gmail.com
Subject: [PATCH AUTOSEL 5.15 023/146] x86: Increase exception stack sizes
Date:   Mon,  8 Nov 2021 12:42:50 -0500
Message-Id: <20211108174453.1187052-23-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7fae4c24a2b84a66c7be399727aca11e7a888462 ]

It turns out that a single page of stack is trivial to overflow with
all the tracing gunk enabled. Raise the exception stacks to 2 pages,
which is still half the interrupt stacks, which are at 4 pages.

Reported-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YUIO9Ye98S5Eb68w@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/page_64_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index a8d4ad8565681..e9e2c3ba59239 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -15,7 +15,7 @@
 #define THREAD_SIZE_ORDER	(2 + KASAN_STACK_ORDER)
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 
-#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
+#define EXCEPTION_STACK_ORDER (1 + KASAN_STACK_ORDER)
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
 
 #define IRQ_STACK_ORDER (2 + KASAN_STACK_ORDER)
-- 
2.33.0

