Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4E4278E44
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbgIYQUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0422C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:34 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id e12so2751174pfm.0
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=C3k20iK3GfE+b9a5aukeGgXsyuic3qNdstQ8OeobIG4=;
        b=P3erom7UiD1Ccn7oAS4KKrMqasIgnxsIp6pEhJuPbyMUDj1Lj0NIcQjYoXieKoS3Lu
         El/T6apyr2e/qBlaGrg/2dfR1eKInSDUEhJXOipE49fZ59003Utn8rwS1rxXg/xFWm6R
         i3wXlzU8z54FY2iaAy9Gg6dHCF6WJNU7kAyyob8xvx3Kj664A23ve8yG63OJblpO2s6X
         fyRUdrjg6TUOGZLRccrzD2gc7QlpVjI5wdVYZaznFpOSwLLDxxNyPM7e8EMQmqhLGc/6
         XcATPEVisDiHwSl5waMl96ltrmVChDBoQJzMuYrjWU+GUdR/VYg0BZP4BGYmNXfsV7w3
         1omQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C3k20iK3GfE+b9a5aukeGgXsyuic3qNdstQ8OeobIG4=;
        b=qTFE0nSocRWOxpU8JL2y86XTz7DOG1EbWRrntL8Ch7ubkFCg6zp9beh0ayg28YRr2u
         WANpNyfPfyPsbWhkO2vMZCDpEvUgtyW1i/cBM1hFNda1oxjT/AkNkklt/lJrP1kQLZGP
         6JbJRbg6DfHYkn/9/x14xSWXuFTA70qtda1xrKMrTfB3HAK6kZTi6euoa9FViyQw+vQS
         yqEpuXlurC5sF8Ma6iG9SynmCICO3HHOu9PXpwk/GSi6kqDKQGcwnChTlR1VnTMa8W3R
         PsB+N8HQ8iDgSA49O0Ej63fTIVSWE1XlSL+uBxuGPmxKuRNk/5GxNE1qJKs6IyPkaPHP
         l/aA==
X-Gm-Message-State: AOAM531q5ei5mcH3a0WWq+p9tBCLt7k9ay9XMHQfyRkVDhf3v7eQOaTT
        svYkie8JtyYenbYgbF9HUorqN1hPUXpE1ia8+3O4Rli1ERLfrKqI0BUzGHh+1CAdDv+tj+encB5
        /St5MZ8o0LacTMPS1Gqy48tpgF55qbu9LOVyqtLn5fqcIYA80MiQL5tetW9Joww==
X-Google-Smtp-Source: ABdhPJwiC5xptl3dyMpabG5Vn52g2nq3uUCGCuMWDompsb2hWxW6jZ0nGRwkDHWpZvJXTV6/qrVwg9zARIc=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:aa7:8a46:0:b029:142:2501:398a with SMTP id
 n6-20020aa78a460000b02901422501398amr9751pfa.79.1601050834187; Fri, 25 Sep
 2020 09:20:34 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:11 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-26-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 25/30 for 5.4] dma-pool: get rid of dma_in_atomic_pool()
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

upstream 23e469be6239d9cf3d921fc3e38545491df56534 commit.

The function is only used once and can be simplified to a one-liner.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 39ca26fa41b5..318035e093fb 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -217,15 +217,6 @@ static inline struct gen_pool *dev_to_pool(struct device *dev)
 	return atomic_pool_kernel;
 }
 
-static bool dma_in_atomic_pool(struct device *dev, void *start, size_t size)
-{
-	struct gen_pool *pool = dev_to_pool(dev);
-
-	if (unlikely(!pool))
-		return false;
-	return gen_pool_has_addr(pool, (unsigned long)start, size);
-}
-
 void *dma_alloc_from_pool(struct device *dev, size_t size,
 			  struct page **ret_page, gfp_t flags)
 {
@@ -260,7 +251,7 @@ bool dma_free_from_pool(struct device *dev, void *start, size_t size)
 {
 	struct gen_pool *pool = dev_to_pool(dev);
 
-	if (!dma_in_atomic_pool(dev, start, size))
+	if (!pool || !gen_pool_has_addr(pool, (unsigned long)start, size))
 		return false;
 	gen_pool_free(pool, (unsigned long)start, size);
 	return true;
-- 
2.28.0.618.gf4bc123cb7-goog

