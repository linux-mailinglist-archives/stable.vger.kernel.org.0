Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DFF2E64BA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403848AbgL1PwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:52:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731899AbgL1NjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:39:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DADA21D94;
        Mon, 28 Dec 2020 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162716;
        bh=gd7jMHjPSILuY19NaiApgrXuSU0MdMGERpGIQSWs66M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKO7j8KSKZKubTtIa+LdqkpUWAVXhtqpnzQiA//EZkd5U9GzsAvozXN0YGiYpUhmg
         AdxWmtrVge/iptfp4gq+00MBoA55BQdUeAesqbbkAJ5EiwZwPErhhgqsInZRQyUQI/
         qSYEas055LBSItYtDrVkLCb4PO4qDfKTyUHumJBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/453] kbuild: avoid split lines in .mod files
Date:   Mon, 28 Dec 2020 13:44:45 +0100
Message-Id: <20201228124939.617001423@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 24a33c01bbf7c..9c689d011bced 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -234,6 +234,9 @@ objtool_dep = $(objtool_obj)					\
 ifdef CONFIG_TRIM_UNUSED_KSYMS
 cmd_gen_ksymdeps = \
 	$(CONFIG_SHELL) $(srctree)/scripts/gen_ksymdeps.sh $@ >> $(dot-target).cmd
+
+# List module undefined symbols
+undefined_syms = $(NM) $< | $(AWK) '$$1 == "U" { printf("%s%s", x++ ? " " : "", $$2) }';
 endif
 
 define rule_cc_o_c
@@ -253,13 +256,6 @@ define rule_as_o_S
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
 	$(call cmd,force_checksrc)
@@ -267,7 +263,7 @@ $(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_dep) FORCE
 
 cmd_mod = { \
 	echo $(if $($*-objs)$($*-y)$($*-m), $(addprefix $(obj)/, $($*-objs) $($*-y) $($*-m)), $(@:.mod=.o)); \
-	$(cmd_undef_syms); \
+	$(undefined_syms) echo; \
 	} > $@
 
 $(obj)/%.mod: $(obj)/%.o FORCE
-- 
2.27.0



