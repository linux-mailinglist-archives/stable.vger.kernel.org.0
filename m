Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE8B3F5053
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 20:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhHWSZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 14:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232035AbhHWSZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 14:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90FA061391;
        Mon, 23 Aug 2021 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629743065;
        bh=mbgdc0dUKiunmXoI2Rt2aikpXgEbZUlHQ/1szUid8Po=;
        h=Date:From:To:Subject:From;
        b=UQ/9x0BsYvhDdF3WFYgmOsFqTo43+u92THieiHHVQcbd3gYg/wja3mqdDG62JF6pR
         FBgrL7CbhuMnGm1uuO3P7gKqCjHO+seaeYWcoCVLlLvVGAQ24Uj20+4DHcSQOlgmtW
         LrTU4xsPjYMGPsW0gceelrC0MoWnR0peLYy2E1ZQ=
Date:   Mon, 23 Aug 2021 11:24:25 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        Kuan-Ying.Lee@mediatek.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 kfence-fix-is_kfence_address-for-addresses-below-kfence_pool_size.patch
 removed from -mm tree
Message-ID: <20210823182425.G3o7F9SlF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE
has been removed from the -mm tree.  Its filename was
     kfence-fix-is_kfence_address-for-addresses-below-kfence_pool_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE

Originally the addr != NULL check was meant to take care of the case where
__kfence_pool == NULL (KFENCE is disabled).  However, this does not work
for addresses where addr > 0 && addr < KFENCE_POOL_SIZE.

This can be the case on NULL-deref where addr > 0 && addr < PAGE_SIZE or
any other faulting access with addr < KFENCE_POOL_SIZE.  While the kernel
would likely crash, the stack traces and report might be confusing due to
double faults upon KFENCE's attempt to unprotect such an address.

Fix it by just checking that __kfence_pool != NULL instead.

Link: https://lkml.kernel.org/r/20210818130300.2482437-1-elver@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>    [5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/kfence.h~kfence-fix-is_kfence_address-for-addresses-below-kfence_pool_size
+++ a/include/linux/kfence.h
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
_

Patches currently in -mm which might be from elver@google.com are

kfence-show-cpu-and-timestamp-in-alloc-free-info.patch

