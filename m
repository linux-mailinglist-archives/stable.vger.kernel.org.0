Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D115451DED
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345836AbhKPAec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344004AbhKOTXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE4E863611;
        Mon, 15 Nov 2021 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637002205;
        bh=1cLVH5KZNDb7WdYsbn/WQAD0Dy9XSwgb8y7wWvwgucw=;
        h=Date:From:To:Subject:From;
        b=U8jiR187b/hzIYyFX1mLAVIFdIgYcHdKAZQr3txL38BswIinjzeb3vyLii/Ok1+PC
         R3/JpN2s/A7V/eKWvM+pMEOIIHgrKf0yttDZT9ahOpDFierq/OTAMX6JOZu+LZhDLe
         a3FKlfzfuwx+DMRPRcGy99FNIgopu7udEsEJaxKU=
Date:   Mon, 15 Nov 2021 10:50:04 -0800
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, cl@linux.com, glommer@parallels.com,
        gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, rkovhaev@gmail.com, stable@vger.kernel.org,
        vbabka@suse.cz
Subject:  + mm-kmemleak-slob-respect-slab_noleaktrace-flag.patch
 added to -mm tree
Message-ID: <20211115185004.cd2DZSA6q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag
has been added to the -mm tree.  Its filename is
     mm-kmemleak-slob-respect-slab_noleaktrace-flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-slob-respect-slab_noleaktrace-flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-slob-respect-slab_noleaktrace-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-kmemleak-slob-respect-slab_noleaktrace-flag.patch

