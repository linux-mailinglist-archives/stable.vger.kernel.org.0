Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C543F6480
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbhHXRFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhHXRCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4336961880;
        Tue, 24 Aug 2021 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824290;
        bh=uCcq/XOxIZnsY216jub7sCph5r3r6fTURJlkc9QdRMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYAm1g8hMRSb1nDO7WaDLPdaUrmLk7n3OoYlLB6tfh5lCJJhY6Xl/kmiXetT6JCZy
         jFkpeJQAntb9Yg5zXvrPcNds90OnapyOXbW+w7Yw+D81+XNRnkZUE6ynq6K/a+jHG2
         xnsq2NSdQXXLuSlJPg7z4UWK8WP6MokSRz+Ol8wTt0oSyuZcjUWt652o1fWSjMFxtx
         oMw4fzhgqPihosi2InXntV7V76DtaTp6bp9k2HH+8fRnspS0d4CbeuOGiU+arwUpYl
         nS1tG4Ji0+3sBQcymEJ8ZVySTdKnHQLAtycn61a/YtvyIPx2C9Lp9OJ+4RP7DBz99c
         bfWSzLDUrJrVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Elver <elver@google.com>,
        Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 123/127] kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE
Date:   Tue, 24 Aug 2021 12:56:03 -0400
Message-Id: <20210824165607.709387-124-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit a7cb5d23eaea148f8582229846f8dfff192f05c3 ]

Originally the addr != NULL check was meant to take care of the case
where __kfence_pool == NULL (KFENCE is disabled).  However, this does
not work for addresses where addr > 0 && addr < KFENCE_POOL_SIZE.

This can be the case on NULL-deref where addr > 0 && addr < PAGE_SIZE or
any other faulting access with addr < KFENCE_POOL_SIZE.  While the
kernel would likely crash, the stack traces and report might be
confusing due to double faults upon KFENCE's attempt to unprotect such
an address.

Fix it by just checking that __kfence_pool != NULL instead.

Link: https://lkml.kernel.org/r/20210818130300.2482437-1-elver@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>    [5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kfence.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index a70d1ea03532..3fe6dd8a18c1 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -51,10 +51,11 @@ extern atomic_t kfence_allocation_gate;
 static __always_inline bool is_kfence_address(const void *addr)
 {
 	/*
-	 * The non-NULL check is required in case the __kfence_pool pointer was
-	 * never initialized; keep it in the slow-path after the range-check.
+	 * The __kfence_pool != NULL check is required to deal with the case
+	 * where __kfence_pool == NULL && addr < KFENCE_POOL_SIZE. Keep it in
+	 * the slow-path after the range-check!
 	 */
-	return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && addr);
+	return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && __kfence_pool);
 }
 
 /**
-- 
2.30.2

