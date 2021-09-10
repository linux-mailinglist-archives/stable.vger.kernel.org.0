Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73534061B1
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhIJAn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhIJATJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D250611C8;
        Fri, 10 Sep 2021 00:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233079;
        bh=eJxBxGpjQPB7ZNdnddIshq/DCvnmJ63/xFh6vcliqmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUf995v4cBbechgnnc7Im3Vz2yYcnHHszV5ufBXeHjJIedSOeseqKv9FKm0tPaIP1
         eVpSLI3j9VKmM6HFfs6nSGgS2h6h1lUDxEzlcSSu7DcQjPazw9QlPtX3Hl/w0bu66W
         c2+7jZkDAsQ3mxioDOC+tQ4R8YMOzwSgWPtbgEofzsWl0z4cWKuUuKwM2Et4rZGOqX
         gir+0uE8u7abUqCGNNMWCalbTzZtTtiUte9+Tu051TQEhuVcQj4K0Sr2PUxfZEB7AU
         ausc6E7Xe+mAuzrNGxCxRBDjA88xCaXs0ahYbXrOUNA1bG+8xVqAU4hJvwb2Hm94TX
         jDyIqDM12UG7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.14 87/99] kbuild: Fix TRIM_UNUSED_KSYMS with LTO_CLANG
Date:   Thu,  9 Sep 2021 20:15:46 -0400
Message-Id: <20210910001558.173296-87-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 850ded46c64299f04d15e39caaba21963fb966f8 ]

With CONFIG_LTO_CLANG, we currently link modules into native
code just before modpost, which means with TRIM_UNUSED_KSYMS
enabled, we still look at the LLVM bitcode in the .o files when
generating the list of used symbols. As the bitcode doesn't
yet have calls to compiler intrinsics and llvm-nm doesn't see
function references that only exist in function-level inline
assembly, we currently need a whitelist for TRIM_UNUSED_KSYMS to
work with LTO.

This change moves module LTO linking to happen earlier, and
thus avoids the issue with LLVM bitcode and TRIM_UNUSED_KSYMS
entirely, allowing us to also drop the whitelist from
gen_autoksyms.sh.

Link: https://github.com/ClangBuiltLinux/linux/issues/1369
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Tested-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build    | 27 ++++++++++++++++++++++++++-
 scripts/Makefile.lib      |  7 +++++++
 scripts/Makefile.modfinal | 21 ++-------------------
 scripts/Makefile.modpost  | 22 +++-------------------
 scripts/gen_autoksyms.sh  | 12 ------------
 5 files changed, 38 insertions(+), 51 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 02197cb8e3a7..ea549579bfb7 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -88,6 +88,10 @@ endif
 
 targets-for-modules := $(patsubst %.o, %.mod, $(filter %.o, $(obj-m)))
 
+ifdef CONFIG_LTO_CLANG
+targets-for-modules += $(patsubst %.o, %.lto.o, $(filter %.o, $(obj-m)))
+endif
+
 ifdef need-modorder
 targets-for-modules += $(obj)/modules.order
 endif
@@ -271,12 +275,33 @@ $(obj)/%.o: $(src)/%.c $(recordmcount_source) $$(objtool_dep) FORCE
 	$(call if_changed_rule,cc_o_c)
 	$(call cmd,force_checksrc)
 
+ifdef CONFIG_LTO_CLANG
+# Module .o files may contain LLVM bitcode, compile them into native code
+# before ELF processing
+quiet_cmd_cc_lto_link_modules = LTO [M] $@
+cmd_cc_lto_link_modules =						\
+	$(LD) $(ld_flags) -r -o $@					\
+		$(shell [ -s $(@:.lto.o=.o.symversions) ] &&		\
+			echo -T $(@:.lto.o=.o.symversions))		\
+		--whole-archive $(filter-out FORCE,$^)
+
+ifdef CONFIG_STACK_VALIDATION
+# objtool was skipped for LLVM bitcode, run it now that we have compiled
+# modules into native code
+cmd_cc_lto_link_modules += ;						\
+	$(objtree)/tools/objtool/objtool $(objtool_args) --module $@
+endif
+
+$(obj)/%.lto.o: $(obj)/%.o FORCE
+	$(call if_changed,cc_lto_link_modules)
+endif
+
 cmd_mod = { \
 	echo $(if $($*-objs)$($*-y)$($*-m), $(addprefix $(obj)/, $($*-objs) $($*-y) $($*-m)), $(@:.mod=.o)); \
 	$(undefined_syms) echo; \
 	} > $@
 
-$(obj)/%.mod: $(obj)/%.o FORCE
+$(obj)/%.mod: $(obj)/%$(mod-prelink-ext).o FORCE
 	$(call if_changed,mod)
 
 quiet_cmd_cc_lst_c = MKLST   $@
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 10950559b223..af1c920a585c 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -225,6 +225,13 @@ dtc_cpp_flags  = -Wp,-MMD,$(depfile).pre.tmp -nostdinc                    \
 		 $(addprefix -I,$(DTC_INCLUDE))                          \
 		 -undef -D__DTS__
 
+ifeq ($(CONFIG_LTO_CLANG),y)
+# With CONFIG_LTO_CLANG, .o files in modules might be LLVM bitcode, so we
+# need to run LTO to compile them into native code (.lto.o) before further
+# processing.
+mod-prelink-ext := .lto
+endif
+
 # Objtool arguments are also needed for modfinal with LTO, so we define
 # then here to avoid duplication.
 objtool_args =								\
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 5e9b8057fb24..ff805777431c 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -9,7 +9,7 @@ __modfinal:
 include include/config/auto.conf
 include $(srctree)/scripts/Kbuild.include
 
-# for c_flags and objtool_args
+# for c_flags and mod-prelink-ext
 include $(srctree)/scripts/Makefile.lib
 
 # find all modules listed in modules.order
@@ -30,23 +30,6 @@ quiet_cmd_cc_o_c = CC [M]  $@
 
 ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(SRCARCH)/Makefile.postlink)
 
-ifdef CONFIG_LTO_CLANG
-# With CONFIG_LTO_CLANG, reuse the object file we compiled for modpost to
-# avoid a second slow LTO link
-prelink-ext := .lto
-
-# ELF processing was skipped earlier because we didn't have native code,
-# so let's now process the prelinked binary before we link the module.
-
-ifdef CONFIG_STACK_VALIDATION
-cmd_ld_ko_o +=								\
-	$(objtree)/tools/objtool/objtool $(objtool_args)		\
-		$(@:.ko=$(prelink-ext).o);
-
-endif # CONFIG_STACK_VALIDATION
-
-endif # CONFIG_LTO_CLANG
-
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o +=							\
 	$(LD) -r $(KBUILD_LDFLAGS)					\
@@ -72,7 +55,7 @@ if_changed_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),      \
 
 
 # Re-generate module BTFs if either module's .ko or vmlinux changed
-$(modules): %.ko: %$(prelink-ext).o %.mod.o scripts/module.lds $(if $(KBUILD_BUILTIN),vmlinux) FORCE
+$(modules): %.ko: %$(mod-prelink-ext).o %.mod.o scripts/module.lds $(if $(KBUILD_BUILTIN),vmlinux) FORCE
 	+$(call if_changed_except,ld_ko_o,vmlinux)
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 	+$(if $(newer-prereqs),$(call cmd,btf_ko))
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index c383ba33d837..eef56d629799 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -41,7 +41,7 @@ __modpost:
 include include/config/auto.conf
 include $(srctree)/scripts/Kbuild.include
 
-# for ld_flags
+# for mod-prelink-ext
 include $(srctree)/scripts/Makefile.lib
 
 MODPOST = scripts/mod/modpost								\
@@ -118,22 +118,6 @@ $(input-symdump):
 	@echo >&2 '         Modules may not have dependencies or modversions.'
 	@echo >&2 '         You may get many unresolved symbol warnings.'
 
-ifdef CONFIG_LTO_CLANG
-# With CONFIG_LTO_CLANG, .o files might be LLVM bitcode, so we need to run
-# LTO to compile them into native code before running modpost
-prelink-ext := .lto
-
-quiet_cmd_cc_lto_link_modules = LTO [M] $@
-cmd_cc_lto_link_modules =						\
-	$(LD) $(ld_flags) -r -o $@					\
-		$(shell [ -s $(@:.lto.o=.o.symversions) ] &&		\
-			echo -T $(@:.lto.o=.o.symversions))		\
-		--whole-archive $^
-
-%.lto.o: %.o
-	$(call if_changed,cc_lto_link_modules)
-endif
-
 modules := $(sort $(shell cat $(MODORDER)))
 
 # KBUILD_MODPOST_WARN can be set to avoid error out in case of undefined symbols
@@ -144,9 +128,9 @@ endif
 # Read out modules.order to pass in modpost.
 # Otherwise, allmodconfig would fail with "Argument list too long".
 quiet_cmd_modpost = MODPOST $@
-      cmd_modpost = sed 's/\.ko$$/$(prelink-ext)\.o/' $< | $(MODPOST) -T -
+      cmd_modpost = sed 's/\.ko$$/$(mod-prelink-ext)\.o/' $< | $(MODPOST) -T -
 
-$(output-symdump): $(MODORDER) $(input-symdump) $(modules:.ko=$(prelink-ext).o) FORCE
+$(output-symdump): $(MODORDER) $(input-symdump) $(modules:.ko=$(mod-prelink-ext).o) FORCE
 	$(call if_changed,modpost)
 
 targets += $(output-symdump)
diff --git a/scripts/gen_autoksyms.sh b/scripts/gen_autoksyms.sh
index da320151e7c3..6ed0d225c8b1 100755
--- a/scripts/gen_autoksyms.sh
+++ b/scripts/gen_autoksyms.sh
@@ -26,18 +26,6 @@ if [ -n "$CONFIG_MODVERSIONS" ]; then
 	needed_symbols="$needed_symbols module_layout"
 fi
 
-# With CONFIG_LTO_CLANG, LLVM bitcode has not yet been compiled into a binary
-# when the .mod files are generated, which means they don't yet contain
-# references to certain symbols that will be present in the final binaries.
-if [ -n "$CONFIG_LTO_CLANG" ]; then
-	# intrinsic functions
-	needed_symbols="$needed_symbols memcpy memmove memset"
-	# ftrace
-	needed_symbols="$needed_symbols _mcount"
-	# stack protector symbols
-	needed_symbols="$needed_symbols __stack_chk_fail __stack_chk_guard"
-fi
-
 ksym_wl=
 if [ -n "$CONFIG_UNUSED_KSYMS_WHITELIST" ]; then
 	# Use 'eval' to expand the whitelist path and check if it is relative
-- 
2.30.2

