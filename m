Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508C3685C53
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjBAApN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjBAApD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:45:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0F64FC2E;
        Tue, 31 Jan 2023 16:45:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D758AB81FC6;
        Wed,  1 Feb 2023 00:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775A0C433D2;
        Wed,  1 Feb 2023 00:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212299;
        bh=r3/kiPjbOX6tK6bXj9ZUjARQpn0TaD3qLbA4VnfBUko=;
        h=Date:To:From:Subject:From;
        b=JXoJUCyUc0678OHqDr9xJ6/wRofbVjzIOKMM5b1ar6dm/4QVUqjvQiXV4Qnl1GURU
         YeXyW1EVOjluRQVCRVNAisn6dW6p8bUJjasylIiCdESnNxz43FFlW2Mb522vHxPn8v
         tTVD8Cobv1m9v5vju3lIbiczp5wO792HmKgVztJo=
Date:   Tue, 31 Jan 2023 16:44:59 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        msizanoen@qtmlabs.xyz, yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch removed from -mm tree
Message-Id: <20230201004459.775A0C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: fix crash during cgroup migration
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: fix crash during cgroup migration
Date: Sun, 15 Jan 2023 20:44:05 -0700

lru_gen_migrate_mm() assumes lru_gen_add_mm() runs prior to itself.  This
isn't true for the following scenario:

    CPU 1                         CPU 2

  clone()
    cgroup_can_fork()
                                cgroup_procs_write()
    cgroup_post_fork()
                                  task_lock()
                                  lru_gen_migrate_mm()
                                  task_unlock()
    task_lock()
    lru_gen_add_mm()
    task_unlock()

And when the above happens, kernel crashes because of linked list
corruption (mm_struct->lru_gen.list).

Link: https://lore.kernel.org/r/20230115134651.30028-1-msizanoen@qtmlabs.xyz/
Link: https://lkml.kernel.org/r/20230116034405.2960276-1-yuzhao@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: msizanoen <msizanoen@qtmlabs.xyz>
Tested-by: msizanoen <msizanoen@qtmlabs.xyz>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-fix-crash-during-cgroup-migration
+++ a/mm/vmscan.c
@@ -3323,13 +3323,16 @@ void lru_gen_migrate_mm(struct mm_struct
 	if (mem_cgroup_disabled())
 		return;
 
+	/* migration can happen before addition */
+	if (!mm->lru_gen.memcg)
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(task);
 	rcu_read_unlock();
 	if (memcg == mm->lru_gen.memcg)
 		return;
 
-	VM_WARN_ON_ONCE(!mm->lru_gen.memcg);
 	VM_WARN_ON_ONCE(list_empty(&mm->lru_gen.list));
 
 	lru_gen_del_mm(mm);
_

Patches currently in -mm which might be from yuzhao@google.com are


