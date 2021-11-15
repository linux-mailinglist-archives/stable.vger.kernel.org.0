Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7239F452703
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345845AbhKPCOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238854AbhKORwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:52:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19BA0632AF;
        Mon, 15 Nov 2021 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997526;
        bh=3dpUZXaobsEN6UAh12VaFkhX4FG6f4zW3RRwrUCy55Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKgK1vUDCdSZ2x10m5ZOUYjGMW7C08CBl3Zk8AXvHslc8JDxT2JmAYzucVDDFDOnP
         k15F1TMgWVlLCufCgV1oWhPfH+uRyJFTwS+1LWkZ6/oRVgOEf6zm1rk3yXcjA+JkG9
         JjBsERu77pfHarh2S4NPe+poZHTB7vofEt/R1+5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wang <yun.wang@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/575] x86: Increase exception stack sizes
Date:   Mon, 15 Nov 2021 17:58:24 +0100
Message-Id: <20211115165349.892304030@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



