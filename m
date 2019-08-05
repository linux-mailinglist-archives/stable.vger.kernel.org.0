Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFC881B28
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfHENMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729415AbfHENKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:10:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F23020880;
        Mon,  5 Aug 2019 13:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010629;
        bh=Xk2akffglzIX5CNolDYB5446ub7rD9dozs1DN9GnEnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9thxZOvHNqOcR+II/ir5NdUIi1MJebunjHW4eFvZQGEL5RhAXmk/fPsSgq5nESiQ
         vS4yw8nu2cwYwYbMwNz+iUwgOcrsv8hFGvkgpT5Pg0R/RL7Ousgnr2fMmb7f0UDNtB
         mhMKevo0g4OWebCPiMo9V0JBMNWekH65+Bl3hc3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 43/74] kbuild: initialize CLANG_FLAGS correctly in the top Makefile
Date:   Mon,  5 Aug 2019 15:02:56 +0200
Message-Id: <20190805124939.358044329@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 5241ab4cf42d3a93b933b55d3d53f43049081fa1 upstream.

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
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -430,6 +430,7 @@ KBUILD_CFLAGS_MODULE  := -DMODULE
 KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
 KBUILD_LDFLAGS :=
 GCC_PLUGINS_CFLAGS :=
+CLANG_FLAGS :=
 
 export ARCH SRCARCH CONFIG_SHELL HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS
@@ -482,7 +483,7 @@ endif
 
 ifeq ($(cc-name),clang)
 ifneq ($(CROSS_COMPILE),)
-CLANG_FLAGS	:= --target=$(notdir $(CROSS_COMPILE:%-=%))
+CLANG_FLAGS	+= --target=$(notdir $(CROSS_COMPILE:%-=%))
 GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
 CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)
 GCC_TOOLCHAIN	:= $(realpath $(GCC_TOOLCHAIN_DIR)/..)


