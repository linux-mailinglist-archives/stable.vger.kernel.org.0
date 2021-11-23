Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E9145AF59
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 23:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238915AbhKWWtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 17:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238852AbhKWWtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 17:49:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4ADA60F5B;
        Tue, 23 Nov 2021 22:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707552;
        bh=B2/8noxuwOC+gEGCaH83L4w1SDipuIEtZpDQbFyjsNM=;
        h=Date:From:To:Subject:From;
        b=wuTYDuNb0Z5LwT5jtXbULb6zfsbmoLtg/+XszJfXwfCRoZvkwA3eZe0py2hSS2wXs
         2YCZ/5O3S+mv6h+nvLEQ/BXRXSctQtetQ8yHO/nXwH1Ri5Jbu+eJBfF6kaQtox6njQ
         BS5GMa87yJf4EVZHnQZR9pNi5h6DlKJJZsFiBoOg=
Date:   Tue, 23 Nov 2021 14:45:51 -0800
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, cl@linux.com, glommer@parallels.com,
        gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, rkovhaev@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-kmemleak-slob-respect-slab_noleaktrace-flag.patch removed from -mm tree
Message-ID: <20211123224551.z6_jxv25w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-slob-respect-slab_noleaktrace-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rkovhaev@gmail.com are


