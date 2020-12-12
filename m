Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E602C2D87AA
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439418AbgLLQKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439400AbgLLQJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:09:56 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 22/23] kbuild: avoid split lines in .mod files
Date:   Sat, 12 Dec 2020 11:08:03 -0500
Message-Id: <20201212160804.2334982-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 7d32358be8acb119dcfe39b6cf67ec6d94bf1fe7 ]

"xargs echo" is not a safe way to remove line breaks because the input
may exceed the command line limit and xargs may break it up into
multiple invocations of echo. This should never happen because
scripts/gen_autoksyms.sh expects all undefined symbols are placed in
the second line of .mod files.

One possible way is to replace "xargs echo" with
"sed ':x;N;$!bx;s/\n/ /g'" or something, but I rewrote the code by
using awk because it is more readable.

This issue was reported by Sami Tolvanen; in his Clang LTO patch set,
$(multi-used-m) is no longer an ELF object, but a thin archive that
contains LLVM bitcode files. llvm-nm prints out symbols for each
archive member separately, which results a lot of dupications, in some
places, beyond the system-defined limit.

This problem must be fixed irrespective of LTO, and we must ensure
zero possibility of having this issue.

Link: https://lkml.org/lkml/2020/12/1/1658
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a467b93234424..80953d5cce80f 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -252,6 +252,9 @@ objtool_dep = $(objtool_obj)					\
 ifdef CONFIG_TRIM_UNUSED_KSYMS
 cmd_gen_ksymdeps = \
 	$(CONFIG_SHELL) $(srctree)/scripts/gen_ksymdeps.sh $@ >> $(dot-target).cmd
+
+# List module undefined symbols
+undefined_syms = $(NM) $< | $(AWK) '$$1 == "U" { printf("%s%s", x++ ? " " : "", $$2) }';
 endif
 
 define rule_cc_o_c
@@ -271,13 +274,6 @@ define rule_as_o_S
 	$(call cmd,modversions_S)
 endef
 
-# List module undefined symbols (or empty line if not enabled)
-ifdef CONFIG_TRIM_UNUSED_KSYMS
-cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | xargs echo
-else
-cmd_undef_syms = echo
-endif
-
 # Built-in and composite module parts
 $(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_dep) FORCE
 	$(call if_changed_rule,cc_o_c)
@@ -285,7 +281,7 @@ $(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_dep) FORCE
 
 cmd_mod = { \
 	echo $(if $($*-objs)$($*-y)$($*-m), $(addprefix $(obj)/, $($*-objs) $($*-y) $($*-m)), $(@:.mod=.o)); \
-	$(cmd_undef_syms); \
+	$(undefined_syms) echo; \
 	} > $@
 
 $(obj)/%.mod: $(obj)/%.o FORCE
-- 
2.27.0

