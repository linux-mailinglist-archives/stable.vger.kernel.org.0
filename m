Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F7E66D0FB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 22:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbjAPVi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 16:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjAPVi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 16:38:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735112B63B;
        Mon, 16 Jan 2023 13:38:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F1EC61154;
        Mon, 16 Jan 2023 21:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611C3C433EF;
        Mon, 16 Jan 2023 21:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673905104;
        bh=lfcFSFE2VDqDOySKBz1PqbGxLZ1JH545q0AENmjmPs4=;
        h=Date:To:From:Subject:From;
        b=dWxepTAPE9L9NcBERtF6fkWR/X+4m78YsFAE2itB4SK6TeEG9MK62UVdmLv8UIhjP
         PD47NWgjnJ9cyUEKPwpDA0CBtCKcXkLMxyGU3evJwDm5Et3LZ+abKb1Kt2sSfRwftn
         oBn+znTkUgTi4lGc/SX5OI0MMk6ZarkRLXE/wD80=
Date:   Mon, 16 Jan 2023 13:38:23 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        msizanoen@qtmlabs.xyz, yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch added to mm-hotfixes-unstable branch
Message-Id: <20230116213824.611C3C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: fix crash during cgroup migration
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch

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

mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch
mm-multi-gen-lru-rename-lru_gen_struct-to-lru_gen_folio.patch
mm-multi-gen-lru-rename-lrugen-lists-to-lrugen-folios.patch
mm-multi-gen-lru-remove-eviction-fairness-safeguard.patch
mm-multi-gen-lru-remove-aging-fairness-safeguard.patch
mm-multi-gen-lru-shuffle-should_run_aging.patch
mm-multi-gen-lru-per-node-lru_gen_folio-lists.patch
mm-multi-gen-lru-clarify-scan_control-flags.patch
mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch
mm-add-vma_has_recency.patch
mm-support-posix_fadv_noreuse.patch

