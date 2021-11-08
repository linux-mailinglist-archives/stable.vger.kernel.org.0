Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A3344A185
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241050AbhKIBKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241984AbhKIBIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:08:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED1D361A3F;
        Tue,  9 Nov 2021 01:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419830;
        bh=3dpUZXaobsEN6UAh12VaFkhX4FG6f4zW3RRwrUCy55Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0kiZLg5sdNdSCbwTr7z1fqgFb2DslBhZV+Q2Uv7k+D7fhbWORSDzm3ZNuaQXjYTB
         fl2uu7yvZ4petwapxOUk/bLMVimclF0Fhi590nMtsL6jZA81j2akneVIQW/dG3NQz8
         Cx1WpA7xHIpGE6aNwvOPX8DWuzsKbs+t/0pxyq+hSDSYjXcGpi+8JOIZpBxS8AWIB7
         J0///IBgx7HMk3A9WgSojzsronXnwvNFSmcyIprzuZ/+nad/584a4qL+Yr/QzlSE50
         bvIA9DGZuHJbRfSeoRv1ffKPpFwKLSqhnS1XDsDUm4ox6JF42EutW1LUYgt7RkHT/m
         FFTX6va69cVSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, adobriyan@gmail.com
Subject: [PATCH AUTOSEL 5.10 018/101] x86: Increase exception stack sizes
Date:   Mon,  8 Nov 2021 12:47:08 -0500
Message-Id: <20211108174832.1189312-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
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
index 3f49dac03617d..224d71aef6303 100644
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

