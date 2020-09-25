Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CDF278E30
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgIYQUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbgIYQUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:09 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E37C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:09 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id t56so2341281qtt.19
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=QcerwLJt+BrBlXaZq3EkwdHRTge1NDWtXmvqdmYSPwQ=;
        b=YLraY8jttzY0GnBwgPXzo57I4pGhtveHN311BpcSxRNGDE/GczHSPmZPIoc+S9pv79
         HAxm2HHC4kamAgAeOTZnXHkgGy42+Q+D2ShMiEjS8V3xI5J+lmVFUmU/PEhbXjFAUhJR
         /5beU2trJ/TsJtWX1YJoT40BnwT1dVBU/wD7Wtip1wj44UjTfkalHz1TIhHmtFTXWsNt
         CTfpFmYuPhbKxGOguookK07CMqyu529hK1SSkrolX18FzSt870hKdZ4PmpsvMN26Kgvf
         yZz4Q1sPWGUKG0ppET0ei9mYKiKZSfkuIhqtzAqUpMGLY60xSCIANeHIsEhJfBT6fnkl
         fqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QcerwLJt+BrBlXaZq3EkwdHRTge1NDWtXmvqdmYSPwQ=;
        b=orkPIMTLRlIbIg09RbdtLKfrQ6D25SaG91Hx4OvNQvtpHDXFIqoC6qTaHL3Vtd2yVM
         lwV1UP6Y6zXszPStak/OqWJs50VxdLjeE9PotkWqBot+XtGfd9Lly2y4T66k0ucdn7vP
         2VhMbUA+g44WBQeIMB5uz8VkVoKsOBR48P4GfAYew8VCiVZkFO2hTlpeIuRgG6/Dd41i
         X7JWJ3NBciXLaR5ucg/Ac/pkX864I9ynLEcqfHcCVlfj5fFNLpkh4g/WcwsbQO8xxxKb
         6TbEtPPEparAJfL+0Py0/wOoo2fR6zzg17XIgSkgRv7bWE7Cap90/CBNuBNUFZQAqigE
         PYrg==
X-Gm-Message-State: AOAM533CkhdHmidEkGp1FK7yC+PBlfcPY99hmG1B5x8bmbw9+IcVU4LZ
        HEZk0jtfHVBM25eiNtYthqLamIzuEIY+4JPd3IVohjJrBjnigMxxFd8EIRvea3Eu28GQxKcJ6Vs
        Ia5pIC3gImyYH2mW7/G1fWC1dh7XM3iTIRINtzNOW1tsCZewkFlePzI4tE3qJtA==
X-Google-Smtp-Source: ABdhPJy1XzGiyNKMCHwbtH0N4ZYRvvSWvgNkSnlEiqZ/OtkVhg2cdVb8Tot9m287lS8xAZekEB3Kzd/UQys=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:ad4:5a0e:: with SMTP id ei14mr176956qvb.15.1601050808300;
 Fri, 25 Sep 2020 09:20:08 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:56 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-11-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 10/30 for 5.4] dma-pool: add pool sizes to debugfs
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream 2edc5bb3c5cc42131438460a50b7b16905c81c2a commit.

The atomic DMA pools can dynamically expand based on non-blocking
allocations that need to use it.

Export the sizes of each of these pools, in bytes, through debugfs for
measurement.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Rientjes <rientjes@google.com>
[hch: remove the !CONFIG_DEBUG_FS stubs]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index c8d61b3a7bd6..dde6de7f8e83 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2012 ARM Ltd.
  * Copyright (C) 2020 Google LLC
  */
+#include <linux/debugfs.h>
 #include <linux/dma-direct.h>
 #include <linux/dma-noncoherent.h>
 #include <linux/dma-contiguous.h>
@@ -13,8 +14,11 @@
 #include <linux/workqueue.h>
 
 static struct gen_pool *atomic_pool_dma __ro_after_init;
+static unsigned long pool_size_dma;
 static struct gen_pool *atomic_pool_dma32 __ro_after_init;
+static unsigned long pool_size_dma32;
 static struct gen_pool *atomic_pool_kernel __ro_after_init;
+static unsigned long pool_size_kernel;
 
 #define DEFAULT_DMA_COHERENT_POOL_SIZE  SZ_256K
 static size_t atomic_pool_size = DEFAULT_DMA_COHERENT_POOL_SIZE;
@@ -29,6 +33,29 @@ static int __init early_coherent_pool(char *p)
 }
 early_param("coherent_pool", early_coherent_pool);
 
+static void __init dma_atomic_pool_debugfs_init(void)
+{
+	struct dentry *root;
+
+	root = debugfs_create_dir("dma_pools", NULL);
+	if (IS_ERR_OR_NULL(root))
+		return;
+
+	debugfs_create_ulong("pool_size_dma", 0400, root, &pool_size_dma);
+	debugfs_create_ulong("pool_size_dma32", 0400, root, &pool_size_dma32);
+	debugfs_create_ulong("pool_size_kernel", 0400, root, &pool_size_kernel);
+}
+
+static void dma_atomic_pool_size_add(gfp_t gfp, size_t size)
+{
+	if (gfp & __GFP_DMA)
+		pool_size_dma += size;
+	else if (gfp & __GFP_DMA32)
+		pool_size_dma32 += size;
+	else
+		pool_size_kernel += size;
+}
+
 static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 			      gfp_t gfp)
 {
@@ -76,6 +103,7 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 	if (ret)
 		goto encrypt_mapping;
 
+	dma_atomic_pool_size_add(gfp, pool_size);
 	return 0;
 
 encrypt_mapping:
@@ -160,6 +188,8 @@ static int __init dma_atomic_pool_init(void)
 		if (!atomic_pool_dma32)
 			ret = -ENOMEM;
 	}
+
+	dma_atomic_pool_debugfs_init();
 	return ret;
 }
 postcore_initcall(dma_atomic_pool_init);
-- 
2.28.0.618.gf4bc123cb7-goog

