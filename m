Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B0E45BD59
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343637AbhKXMhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344160AbhKXMf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:35:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07CFA6139F;
        Wed, 24 Nov 2021 12:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756500;
        bh=Q0iVTnW0UUWj/MGIy+a7Z2i9YAx1Nh9hx+WYO7uayhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEu1Bb3WWFKQsChaZ3SXERhN1Ow8O+XuRXvSZVhJ6CYZYmTTdLuwOidnnBh2aYaJX
         kCuOB86knMV2ujyXO5XYe5eN2MGsCIspRU/vZt9IbzILb9pxmptwXnHd2/vD68BCVI
         O/MlgPCx6Y3/q2NUUL22uAVX5eFwyDLj95/AiZSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wang <yun.wang@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/251] x86: Increase exception stack sizes
Date:   Wed, 24 Nov 2021 12:55:17 +0100
Message-Id: <20211124115712.863030563@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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



