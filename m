Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45D498EA7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbiAXToZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:44:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345396AbiAXTmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:42:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42B7061031;
        Mon, 24 Jan 2022 19:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F61AC340E5;
        Mon, 24 Jan 2022 19:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053342;
        bh=V+le2JyJO4eaQ2u2wi+xJ2j42OxrRL3YiITO6FyFsQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUB8XIQUT7pjBHXwg9O4Kx+RaEv8ohO4uti8S/HOHt46KVsniVxITrqsERRYfxiz8
         gHndP1l51YLzHfX5BtHGOj7ndX9aqfA2GLlZCt5t46iwT3DtcMrIohvpmbXMg8fDIB
         zufZmb5FcgfCbUE3FZe28wgxuyvyMOGFTmKKKPQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 5.10 032/563] lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()
Date:   Mon, 24 Jan 2022 19:36:37 +0100
Message-Id: <20220124184025.541909855@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit bc93a22a19eb2b68a16ecf04cdf4b2ed65aaf398 upstream.

On a kernel without CONFIG_STRICT_KERNEL_RWX, running EXEC_RODATA
test leads to "Illegal instruction" failure.

Looking at the content of rodata_objcopy.o, we see that the
function content zeroes only:

	Disassembly of section .rodata:

	0000000000000000 <.lkdtm_rodata_do_nothing>:
	   0:	00 00 00 00 	.long 0x0

Add the contents flag in order to keep the content of the section
while renaming it.

	Disassembly of section .rodata:

	0000000000000000 <.lkdtm_rodata_do_nothing>:
	   0:	4e 80 00 20 	blr

Fixes: e9e08a07385e ("lkdtm: support llvm-objcopy")
Cc: stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/8900731fbc05fb8b0de18af7133a8fc07c3c53a1.1633712176.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/lkdtm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -16,7 +16,7 @@ KCOV_INSTRUMENT_rodata.o	:= n
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-			--rename-section .noinstr.text=.rodata,alloc,readonly,load
+			--rename-section .noinstr.text=.rodata,alloc,readonly,load,contents
 targets += rodata.o rodata_objcopy.o
 $(obj)/rodata_objcopy.o: $(obj)/rodata.o FORCE
 	$(call if_changed,objcopy)


