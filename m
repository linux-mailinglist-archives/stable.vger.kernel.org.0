Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150D960400E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiJSJnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiJSJl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42227F6C17;
        Wed, 19 Oct 2022 02:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE03961828;
        Wed, 19 Oct 2022 09:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCF5C433C1;
        Wed, 19 Oct 2022 09:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170980;
        bh=FYipOXVEh/W6XkjRwrcbJtXg1hEM0/kwaTD3dCXorOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVwSZxjA/M7QGu+qmO5WiBthuf9anPVXN6HXmomNDUru6DSlau6lhEt5JRVubWxfW
         g1pdzwsqeVcCsv/TR9RDHglVTs68Py9bcq4JsslMyU9YjjY7X0+Avxgrt58znO222r
         ZqB/fVBbYNptrX16pPkBOrpzHiFZS0W8/+ZmCH00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.0 860/862] Kconfig.debug: simplify the dependency of DEBUG_INFO_DWARF4/5
Date:   Wed, 19 Oct 2022 10:35:47 +0200
Message-Id: <20221019083327.899440801@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 4f001a21080ff2e2f0e1c3692f5e119aedbb3bc1 upstream.

Commit c0a5c81ca9be ("Kconfig.debug: drop GCC 5+ version check for
DWARF5") could have cleaned up the code a bit more.

"CC_IS_CLANG &&" is unneeded. No functional change is intended.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -264,7 +264,7 @@ config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAUL
 config DEBUG_INFO_DWARF4
 	bool "Generate DWARF Version 4 debuginfo"
 	select DEBUG_INFO
-	depends on !CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)))
+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)
 	help
 	  Generate DWARF v4 debug info. This requires gcc 4.5+, binutils 2.35.2
 	  if using clang without clang's integrated assembler, and gdb 7.0+.
@@ -276,7 +276,7 @@ config DEBUG_INFO_DWARF4
 config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
 	select DEBUG_INFO
-	depends on !CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)))
+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
 	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some


