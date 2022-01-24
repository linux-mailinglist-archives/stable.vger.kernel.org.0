Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9C849A03F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843570AbiAXXE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382512AbiAXW4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:56:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65E7C055AA1;
        Mon, 24 Jan 2022 13:10:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73AD76141C;
        Mon, 24 Jan 2022 21:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F88FC340E5;
        Mon, 24 Jan 2022 21:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058639;
        bh=3brKqyaqybEcUH8yC/phuL2yfofUBG/ciXNRmRgItE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCBbpwPRLDpBeKMxZ+FAAPXw5/nvqvoXOut4iPIs+9v2lfbs1NUdSthNAzm4R+efT
         fdhAhXrF5jNH/nyYH434jIfSHs5I3uKZrJ1Tg5vzC1zAtk0N2QVps9vdWYAmFkq0N6
         n/Mlq5Xwb8mm5+ffWUIm4Lad8+FWmth0MyNaTAvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0354/1039] x86/boot/compressed: Move CLANG_FLAGS to beginning of KBUILD_CFLAGS
Date:   Mon, 24 Jan 2022 19:35:43 +0100
Message-Id: <20220124184137.179404474@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 5fe392ff9d1f7254a1fbb3f72d9893088e4d23eb ]

When cross compiling i386_defconfig on an arm64 host with clang, there
are a few instances of '-Waddress-of-packed-member' and
'-Wgnu-variable-sized-type-not-at-end' in arch/x86/boot/compressed/,
which should both be disabled with the cc-disable-warning calls in that
directory's Makefile, which indicates that cc-disable-warning is failing
at the point of testing these flags.

The cc-disable-warning calls fail because at the point that the flags
are tested, KBUILD_CFLAGS has '-march=i386' without $(CLANG_FLAGS),
which has the '--target=' flag to tell clang what architecture it is
targeting. Without the '--target=' flag, the host architecture (arm64)
is used and i386 is not a valid value for '-march=' in that case. This
error can be seen by adding some logging to try-run:

  clang-14: error: the clang compiler does not support '-march=i386'

Invoking the compiler has to succeed prior to calling cc-option or
cc-disable-warning in order to accurately test whether or not the flag
is supported; if it doesn't, the requested flag can never be added to
the compiler flags. Move $(CLANG_FLAGS) to the beginning of KBUILD_FLAGS
so that any new flags that might be added in the future can be
accurately tested.

Fixes: d5cbd80e302d ("x86/boot: Add $(CLANG_FLAGS) to compressed KBUILD_CFLAGS")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211222163040.1961481-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 431bf7f846c3c..e118136460518 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -28,7 +28,11 @@ KCOV_INSTRUMENT		:= n
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
 	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4 vmlinux.bin.zst
 
-KBUILD_CFLAGS := -m$(BITS) -O2
+# CLANG_FLAGS must come before any cc-disable-warning or cc-option calls in
+# case of cross compiling, as it has the '--target=' flag, which is needed to
+# avoid errors with '-march=i386', and future flags may depend on the target to
+# be valid.
+KBUILD_CFLAGS := -m$(BITS) -O2 $(CLANG_FLAGS)
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIE
 KBUILD_CFLAGS += -Wundef
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
@@ -47,7 +51,6 @@ KBUILD_CFLAGS += -D__DISABLE_EXPORTS
 # Disable relocation relaxation in case the link is not PIE.
 KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 KBUILD_CFLAGS += -include $(srctree)/include/linux/hidden.h
-KBUILD_CFLAGS += $(CLANG_FLAGS)
 
 # sev.c indirectly inludes inat-table.h which is generated during
 # compilation and stored in $(objtree). Add the directory to the includes so
-- 
2.34.1



