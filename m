Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B320644A202
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243399AbhKIBQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242054AbhKIBLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:11:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A8C261A87;
        Tue,  9 Nov 2021 01:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419894;
        bh=AlNY1KDY+3Z4FOFEcpeF7Bga+azl9Y2sftpCI89T+Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5lrP334y7kI2i6OoSsIwXRznlH9YbFio0619uDBsuN+JDQ6V8QuzGArDgrdHZ4jV
         wdcrqIJ2cl167hb8asz8fa412b9nKXNnEfg/40B3JAuSQG8H0XtHqpKbilQc3Uwuh/
         dhGxe672sd6T1BLBSw2xlx9OJmkYTIDh6+H7Fi26a0ZqzBWo7O5cDiouZdeXe7chAY
         mOHIUrvFQJv/pi+Z00ZtF8XSds8SVK3gwkZl5N9ycc6OSwKQuk1Kx2rQUgNtzuU6TO
         YLcIHKuth6U0mfM6hljg7MZPCy6C7VPFtjBjrl7KRz0WMXTOcr7FzngSpZ1+vgH2ry
         8fiOPVx4cnozw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, adobriyan@gmail.com
Subject: [PATCH AUTOSEL 5.4 15/74] x86: Increase exception stack sizes
Date:   Mon,  8 Nov 2021 12:48:42 -0500
Message-Id: <20211108174942.1189927-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174942.1189927-1-sashal@kernel.org>
References: <20211108174942.1189927-1-sashal@kernel.org>
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

