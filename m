Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8262862F208
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 11:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiKRKA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 05:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241066AbiKRKAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 05:00:24 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5936A253
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 02:00:22 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o7so4086306pjj.1
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 02:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w4Tv0F1uItwO4IHFiNDZHG9aEzkG+Q+HP5zfgRRlg7Q=;
        b=lseM9UHtQiSZ5wY8hPbQUGoaPEPzQ2N4x5yTzW3cVgV1oqQ7kONRnY3bNQ7o5TurHT
         ZJHvXvXxNrWZENrgIr3MoKP4IIAsCK5xsrneVz2kCe3EAzcLKMzuXYnuCmp774nlmizR
         V6Xist7V8Qc5qrBOsrgRug0vCgLJhrfi/2/5ufqo5k05Kpwlkhq/EG95pTLNwKkarURn
         XIrfDCuPPnCPwOpICKjcmJcezfJeWTERGRTbqlacXzig465HsZpXK+MzmeG8KYIKFajR
         ixdRkOzWla7EwqxCFBc/iMor6RvoKGaFSRU4R86r/fI0b5bdSWm40+WL5zSh15pSxXTR
         CSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w4Tv0F1uItwO4IHFiNDZHG9aEzkG+Q+HP5zfgRRlg7Q=;
        b=bGCBsQ6H5NG+AeKjN0jDbEV3UzR1VeJY4AQV+E1G3ogIvpS5KWVmAYhx/2llI9ZlXz
         v6d3alwW5BAXQxG0KYiYRpi1M0x99JJY6WiiPsMN4k6ruk4BmHv5R67P4Q3Fe6SjTqUw
         Iq/KEdveZm0GvMKDIlkBNjXlEaZD3HG6wzDna3OyI9RZ7DSh8qQcR/CqRodLS1alEVSo
         DGZJdUTlXUlXS/ER2bp6ywPUGRCiDP1a4tipCOMT91UfBHnG8xIFmF7RCd47F7dHY4a4
         owjWrZXaKgwGjSB+bhs1C3QFxCYQKA0M1Azyd69m8XxFcWDzNv7L4v3OtwZjWwgJPx/A
         1YhA==
X-Gm-Message-State: ANoB5pmT/UqbNon9kwC/3iDh674VTz4HvvvXSABZrnrlQAhpa6rj/NVF
        uBrOqVRWgT99G1dBbkyJ7hVk+A==
X-Google-Smtp-Source: AA0mqf60nRcs2G+x9aqMKPfPjzEgHr1qUsJJdKgfHIYXSiZgm1tHigXAMjpI42JSWc02ylMk4JDARA==
X-Received: by 2002:a17:90b:4390:b0:218:4d16:e0c7 with SMTP id in16-20020a17090b439000b002184d16e0c7mr7118201pjb.105.1668765621883;
        Fri, 18 Nov 2022 02:00:21 -0800 (PST)
Received: from C02DW0BEMD6R.bytedance.net ([2404:9dc0:cd01::24])
        by smtp.gmail.com with ESMTPSA id n10-20020a6563ca000000b0043a18cef977sm2439463pgv.13.2022.11.18.02.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 02:00:21 -0800 (PST)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org
Cc:     akinobu.mita@gmail.com, dvyukov@google.com, jgg@nvidia.com,
        willy@infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3] mm: fix unexpected changes to {failslab|fail_page_alloc}.attr
Date:   Fri, 18 Nov 2022 18:00:11 +0800
Message-Id: <20221118100011.2634-1-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we specify __GFP_NOWARN, we only expect that no warnings
will be issued for current caller. But in the __should_failslab()
and __should_fail_alloc_page(), the local GFP flags alter the
global {failslab|fail_page_alloc}.attr, which is persistent and
shared by all tasks. This is not what we expected, let's fix it.

Cc: stable@vger.kernel.org
Fixes: 3f913fc5f974 ("mm: fix missing handler for __GFP_NOWARN")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 v1: https://lore.kernel.org/lkml/20221107033109.59709-1-zhengqi.arch@bytedance.com/
 v2: https://lore.kernel.org/lkml/20221108035232.87180-1-zhengqi.arch@bytedance.com/

 Changelog in v2 -> v3:
 - collect Reviewed-by
 - rebase onto the next-20221118

 Changelog in v1 -> v2:
  - add comment for __should_failslab() and __should_fail_alloc_page()
    (suggested by Jason)

 include/linux/fault-inject.h |  7 +++++--
 lib/fault-inject.c           | 14 +++++++++-----
 mm/failslab.c                | 12 ++++++++++--
 mm/page_alloc.c              |  7 +++++--
 4 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 9f6e25467844..444236dadcf0 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -20,7 +20,6 @@ struct fault_attr {
 	atomic_t space;
 	unsigned long verbose;
 	bool task_filter;
-	bool no_warn;
 	unsigned long stacktrace_depth;
 	unsigned long require_start;
 	unsigned long require_end;
@@ -32,6 +31,10 @@ struct fault_attr {
 	struct dentry *dname;
 };
 
+enum fault_flags {
+	FAULT_NOWARN =	1 << 0,
+};
+
 #define FAULT_ATTR_INITIALIZER {					\
 		.interval = 1,						\
 		.times = ATOMIC_INIT(1),				\
@@ -40,11 +43,11 @@ struct fault_attr {
 		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
 		.verbose = 2,						\
 		.dname = NULL,						\
-		.no_warn = false,					\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
 int setup_fault_attr(struct fault_attr *attr, char *str);
+bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 4b8fafce415c..5971f7c3e49e 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -41,9 +41,6 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
 
 static void fail_dump(struct fault_attr *attr)
 {
-	if (attr->no_warn)
-		return;
-
 	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
 		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
 		       "name %pd, interval %lu, probability %lu, "
@@ -103,7 +100,7 @@ static inline bool fail_stacktrace(struct fault_attr *attr)
  * http://www.nongnu.org/failmalloc/
  */
 
-bool should_fail(struct fault_attr *attr, ssize_t size)
+bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
 {
 	bool stack_checked = false;
 
@@ -152,13 +149,20 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
 		return false;
 
 fail:
-	fail_dump(attr);
+	if (!(flags & FAULT_NOWARN))
+		fail_dump(attr);
 
 	if (atomic_read(&attr->times) != -1)
 		atomic_dec_not_zero(&attr->times);
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(should_fail_ex);
+
+bool should_fail(struct fault_attr *attr, ssize_t size)
+{
+	return should_fail_ex(attr, size, 0);
+}
 EXPORT_SYMBOL_GPL(should_fail);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
diff --git a/mm/failslab.c b/mm/failslab.c
index 58df9789f1d2..ffc420c0e767 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -16,6 +16,8 @@ static struct {
 
 bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
+	int flags = 0;
+
 	/* No fault-injection for bootstrap cache */
 	if (unlikely(s == kmem_cache))
 		return false;
@@ -30,10 +32,16 @@ bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 	if (failslab.cache_filter && !(s->flags & SLAB_FAILSLAB))
 		return false;
 
+	/*
+	 * In some cases, it expects to specify __GFP_NOWARN
+	 * to avoid printing any information(not just a warning),
+	 * thus avoiding deadlocks. See commit 6b9dbedbe349 for
+	 * details.
+	 */
 	if (gfpflags & __GFP_NOWARN)
-		failslab.attr.no_warn = true;
+		flags |= FAULT_NOWARN;
 
-	return should_fail(&failslab.attr, s->object_size);
+	return should_fail_ex(&failslab.attr, s->object_size, flags);
 }
 
 static int __init setup_failslab(char *str)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f7a63684e6c4..baf97166172c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3909,6 +3909,8 @@ __setup("fail_page_alloc=", setup_fail_page_alloc);
 
 static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
+	int flags = 0;
+
 	if (order < fail_page_alloc.min_order)
 		return false;
 	if (gfp_mask & __GFP_NOFAIL)
@@ -3919,10 +3921,11 @@ static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 			(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return false;
 
+	/* See comment in __should_failslab() */
 	if (gfp_mask & __GFP_NOWARN)
-		fail_page_alloc.attr.no_warn = true;
+		flags |= FAULT_NOWARN;
 
-	return should_fail(&fail_page_alloc.attr, 1 << order);
+	return should_fail_ex(&fail_page_alloc.attr, 1 << order, flags);
 }
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-- 
2.20.1

