Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032EE44A2A4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhKIBTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241965AbhKIBRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:17:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050DB61A57;
        Tue,  9 Nov 2021 01:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420027;
        bh=Q0iVTnW0UUWj/MGIy+a7Z2i9YAx1Nh9hx+WYO7uayhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YouAUHSzONnVvxv8VoZ8w32JqYW9Yuyw7JMabTD2sHXKuFRtVEQTnIkByngiBlxcD
         p8l01wNJRyNuZVeHn9zx7bmvBGZNkOvfy+iMKQdEGQajh+4J2IeU91/VwlmcTD6afo
         1BzbZ8po3z/d8hFO5uOJ636T3oZQg7Up431P8277kPAoyxtiJanCPOWLuZW/kZ3xqo
         Tv0zsS0hJyNhX4ZD59YG+6BILouL65xjL2EDppywqOdR31i0G9DbfMfasuTD71I+do
         AWhZJMWUsmnvbHrVXlYCw6LwWH6JiW+xQCMmIKIuHJNcbcQIcyKqYJlhP6TOH0JSXe
         PvxZLeUOrSSdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, adobriyan@gmail.com
Subject: [PATCH AUTOSEL 4.14 09/39] x86: Increase exception stack sizes
Date:   Mon,  8 Nov 2021 20:06:19 -0500
Message-Id: <20211109010649.1191041-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
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
index 50c8baaca4b06..4c807635e6244 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -20,7 +20,7 @@
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))
 
-#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
+#define EXCEPTION_STACK_ORDER (1 + KASAN_STACK_ORDER)
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
 
 #define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
-- 
2.33.0

