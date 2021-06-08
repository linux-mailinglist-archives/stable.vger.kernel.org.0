Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3E63A009B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhFHSpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhFHSmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 14:42:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34014C0611BE
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 11:40:00 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c13so11188135plz.0
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 11:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WlWwfWm11ZwbBadKiVuyPJC6XajjDuI6+AslLyW5z08=;
        b=QbVPX1GwRQCu14OD+ZSs2LvfKRFfPgURgMXB+3uhrM/YY9d5aFspnwPaBDccVOrIo3
         M/ZaPHnxbHRRFmowOSMtUgWnXm5nZFjOXby4MFQMPrwDLtFIuAZtOBAm93mdLHCsqb/Q
         8okr0y42mrVxXiHgVb+CdogkSVVsRGOhRyTxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WlWwfWm11ZwbBadKiVuyPJC6XajjDuI6+AslLyW5z08=;
        b=Aj+u2ilCmsl0Av8CnQNgMs7xPJyUKzpImPM9l6cI5HERCKpEZ9fyz8GmxhuMduaus0
         ROhCmOucGgGKhTHSOBw7a9Cg5zQQaMoBlUcDhVmFyrptHrVHkmHLZsDnYVtiRT8Czb1K
         2dyHn37qJ5j+SrNviufrlmnoKt68JkqAunYISYkkA9hoTXjofoT2ElXzrKVqw7MhG/RV
         o+uBjS9I0ZX+2EbwuDZWqgPoCnWMDzSGYZfyOVTlo1yEjbi5kzepoWsYZ8ps5SrnF2NR
         HNYRqNLAGeTUVc+bMP+jQ7Y5uQF3+Is9XY5lWbr2a4dpa5jiUVKIQJ97mqKZBr0Y4uLR
         PkrA==
X-Gm-Message-State: AOAM530YFgrpy7c0LcGO8EeovKcSH8eJVcHdaQ80w3RmnKrqlVkwKrvE
        MAwS7OPma8vIExcLALb6BErKtQ==
X-Google-Smtp-Source: ABdhPJzqy4n4WdYTLIGeM6Q8LDAjzOhL4aPsd5U04TX5u6JdmHUAEsG/77ua5jo+MiWEvpvtD6yw4A==
X-Received: by 2002:a17:902:c1d2:b029:101:656b:8c06 with SMTP id c18-20020a170902c1d2b0290101656b8c06mr1015590plc.77.1623177598937;
        Tue, 08 Jun 2021 11:39:58 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c5sm9354668pfn.144.2021.06.08.11.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 11:39:58 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Marco Elver <elver@google.com>,
        Christoph Lameter <cl@linux.com>,
        "Lin, Zhenpeng" <zplin@psu.edu>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v4 2/3] mm/slub: Fix redzoning for small allocations
Date:   Tue,  8 Jun 2021 11:39:54 -0700
Message-Id: <20210608183955.280836-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210608183955.280836-1-keescook@chromium.org>
References: <20210608183955.280836-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=4d07ab25d78303866d0d97043ac7d3b3c89a188b; i=/4wP7Z7hf8NRJqx5cO57ZcO310lU091PUfj+vstIw5Q=; m=ZkE5m/qyaah1o2CK6u/oGOeYjX1Qohn3GAXR8LvKXFY=; p=QHACCNDXDPZn3tQzC59FK9Xid+U/e7qsN2m1YshAXh8=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmC/uXsACgkQiXL039xtwCZiyRAAlgt u28QImlU8Sk7zOkeBTH8PG+BF6ltMWSFMOWluk38QI6ysgrJyZuz8nPqyhlY4LbKmPZlM5dDzLrEl WFazxogGESoFjztYt2+fvWgirR7F4Ovi7zR3GOPg/U8Z74iwOWWjlL4Ps59MVV/4MtPihc+t6rtLS el+ck+DdHro3yhcPxc55bj2WQEoz5L+fXpqDzijkcDiSYKu8oYfRKNAXM4zjUPbuEebemG7C5W8ir gm5za0N1wQMZW6NnS4/7IQGfMkxVlrNsRHE8G34iWXP669r75O7EMGkfAoBmCh1SitVfGLkOhYWj3 YHDRwVy0ymZEpifJNKrxfokXFfNXSN9hrKi/vjSLA1alN8WFHkduOBu/daDHCsOmC9cbcYWuX7sEd nrQGxfzVvX3SYAOwTkbpxstr3E1QBwCMr+YzUYWNZr9ttwA1YAiWsZYMBnI6V1OY6mTmWJWPMy9fs bUSkP5OxEMCDR+DlHXFB7l6Q8RokenOAtQZlloq/rO0YAjDOJ+qe51052Iq5bbPB0ISUcIANpyruz R8xovxgPxcIKTYwaISm3YbbyxU44O9ZjZoTK53DHKQiCGXtOSTKXs3bO9Xvl3U6KuSuu++JONo0xY q9NXQPUYRi7+o754GbK2a5C5BAJQwms6BS5Q2uVWSOe3ji3RCxhTfQRuUkxHE5pY=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The redzone area for SLUB exists between s->object_size and s->inuse
(which is at least the word-aligned object_size). If a cache were created
with an object_size smaller than sizeof(void *), the in-object stored
freelist pointer would overwrite the redzone (e.g. with boot param
"slub_debug=ZF"):

BUG test (Tainted: G    B            ): Right Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

Redzone  (____ptrval____): bb bb bb bb bb bb bb bb    ........
Object   (____ptrval____): f6 f4 a5 40 1d e8          ...@..
Redzone  (____ptrval____): 1a aa                      ..
Padding  (____ptrval____): 00 00 00 00 00 00 00 00    ........

Store the freelist pointer out of line when object_size is smaller than
sizeof(void *) and redzoning is enabled.

Additionally remove the "smaller than sizeof(void *)" check under
CONFIG_DEBUG_VM in kmem_cache_sanity_check() as it is now redundant:
SLAB and SLOB both handle small sizes.

(Note that no caches within this size range are known to exist in the
kernel currently.)

Fixes: 81819f0fc828 ("SLUB core")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/slab_common.c | 3 +--
 mm/slub.c        | 8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index a4a571428c51..7cab77655f11 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -97,8 +97,7 @@ EXPORT_SYMBOL(kmem_cache_size);
 #ifdef CONFIG_DEBUG_VM
 static int kmem_cache_sanity_check(const char *name, unsigned int size)
 {
-	if (!name || in_interrupt() || size < sizeof(void *) ||
-		size > KMALLOC_MAX_SIZE) {
+	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
 		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
 		return -EINVAL;
 	}
diff --git a/mm/slub.c b/mm/slub.c
index f91d9fe7d0d8..f58cfd456548 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3734,15 +3734,17 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	 */
 	s->inuse = size;
 
-	if (((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
-		s->ctor)) {
+	if ((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
+	    ((flags & SLAB_RED_ZONE) && s->object_size < sizeof(void *)) ||
+	    s->ctor) {
 		/*
 		 * Relocate free pointer after the object if it is not
 		 * permitted to overwrite the first word of the object on
 		 * kmem_cache_free.
 		 *
 		 * This is the case if we do RCU, have a constructor or
-		 * destructor or are poisoning the objects.
+		 * destructor, are poisoning the objects, or are
+		 * redzoning an object smaller than sizeof(void *).
 		 *
 		 * The assumption that s->offset >= s->inuse means free
 		 * pointer is outside of the object is used in the
-- 
2.25.1

