Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7335778833
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 11:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfG2JU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 05:20:27 -0400
Received: from condef-04.nifty.com ([202.248.20.69]:39064 "EHLO
        condef-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfG2JU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 05:20:26 -0400
Received: from conuserg-10.nifty.com ([10.126.8.73])by condef-04.nifty.com with ESMTP id x6T9GUUA007533
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 18:16:30 +0900
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x6T9FQFU007006;
        Mon, 29 Jul 2019 18:15:26 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x6T9FQFU007006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564391727;
        bh=16VOGPWZt50QIHw/yZwbKWLNAnF5eIhm7sbfTUqTMxA=;
        h=From:To:Cc:Subject:Date:From;
        b=u/TOvPqsajpOhFpabeQCcu9qwyoIyMmujb5rMmt9gB0Wd+b+HQleb4MRmthDq5rGL
         9MJfl3XWc796KP5LciGQTI0lDcDnuMBMCX0hsvK0G33oq5rGnxkOD7DAHhd9cWviI9
         R9otBuj5iDdjHfKzzE/Ll53q0VQ01ujIpNhDDyiJWbd8s8go7BT3YWNKG4LITpsIJG
         /y0WY7HleQol3+W8Zu8r85nJofkrjLEvbnTcF/AOyQj/4A+vRYHv+vkT/Xgql+b/ky
         HfQSevJduCNBLGpsqSuKkt9pUACuU3kTG5QH9i1CZUjx3DuXo7onZNdSRE6GVSfoYT
         zmkzFARkmZQkQ==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        stable@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: initialize CLANG_FLAGS correctly in the top Makefile
Date:   Mon, 29 Jul 2019 18:15:17 +0900
Message-Id: <20190729091517.5334-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CLANG_FLAGS is initialized by the following line:

  CLANG_FLAGS     := --target=$(notdir $(CROSS_COMPILE:%-=%))

..., which is run only when CROSS_COMPILE is set.

Some build targets (bindeb-pkg etc.) recurse to the top Makefile.

When you build the kernel with Clang but without CROSS_COMPILE,
the same compiler flags such as -no-integrated-as are accumulated
into CLANG_FLAGS.

If you run 'make CC=clang' and then 'make CC=clang bindeb-pkg',
Kbuild will recompile everything needlessly due to the build command
change.

Fix this by correctly initializing CLANG_FLAGS.

Fixes: 238bcbc4e07f ("kbuild: consolidate Clang compiler flags")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index fa0fbe7851ea..5ee6f6889869 100644
--- a/Makefile
+++ b/Makefile
@@ -472,6 +472,7 @@ KBUILD_CFLAGS_MODULE  := -DMODULE
 KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
 KBUILD_LDFLAGS :=
 GCC_PLUGINS_CFLAGS :=
+CLANG_FLAGS :=
 
 export ARCH SRCARCH CONFIG_SHELL HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP PAHOLE KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS
@@ -519,7 +520,7 @@ endif
 
 ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
 ifneq ($(CROSS_COMPILE),)
-CLANG_FLAGS	:= --target=$(notdir $(CROSS_COMPILE:%-=%))
+CLANG_FLAGS	+= --target=$(notdir $(CROSS_COMPILE:%-=%))
 GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
 CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)
 GCC_TOOLCHAIN	:= $(realpath $(GCC_TOOLCHAIN_DIR)/..)
-- 
2.17.1

