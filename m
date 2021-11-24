Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE47E45BB85
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243467AbhKXMUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243530AbhKXMSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:18:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A1661153;
        Wed, 24 Nov 2021 12:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755893;
        bh=KtonEn5HvGcYC394V97oFTNdYEp6zGgCSACTXwtaPNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3SiNJ1iBYd4Jbi68hmcC99/7LS0+u0Uri2Veyabrnu4eDUyiawvwtP0q3XHwote7
         fBAhk9TBlcNp5Av46k3KtzGBakEdHyiSe/UJsjoX+Fj0CcgjCwvGMqAau8tBTZeSEK
         bf1cI05MRFNLoeost0bjLj3zt4ZL8jP3hLjTxLOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wang <yun.wang@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 063/207] x86: Increase exception stack sizes
Date:   Wed, 24 Nov 2021 12:55:34 +0100
Message-Id: <20211124115705.965579826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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



