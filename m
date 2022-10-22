Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C8E608A85
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiJVI7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiJVI64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:58:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8479729B8B8;
        Sat, 22 Oct 2022 01:16:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14F2460B83;
        Sat, 22 Oct 2022 08:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0ADC433D6;
        Sat, 22 Oct 2022 08:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426075;
        bh=FYipOXVEh/W6XkjRwrcbJtXg1hEM0/kwaTD3dCXorOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xk+pYHp8qgTxP3p5QGmdaIAU/3CE3pV+4Sk67iDpYlByUFumEHpUKNVMIZudwll42
         GGaGuL41XKLf+JwePuZGcUCDS2BAgL/ValJIu5oDfq+Mv6yzxniSMFWfUBsGEW3IgG
         Jo+Z/44vpgGs3sO5PRAs72Qq3D6MxLVTOOBf7XSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.19 710/717] Kconfig.debug: simplify the dependency of DEBUG_INFO_DWARF4/5
Date:   Sat, 22 Oct 2022 09:29:49 +0200
Message-Id: <20221022072529.869510319@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


