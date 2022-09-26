Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888795EA5B3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiIZMOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239584AbiIZMNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:13:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0194F196;
        Mon, 26 Sep 2022 03:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76762604F5;
        Mon, 26 Sep 2022 10:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836CFC43141;
        Mon, 26 Sep 2022 10:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189206;
        bh=8J29lsujgPPQZQZIeLZnW3XufyGdE1hUpb/14e0fxFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cv3YF2GY+5wbh2+IvUW8zi/lnwgFrIjqjBhQXz0QdfbWPl4axVtT8SBb8nqPtBqu1
         FthoFNX+7R6/i8Pqk9Hn7cHYCdCRJwJq87pyZFfIYZUQB5mzIcf+PECWtPunGUviwB
         1SuOmbdLOex6qzoKHWN7b5argC/KReeVxItSTXck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 109/207] mm/slab_common: fix possible double free of kmem_cache
Date:   Mon, 26 Sep 2022 12:11:38 +0200
Message-Id: <20220926100811.481562993@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

[ Upstream commit d71608a877362becdc94191f190902fac1e64d35 ]

When doing slub_debug test, kfence's 'test_memcache_typesafe_by_rcu'
kunit test case cause a use-after-free error:

  BUG: KASAN: use-after-free in kobject_del+0x14/0x30
  Read of size 8 at addr ffff888007679090 by task kunit_try_catch/261

  CPU: 1 PID: 261 Comm: kunit_try_catch Tainted: G    B            N 6.0.0-rc5-next-20220916 #17
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x48
   print_address_description.constprop.0+0x87/0x2a5
   print_report+0x103/0x1ed
   kasan_report+0xb7/0x140
   kobject_del+0x14/0x30
   kmem_cache_destroy+0x130/0x170
   test_exit+0x1a/0x30
   kunit_try_run_case+0xad/0xc0
   kunit_generic_run_threadfn_adapter+0x26/0x50
   kthread+0x17b/0x1b0
   </TASK>

The cause is inside kmem_cache_destroy():

kmem_cache_destroy
    acquire lock/mutex
    shutdown_cache
        schedule_work(kmem_cache_release) (if RCU flag set)
    release lock/mutex
    kmem_cache_release (if RCU flag not set)

In some certain timing, the scheduled work could be run before
the next RCU flag checking, which can then get a wrong value
and lead to double kmem_cache_release().

Fix it by caching the RCU flag inside protected area, just like 'refcnt'

Fixes: 0495e337b703 ("mm/slab_common: Deleting kobject in kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock")
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index dbd4b6f9b0e7..29ae1358d5f0 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -503,6 +503,7 @@ void slab_kmem_cache_release(struct kmem_cache *s)
 void kmem_cache_destroy(struct kmem_cache *s)
 {
 	int refcnt;
+	bool rcu_set;
 
 	if (unlikely(!s) || !kasan_check_byte(s))
 		return;
@@ -510,6 +511,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	cpus_read_lock();
 	mutex_lock(&slab_mutex);
 
+	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;
+
 	refcnt = --s->refcount;
 	if (refcnt)
 		goto out_unlock;
@@ -520,7 +523,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
 out_unlock:
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
-	if (!refcnt && !(s->flags & SLAB_TYPESAFE_BY_RCU))
+	if (!refcnt && !rcu_set)
 		kmem_cache_release(s);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
-- 
2.35.1



