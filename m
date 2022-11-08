Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F5D6207D1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 04:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiKHDwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 22:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbiKHDwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 22:52:49 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059A32F390
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 19:52:48 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o7so12622319pjj.1
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 19:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCbnVcwfxaz8WtuNm+dEU4u6g06+3FeMUHVI5XHFQX8=;
        b=cH6oIK+cRiM9JP04nwl7ycPUaaFryhc7fuPf6QP2unzym9OFAXM3cj8P8q3Z0l3UQ8
         fO3U06Wogr7GIymltQYsOZuNGuYI//al0ILagvi/IcuJqE9MF2CgpTnuhq6WqH9wiOyG
         qReEY6Rsb8gmlJCnoeUw0FhBsSb5Vva9ClovzmEC0LwLA/lm6QMwgSYzVLZk9YocVoiI
         JBcvCRjM7ySOzjPeDYoVALfidXKJr19nhTCgMx+U62h9DE2xcd+mJXN2Ba31pwvuWrdw
         PPsE/lL/0eLznOpdC0R8JnZZ2271DQnHEOtNmF6wz5/OU9sDZQhZ6EAS1/VC0+2FLA8f
         14PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uCbnVcwfxaz8WtuNm+dEU4u6g06+3FeMUHVI5XHFQX8=;
        b=Rqba2+DLVQvEo+k7GscGdsyauOTc7Gfon3M8Do2dXqYrJdNuDbese+UlZCLU2CF+RY
         hS5hs8Vki4JFhR9ZzDriqh6QgPIhdDCFs+no3R3/0eqqtwYA+N42vh1xE4PUnz5O2h6l
         NCnIs8k5T327LttyrktkXDoPnQDCXLZIx0JY3REfLlF13OGDaL9quS/tjJoSyY1qL6va
         Px/MqMjpcTFor15dVAz+G7j2flGtCgffkB6l5Xm8YcJUqYYLbUPLVtH5hUO56fyhZ/Sc
         CT1GvjQcsHPUfn51bgkTot/Fk3Ss3mJNKF5udi0j2EM4AId5/0zF6E0pk8NI4Ysxtloq
         gjsw==
X-Gm-Message-State: ANoB5pn8vtnY0cR+44CYzbkXH6BuSuUteaYZ7qehFWx+iYxhAO/ocbhq
        XEXyouFZL6QNWovkb1MTJjTayw==
X-Google-Smtp-Source: AA0mqf7NI1yJdV5umCgvPMvxA3wJbCU2bY2T2ObWSHagxwnHwoIDEjY5taSByd88BDmJQitnYIpiMA==
X-Received: by 2002:a17:902:e5cc:b0:188:712f:df78 with SMTP id u12-20020a170902e5cc00b00188712fdf78mr17567320plf.106.1667879567491;
        Mon, 07 Nov 2022 19:52:47 -0800 (PST)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902a38600b0018685257c0dsm5747418pla.58.2022.11.07.19.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 19:52:46 -0800 (PST)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     dvyukov@google.com, jgg@nvidia.com, willy@infradead.org,
        akinobu.mita@gmail.com
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v2] mm: fix unexpected changes to {failslab|fail_page_alloc}.attr
Date:   Tue,  8 Nov 2022 11:52:32 +0800
Message-Id: <20221108035232.87180-1-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <Y2kxrerISWIxQsFO@nvidia.com>
References: <Y2kxrerISWIxQsFO@nvidia.com>
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
---
 v1: https://lore.kernel.org/lkml/20221107033109.59709-1-zhengqi.arch@bytedance.com/

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
index 7192ded44ad0..cb6fe715d983 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3902,6 +3902,8 @@ __setup("fail_page_alloc=", setup_fail_page_alloc);
 
 static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
+	int flags = 0;
+
 	if (order < fail_page_alloc.min_order)
 		return false;
 	if (gfp_mask & __GFP_NOFAIL)
@@ -3912,10 +3914,11 @@ static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
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

