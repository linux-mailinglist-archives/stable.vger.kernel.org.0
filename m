Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01207498B9E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344550AbiAXTPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:15:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42248 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346348AbiAXTMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:12:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1221611A9;
        Mon, 24 Jan 2022 19:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FE2C340E5;
        Mon, 24 Jan 2022 19:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051555;
        bh=7MC46cqVCemBIVTmpcjdimelq3KvYsWQumf2TrlMETo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIv0oRvv+6nOyegDsecpJeOfQnpFJlxjDmgR86qGzivKyiUeKNHSxmdqd84kU8DbT
         gg4mQ7SzJUII0LvjdKDXJmosU/zXAZaZ2yx3m5+bsztFIWmGg/th8DL4rgbQi4g0+Z
         I+qcrWUdtgO2MwXlBOn1qgOLWkW4AV6uuphR+S1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Paul Barker <paul.barker@sancloud.com>
Subject: [PATCH 4.19 013/239] kbuild: Add $(KBUILD_HOSTLDFLAGS) to has_libelf test
Date:   Mon, 24 Jan 2022 19:40:51 +0100
Message-Id: <20220124183943.538536958@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit f634ca650f724347892068489c7920631a3aac6a upstream.

Normally, invocations of $(HOSTCC) include $(KBUILD_HOSTLDFLAGS), which
in turn includes $(HOSTLDFLAGS), which allows users to pass in their own
flags when linking. However, the 'has_libelf' test does not, meaning
that if a user requests a specific linker via HOSTLDFLAGS=-fuse-ld=...,
it is not respected and the build might error.

For example, if a user building with clang wants to use all of the LLVM
tools without any GNU tools, they might remove all of the GNU tools from
their system or PATH then build with

$ make HOSTLDFLAGS=-fuse-ld=lld LLVM=1 LLVM_IAS=1

which says use all of the LLVM tools, the integrated assembler, and
ld.lld for linking host executables. Without this change, the build will
error because $(HOSTCC) uses its default linker, rather than the one
requested via -fuse-ld=..., which is GNU ld in clang's case in a default
configuration.

error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please
install libelf-dev, libelf-devel or elfutils-libelf-devel
make[1]: *** [Makefile:1260: prepare-objtool] Error 1

Add $(KBUILD_HOSTLDFLAGS) to the 'has_libelf' test so that the linker
choice is respected.

Link: https://github.com/ClangBuiltLinux/linux/issues/479
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Paul Barker <paul.barker@sancloud.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -972,7 +972,7 @@ HOST_LIBELF_LIBS = $(shell pkg-config li
 
 ifdef CONFIG_STACK_VALIDATION
   has_libelf := $(call try-run,\
-		echo "int main() {}" | $(HOSTCC) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
+		echo "int main() {}" | $(HOSTCC) $(KBUILD_HOSTLDFLAGS) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
   ifeq ($(has_libelf),1)
     objtool_target := tools/objtool FORCE
   else


