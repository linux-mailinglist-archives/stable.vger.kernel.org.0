Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9B74FAB0E
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 00:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiDIWTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 18:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbiDIWTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 18:19:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E9934BB5;
        Sat,  9 Apr 2022 15:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A552B803F2;
        Sat,  9 Apr 2022 22:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33449C385A0;
        Sat,  9 Apr 2022 22:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649542643;
        bh=5q4B4MU0qhnyj784+WM3Mqf55bd82nyICd6SWwAf4Yw=;
        h=Date:To:From:Subject:From;
        b=Qc1LrIhh27SlJ3ZavGUANoOyK1NH2AQjRnfr9+ZoREb4q/bklwUXb4B+CTo+i1vr4
         0H3JKiGjyyRcZ2t5yhoG6qh3pWV9iv7NuFJBebnd1s4n/JucWoy5Hw8oFOYJj3Y8SK
         58vZ9tACw6l5HBw0+7S0M1Ml1SCzu2uynOFGPOvA=
Date:   Sat, 09 Apr 2022 15:17:22 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        surenb@google.com, stable@vger.kernel.org, sspatil@google.com,
        songliubraving@fb.com, shuah@kernel.org, rppt@kernel.org,
        rientjes@google.com, regressions@leemhuis.info,
        ndesaulniers@google.com, mike.kravetz@oracle.com,
        maskray@google.com, kirill.shutemov@linux.intel.com,
        irogers@google.com, hughd@google.com, hjl.tools@gmail.com,
        ckennelly@google.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch added to -mm tree
Message-Id: <20220409221723.33449C385A0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: revert "fs/binfmt_elf: use PT_LOAD p_align values for static PIE"
has been added to the -mm tree.  Its filename is
     revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "fs/binfmt_elf: use PT_LOAD p_align values for static PIE"

Despite Mike's attempted fix (925346c129da117122), regressions reports
continue:

https://lore.kernel.org/lkml/cb5b81bd-9882-e5dc-cd22-54bdbaaefbbc@leemhuis.info/
https://bugzilla.kernel.org/show_bug.cgi?id=215720
https://lkml.kernel.org/r/b685f3d0-da34-531d-1aa9-479accd3e21b@leemhuis.info

So revert this patch.

Fixes: 9630f0d60fec ("fs/binfmt_elf: use PT_LOAD p_align values for static PIE")

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/binfmt_elf.c~revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie
+++ a/fs/binfmt_elf.c
@@ -1117,11 +1117,11 @@ out_free_interp:
 			 * independently randomized mmap region (0 load_bias
 			 * without MAP_FIXED nor MAP_FIXED_NOREPLACE).
 			 */
-			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
-			if (alignment > ELF_MIN_ALIGN) {
+			if (interpreter) {
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
+				alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
 				if (alignment)
 					load_bias &= ~(alignment - 1);
 				elf_flags |= MAP_FIXED_NOREPLACE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch
revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

