Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24173B85B4
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 17:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhF3PFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 11:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhF3PFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 11:05:10 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A71C061766
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 08:02:41 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id g14-20020ad4510e0000b02902890eb69b5aso1559430qvp.21
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 08:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NsJPxv+Yi9Y0Cxl+/SZ8/0DfgNfKjUrGLSr4GOlizVE=;
        b=ZSFYc1N7Bh9wv2errbcoilHdQgrtZa4Egl/x1q8DWx087ZrALCwjG7d45PprJ7nOV+
         8ybg4z8OgnOrqDzpnDFp+d256wUotxawgE/vD2sBzRB+i9B08DGeCdhjXrw3GFVws+AS
         syJ+SBqSs9SGklX7ualr3e0kyhIbqSZqAXs5MsS0ReBBnE3YswrsTgZ4xk6ur3Q3qwkh
         mlkpUkSm1Y3v1Fgz/jYzX7caVUQz7AWqahH08YA04wZxzv4uDmF8A7Zo8QN3KPPw2DYy
         wtL6FSIyBrpaFv5c37rI/H2FcsggCqbNJLo/kQWTBPugSIKS0T8xVMd4H67528gI2oDi
         6H2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NsJPxv+Yi9Y0Cxl+/SZ8/0DfgNfKjUrGLSr4GOlizVE=;
        b=ahjMadfm3PNZjECDryIT0PSBayUkS1D9nWM0md4bgiX0mGY5UoU2QkWun0p9B2MorZ
         9tlGeVuzLJ/HLNI9uxyS7fuLVSFe0nfHwH5O+wAjKrRKL4uwWWT6CthvVtDvzdYx4yVv
         bZoKqNXYbWTzIN/QP/LF6fQU2gXGeBEDkQXNe8lUO/wiP7M/av//F05olBD/A0ZzfVgX
         KC4KS5gZJ44bCRXJi+xpShkrSG202ku5LVytVLDsZiMqK/UGILDuVzKPZNJ/QfZD1cyG
         hVY+ctoSiR8JbQzNTVES4PqndUVmmYGUq8WuQTy6KxTgXfdXr7ZtlWVhcna5YGHgciFZ
         fLSQ==
X-Gm-Message-State: AOAM530aiY0S0bVojrBfOwSvURWOj106nIrbfHP7n1N/GqP813l5QexF
        qmTFePPjRWraMpqlcI6HyGjclentDU4=
X-Google-Smtp-Source: ABdhPJy7krc3G3WIMTiQX8NdRFoM6NqtuGwGFCDI6oCddBMt9ABKJsibDaVZoTeNgXV5FaqCkdk5iSEw/Sg=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:15:13:a3fc:e8:8089:1013])
 (user=glider job=sendgmr) by 2002:a05:6214:966:: with SMTP id
 do6mr37584817qvb.57.1625065360398; Wed, 30 Jun 2021 08:02:40 -0700 (PDT)
Date:   Wed, 30 Jun 2021 17:02:34 +0200
In-Reply-To: <20210630150234.1109496-1-glider@google.com>
Message-Id: <20210630150234.1109496-2-glider@google.com>
Mime-Version: 1.0
References: <20210630150234.1109496-1-glider@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v4 2/2] kfence: skip all GFP_ZONEMASK allocations
From:   Alexander Potapenko <glider@google.com>
To:     akpm@linux-foundation.org
Cc:     dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, jrdr.linux@gmail.com,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allocation requests outside ZONE_NORMAL (MOVABLE, HIGHMEM or DMA) cannot
be fulfilled by KFENCE, because KFENCE memory pool is located in a
zone different from the requested one.

Because callers of kmem_cache_alloc() may actually rely on the
allocation to reside in the requested zone (e.g. memory allocations done
with __GFP_DMA must be DMAable), skip all allocations done with
GFP_ZONEMASK and/or respective SLAB flags (SLAB_CACHE_DMA and
SLAB_CACHE_DMA32).

Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: stable@vger.kernel.org # 5.12+
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>

---

v2:
 - added parentheses around the GFP clause, as requested by Marco
v3:
 - ignore GFP_ZONEMASK, which also covers __GFP_HIGHMEM and __GFP_MOVABLE
 - move the flag check at the beginning of the function, as requested by
   Souptick Joarder
v4:
 - minor fixes to description and comment formatting
---
 mm/kfence/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 33bb20d91bf6a..1cbdb62e6d0fb 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -740,6 +740,15 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 	if (size > PAGE_SIZE)
 		return NULL;
 
+	/*
+	 * Skip allocations from non-default zones, including DMA. We cannot
+	 * guarantee that pages in the KFENCE pool will have the requested
+	 * properties (e.g. reside in DMAable memory).
+	 */
+	if ((flags & GFP_ZONEMASK) ||
+	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
+		return NULL;
+
 	/*
 	 * allocation_gate only needs to become non-zero, so it doesn't make
 	 * sense to continue writing to it and pay the associated contention
-- 
2.32.0.93.g670b81a890-goog

