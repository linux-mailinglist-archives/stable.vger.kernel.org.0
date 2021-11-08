Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EE744A117
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238765AbhKIBH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237415AbhKIBFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5333610A8;
        Tue,  9 Nov 2021 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419740;
        bh=TvmCK6lQ2hlYhAva3GZM/grX/Nr5WqkWiEZe0gfSME4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAT1xsVrA57qFsv+iBy3dVRhrFAnEYaTW17laUBB6kpdrT988/+j8JqKLURDTRG5/
         Egyjb2LROrbSKeRZ99Dy8U4Om07qLWbFP8ZJCZSEdz4yoLI0oofoDii/wcqvIjVDrn
         zK6AkPA75/9QIx+jBGaYi7vjLfTGxE/2tpE/J1OjIt49f2DRQFuWtNw63JBtvg9bpw
         ghOv+74duPFRC9hlaoBz8RTpZSZ8yI9OI0HoXtvGg0KXz15mPCN7fN5kJnxT6T/bSw
         cV8HuTHEoNXn8dxMRRlC9t0WwEppZXEKb5fnzHb4+AN0iP8ju7zOW+yhpFj8K8xIQq
         IQDSHhdu1ugtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, adobriyan@gmail.com
Subject: [PATCH AUTOSEL 5.14 021/138] x86: Increase exception stack sizes
Date:   Mon,  8 Nov 2021 12:44:47 -0500
Message-Id: <20211108174644.1187889-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
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

