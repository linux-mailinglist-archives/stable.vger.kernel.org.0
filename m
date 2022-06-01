Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3597953B078
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 02:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbiFAW7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 18:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiFAW7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 18:59:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EA3E15C5;
        Wed,  1 Jun 2022 15:58:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0BF65CE1E37;
        Wed,  1 Jun 2022 22:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16964C385B8;
        Wed,  1 Jun 2022 22:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654124335;
        bh=1bWZyYEFa/qkJ2367p5mr0pD6HHQfNOvmKVfG80FxFE=;
        h=Date:To:From:Subject:From;
        b=hBdNT0WvLpLVlRIvPNJt12tXvgKj2I955g6pUu36dlWj26fvyVIOeZUV/Jld1C3ik
         AI8aoHeDDdmqT9HW2nbrJSbzC6YSBtDYfpHV8vh/dxyVzYA1b6Sc73hxBRAaFp7OLW
         RoHu3rT8WUBnz+43FrkbgevIPLY3tvEe4SHBYgQg=
Date:   Wed, 01 Jun 2022 15:58:54 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        dyoung@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-kexec-fix-memory-leak-of-elf-header-buffer.patch removed from -mm tree
Message-Id: <20220601225855.16964C385B8@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: x86/kexec: fix memory leak of elf header buffer
has been removed from the -mm tree.  Its filename was
     x86-kexec-fix-memory-leak-of-elf-header-buffer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


