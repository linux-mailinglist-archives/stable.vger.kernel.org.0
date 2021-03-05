Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A9832EA4E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhCEMhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233295AbhCEMh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:37:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C79CC64FF0;
        Fri,  5 Mar 2021 12:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947848;
        bh=REp7H5p8IRHVqCJCTfbqYcUv2c+CstGSyLCle3paWm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7Df47diid+ZXWQMSjXUaxPH06YLSXDmlcy+2PFEVjPM1Z/1XGkTKM8d8xVXj2XCJ
         e7UIAEH62AoSYgp8ukjcVz6xS2sBawVIKNM+vGC2gKjMlcP0GtPBsghwRgnPpehTtK
         2IYYgIzRCd0bL86uCzpwzJUossQgBHjhU4CCHwSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.19 09/52] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out --target=
Date:   Fri,  5 Mar 2021 13:21:40 +0100
Message-Id: <20210305120854.117213156@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 76d7fff22be3e4185ee5f9da2eecbd8188e76b2c upstream.

Commit ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO
cflags") allowed the '--target=' flag from the main Makefile to filter
through to the vDSO. However, it did not bring any of the other clang
specific flags for controlling the integrated assembler and the GNU
tools locations (--prefix=, --gcc-toolchain=, and -no-integrated-as).
Without these, we will get a warning (visible with tinyconfig):

arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per
compilation unit
.pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long
4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
^
arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per
compilation unit
 .section .mips_abiflags, "a"
 ^

All of these flags are bundled up under CLANG_FLAGS in the main Makefile
and exported so that they can be added to Makefiles that set their own
CFLAGS. Use this value instead of filtering out '--target=' so there is
no warning and all of the tools are properly used.

Cc: stable@vger.kernel.org
Fixes: ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
Link: https://github.com/ClangBuiltLinux/linux/issues/1256
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
[nc: Fix conflict due to lack of 99570c3da96a and 076f421da5d4 in 4.19]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/vdso/Makefile |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -10,12 +10,9 @@ ccflags-vdso := \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
 	$(filter -m%-float,$(KBUILD_CFLAGS)) \
 	$(filter -mno-loongson-%,$(KBUILD_CFLAGS)) \
+	$(CLANG_FLAGS) \
 	-D__VDSO__
 
-ifeq ($(cc-name),clang)
-ccflags-vdso += $(filter --target=%,$(KBUILD_CFLAGS))
-endif
-
 cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
 	-O2 -g -fPIC -fno-strict-aliasing -fno-common -fno-builtin -G 0 \


