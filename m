Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218811C15B2
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbgEANcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729560AbgEANcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:32:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B47520757;
        Fri,  1 May 2020 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339928;
        bh=KxgNkUjVFM7CT+iFDdcDZHWsAV/C9tx3nHEWZ0Hnhl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnFPh7eKUFHwHn2d/hO3ewAh1hFDT8CIs7TYpybTNIoCIhRbqxDPKqZiftsgtUteK
         18Ke8xQKysosNkR7LcJqZEN/zFUs/bFjFl0yyQMN+afPJT/IPXVj2lIGqxOFuOC4yT
         ssKszueZQL68dCIb64SYb7PHSXFvycAwPQgC+CuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/117] mm, slub: restore the original intention of prefetch_freepointer()
Date:   Fri,  1 May 2020 15:20:59 +0200
Message-Id: <20200501131547.739266029@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit 0882ff9190e3bc51e2d78c3aadd7c690eeaa91d5 upstream.

In SLUB, prefetch_freepointer() is used when allocating an object from
cache's freelist, to make sure the next object in the list is cache-hot,
since it's probable it will be allocated soon.

Commit 2482ddec670f ("mm: add SLUB free list pointer obfuscation") has
unintentionally changed the prefetch in a way where the prefetch is
turned to a real fetch, and only the next->next pointer is prefetched.
In case there is not a stream of allocations that would benefit from
prefetching, the extra real fetch might add a useless cache miss to the
allocation.  Restore the previous behavior.

Link: http://lkml.kernel.org/r/20180809085245.22448-1-vbabka@suse.cz
Fixes: 2482ddec670f ("mm: add SLUB free list pointer obfuscation")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthias Schiffer <mschiffer@universe-factory.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3c1a16f03b2bd..481518c3f61a9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -269,8 +269,7 @@ static inline void *get_freepointer(struct kmem_cache *s, void *object)
 
 static void prefetch_freepointer(const struct kmem_cache *s, void *object)
 {
-	if (object)
-		prefetch(freelist_dereference(s, object + s->offset));
+	prefetch(object + s->offset);
 }
 
 static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
-- 
2.20.1



