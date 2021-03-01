Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0527C329136
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhCAUWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236542AbhCAUNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC0B56507E;
        Mon,  1 Mar 2021 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621679;
        bh=Qj6SvHx4Z1EeQh+3XarPAeOQ/tPaEbqStbueKupEZG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcf2FuXHJZPi6+FQRdarHSyOREzoAJ0IjBIiQWoMfEodiiP1HEAhzJeusGnw/Grck
         HuVYjJ9dfpVYzttw0y5RNKk7hPNZnIEcGE6f2aEtd/U7dCqoC5kFEsV8YYlXhmZKQM
         3iKJw27F+t5j33ssZnHFjVkxtkiZiv02IMPJt+08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.11 605/775] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out --target=
Date:   Mon,  1 Mar 2021 17:12:53 +0100
Message-Id: <20210301161231.311147718@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/vdso/Makefile |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -16,16 +16,13 @@ ccflags-vdso := \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
 	$(filter -m%-float,$(KBUILD_CFLAGS)) \
 	$(filter -mno-loongson-%,$(KBUILD_CFLAGS)) \
+	$(CLANG_FLAGS) \
 	-D__VDSO__
 
 ifndef CONFIG_64BIT
 ccflags-vdso += -DBUILD_VDSO32
 endif
 
-ifdef CONFIG_CC_IS_CLANG
-ccflags-vdso += $(filter --target=%,$(KBUILD_CFLAGS))
-endif
-
 #
 # The -fno-jump-tables flag only prevents the compiler from generating
 # jump tables but does not prevent the compiler from emitting absolute


