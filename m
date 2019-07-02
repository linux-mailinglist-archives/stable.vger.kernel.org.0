Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7AB5CBA0
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfGBIOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfGBIFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B68321841;
        Tue,  2 Jul 2019 08:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054742;
        bh=UHj+reTeQRaOFAHNyvjjTOieOnvPAd53doWoMIt3ixE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxwORs356FDiGVF0JtNDdDj93Dyd3ax/qdbQ2qD+TPkE9VSMk6+PZToydHqGnY0CZ
         u9kvZa6Ppvr8fQixgYbosvonRhngWBLrt0wCkgWGJ5wrhE2fgtAWWPEfFxDocNu3Nr
         FAbKu95jJ6+gQc4LG1PlXCpJUH3wedqyVNSESZw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Dave Martin <Dave.Martin@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.19 04/72] arm64: Dont unconditionally add -Wno-psabi to KBUILD_CFLAGS
Date:   Tue,  2 Jul 2019 10:01:05 +0200
Message-Id: <20190702080124.797142876@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit fa63da2ab046b885a7f70291aafc4e8ce015429b upstream.

This is a GCC only option, which warns about ABI changes within GCC, so
unconditionally adding it breaks Clang with tons of:

warning: unknown warning option '-Wno-psabi' [-Wunknown-warning-option]

and link time failures:

ld.lld: error: undefined symbol: __efistub___stack_chk_guard
>>> referenced by arm-stub.c:73
(/home/nathan/cbl/linux/drivers/firmware/efi/libstub/arm-stub.c:73)
>>>               arm-stub.stub.o:(__efistub_install_memreserve_table)
in archive ./drivers/firmware/efi/libstub/lib.a

These failures come from the lack of -fno-stack-protector, which is
added via cc-option in drivers/firmware/efi/libstub/Makefile. When an
unknown flag is added to KBUILD_CFLAGS, clang will noisily warn that it
is ignoring the option like above, unlike gcc, who will just error.

$ echo "int main() { return 0; }" > tmp.c

$ clang -Wno-psabi tmp.c; echo $?
warning: unknown warning option '-Wno-psabi' [-Wunknown-warning-option]
1 warning generated.
0

$ gcc -Wsometimes-uninitialized tmp.c; echo $?
gcc: error: unrecognized command line option
‘-Wsometimes-uninitialized’; did you mean ‘-Wmaybe-uninitialized’?
1

For cc-option to work properly with clang and behave like gcc, -Werror
is needed, which was done in commit c3f0d0bc5b01 ("kbuild, LLVMLinux:
Add -Werror to cc-option to support clang").

$ clang -Werror -Wno-psabi tmp.c; echo $?
error: unknown warning option '-Wno-psabi'
[-Werror,-Wunknown-warning-option]
1

As a consequence of this, when an unknown flag is unconditionally added
to KBUILD_CFLAGS, it will cause cc-option to always fail and those flags
will never get added:

$ clang -Werror -Wno-psabi -fno-stack-protector tmp.c; echo $?
error: unknown warning option '-Wno-psabi'
[-Werror,-Wunknown-warning-option]
1

This can be seen when compiling the whole kernel as some warnings that
are normally disabled (see below) show up. The full list of flags
missing from drivers/firmware/efi/libstub are the following (gathered
from diffing .arm64-stub.o.cmd):

-fno-delete-null-pointer-checks
-Wno-address-of-packed-member
-Wframe-larger-than=2048
-Wno-unused-const-variable
-fno-strict-overflow
-fno-merge-all-constants
-fno-stack-check
-Werror=date-time
-Werror=incompatible-pointer-types
-ffreestanding
-fno-stack-protector

Use cc-disable-warning so that it gets disabled for GCC and does nothing
for Clang.

Fixes: ebcc5928c5d9 ("arm64: Silence gcc warnings about arch ABI drift")
Link: https://github.com/ClangBuiltLinux/linux/issues/511
Reported-by: Qian Cai <cai@lca.pw>
Acked-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -51,7 +51,7 @@ endif
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst)
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
-KBUILD_CFLAGS	+= -Wno-psabi
+KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst)
 
 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)


