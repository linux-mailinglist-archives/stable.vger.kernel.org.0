Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52FD27886F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgIYMyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbgIYMyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34B221741;
        Fri, 25 Sep 2020 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038472;
        bh=U3GYSQG903DEutQhFu1KXFAMg8Yr6ryWP+xTFhHoWSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNzkJFPSAEKJGR/Wm61rNzwqj89aBHv9As30OoiXKgSDbW7I1ebgox2NZLxT2a7Z2
         uBr/073a+KkN60m7UQD6IbfzGYewWxXhSr8L9CuP2jNzB+KWHDLsLhDGWbE22b6qDj
         Bms9oDEEBiNFOfLl3R0TqMa1MR/AIIUgGawjdhbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 30/37] x86/boot: kbuild: allow readelf executable to be specified
Date:   Fri, 25 Sep 2020 14:48:58 +0200
Message-Id: <20200925124725.495192875@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Golovin <dima@golovin.in>

commit eefb8c124fd969e9a174ff2bedff86aa305a7438 upstream.

Introduce a new READELF variable to top-level Makefile, so the name of
readelf binary can be specified.

Before this change the name of the binary was hardcoded to
"$(CROSS_COMPILE)readelf" which might not be present for every
toolchain.

This allows to build with LLVM Object Reader by using make parameter
READELF=llvm-readelf.

Link: https://github.com/ClangBuiltLinux/linux/issues/771
Signed-off-by: Dmitry Golovin <dima@golovin.in>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
[nd: conflict in exported vars list from not backporting commit
 e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                          |    3 ++-
 arch/x86/boot/compressed/Makefile |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -378,6 +378,7 @@ STRIP		= $(CROSS_COMPILE)strip
 OBJCOPY		= $(CROSS_COMPILE)objcopy
 OBJDUMP		= $(CROSS_COMPILE)objdump
 OBJSIZE		= $(CROSS_COMPILE)size
+READELF		= $(CROSS_COMPILE)readelf
 LEX		= flex
 YACC		= bison
 AWK		= awk
@@ -434,7 +435,7 @@ GCC_PLUGINS_CFLAGS :=
 CLANG_FLAGS :=
 
 export ARCH SRCARCH CONFIG_SHELL HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS
+export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS
 export MAKE LEX YACC AWK GENKSYMS INSTALLKERNEL PERL PYTHON PYTHON2 PYTHON3 UTS_MACHINE
 export HOSTCXX KBUILD_HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -102,7 +102,7 @@ vmlinux-objs-$(CONFIG_EFI_MIXED) += $(ob
 quiet_cmd_check_data_rel = DATAREL $@
 define cmd_check_data_rel
 	for obj in $(filter %.o,$^); do \
-		${CROSS_COMPILE}readelf -S $$obj | grep -qF .rel.local && { \
+		$(READELF) -S $$obj | grep -qF .rel.local && { \
 			echo "error: $$obj has data relocations!" >&2; \
 			exit 1; \
 		} || true; \


