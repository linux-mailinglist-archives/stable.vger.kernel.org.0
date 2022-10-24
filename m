Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF91960A857
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbiJXNFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiJXNDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:03:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7562111821;
        Mon, 24 Oct 2022 05:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF4FF61291;
        Mon, 24 Oct 2022 12:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25AFC433C1;
        Mon, 24 Oct 2022 12:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613971;
        bh=D4hibD4zy0sXG40th7Pdzjhko9OObAeTXdWrhJZa2ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDQqV9s9UDrGJ7wfnbj2LEjgQxRWd239Z/W7/Vydf65avNTnG0jjUgP/96VQPsvKM
         Q2r7s2mNfzA6Vwoq47WJJBvha/KdEpFv6Nc+OpCmcPd/7vKd5xBq+Nc+Xla5bfdd4J
         ECOyEn8yrIzOboeeDA6pk9RfDuEi6Gvgg2E4AoyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, glider@google.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-security-module@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 5.10 053/390] hardening: Clarify Kconfig text for auto-var-init
Date:   Mon, 24 Oct 2022 13:27:30 +0200
Message-Id: <20221024113024.895215368@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit dcb7c0b9461c2a30f6616262736daac6f01ecb09 upstream.

Clarify the details around the automatic variable initialization modes
available. Specifically this details the values used for pattern init
and expands on the rationale for zero init safety. Additionally makes
zero init the default when available.

Cc: glider@google.com
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: linux-security-module@vger.kernel.org
Cc: clang-built-linux@googlegroups.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/Kconfig.hardening |   52 +++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 20 deletions(-)

--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -29,6 +29,7 @@ choice
 	prompt "Initialize kernel stack variables at function entry"
 	default GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if COMPILE_TEST && GCC_PLUGINS
 	default INIT_STACK_ALL_PATTERN if COMPILE_TEST && CC_HAS_AUTO_VAR_INIT_PATTERN
+	default INIT_STACK_ALL_ZERO if CC_HAS_AUTO_VAR_INIT_PATTERN
 	default INIT_STACK_NONE
 	help
 	  This option enables initialization of stack variables at
@@ -39,11 +40,11 @@ choice
 	  syscalls.
 
 	  This chooses the level of coverage over classes of potentially
-	  uninitialized variables. The selected class will be
+	  uninitialized variables. The selected class of variable will be
 	  initialized before use in a function.
 
 	config INIT_STACK_NONE
-		bool "no automatic initialization (weakest)"
+		bool "no automatic stack variable initialization (weakest)"
 		help
 		  Disable automatic stack variable initialization.
 		  This leaves the kernel vulnerable to the standard
@@ -80,7 +81,7 @@ choice
 		  and is disallowed.
 
 	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
-		bool "zero-init anything passed by reference (very strong)"
+		bool "zero-init everything passed by reference (very strong)"
 		depends on GCC_PLUGINS
 		depends on !(KASAN && KASAN_STACK=1)
 		select GCC_PLUGIN_STRUCTLEAK
@@ -91,33 +92,44 @@ choice
 		  of uninitialized stack variable exploits and information
 		  exposures.
 
+		  As a side-effect, this keeps a lot of variables on the
+		  stack that can otherwise be optimized out, so combining
+		  this with CONFIG_KASAN_STACK can lead to a stack overflow
+		  and is disallowed.
+
 	config INIT_STACK_ALL_PATTERN
-		bool "0xAA-init everything on the stack (strongest)"
+		bool "pattern-init everything (strongest)"
 		depends on CC_HAS_AUTO_VAR_INIT_PATTERN
 		help
-		  Initializes everything on the stack with a 0xAA
-		  pattern. This is intended to eliminate all classes
-		  of uninitialized stack variable exploits and information
-		  exposures, even variables that were warned to have been
-		  left uninitialized.
+		  Initializes everything on the stack (including padding)
+		  with a specific debug value. This is intended to eliminate
+		  all classes of uninitialized stack variable exploits and
+		  information exposures, even variables that were warned about
+		  having been left uninitialized.
 
 		  Pattern initialization is known to provoke many existing bugs
 		  related to uninitialized locals, e.g. pointers receive
-		  non-NULL values, buffer sizes and indices are very big.
+		  non-NULL values, buffer sizes and indices are very big. The
+		  pattern is situation-specific; Clang on 64-bit uses 0xAA
+		  repeating for all types and padding except float and double
+		  which use 0xFF repeating (-NaN). Clang on 32-bit uses 0xFF
+		  repeating for all types and padding.
 
 	config INIT_STACK_ALL_ZERO
-		bool "zero-init everything on the stack (strongest and safest)"
+		bool "zero-init everything (strongest and safest)"
 		depends on CC_HAS_AUTO_VAR_INIT_ZERO
 		help
-		  Initializes everything on the stack with a zero
-		  value. This is intended to eliminate all classes
-		  of uninitialized stack variable exploits and information
-		  exposures, even variables that were warned to have been
-		  left uninitialized.
-
-		  Zero initialization provides safe defaults for strings,
-		  pointers, indices and sizes, and is therefore
-		  more suitable as a security mitigation measure.
+		  Initializes everything on the stack (including padding)
+		  with a zero value. This is intended to eliminate all
+		  classes of uninitialized stack variable exploits and
+		  information exposures, even variables that were warned
+		  about having been left uninitialized.
+
+		  Zero initialization provides safe defaults for strings
+		  (immediately NUL-terminated), pointers (NULL), indices
+		  (index 0), and sizes (0 length), so it is therefore more
+		  suitable as a production security mitigation than pattern
+		  initialization.
 
 endchoice
 


