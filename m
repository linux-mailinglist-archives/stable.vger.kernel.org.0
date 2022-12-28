Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2348A657879
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiL1Ove (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiL1Ouz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:50:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10B410070
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:50:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 702B561130
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C48C433D2;
        Wed, 28 Dec 2022 14:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239050;
        bh=ql0cpyGneQfU9Y9vqzBIXG4rY7f6linehaNmb0D72R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0WRJE9Az0wj+tLkb7qYyl0srIeKBMuq+99tviT8MYX8RYZVbJPIdmFPOd1pn6+t8
         4TGhbpEKXp0VtzQqmiR0REyFTicZymhr3ceqG9ZrOTlHAWIZYhGz19GOiYIO8kJkQu
         AbDLSARDS++jC0GvWxsFZtvfPlnt8eM3XfiPtNgQ=
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
Subject: [PATCH 5.15 083/731] lib/debugobjects: fix stat count and optimize debug_objects_mem_init
Date:   Wed, 28 Dec 2022 15:33:10 +0100
Message-Id: <20221228144258.957375641@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 6946f8e204e3..793c31b7e417 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -440,6 +440,7 @@ static int object_cpu_offline(unsigned int cpu)
 	struct debug_percpu_free *percpu_pool;
 	struct hlist_node *tmp;
 	struct debug_obj *obj;
+	unsigned long flags;
 
 	/* Remote access is safe as the CPU is dead already */
 	percpu_pool = per_cpu_ptr(&percpu_obj_pool, cpu);
@@ -447,6 +448,12 @@ static int object_cpu_offline(unsigned int cpu)
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
@@ -1321,6 +1328,8 @@ static int __init debug_objects_replace_static_objects(void)
 		hlist_add_head(&obj->node, &objects);
 	}
 
+	debug_objects_allocated += i;
+
 	/*
 	 * debug_objects_mem_init() is now called early that only one CPU is up
 	 * and interrupts have been disabled, so it is safe to replace the
@@ -1389,6 +1398,7 @@ void __init debug_objects_mem_init(void)
 		debug_objects_enabled = 0;
 		kmem_cache_destroy(obj_cache);
 		pr_warn("out of memory.\n");
+		return;
 	} else
 		debug_objects_selftest();
 
-- 
2.35.1



