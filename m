Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63784526478
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381011AbiEMObv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381194AbiEMObJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AF919C3BD;
        Fri, 13 May 2022 07:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 190F662175;
        Fri, 13 May 2022 14:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF23AC34100;
        Fri, 13 May 2022 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452121;
        bh=rOu789wVzOD6bYsiCxLndfe4675ny745B3rwyw6CJXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/kVPwLxHnVYHJolDTHTHgAdl/Bz3Bi3K8HdxX/uB358M4qjU+PEtEj/bUxRBGRJN
         1fEN7b/WSXx0lHfSAVsRaSMGLCxaibd7u0xhZQiMlfUDEME+0Gy4uar6gVsffhYzzq
         o3nCr8XwI+cfr+z7MAj5awicqS45+Z8afYxvLjR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/21] kbuild: move objtool_args back to scripts/Makefile.build
Date:   Fri, 13 May 2022 16:23:48 +0200
Message-Id: <20220513142230.062663025@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 8f0c32c788fffa8e88f995372415864039347c8a ]

Commit b1a1a1a09b46 ("kbuild: lto: postpone objtool") moved objtool_args
to Makefile.lib, so the arguments can be used in Makefile.modfinal as
well as Makefile.build.

With commit 850ded46c642 ("kbuild: Fix TRIM_UNUSED_KSYMS with
LTO_CLANG"), module LTO linking came back to scripts/Makefile.build
again.

So, there is no more reason to keep objtool_args in a separate file.

Get it back to the original place, close to the objtool command.

Remove the stale comment too.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.build |   10 ++++++++++
 scripts/Makefile.lib   |   11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -224,6 +224,16 @@ cmd_record_mcount = $(if $(findstring $(
 endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
 
 ifdef CONFIG_STACK_VALIDATION
+
+objtool_args =								\
+	$(if $(CONFIG_UNWINDER_ORC),orc generate,check)			\
+	$(if $(part-of-module), --module)				\
+	$(if $(CONFIG_FRAME_POINTER),, --no-fp)				\
+	$(if $(CONFIG_GCOV_KERNEL)$(CONFIG_LTO_CLANG), --no-unreachable)\
+	$(if $(CONFIG_RETPOLINE), --retpoline)				\
+	$(if $(CONFIG_X86_SMAP), --uaccess)				\
+	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)
+
 ifndef CONFIG_LTO_CLANG
 
 __objtool_obj := $(objtree)/tools/objtool/objtool
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -232,17 +232,6 @@ ifeq ($(CONFIG_LTO_CLANG),y)
 mod-prelink-ext := .lto
 endif
 
-# Objtool arguments are also needed for modfinal with LTO, so we define
-# then here to avoid duplication.
-objtool_args =								\
-	$(if $(CONFIG_UNWINDER_ORC),orc generate,check)			\
-	$(if $(part-of-module), --module)				\
-	$(if $(CONFIG_FRAME_POINTER),, --no-fp)				\
-	$(if $(CONFIG_GCOV_KERNEL)$(CONFIG_LTO_CLANG), --no-unreachable)\
-	$(if $(CONFIG_RETPOLINE), --retpoline)				\
-	$(if $(CONFIG_X86_SMAP), --uaccess)				\
-	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)
-
 # Useful for describing the dependency of composite objects
 # Usage:
 #   $(call multi_depend, multi_used_targets, suffix_to_remove, suffix_to_add)


