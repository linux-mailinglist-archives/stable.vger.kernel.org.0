Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645C9450B21
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhKORUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:20:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237131AbhKORR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C75563238;
        Mon, 15 Nov 2021 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996399;
        bh=AlNY1KDY+3Z4FOFEcpeF7Bga+azl9Y2sftpCI89T+Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVOYeVAnIIHORrS+Uuc2MdFcmqPbfKFP9ZvpY0xH5THD+5jcPo0pP8T+OvrITsALg
         crJvH76Ur6QE5cuH6XXEaHiC9VGvTMJKQ1EOgmtELg9axHBJqq9Xdf+pdO3uzXJG8D
         pycisSPplz+7kDtVw8YyA5JcmHV4HUbfjtGbPpLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wang <yun.wang@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/355] x86: Increase exception stack sizes
Date:   Mon, 15 Nov 2021 18:00:49 +0100
Message-Id: <20211115165317.858370194@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 288b065955b72..9d0b479452720 100644
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



