Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FAF3F2493
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 04:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhHTCFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 22:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTCFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 22:05:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 840B461056;
        Fri, 20 Aug 2021 02:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425070;
        bh=FAbgX98AcgWnC66yUp/bgSzwqTVgDkEDzHuEwn3Fbw0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=a7Ir5CfHyUv4BhHr9giy0OFZ2b/aQdUfMhbhDc4MJSFAkzsDPXN9LGd+SkZibvEIi
         mKnH0VmwQ3f24y+BYCeKfHvnGaTGTVQ8QDJ2hn8FmHFO2iXNHhI6ImWUO61PmM00iE
         LAqw24/UsYPSY3tVB4HYkfVRc57ZYs3ONtCxx3kU=
Date:   Thu, 19 Aug 2021 19:04:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, Kuan-Ying.Lee@mediatek.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 09/10] kfence: fix is_kfence_address() for
 addresses below KFENCE_POOL_SIZE
Message-ID: <20210820020430.mQDxQa8Jr%akpm@linux-foundation.org>
In-Reply-To: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
