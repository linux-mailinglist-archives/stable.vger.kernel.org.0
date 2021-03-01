Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C15328E0A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241446AbhCATWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241337AbhCATRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A93C464FE9;
        Mon,  1 Mar 2021 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618100;
        bh=8zqo6lmPKPKvU0lpGG+8sKgpiGrwcJ7fbjRbcPJuWIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDvaIjpRtHTauTGnDCi1KelR1nA7DAAzpBInbukkxdTFWyPOfkedhW5K6eMsvg9/X
         9Ur+Wp6nWufpeyv+FypyyFrT94l6fGi+MHUBSYrdDu/QHl9KsxxA//FbSQDEyiQysX
         HcTWqIDuk+hWqQV+ekZqzFs++nCx8ZmdCSYsEUQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Fangrui Song <maskray@google.com>, Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 307/340] module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for undefined symbols
Date:   Mon,  1 Mar 2021 17:14:11 +0100
Message-Id: <20210301161103.392423857@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

commit ebfac7b778fac8b0e8e92ec91d0b055f046b4604 upstream.

clang-12 -fno-pic (since
https://github.com/llvm/llvm-project/commit/a084c0388e2a59b9556f2de0083333232da3f1d6)
can emit `call __stack_chk_fail@PLT` instead of `call __stack_chk_fail`
on x86.  The two forms should have identical behaviors on x86-64 but the
former causes GNU as<2.37 to produce an unreferenced undefined symbol
_GLOBAL_OFFSET_TABLE_.

(On x86-32, there is an R_386_PC32 vs R_386_PLT32 difference but the
linker behavior is identical as far as Linux kernel is concerned.)

Simply ignore _GLOBAL_OFFSET_TABLE_ for now, like what
scripts/mod/modpost.c:ignore_undef_symbol does. This also fixes the
problem for gcc/clang -fpie and -fpic, which may emit `call foo@PLT` for
external function calls on x86.

Note: ld -z defs and dynamic loaders do not error for unreferenced
undefined symbols so the module loader is reading too much.  If we ever
need to ignore more symbols, the code should be refactored to ignore
unreferenced symbols.

Cc: <stable@vger.kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1250
Link: https://sourceware.org/bugzilla/show_bug.cgi?id=27178
Reported-by: Marco Elver <elver@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Marco Elver <elver@google.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2310,6 +2310,21 @@ static int verify_exported_symbols(struc
 	return 0;
 }
 
+static bool ignore_undef_symbol(Elf_Half emachine, const char *name)
+{
+	/*
+	 * On x86, PIC code and Clang non-PIC code may have call foo@PLT. GNU as
+	 * before 2.37 produces an unreferenced _GLOBAL_OFFSET_TABLE_ on x86-64.
+	 * i386 has a similar problem but may not deserve a fix.
+	 *
+	 * If we ever have to ignore many symbols, consider refactoring the code to
+	 * only warn if referenced by a relocation.
+	 */
+	if (emachine == EM_386 || emachine == EM_X86_64)
+		return !strcmp(name, "_GLOBAL_OFFSET_TABLE_");
+	return false;
+}
+
 /* Change all symbols so that st_value encodes the pointer directly. */
 static int simplify_symbols(struct module *mod, const struct load_info *info)
 {
@@ -2355,8 +2370,10 @@ static int simplify_symbols(struct modul
 				break;
 			}
 
-			/* Ok if weak.  */
-			if (!ksym && ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
+			/* Ok if weak or ignored.  */
+			if (!ksym &&
+			    (ELF_ST_BIND(sym[i].st_info) == STB_WEAK ||
+			     ignore_undef_symbol(info->hdr->e_machine, name)))
 				break;
 
 			ret = PTR_ERR(ksym) ?: -ENOENT;


