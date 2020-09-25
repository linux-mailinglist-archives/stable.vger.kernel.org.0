Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99163278E45
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgIYQUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E05FC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:36 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e28so2671490pgm.15
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=8WmVpMJEQT1pHI2cMLK8QhgtDuHMgVuFfXN4ECzM5os=;
        b=QBeZ9u/7JM7azMzEpXE2Yr4MVKnwbIniM88pEPVs1cp42Kl2UBbqwtNsv0uc4dIzWB
         +L5eHzmzzm2enx5ahzRvc9tJ+A7yLtNLxUBYcVqHF4nYMKYl9qf0vYUBOiZAR3+jA9Tv
         p3jz1/FI/4jzEGbD43N6RSpFPLfDkj/PDfGeyaWZicbRkpaLvSoxZaVjdcbW2AEjHh2S
         Z0FIlXlM82nNt4ofPiCMpLfpQ9iKAy78jXTZbZUWFxsghLXAf2QmNjnB7BW1iSCvpav/
         tbYv0XIGw/7CfB8Tl1G3j9KbHXmWGHzTgb2WIfHtTa80UAywtiOOyMp6Z/QaRLsRv/pa
         O7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8WmVpMJEQT1pHI2cMLK8QhgtDuHMgVuFfXN4ECzM5os=;
        b=dd8bNY7ZQjQQQ23z23W98eHnFhOSR+nC9dE8Lp9V7icnvUC+uZvz2LrgY0/41RjGzz
         8Po3qxwXhCA8HHsF82n5ZMgTdEA64tKoNie+HFyEBApUGm7CRTWHBlTP1BiJdVRLS4b/
         gNPuZBACtpFiDjiDv29C7342eY+ObHBak5OASBW2qMx4/hg6WbA5EPuFObDfNmXhAbTx
         R7k08hbABXFALNUL/8Ll3fZyRWH6kFGuQbyJP/dYre+zwWkxKwJPswKT4qj8cCMZJO81
         PLEd28DhG++7afqTC+nXIP06T8VzDYA7aDZghjBs8WzoK93GU9ONkQt0v30RHbfIlLjv
         4ROw==
X-Gm-Message-State: AOAM532+K1bmCSLM37QdsA9o/5po5Q2y222jRQt4NRN765mtiG+8qzKF
        49qD/fIV1T+hC1JNGqxQamJi9+7lQchCauUXeZcRe/WyrnRR+DSihbEHp8w7L8XJ+baj8JdGpOw
        4i0vpGcKtjjOuUIQuJa2Bk+R0PQUaZQe0uvWIq7x/Gg8DLAVJN9uTSJs7b45dWw==
X-Google-Smtp-Source: ABdhPJy8PbGKlaz/oHyL9ckDhw9QjZ4GQwh3Sl2JpH/7mZG4QOUYJB9D2j4Bjz15FCuogDDWb1AdUhLPJFI=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a17:90b:408b:: with SMTP id
 jb11mr379843pjb.164.1601050835964; Fri, 25 Sep 2020 09:20:35 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:12 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-27-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 26/30 for 5.4] dma-pool: introduce dma_guess_pool()
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

upstream 48b6703858dd5526c82d8ff2dbac59acab3a9dda commit.

dma-pool's dev_to_pool() creates the false impression that there is a
way to grantee a mapping between a device's DMA constraints and an
atomic pool. It tuns out it's just a guess, and the device might need to
use an atomic pool containing memory from a 'safer' (or lower) memory
zone.

To help mitigate this, introduce dma_guess_pool() which can be fed a
device's DMA constraints and atomic pools already known to be faulty, in
order for it to provide an better guess on which pool to use.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 318035e093fb..5b9eaa2b498d 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -203,7 +203,7 @@ static int __init dma_atomic_pool_init(void)
 }
 postcore_initcall(dma_atomic_pool_init);
 
-static inline struct gen_pool *dev_to_pool(struct device *dev)
+static inline struct gen_pool *dma_guess_pool_from_device(struct device *dev)
 {
 	u64 phys_mask;
 	gfp_t gfp;
@@ -217,10 +217,30 @@ static inline struct gen_pool *dev_to_pool(struct device *dev)
 	return atomic_pool_kernel;
 }
 
+static inline struct gen_pool *dma_get_safer_pool(struct gen_pool *bad_pool)
+{
+	if (bad_pool == atomic_pool_kernel)
+		return atomic_pool_dma32 ? : atomic_pool_dma;
+
+	if (bad_pool == atomic_pool_dma32)
+		return atomic_pool_dma;
+
+	return NULL;
+}
+
+static inline struct gen_pool *dma_guess_pool(struct device *dev,
+					      struct gen_pool *bad_pool)
+{
+	if (bad_pool)
+		return dma_get_safer_pool(bad_pool);
+
+	return dma_guess_pool_from_device(dev);
+}
+
 void *dma_alloc_from_pool(struct device *dev, size_t size,
 			  struct page **ret_page, gfp_t flags)
 {
-	struct gen_pool *pool = dev_to_pool(dev);
+	struct gen_pool *pool = dma_guess_pool(dev, NULL);
 	unsigned long val;
 	void *ptr = NULL;
 
@@ -249,7 +269,7 @@ void *dma_alloc_from_pool(struct device *dev, size_t size,
 
 bool dma_free_from_pool(struct device *dev, void *start, size_t size)
 {
-	struct gen_pool *pool = dev_to_pool(dev);
+	struct gen_pool *pool = dma_guess_pool(dev, NULL);
 
 	if (!pool || !gen_pool_has_addr(pool, (unsigned long)start, size))
 		return false;
-- 
2.28.0.618.gf4bc123cb7-goog

