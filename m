Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0024628BBA
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiKNWDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiKNWDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:03:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B151319C29;
        Mon, 14 Nov 2022 14:03:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4504D61483;
        Mon, 14 Nov 2022 22:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F454C433D6;
        Mon, 14 Nov 2022 22:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668463382;
        bh=Ji3cHPhMpU3rokskpjNvyEV3mToj7C2hdmeuacJGTaY=;
        h=Date:To:From:Subject:From;
        b=p7HnCJw28Zg1XvJFJ3HPCJsaoYngG1fpff3kX343nU5PCdH9utYTPSj0vCdnm0HZw
         HPVaMALrmci3qp8CU+YsieOsTm3rgddIMph0eAQtJpRvgx/gO0cZouCUfGZ6ygFw0d
         Z6rwpfQP9KIFER9pjJ9UwRuItloVQqRje8V3yUkE=
Date:   Mon, 14 Nov 2022 14:03:01 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        liliguang@baidu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correctly-charge-compressed-memory-to-its-memcg.patch added to mm-hotfixes-unstable branch
Message-Id: <20221114220302.8F454C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: correctly charge compressed memory to its memcg
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-correctly-charge-compressed-memory-to-its-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correctly-charge-compressed-memory-to-its-memcg.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-correctly-charge-compressed-memory-to-its-memcg.patch

