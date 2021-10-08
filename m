Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B1C426F4E
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 18:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhJHRBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 13:01:13 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:38355 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhJHRBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 13:01:13 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HQvYJ1W05z9sSf;
        Fri,  8 Oct 2021 18:59:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7suNWJT6mezi; Fri,  8 Oct 2021 18:59:16 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HQvYJ0N2gz9sST;
        Fri,  8 Oct 2021 18:59:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E46BB8B780;
        Fri,  8 Oct 2021 18:59:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id IiSHFEJI4zlE; Fri,  8 Oct 2021 18:59:15 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.75])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 996268B763;
        Fri,  8 Oct 2021 18:59:15 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1) with ESMTPS id 198Gwtpf1171169
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 8 Oct 2021 18:58:55 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1/Submit) id 198Gws7t1171165;
        Fri, 8 Oct 2021 18:58:54 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()
Date:   Fri,  8 Oct 2021 18:58:40 +0200
Message-Id: <8900731fbc05fb8b0de18af7133a8fc07c3c53a1.1633712176.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/misc/lkdtm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index aa12097668d3..e2984ce51fe4 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -20,7 +20,7 @@ CFLAGS_REMOVE_rodata.o		+= $(CC_FLAGS_LTO)
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-			--rename-section .noinstr.text=.rodata,alloc,readonly,load
+			--rename-section .noinstr.text=.rodata,alloc,readonly,load,contents
 targets += rodata.o rodata_objcopy.o
 $(obj)/rodata_objcopy.o: $(obj)/rodata.o FORCE
 	$(call if_changed,objcopy)
-- 
2.31.1

