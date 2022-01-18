Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00767492A36
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346374AbiARQI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243030AbiARQHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:07:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40500C06161C;
        Tue, 18 Jan 2022 08:07:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4B11CE1A3D;
        Tue, 18 Jan 2022 16:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C13C340E0;
        Tue, 18 Jan 2022 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522051;
        bh=rjWTO/p7fIy6qGufrFBgvX7eBrnt5/kirKWfyg1bm4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIfrflV1ZucrOkVecQpc72iMuIgxoUvkMHl9zuDSLCFD48MvQWQmsiCkxOurW0rTA
         HXudLNH+g4dvxCDi5Q7B2wrp5U1O4JyeLSxm2B17DcIePcjTbdPq5lgGMhwHUpO4CK
         IAGrW4F+JQ6U+DUbE+utewe3eJbI61K0SSkpZ6KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Paul Barker <paul.barker@sancloud.com>
Subject: [PATCH 5.10 01/23] kbuild: Add $(KBUILD_HOSTLDFLAGS) to has_libelf test
Date:   Tue, 18 Jan 2022 17:05:41 +0100
Message-Id: <20220118160451.280084496@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
Cc: Paul Barker <paul.barker@sancloud.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1073,7 +1073,7 @@ export mod_sign_cmd
 HOST_LIBELF_LIBS = $(shell pkg-config libelf --libs 2>/dev/null || echo -lelf)
 
 has_libelf = $(call try-run,\
-               echo "int main() {}" | $(HOSTCC) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
+               echo "int main() {}" | $(HOSTCC) $(KBUILD_HOSTLDFLAGS) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
 
 ifdef CONFIG_STACK_VALIDATION
   ifeq ($(has_libelf),1)


