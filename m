Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9B45EA65B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiIZMmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbiIZMmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:42:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214DA4B483;
        Mon, 26 Sep 2022 04:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFC4860C09;
        Mon, 26 Sep 2022 10:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAFDC433C1;
        Mon, 26 Sep 2022 10:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189518;
        bh=2cGH1mAPRTMCE+KtpGsX54UrcUXI3dW1W9qeiEFt52w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O94om6s9V3iDBxUPj8ScmqGIvZNKj29VWhOq4OseqvcrS4yLQJ4vY7VxRrVbpQzmh
         G2bV9cf2ahksJcEsTJ1AC+3VIROg0gQeyb+l5CNc/0GldmysPyOcoj3eTyVOufBZRJ
         KfA/Nr6zZoX6aDXl5uhpxYg7b+ZYSQNZHxMX3uVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Alexandrov <aalexand@google.com>,
        Bill Wendling <morbo@google.com>,
        Greg Thelen <gthelen@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 198/207] Makefile.debug: re-enable debug info for .S files
Date:   Mon, 26 Sep 2022 12:13:07 +0200
Message-Id: <20220926100815.462063478@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 32ef9e5054ec0321b9336058c58ec749e9c6b0fe ]

Alexey reported that the fraction of unknown filename instances in
kallsyms grew from ~0.3% to ~10% recently; Bill and Greg tracked it down
to assembler defined symbols, which regressed as a result of:

commit b8a9092330da ("Kbuild: do not emit debug info for assembly with LLVM_IAS=1")

In that commit, I allude to restoring debug info for assembler defined
symbols in a follow up patch, but it seems I forgot to do so in

commit a66049e2cf0e ("Kbuild: make DWARF version a choice")

Link: https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=31bf18645d98b4d3d7357353be840e320649a67d
Fixes: b8a9092330da ("Kbuild: do not emit debug info for assembly with LLVM_IAS=1")
Reported-by: Alexey Alexandrov <aalexand@google.com>
Reported-by: Bill Wendling <morbo@google.com>
Reported-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug      |  4 +++-
 scripts/Makefile.debug | 21 +++++++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2e24db4bff19..c399ab486557 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -264,8 +264,10 @@ config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
 config DEBUG_INFO_DWARF4
 	bool "Generate DWARF Version 4 debuginfo"
 	select DEBUG_INFO
+	depends on !CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)))
 	help
-	  Generate DWARF v4 debug info. This requires gcc 4.5+ and gdb 7.0+.
+	  Generate DWARF v4 debug info. This requires gcc 4.5+, binutils 2.35.2
+	  if using clang without clang's integrated assembler, and gdb 7.0+.
 
 	  If you have consumers of DWARF debug info that are not ready for
 	  newer revisions of DWARF, you may wish to choose this or have your
diff --git a/scripts/Makefile.debug b/scripts/Makefile.debug
index 26d6a9d97a20..8cf1cb22dd93 100644
--- a/scripts/Makefile.debug
+++ b/scripts/Makefile.debug
@@ -1,18 +1,19 @@
-DEBUG_CFLAGS	:= -g
+DEBUG_CFLAGS	:=
+debug-flags-y	:= -g
 
 ifdef CONFIG_DEBUG_INFO_SPLIT
 DEBUG_CFLAGS	+= -gsplit-dwarf
 endif
 
-ifndef CONFIG_AS_IS_LLVM
-KBUILD_AFLAGS	+= -Wa,-gdwarf-2
-endif
-
-ifndef CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
-dwarf-version-$(CONFIG_DEBUG_INFO_DWARF4) := 4
-dwarf-version-$(CONFIG_DEBUG_INFO_DWARF5) := 5
-DEBUG_CFLAGS	+= -gdwarf-$(dwarf-version-y)
+debug-flags-$(CONFIG_DEBUG_INFO_DWARF4)	+= -gdwarf-4
+debug-flags-$(CONFIG_DEBUG_INFO_DWARF5)	+= -gdwarf-5
+ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_AS_IS_GNU),yy)
+# Clang does not pass -g or -gdwarf-* option down to GAS.
+# Add -Wa, prefix to explicitly specify the flags.
+KBUILD_AFLAGS	+= $(addprefix -Wa$(comma), $(debug-flags-y))
 endif
+DEBUG_CFLAGS	+= $(debug-flags-y)
+KBUILD_AFLAGS	+= $(debug-flags-y)
 
 ifdef CONFIG_DEBUG_INFO_REDUCED
 DEBUG_CFLAGS	+= -fno-var-tracking
@@ -27,5 +28,5 @@ KBUILD_AFLAGS	+= -gz=zlib
 KBUILD_LDFLAGS	+= --compress-debug-sections=zlib
 endif
 
-KBUILD_CFLAGS += $(DEBUG_CFLAGS)
+KBUILD_CFLAGS	+= $(DEBUG_CFLAGS)
 export DEBUG_CFLAGS
-- 
2.35.1



