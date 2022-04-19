Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1155060ED
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbiDSA3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240567AbiDSA3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:29:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC2D23BC1;
        Mon, 18 Apr 2022 17:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D817B81123;
        Tue, 19 Apr 2022 00:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0348EC385A1;
        Tue, 19 Apr 2022 00:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650327969;
        bh=VnfmwaBnePMmzI7hlp0gWsJ/Ki89Om1zdjwh5jAMssE=;
        h=Date:To:From:Subject:From;
        b=g1BK38rbN+V2qJbxpOxyuw0P+U6AcBHeBlfW1hkqHFgqU7XBRr0tLpFXAmgbG6zAr
         SDJB591oNBTCiBHlYM3e3bnCWjETfpoez7JLadQ+gHk3eUMeh/BekSoWf3RDGjZZIg
         b7lEwPMksrfg0d+BLaLw6CLhgpRuS0wImOg9y/eI=
Date:   Mon, 18 Apr 2022 17:26:08 -0700
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
Subject: [merged] revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch removed from -mm tree
Message-Id: <20220419002609.0348EC385A1@smtp.kernel.org>
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
     Subject: revert "fs/binfmt_elf: fix PT_LOAD p_align values for loaders"
has been removed from the -mm tree.  Its filename was
     revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "fs/binfmt_elf: fix PT_LOAD p_align values for loaders"

925346c129da11 ("fs/binfmt_elf: fix PT_LOAD p_align values for loaders")
is an attempt to fix regressions due to 9630f0d60fec5f ("fs/binfmt_elf:
use PT_LOAD p_align values for static PIE").

But regressionss continue to be reported:

https://lore.kernel.org/lkml/cb5b81bd-9882-e5dc-cd22-54bdbaaefbbc@leemhuis.info/
https://bugzilla.kernel.org/show_bug.cgi?id=215720
https://lkml.kernel.org/r/b685f3d0-da34-531d-1aa9-479accd3e21b@leemhuis.info

This patch reverts the fix, so the original can also be reverted.

Fixes: 925346c129da11 ("fs/binfmt_elf: fix PT_LOAD p_align values for loaders")
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders
+++ a/fs/binfmt_elf.c
@@ -1118,7 +1118,7 @@ out_free_interp:
 			 * without MAP_FIXED nor MAP_FIXED_NOREPLACE).
 			 */
 			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
-			if (interpreter || alignment > ELF_MIN_ALIGN) {
+			if (alignment > ELF_MIN_ALIGN) {
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mglru-vs-maple-tree.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

