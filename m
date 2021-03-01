Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D08328BAF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbhCASi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239932AbhCASbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2E3765136;
        Mon,  1 Mar 2021 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618238;
        bh=th8TsAFHgOKsQiWBkDQOvbvXLxd5vbSrr4tcisIb06c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+bhbztFfeQaYiURn09M2GSQrxvc6uZHbGlVvf15aaXuTIqzltkFTXVb9rciLogld
         axlMH4wvGzdl0edeQTVeQe+s1hSUwyMlhmLcGSHUKTAVQhIXC08fENv1eCWyZCoYD5
         paiPbJKL0j2Y2hnWxGNlDR6YSIgGpAhPufrMOyHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 015/663] vmlinux.lds.h: Define SANTIZER_DISCARDS with CONFIG_GCOV_KERNEL=y
Date:   Mon,  1 Mar 2021 17:04:23 +0100
Message-Id: <20210301161142.540509077@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit f5b6a74d9c08b19740ca056876bf6584acdba582 upstream.

clang produces .eh_frame sections when CONFIG_GCOV_KERNEL is enabled,
even when -fno-asynchronous-unwind-tables is in KBUILD_CFLAGS:

$ make CC=clang vmlinux
...
ld: warning: orphan section `.eh_frame' from `init/main.o' being placed in section `.eh_frame'
ld: warning: orphan section `.eh_frame' from `init/version.o' being placed in section `.eh_frame'
ld: warning: orphan section `.eh_frame' from `init/do_mounts.o' being placed in section `.eh_frame'
ld: warning: orphan section `.eh_frame' from `init/do_mounts_initrd.o' being placed in section `.eh_frame'
ld: warning: orphan section `.eh_frame' from `init/initramfs.o' being placed in section `.eh_frame'
ld: warning: orphan section `.eh_frame' from `init/calibrate.o' being placed in section `.eh_frame'
ld: warning: orphan section `.eh_frame' from `init/init_task.o' being placed in section `.eh_frame'
...

$ rg "GCOV_KERNEL|GCOV_PROFILE_ALL" .config
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_GCOV_PROFILE_ALL=y

This was already handled for a couple of other options in
commit d812db78288d ("vmlinux.lds.h: Avoid KASAN and KCSAN's unwanted
sections") and there is an open LLVM bug for this issue. Take advantage
of that section for this config as well so that there are no more orphan
warnings.

Link: https://bugs.llvm.org/show_bug.cgi?id=46478
Link: https://github.com/ClangBuiltLinux/linux/issues/1069
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Fixes: d812db78288d ("vmlinux.lds.h: Avoid KASAN and KCSAN's unwanted sections")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210130004650.2682422-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -993,12 +993,13 @@
 #endif
 
 /*
- * Clang's -fsanitize=kernel-address and -fsanitize=thread produce
- * unwanted sections (.eh_frame and .init_array.*), but
- * CONFIG_CONSTRUCTORS wants to keep any .init_array.* sections.
+ * Clang's -fprofile-arcs, -fsanitize=kernel-address, and
+ * -fsanitize=thread produce unwanted sections (.eh_frame
+ * and .init_array.*), but CONFIG_CONSTRUCTORS wants to
+ * keep any .init_array.* sections.
  * https://bugs.llvm.org/show_bug.cgi?id=46478
  */
-#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KCSAN)
+#if defined(CONFIG_GCOV_KERNEL) || defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KCSAN)
 # ifdef CONFIG_CONSTRUCTORS
 #  define SANITIZER_DISCARDS						\
 	*(.eh_frame)


