Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A48657B12
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbiL1PR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiL1PRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:17:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5F313F95
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:17:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD9FEB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35858C433D2;
        Wed, 28 Dec 2022 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240665;
        bh=NiptSmm1Izwv4ZrmHEeZGc306A/GVdhTjv/BY+YFM/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cd6CqEBeb647kYoUiddc3uHpjPgxVIeayz9qtv+aBGlry2EyKcPRQ1VIJpAKBZmBn
         7xlOdHvDjeJFSu1EAHrW3LvPJiwam7wdAQTTLxIJxed9XjsUM95PfcJ67bGW7QjaxX
         Aa9A1um9pa+Ce+ZMfmxboxsTN/DT+hwWgR5F0Alg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, wuchi <wuchi.zero@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0125/1146] lib/debugobjects: fix stat count and optimize debug_objects_mem_init
Date:   Wed, 28 Dec 2022 15:27:44 +0100
Message-Id: <20221228144333.549646154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wuchi <wuchi.zero@gmail.com>

[ Upstream commit eabb7f1ace53e127309407b2b5e74e8199e85270 ]

1. Var debug_objects_allocated tracks valid kmem_cache_alloc calls, so
   track it in debug_objects_replace_static_objects.  Do similar things in
   object_cpu_offline.

2. In debug_objects_mem_init, there is no need to call function
   cpuhp_setup_state_nocalls when debug_objects_enabled = 0 (out of
   memory).

Link: https://lkml.kernel.org/r/20220611130634.99741-1-wuchi.zero@gmail.com
Fixes: 634d61f45d6f ("debugobjects: Percpu pool lookahead freeing/allocation")
Fixes: c4b73aabd098 ("debugobjects: Track number of kmem_cache_alloc/kmem_cache_free done")
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 337d797a7141..6f8e5dd1dcd0 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -437,6 +437,7 @@ static int object_cpu_offline(unsigned int cpu)
 	struct debug_percpu_free *percpu_pool;
 	struct hlist_node *tmp;
 	struct debug_obj *obj;
+	unsigned long flags;
 
 	/* Remote access is safe as the CPU is dead already */
 	percpu_pool = per_cpu_ptr(&percpu_obj_pool, cpu);
@@ -444,6 +445,12 @@ static int object_cpu_offline(unsigned int cpu)
 		hlist_del(&obj->node);
 		kmem_cache_free(obj_cache, obj);
 	}
+
+	raw_spin_lock_irqsave(&pool_lock, flags);
+	obj_pool_used -= percpu_pool->obj_free;
+	debug_objects_freed += percpu_pool->obj_free;
+	raw_spin_unlock_irqrestore(&pool_lock, flags);
+
 	percpu_pool->obj_free = 0;
 
 	return 0;
@@ -1318,6 +1325,8 @@ static int __init debug_objects_replace_static_objects(void)
 		hlist_add_head(&obj->node, &objects);
 	}
 
+	debug_objects_allocated += i;
+
 	/*
 	 * debug_objects_mem_init() is now called early that only one CPU is up
 	 * and interrupts have been disabled, so it is safe to replace the
@@ -1386,6 +1395,7 @@ void __init debug_objects_mem_init(void)
 		debug_objects_enabled = 0;
 		kmem_cache_destroy(obj_cache);
 		pr_warn("out of memory.\n");
+		return;
 	} else
 		debug_objects_selftest();
 
-- 
2.35.1



