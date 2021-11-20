Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEBF457A46
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 01:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbhKTAqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 19:46:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234793AbhKTAqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 19:46:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B48176137B;
        Sat, 20 Nov 2021 00:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637369018;
        bh=AQ5tlSpHHH8OIRqYCVH8VZh2bPmobVgNxO6sRajN5eY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JdLn7IqyymouIK14Ddqjv0m8YtVB6/TRqj4luEsBm13oasqzfiVSpvZHUJ6yf2OZ1
         1Ucj2pCX4V4pC+QeHJ98wvmY/8obOc60QrzYcnsV7a8zvWMBpcZNfK8s4sF7rjwDh1
         haBGOwECIISotm7z4yNHdghbS/M6KpO9mAuvPX0Y=
Date:   Fri, 19 Nov 2021 16:43:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, catalin.marinas@arm.com, cl@linux.com,
        glommer@parallels.com, gregkh@linuxfoundation.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, rkovhaev@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 08/15] mm: kmemleak: slob: respect
 SLAB_NOLEAKTRACE flag
Message-ID: <20211120004337.1cGvw42-J%akpm@linux-foundation.org>
In-Reply-To: <20211119164248.50feee07c5d2cc6cc4addf97@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>
Subject: mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

When kmemleak is enabled for SLOB, system does not boot and does not print
anything to the console.  At the very early stage in the boot process we
hit infinite recursion from kmemleak_init() and eventually kernel crashes.

kmemleak_init() specifies SLAB_NOLEAKTRACE for KMEM_CACHE(), but
kmem_cache_create_usercopy() removes it because CACHE_CREATE_MASK is not
valid for SLOB.

Let's fix CACHE_CREATE_MASK and make kmemleak work with SLOB

Link: https://lkml.kernel.org/r/20211115020850.3154366-1-rkovhaev@gmail.com
Fixes: d8843922fba4 ("slab: Ignore internal flags in cache creation")
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Glauber Costa <glommer@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.h~mm-kmemleak-slob-respect-slab_noleaktrace-flag
+++ a/mm/slab.h
@@ -147,7 +147,7 @@ static inline slab_flags_t kmem_cache_fl
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			  SLAB_TEMPORARY | SLAB_ACCOUNT)
 #else
-#define SLAB_CACHE_FLAGS (0)
+#define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE)
 #endif
 
 /* Common flags available with current configuration */
_
