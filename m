Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FD15398BF
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 23:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbiEaV1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 May 2022 17:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238279AbiEaV1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 May 2022 17:27:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5E63B3EC;
        Tue, 31 May 2022 14:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76F6E6132D;
        Tue, 31 May 2022 21:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6EFC385A9;
        Tue, 31 May 2022 21:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654032449;
        bh=J/B6HZrOHzGGN29mQ4Jyk0qb4sS6EYDCzmWhnk3A4pM=;
        h=Date:To:From:Subject:From;
        b=nidv6J3Q69KMhuVt7wzOnVqDeKDLzqV4IYgsh89bGoXruwvK86BXLfsH+4NQQa7Dj
         XTZRlmh/eJShyt6ITFbw3r51MBj/sHMDxFhxp5WgejIVVPnP0ugL6lvRWUDC9PLnLy
         GBLEbOV+wVg8MPPR/P5AHfiVvSRCFpTnsSunRCtg=
Date:   Tue, 31 May 2022 14:27:28 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        dyoung@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-fix-memory-leak-of-elf-header-buffer.patch added to mm-hotfixes-unstable branch
Message-Id: <20220531212729.CC6EFC385A9@smtp.kernel.org>
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
     Subject: x86/kexec: fix memory leak of elf header buffer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-kexec-fix-memory-leak-of-elf-header-buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-fix-memory-leak-of-elf-header-buffer.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: x86/kexec: fix memory leak of elf header buffer
Date: Wed, 23 Feb 2022 19:32:24 +0800

This is reported by kmemleak detector:

unreferenced object 0xffffc900002a9000 (size 4096):
  comm "kexec", pid 14950, jiffies 4295110793 (age 373.951s)
  hex dump (first 32 bytes):
    7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00  .ELF............
    04 00 3e 00 01 00 00 00 00 00 00 00 00 00 00 00  ..>.............
  backtrace:
    [<0000000016a8ef9f>] __vmalloc_node_range+0x101/0x170
    [<000000002b66b6c0>] __vmalloc_node+0xb4/0x160
    [<00000000ad40107d>] crash_prepare_elf64_headers+0x8e/0xcd0
    [<0000000019afff23>] crash_load_segments+0x260/0x470
    [<0000000019ebe95c>] bzImage64_load+0x814/0xad0
    [<0000000093e16b05>] arch_kexec_kernel_image_load+0x1be/0x2a0
    [<000000009ef2fc88>] kimage_file_alloc_init+0x2ec/0x5a0
    [<0000000038f5a97a>] __do_sys_kexec_file_load+0x28d/0x530
    [<0000000087c19992>] do_syscall_64+0x3b/0x90
    [<0000000066e063a4>] entry_SYSCALL_64_after_hwframe+0x44/0xae

In crash_prepare_elf64_headers(), a buffer is allocated via vmalloc() to
store elf headers.  While it's not freed back to system correctly when
kdump kernel is reloaded or unloaded.  Then memory leak is caused.  Fix it
by introducing x86 specific function arch_kimage_file_post_load_cleanup(),
and freeing the buffer there.

And also remove the incorrect elf header buffer freeing code.  Before
calling arch specific kexec_file loading function, the image instance has
been initialized.  So 'image->elf_headers' must be NULL.  It doesn't make
sense to free the elf header buffer in the place.

Three different people have reported three bugs about the memory leak on
x86_64 inside Redhat.

Link: https://lkml.kernel.org/r/20220223113225.63106-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c~x86-kexec-fix-memory-leak-of-elf-header-buffer
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -376,9 +376,6 @@ void machine_kexec(struct kimage *image)
 #ifdef CONFIG_KEXEC_FILE
 void *arch_kexec_kernel_image_load(struct kimage *image)
 {
-	vfree(image->elf_headers);
-	image->elf_headers = NULL;
-
 	if (!image->fops || !image->fops->load)
 		return ERR_PTR(-ENOEXEC);
 
@@ -514,6 +511,15 @@ overflow:
 	       (int)ELF64_R_TYPE(rel[i].r_info), value);
 	return -ENOEXEC;
 }
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	vfree(image->elf_headers);
+	image->elf_headers = NULL;
+	image->elf_headers_sz = 0;
+
+	return kexec_image_post_load_cleanup_default(image);
+}
 #endif /* CONFIG_KEXEC_FILE */
 
 static int
_

Patches currently in -mm which might be from bhe@redhat.com are

x86-kexec-fix-memory-leak-of-elf-header-buffer.patch

