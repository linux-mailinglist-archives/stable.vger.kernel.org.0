Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9DE44A38A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243439AbhKIB1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244217AbhKIBY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B364661B3F;
        Tue,  9 Nov 2021 01:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420174;
        bh=/0LBGR/tDVCf/txDBVm2oikXt0vZaDQ4+mz7fcuQWJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaXquggLgZq1T2XU2GhLm5B9Ontc2ufgnBM7YCc+nU8xxSFv4P9YPADHZ5ZsdGXfj
         lpZe4RwBEEvKKH/Rh5gfOGeMonfuqD/sMXhmOmqbyDjOqkyEeex5EwmciNgcRgN7Mf
         FbfgIApQ+4qRXnuDskfSWoJmVIxNYf3z/fVs0DGidwrcaCK44BpBv3mnnJoKNsUzog
         xVW9i8Xo/qY5Ed+1a77UXslk7TDENlRCDov5/37CIjYYYORbM3KAgaeq9s9ZbZIvo/
         wBDkcg7a8xAGmYkcY5kSPgTaNsDEzRiFl2H4FTkRzDyprVsfwDiRIhPjZ4UAXJ7PL0
         MlUEzkxCpGHNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, adobriyan@gmail.com, luto@kernel.org
Subject: [PATCH AUTOSEL 4.4 08/30] x86: Increase exception stack sizes
Date:   Mon,  8 Nov 2021 20:08:56 -0500
Message-Id: <20211109010918.1192063-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
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
index fb1251946b45e..67a140d77f336 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -15,7 +15,7 @@
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))
 
-#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
+#define EXCEPTION_STACK_ORDER (1 + KASAN_STACK_ORDER)
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
 
 #define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
-- 
2.33.0

