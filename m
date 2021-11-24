Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B208145C3AD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349302AbhKXNlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350258AbhKXNji (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:39:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A927361884;
        Wed, 24 Nov 2021 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758605;
        bh=iPZqAwq281dPGItrKn315H2dtBSW/7NRTHTjnry0IrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgJWJExEcx0OgfybuLVrhprI6Ugvg4+U2nqd6iyo0X87rzic9vr81w92hd4EtJfWz
         6MiNL5rU57Yn/vZ7blLUOAw4othoivbnQKGyCU9j5t4oBFqz4azjrj9pCcW6Ep+Bgt
         NJbd2pvDSyLEKKBhd5UYl8qXzQvqGrY6fgP2oBkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <songmuchun@bytedance.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 125/154] mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag
Date:   Wed, 24 Nov 2021 12:58:41 +0100
Message-Id: <20211124115706.333377140@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

commit 34dbc3aaf5d9e89ba6cc5e24add9458c21ab1950 upstream.

When kmemleak is enabled for SLOB, system does not boot and does not
print anything to the console.  At the very early stage in the boot
process we hit infinite recursion from kmemleak_init() and eventually
kernel crashes.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.h
+++ b/mm/slab.h
@@ -147,7 +147,7 @@ static inline slab_flags_t kmem_cache_fl
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			  SLAB_TEMPORARY | SLAB_ACCOUNT)
 #else
-#define SLAB_CACHE_FLAGS (0)
+#define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE)
 #endif
 
 /* Common flags available with current configuration */


