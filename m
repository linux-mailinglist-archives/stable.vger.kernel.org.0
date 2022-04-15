Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3984F502057
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 04:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348612AbiDOCQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 22:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348615AbiDOCQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 22:16:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34D13190A;
        Thu, 14 Apr 2022 19:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF15B82BF3;
        Fri, 15 Apr 2022 02:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCA3C385A5;
        Fri, 15 Apr 2022 02:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649988839;
        bh=am2ji8hOArEj1jJvaTmG1u8UgrvozH1QixzKt+KNgWU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Fx/60ptRS88rycGMyNZZbzfrt/wpN4qFFZtmnPKZFN7XJXELZJfMo7nQX1RhMz6B/
         PqCS64+RxvO+cwxBK3HDcZdY7BzYSJIaa+d58gHI0phEUln+4es3L0AhbvodPYcKl3
         wWPrpoa1INiiohMDLVcOI0TdZdZ9BwMvI6UfkO54=
Date:   Thu, 14 Apr 2022 19:13:58 -0700
To:     viro@zeniv.linux.org.uk, surenb@google.com, stable@vger.kernel.org,
        sspatil@google.com, songliubraving@fb.com, shuah@kernel.org,
        rppt@kernel.org, rientjes@google.com, regressions@leemhuis.info,
        ndesaulniers@google.com, mike.kravetz@oracle.com,
        maskray@google.com, kirill.shutemov@linux.intel.com,
        irogers@google.com, hughd@google.com, hjl.tools@gmail.com,
        ckennelly@google.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
Subject: [patch 12/14] revert "fs/binfmt_elf: use PT_LOAD p_align values for static PIE"
Message-Id: <20220415021359.3FCA3C385A5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
