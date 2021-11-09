Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA2544A330
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242752AbhKIB0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237287AbhKIBVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 561AC61B21;
        Tue,  9 Nov 2021 01:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420105;
        bh=KtonEn5HvGcYC394V97oFTNdYEp6zGgCSACTXwtaPNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSiy5DxZ5gema04xG/YNnTaArt1a8Jp967cmQQNGXuYenFitk2bchHegVhO+7VKf0
         QbHomjrdGe663grq4eEGCQ5onNXSJOzcxZhUvvAj6M7uru/XsFi5qAklrkBXsQtWn2
         opuYgUXfkdwU/230QKU6zkoI8DOrnRR3NlF4np5k/OTtgGnDc14Rmr0oFcGNMpvvZX
         901OTYiADjlZ14UGVZ+cBS9qa5pb+/SeuQVi+ey4lEJ+9fAz6DjR3Lh9LVVN9OBGM0
         XtomS6+pGhigwUp2u0g0+LpIPlX00qXaNxO1v1gC4aU1rSLuvX+MroFfsabYSn4lDE
         JdcHtiFBtJIrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, adobriyan@gmail.com
Subject: [PATCH AUTOSEL 4.9 09/33] x86: Increase exception stack sizes
Date:   Mon,  8 Nov 2021 20:07:43 -0500
Message-Id: <20211109010807.1191567-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
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
index 390fdd39e0e21..5a69eee673536 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -19,7 +19,7 @@
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))
 
-#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
+#define EXCEPTION_STACK_ORDER (1 + KASAN_STACK_ORDER)
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
 
 #define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
-- 
2.33.0

