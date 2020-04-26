Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FA51B8D27
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgDZHIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 03:08:38 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:57096 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgDZHIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 03:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1587884910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dwp6Fdqipgt2m29Kc8rAwdHthR1+Rg86NnuTjSAnjVI=;
        b=NoxP6KP96gX2Aq2y+8HgSauEx+jX+KblSoiwZQHLSmXGEqThmtj3F9ZH09WSNiWPS3qJJi
        PTg3CIehbuevfTcS5sTrIqe304lqvnjlXwUh1dnjKs+FyYpPVz8NCzRM4ifzNoBYFG6+4u
        sm3Lw7rUc0UDmKX6RuxgS1p6bVTswuc=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Vlastimil Babka <vbabka@suse.cz>,
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
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.14] mm, slub: restore the original intention of prefetch_freepointer()
Date:   Sun, 26 Apr 2020 09:06:17 +0200
Message-Id: <20200426070617.14575-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
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
---
The original problem is explained in the patch description as
performance problem. And maybe this could also be one reason why it was
never submitted for a stable kernel.

But tests on mips ath79 (OpenWrt ar71xx target) showed that it most likely
related to "random" data bus errors. At least applying this patch seemed to
have solved it for Matthias Schiffer <mschiffer@universe-factory.net> and
some other persons who where debugging/testing this problem with him.

More details about it can be found in
https://github.com/freifunk-gluon/gluon/issues/1982
---
 mm/slub.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3c1a16f03b2b..481518c3f61a 100644
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

