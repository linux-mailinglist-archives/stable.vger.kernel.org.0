Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB97634E0B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 03:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiKWCxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 21:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbiKWCxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 21:53:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C63B7A349;
        Tue, 22 Nov 2022 18:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56D92B81E5C;
        Wed, 23 Nov 2022 02:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A254C433D6;
        Wed, 23 Nov 2022 02:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171992;
        bh=YFkNCCloeZT691sXTlPJ3lrU3jMCeLruUowXsIeBfW8=;
        h=Date:To:From:Subject:From;
        b=Cye9XVmbf4muDAHTi0ozqXsHRZWxU1VQUfJVGY6wBPweNnHlKra6Kyy59IMhA+RxJ
         7lNJoyG53kc3Fb+WwWGRBGGuXuuehH79aKq5uRKYSST6edtOqNxbzuYLlM/Ghrvs3e
         u+7nzk3nvEc3sPUafIhqFm/eiBI421NkiGb33H/Q=
Date:   Tue, 22 Nov 2022 18:53:11 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        liliguang@baidu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-correctly-charge-compressed-memory-to-its-memcg.patch removed from -mm tree
Message-Id: <20221123025312.0A254C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: correctly charge compressed memory to its memcg
has been removed from the -mm tree.  Its filename was
     mm-correctly-charge-compressed-memory-to-its-memcg.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Liguang <liliguang@baidu.com>
Subject: mm: correctly charge compressed memory to its memcg
Date: Mon, 14 Nov 2022 14:48:28 -0500

Kswapd will reclaim memory when memory pressure is high, the annonymous
memory will be compressed and stored in the zpool if zswap is enabled. 
The memcg_kmem_bypass() in get_obj_cgroup_from_page() will bypass the
kernel thread and cause the compressed memory not be charged to its memory
cgroup.

Remove the memcg_kmem_bypass() call and properly charge compressed memory
to its corresponding memory cgroup.

Link: https://lore.kernel.org/linux-mm/CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com/
Link: https://lkml.kernel.org/r/20221114194828.100822-1-hannes@cmpxchg.org
Fixes: f4840ccfca25 ("zswap: memcg accounting")
Signed-off-by: Li Liguang <liliguang@baidu.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-correctly-charge-compressed-memory-to-its-memcg
+++ a/mm/memcontrol.c
@@ -3026,7 +3026,7 @@ struct obj_cgroup *get_obj_cgroup_from_p
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_enabled() || memcg_kmem_bypass())
+	if (!memcg_kmem_enabled())
 		return NULL;
 
 	if (PageMemcgKmem(page)) {
_

Patches currently in -mm which might be from liliguang@baidu.com are


