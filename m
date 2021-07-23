Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4433D4318
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 00:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhGWWJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 18:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhGWWJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 18:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F39560EB5;
        Fri, 23 Jul 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080611;
        bh=xpuL7eQJ7xIPE/XkgeA272A2+E7I7sd5biWYgp+buAw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AJJZqaI5Bfft/bWGO1YiP4dhQEbOZH/9BzClDlW/vYxzKmHONpSrgTH1RW/yMlufC
         n2GokPJWggESxvNkdmzeZbDYIFtocQoVYAY/DIOGnnFD7Hym4FK3D+ELushuwhNVUT
         yV3tq/6jrs9iYnCigvx0cGo/uJ20vsQ0VuleLJ24=
Date:   Fri, 23 Jul 2021 15:50:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 04/15] kfence: move the size check to the
 beginning of __kfence_alloc()
Message-ID: <20210723225011.pURAgvl2s%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>
Subject: kfence: move the size check to the beginning of __kfence_alloc()

Check the allocation size before toggling kfence_allocation_gate.  This
way allocations that can't be served by KFENCE will not result in waiting
for another CONFIG_KFENCE_SAMPLE_INTERVAL without allocating anything.

Link: https://lkml.kernel.org/r/20210714092222.1890268-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/kfence/core.c~kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc
+++ a/mm/kfence/core.c
@@ -734,6 +734,13 @@ void kfence_shutdown_cache(struct kmem_c
 void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
 	/*
+	 * Perform size check before switching kfence_allocation_gate, so that
+	 * we don't disable KFENCE without making an allocation.
+	 */
+	if (size > PAGE_SIZE)
+		return NULL;
+
+	/*
 	 * allocation_gate only needs to become non-zero, so it doesn't make
 	 * sense to continue writing to it and pay the associated contention
 	 * cost, in case we have a large number of concurrent allocations.
@@ -757,9 +764,6 @@ void *__kfence_alloc(struct kmem_cache *
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
 
-	if (size > PAGE_SIZE)
-		return NULL;
-
 	return kfence_guarded_alloc(s, size, flags);
 }
 
_
