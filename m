Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A0028949B
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 21:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391319AbgJITyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 15:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391315AbgJITyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 15:54:19 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D97BC0613D7
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 12:54:18 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o8so4959790pll.4
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 12:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F22bFMhtVAhmXTuR4/1X/bDcNMMhExWItCxCe23EWIU=;
        b=Npi7NjSNb1UGyIYVCTZp0CJo5fFQ9smww6dV+Q25wTc2HAzHcAD9HniVj0B4XPRH//
         WdZghGsaQYl4k4yEDWekvGgx7hMKJxtl08sxOC5IV13cK3peE4jZDdmUo1v8Gsb9t2VX
         nc+sYxt+BqlRIIjWtu6LTDNQCGVeM9TAfj5iQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F22bFMhtVAhmXTuR4/1X/bDcNMMhExWItCxCe23EWIU=;
        b=owjdI7hHPmfKLP1xF6sCZzrkaadxj+7zRflsqH1GGFih6eGueNrzTbBCmUeehgd92s
         SU3+LMie6QdeLFEAeXcv/E9UAQSnRJXjnwP3CRiEqAo1+D3cm481yODV51ivvrd5lFyT
         bMoeKlYNKJYi0bKg7Q7N2xHg3mz3ZGvxDo3g3OqBG7fRoDgjRFwn2ZdIN3bTSfsUTaFa
         At5ZlvW55l0L0a74xvUrYu3lZRXJd+1Bjbx1a8ELkHarZAFQt7ULJ/7kVrEzpFEx7SDr
         Duz6lyfU0LZHNVbUFfliMbiy4U7mjwvYzxWov1pc2YMf66Koe2e/x/G49bxnwID9lajE
         OHQQ==
X-Gm-Message-State: AOAM5313RtVvvMxDsksgEtzwNZWjtUjGNi5oUueZJBWsvohJzgq1uq5l
        nzXiZnZtr6q/zRIsc7axbr4EIQ==
X-Google-Smtp-Source: ABdhPJz5BOO9kgJYxc5gMsHxfsWRC4HsO7I3VpQgWqsf3q4eDcCpfAaC13NDroJ8WTncKDv0pVy62w==
X-Received: by 2002:a17:902:b283:b029:d3:d779:94fd with SMTP id u3-20020a170902b283b02900d3d77994fdmr13103470plr.8.1602273258032;
        Fri, 09 Oct 2020 12:54:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w143sm11701672pfc.31.2020.10.09.12.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 12:54:16 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Marco Elver <elver@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 2/3] mm/slub: Fix redzoning for small allocations
Date:   Fri,  9 Oct 2020 12:54:10 -0700
Message-Id: <20201009195411.4018141-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201009195411.4018141-1-keescook@chromium.org>
References: <20201009195411.4018141-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The redzone area for SLUB exists between s->object_size and s->inuse
(which is at least the word-aligned object size). If a cache were created
with an object_size smaller than sizeof(void *), the in-object stored
freelist pointer will be overwritten by redzoning (e.g. with boot param
"slub_debug=ZV"):

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

(Note that no caches with such a size are known to exist in the kernel
currently.)

Fixes: 81819f0fc828 ("SLUB core")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/slub.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f4f1d63f0ab9..752fad36522c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3682,15 +3682,17 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
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

