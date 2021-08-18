Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B73F0BDA
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 21:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhHRTf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 15:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232149AbhHRTfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 15:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7D1960F4C;
        Wed, 18 Aug 2021 19:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629315290;
        bh=EN7kRYTJb+Gsldxs/kkTEiPA6uL0vQ2qeaYiF5NF6g0=;
        h=Date:From:To:Subject:From;
        b=qSdDGaPT4P/ccNIIHnmynHs3T/cjqHeZkJ1DYthpUFBAyo1QO2pttV+uxOZODBuU7
         38qJgHvimmdFezHw9kO6S75O41i6NzyDeCdVcsKyeGRFmNH7vXoemk6J5KpmQ4nBxs
         drXQSp70nSldIvhGMgAWMCBfqlt41yxSJf+mmmew=
Date:   Wed, 18 Aug 2021 12:34:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Kuan-Ying.Lee@mediatek.com, glider@google.com, dvyukov@google.com,
        elver@google.com
Subject:  +
 kfence-fix-is_kfence_address-for-addresses-below-kfence_pool_size.patch added
 to -mm tree
Message-ID: <20210818193450.CWYTY%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE
has been added to the -mm tree.  Its filename is
     kfence-fix-is_kfence_address-for-addresses-below-kfence_pool_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-fix-is_kfence_address-for-addresses-below-kfence_pool_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-fix-is_kfence_address-for-addresses-below-kfence_pool_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kfence-fix-is_kfence_address-for-addresses-below-kfence_pool_size.patch
kfence-show-cpu-and-timestamp-in-alloc-free-info.patch

