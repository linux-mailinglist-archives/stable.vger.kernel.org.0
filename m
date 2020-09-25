Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049B6278E49
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgIYQUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:40 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0906BC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:40 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e4so2339359pjd.4
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KU8huPEhL7T7UkG35//hpouPqo6XDp+tXBvhHSjepB8=;
        b=Hrkxa998Q2FnoRq+WycNNFC7a/B97QHFToQfZttXbcYdVDjTB+Gbwbatbx/3rgpPpt
         BUpn3xL3kR0t8zwDeBcxXOyp9P9fP//KgDOzfLilZEtWpH6b86njKMTzVTuiI88K7ay0
         onvcLsoPKfUSbgwWF9anqT+EVPP8yjOrywdCmsU5kNwtMum+nZlBTM9yrKHuGfYGiERx
         MQK2uquHHQATsMSBIhUqKZVeBDZR+llspzwl7k5WYXjPoGk/zSBmalSDw3t8dC/u6s6w
         +Gk4fb2pJUK0wr/XEupQZCwkCT0W01EZ1tZKVCTkSV8vJ1ZaNgZlm2L4RNPK7bUxnQdQ
         DqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KU8huPEhL7T7UkG35//hpouPqo6XDp+tXBvhHSjepB8=;
        b=GdxF58K78FNTy3zOdGIk0pWeeqcnemoq7rOx9yMmZAiyIKRIZ71QwR5EhUb6c/jtVc
         yIIdYEv78tuVWu8Wk2AsJdShgTyJyJgH7qIM4wLLNsyXPPhqE6DEhdAEcKOmfEWNciqO
         lhljrYokUAo5ZG1smUnYR4/oNOwxqvdoXiTqEi7mD06+l3/5bHgCBeyjmdeaEraqxNOR
         77L56wlufHi1vlBjJ3TgNk9urJBdiVM3i1n2AIVu2UTwbyLlRWi0aAveeHqOS0io0ywG
         3nmgxiw4GG/Pc4WF/vcUIvLlVTodsnpRaIp9opkagNQIe98BZlGs/KCx1Y8DmuqlR3xg
         fZkg==
X-Gm-Message-State: AOAM533llanSqQ0thgexKjFLmesNcJlJMZo3Bq5sbM4XU7deNzjQd63x
        KlIjONj9DRzqjFBom3z47E0XVa0pfWG7mcks1EwqPWC3po37sIGYdX52RE+bIqI46g1P+AeKHUi
        cXmbDjEBkb2PFDmOdQRizW53hsnZgHS/gn/ZPLCUojWDdw5qkYz+ntgL0ATIa5g==
X-Google-Smtp-Source: ABdhPJzQpVORyOny5JyJHrLQZF+85/6ZcAD61/lKKwyTunsYamu5beZ/Lmu84qthG8zgWx8GCIpF98pCe74=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a17:902:8493:b029:d2:42a6:238 with SMTP id
 c19-20020a1709028493b02900d242a60238mr199084plo.4.1601050839356; Fri, 25 Sep
 2020 09:20:39 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:14 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-29-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 28/30 for 5.4] dma-pool: do not allocate pool memory from CMA
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

upstream d9765e41d8e9ea2251bf73735a2895c8bad546fc commit.

There is no guarantee to CMA's placement, so allocating a zone specific
atomic pool from CMA might return memory from a completely different
memory zone. So stop using it.

Fixes: c84dc6e68a1d ("dma-pool: add additional coherent pools to map to gfp mask")
Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index d48d9acb585f..6bc74a2d5127 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -6,7 +6,6 @@
 #include <linux/debugfs.h>
 #include <linux/dma-direct.h>
 #include <linux/dma-noncoherent.h>
-#include <linux/dma-contiguous.h>
 #include <linux/init.h>
 #include <linux/genalloc.h>
 #include <linux/set_memory.h>
@@ -69,12 +68,7 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 
 	do {
 		pool_size = 1 << (PAGE_SHIFT + order);
-
-		if (dev_get_cma_area(NULL))
-			page = dma_alloc_from_contiguous(NULL, 1 << order,
-							 order, false);
-		else
-			page = alloc_pages(gfp, order);
+		page = alloc_pages(gfp, order);
 	} while (!page && order-- > 0);
 	if (!page)
 		goto out;
@@ -118,8 +112,7 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 	dma_common_free_remap(addr, pool_size);
 #endif
 free_page: __maybe_unused
-	if (!dma_release_from_contiguous(NULL, page, 1 << order))
-		__free_pages(page, order);
+	__free_pages(page, order);
 out:
 	return ret;
 }
-- 
2.28.0.618.gf4bc123cb7-goog

