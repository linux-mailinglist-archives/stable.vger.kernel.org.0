Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468D63D7E88
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 21:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhG0TfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 15:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhG0TfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9290160FA0;
        Tue, 27 Jul 2021 19:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414508;
        bh=3ZrqY4Q2nFu3UuYq1irywXFE+7ic8vFlUHSsEHt93vk=;
        h=Date:From:To:Subject:From;
        b=MjHOL1KKoZSDLMRYeD18EHDzKCYHvoerHK7uva202U7+sU1oTTmo434n2/d0pQujJ
         fuubn/vN/GVKZi73nvyuJqPrO1I778/C7DbbOm8JLocTeddsTSTg5zh2RBq4IbqdX0
         knfsUqH+R3aO28kSHCPoHUv1Zf1GhmcZe/2V5NPs=
Date:   Tue, 27 Jul 2021 12:35:08 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc.patch removed
 from -mm tree
Message-ID: <20210727193508.0aO69KOYK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kfence: move the size check to the beginning of __kfence_alloc()
has been removed from the -mm tree.  Its filename was
     kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from glider@google.com are


