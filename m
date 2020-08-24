Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4348724F92D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgHXJmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbgHXIoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:44:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E57382075B;
        Mon, 24 Aug 2020 08:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258694;
        bh=Z9lKzba1BAVgIqYEc7h0WsfNDzOkK9y1hwS3TfHMqKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJ000ManXxChTzQZgytvbOjs5PSqftfxAmmSThN0I7Ce5alHJNPaIl+dLzmzt8sKr
         TrtdVfX58/sBL2074y+0xm+vgIqHZeTmm13vSry5t32nR8yJn60FTuWN1aYBT29m68
         i4yBRSUzcIW9nHRhm/NSg3ZxQmeSRLz9wh3fdTis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 005/107] x86/boot: kbuild: allow readelf executable to be specified
Date:   Mon, 24 Aug 2020 10:29:31 +0200
Message-Id: <20200824082405.298221904@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                          |    3 ++-
 arch/x86/boot/compressed/Makefile |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -414,6 +414,7 @@ STRIP		= $(CROSS_COMPILE)strip
 OBJCOPY		= $(CROSS_COMPILE)objcopy
 OBJDUMP		= $(CROSS_COMPILE)objdump
 OBJSIZE		= $(CROSS_COMPILE)size
+READELF		= $(CROSS_COMPILE)readelf
 PAHOLE		= pahole
 LEX		= flex
 YACC		= bison
@@ -472,7 +473,7 @@ GCC_PLUGINS_CFLAGS :=
 CLANG_FLAGS :=
 
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE PAHOLE LEX YACC AWK INSTALLKERNEL
+export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON PYTHON2 PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
 export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
 
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


