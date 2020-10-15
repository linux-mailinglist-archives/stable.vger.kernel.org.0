Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A289C28EB9B
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 05:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgJODhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 23:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729108AbgJODhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 23:37:16 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C51C0613D3
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:37:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l18so1012930pgg.0
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rKpXkxl6yJIU4tRkHvXmPNNxYUSkKNgxeKQKUdkfeI4=;
        b=Y7RwMlnTp+htb3EhE553XcSxYY00imMzkms1Q4ltiGTIPjbmMrFB9MsRfPZ8yGBGPR
         2GQwJoxN0tNXCP7H7TODKP0OefvZGiXFMH33q68Fvyig5D2hvk6Li16EejMb2cAqJYRv
         V9A/iQbWQ0cYjMEagNkFayGL8XGicbm+FsUQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rKpXkxl6yJIU4tRkHvXmPNNxYUSkKNgxeKQKUdkfeI4=;
        b=VWosPsLCnuG/jDWliFeWMz/t7KbCF8F9RzuszcuJlbaWeONhaKMrvmTf4uIMZEtXqb
         QYAohb5z2lfS3kwbIDJAXvyUezOHNwy/+sYTjdt6/S6qhVo78degh6zP0hr7xN0JUHMS
         JrVCK/ma6pNBywlRnd/LYxOgBNWbSYVPI5v3LQEriOq2YB4TeggIfpztJscQGGbKo2dA
         rJlmbBogTzCpZsYSRkjAL1RO31XI8pGwTEcELDJu32pZZG9IRxPmcT0M+QCF9EaF44c0
         AcIJswWzjSjsQ8SJ4konhAiQiTGC0B+uY/THfjnNqQLC4azrUlxDJwPwyvlmf5WoJxNN
         IUaA==
X-Gm-Message-State: AOAM5329ll/LpYAbI6zCuiL89TNq+76OAVRoxzFwAIkF8Y89dM6nrpsS
        JalwKm5TErEeIKKM8p8CNY06Kw==
X-Google-Smtp-Source: ABdhPJyoubbBOjnFUbsWxFOasUJwB58/UjuuTINRsJ1mzvqelRDL/1DXYNuIQElP2sRZyoYFfT/RKQ==
X-Received: by 2002:aa7:8216:0:b029:142:2501:3968 with SMTP id k22-20020aa782160000b029014225013968mr2244959pfi.45.1602733035675;
        Wed, 14 Oct 2020 20:37:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 78sm1157099pfz.211.2020.10.14.20.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 20:37:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Waiman Long <longman@redhat.com>,
        Marco Elver <elver@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3 2/3] mm/slub: Fix redzoning for small allocations
Date:   Wed, 14 Oct 2020 20:37:11 -0700
Message-Id: <20201015033712.1491731-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201015033712.1491731-1-keescook@chromium.org>
References: <20201015033712.1491731-1-keescook@chromium.org>
MIME-Version: 1.0
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

Store the freelist pointer out of line when object_size is smaller
than sizeof(void *) and redzoning is enabled. (This object_size is not
actually considered valid, as tested by kmem_cache_sanity_check() under
CONFIG_DEBUG_VM. This is being added for extra robustness, since it IS
possible to build kernels where this is allowed -- why keep foot-guns
around?)

(Note that no caches in this size range are known to exist in the kernel
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

