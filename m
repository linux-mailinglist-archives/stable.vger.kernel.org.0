Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88E645BC50
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244803AbhKXM1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243175AbhKXMZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:25:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4948D61213;
        Wed, 24 Nov 2021 12:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756157;
        bh=bKq4lYb0lpF7Fc7iG6VFFMccq/G/q9YX1yhIEKmHINU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfJ9c3o81wzcK2fcm2+IN6zAG2TOBfZqKcX04SHEakjqzHzyl8lKE7Eu6yZLpit0w
         qsBZ4Co5n2vEUWPYC2fNLM9rXyQTXY9GKbPuAgPcLS7KOLVqg5rRpsWHWK4TSmb11q
         1vTc3FXam2uTQATfZZTdJNbxPS/cJnuVy8zGWts8=
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
Subject: [PATCH 4.9 192/207] mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag
Date:   Wed, 24 Nov 2021 12:57:43 +0100
Message-Id: <20211124115710.169334631@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
@@ -139,7 +139,7 @@ static inline unsigned long kmem_cache_f
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			  SLAB_TEMPORARY | SLAB_NOTRACK | SLAB_ACCOUNT)
 #else
-#define SLAB_CACHE_FLAGS (0)
+#define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE)
 #endif
 
 #define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)


