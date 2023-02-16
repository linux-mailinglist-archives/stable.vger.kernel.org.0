Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7591699F20
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 22:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjBPVrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 16:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBPVq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 16:46:57 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1CD3B3E0
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 13:46:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a9-20020a25af09000000b0083fa6f15c2fso3348759ybh.16
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 13:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bAVGkn1V34UfXYCduywOhSCUf/aOV+M7/FaubotBnKo=;
        b=JZAUr2Tg5NuD448WHvjh+8YkRdoIacbUZPBD3nVNUVvSbitNVpesxnEV3FneQVL4u0
         +/hzv8QubrW6Hrxc4RBOd2e2k0+J8W8SXc9vMH2v2W4y/FuH+7TG3P9n08NUOFoubJR2
         /v6DSmmAQgl7dEA7IPz0hafu/rk7H7agMvCqxGa7limWbLJ1h3wl0tlOrGcjgOsl0qUI
         R6HZV/Hc46HTkG5A3uBRf6crZKCmrj8KbJMLGHbskVZ0GLsirSGfUP/euIiv0F1GUR8b
         7AKyDX/mp4A5SMT1pB0DSkK8vdgudro77O7VOPj6eMC4Akq1jKytnC17StBzri8QorxF
         k9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAVGkn1V34UfXYCduywOhSCUf/aOV+M7/FaubotBnKo=;
        b=2XSj5L+tZUIzbk1wqwqLdhQ+USlTyNij+8Wt/wliXNfZhVyfxQmpbvepquqxzyLwG8
         FbN44hPzb595oW1ZaNlB++c40Hx6PVf0C2qI8ErfkkkaG3lYrgYsbOGAVUgFMXJkyp6X
         n+JYmTHIjay52S0/JlvIM7TeNQmpxc1mEMe5fmBOvVEFjhaa5SNmDdyoOODvKCMJ+Itb
         AIYVzECzqIgi49YKEZD8NNxveqA75n1weoXv9QwtI88swC6VfWyoriXT2iWKMyPWtMMp
         4TGRXPkHqKF0Ur8NwwzLXm/vBx936aIA5S343hDGOVQLmUiQB/wV1Z6CE3aEsWJmExS5
         OMwA==
X-Gm-Message-State: AO0yUKVsNUkHaIg+qhHDuvqSDforlRgwvwxvWbRMaeL564pudnp1/mWe
        yU5+4y5xSwbot/T3PaJQO1gite/MYqMqlQ==
X-Google-Smtp-Source: AK7set+QV/wWuwbl6qV/GeSY5iFq0uelWYs66FJfk18i4lZzoABSqGvHLj83tbXBq2ewq0nMZjZxXwGJh+CP4w==
X-Received: from aaltinayspec.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:7fcc])
 (user=aaltinay job=sendgmr) by 2002:a05:690c:b83:b0:52e:b74b:1b93 with SMTP
 id ck3-20020a05690c0b8300b0052eb74b1b93mr8ywb.0.1676584014672; Thu, 16 Feb
 2023 13:46:54 -0800 (PST)
Date:   Thu, 16 Feb 2023 21:46:51 +0000
In-Reply-To: <20230216214651.3514675-1-aaltinay@google.com>
Mime-Version: 1.0
References: <20230216214651.3514675-1-aaltinay@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216214651.3514675-2-aaltinay@google.com>
Subject: [PATCH 1/1] apparmor: cache buffers on percpu list if there is lock contention
From:   Anil Altinay <aaltinay@google.com>
To:     john.johansen@canonical.com, linux-security-module@vger.kernel.org
Cc:     aaltinay@google.com, Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On a heavily loaded machine there can be lock contention on the
global buffers lock. Add a percpu list to cache buffers on when
lock contention is encountered.

When allocating buffers attempt to use cached buffers first,
before taking the global buffers lock. When freeing buffers
try to put them back to the global list but if contention is
encountered, put the buffer on the percpu list.

The length of time a buffer is held on the percpu list is dynamically
adjusted based on lock contention.  The amount of hold time is rapidly
increased and slow ramped down.

Fixes: df323337e507 ("apparmor: Use a memory pool instead per-CPU caches")
Link: https://lore.kernel.org/lkml/cfd5cc6f-5943-2e06-1dbe-f4b4ad5c1fa1@canonical.com/
Signed-off-by: John Johansen <john.johansen@canonical.com>
Reported-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Anil Altinay <aaltinay@google.com>
Cc: stable@vger.kernel.org
---
 security/apparmor/lsm.c | 73 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index c6728a629437..56b22e2def4c 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -49,12 +49,19 @@ union aa_buffer {
 	char buffer[1];
 };
 
+struct aa_local_cache {
+	unsigned int contention;
+	unsigned int hold;
+	struct list_head head;
+};
+
 #define RESERVE_COUNT 2
 static int reserve_count = RESERVE_COUNT;
 static int buffer_count;
 
 static LIST_HEAD(aa_global_buffers);
 static DEFINE_SPINLOCK(aa_buffers_lock);
+static DEFINE_PER_CPU(struct aa_local_cache, aa_local_buffers);
 
 /*
  * LSM hook functions
@@ -1634,14 +1641,43 @@ static int param_set_mode(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
+static void update_contention(struct aa_local_cache *cache)
+{
+	cache->contention += 3;
+	if (cache->contention > 9)
+		cache->contention = 9;
+	cache->hold += 1 << cache->contention;		/* 8, 64, 512 */
+}
+
 char *aa_get_buffer(bool in_atomic)
 {
 	union aa_buffer *aa_buf;
+	struct aa_local_cache *cache;
 	bool try_again = true;
 	gfp_t flags = (GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN);
+	/* use per cpu cached buffers first */
+	cache = get_cpu_ptr(&aa_local_buffers);
+	if (!list_empty(&cache->head)) {
+		aa_buf = list_first_entry(&cache->head, union aa_buffer, list);
+		list_del(&aa_buf->list);
+		cache->hold--;
+		put_cpu_ptr(&aa_local_buffers);
+		return &aa_buf->buffer[0];
+	}
+	put_cpu_ptr(&aa_local_buffers);
 
+	if (!spin_trylock(&aa_buffers_lock)) {
+		cache = get_cpu_ptr(&aa_local_buffers);
+		update_contention(cache);
+		put_cpu_ptr(&aa_local_buffers);
+		spin_lock(&aa_buffers_lock);
+	} else {
+		cache = get_cpu_ptr(&aa_local_buffers);
+		if (cache->contention)
+			cache->contention--;
+		put_cpu_ptr(&aa_local_buffers);
+	}
 retry:
-	spin_lock(&aa_buffers_lock);
 	if (buffer_count > reserve_count ||
 	    (in_atomic && !list_empty(&aa_global_buffers))) {
 		aa_buf = list_first_entry(&aa_global_buffers, union aa_buffer,
@@ -1667,6 +1703,7 @@ char *aa_get_buffer(bool in_atomic)
 	if (!aa_buf) {
 		if (try_again) {
 			try_again = false;
+			spin_lock(&aa_buffers_lock);
 			goto retry;
 		}
 		pr_warn_once("AppArmor: Failed to allocate a memory buffer.\n");
@@ -1678,15 +1715,32 @@ char *aa_get_buffer(bool in_atomic)
 void aa_put_buffer(char *buf)
 {
 	union aa_buffer *aa_buf;
+	struct aa_local_cache *cache;
 
 	if (!buf)
 		return;
 	aa_buf = container_of(buf, union aa_buffer, buffer[0]);
 
-	spin_lock(&aa_buffers_lock);
-	list_add(&aa_buf->list, &aa_global_buffers);
-	buffer_count++;
-	spin_unlock(&aa_buffers_lock);
+	cache = get_cpu_ptr(&aa_local_buffers);
+	if (!cache->hold) {
+		put_cpu_ptr(&aa_local_buffers);
+		if (spin_trylock(&aa_buffers_lock)) {
+			list_add(&aa_buf->list, &aa_global_buffers);
+			buffer_count++;
+			spin_unlock(&aa_buffers_lock);
+			cache = get_cpu_ptr(&aa_local_buffers);
+			if (cache->contention)
+				cache->contention--;
+			put_cpu_ptr(&aa_local_buffers);
+			return;
+		}
+		cache = get_cpu_ptr(&aa_local_buffers);
+		update_contention(cache);
+	}
+
+	/* cache in percpu list */
+	list_add(&aa_buf->list, &cache->head);
+	put_cpu_ptr(&aa_local_buffers);
 }
 
 /*
@@ -1728,6 +1782,15 @@ static int __init alloc_buffers(void)
 	union aa_buffer *aa_buf;
 	int i, num;
 
+	/*
+	 * per cpu set of cached allocated buffers used to help reduce
+	 * lock contention
+	 */
+	for_each_possible_cpu(i) {
+		per_cpu(aa_local_buffers, i).contention = 0;
+		per_cpu(aa_local_buffers, i).hold = 0;
+		INIT_LIST_HEAD(&per_cpu(aa_local_buffers, i).head);
+	}
 	/*
 	 * A function may require two buffers at once. Usually the buffers are
 	 * used for a short period of time and are shared. On UP kernel buffers
-- 
2.39.2.637.g21b0678d19-goog

