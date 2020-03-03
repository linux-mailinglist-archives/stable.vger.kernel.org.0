Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1644178076
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbgCCR5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732684AbgCCR4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46BC3206D5;
        Tue,  3 Mar 2020 17:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258212;
        bh=9FKswDVtYEDyso0kvaoRSlcSlgbB0d/jtyAbq574GS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5UBDYbGjUzJggUvaQxV2MA/uWdOK0m+SWS0YZC2oBv0HggTKY0gzjxnr3+bm7sVA
         4ycSEqXQORo1VDy6LDdZFMsSt7cAgUvGz569JhCgqkirDb/XOqHYJl+STtqIupFrAb
         vKyKXTkR36kDngWEntSTfWSYLqSwPlWAih0k2Ifg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 5.4 114/152] kbuild: move headers_check rule to usr/include/Makefile
Date:   Tue,  3 Mar 2020 18:43:32 +0100
Message-Id: <20200303174315.704945660@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 7ecaf069da52e472d393f03e79d721aabd724166 upstream.

Currently, some sanity checks for uapi headers are done by
scripts/headers_check.pl, which is wired up to the 'headers_check'
target in the top Makefile.

It is true compiling headers has better test coverage, but there
are still several headers excluded from the compile test. I like
to keep headers_check.pl for a while, but we can delete a lot of
code by moving the build rule to usr/include/Makefile.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile                     |   11 +++--------
 lib/Kconfig.debug            |   11 -----------
 scripts/Makefile.headersinst |   18 ------------------
 usr/include/Makefile         |    9 ++++++---
 4 files changed, 9 insertions(+), 40 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1195,19 +1195,15 @@ headers: $(version_h) scripts_unifdef ua
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(SRCARCH)/include/uapi
 
+# Deprecated. It is no-op now.
 PHONY += headers_check
-headers_check: headers
-	$(Q)$(MAKE) $(hdr-inst)=include/uapi HDRCHECK=1
-	$(Q)$(MAKE) $(hdr-inst)=arch/$(SRCARCH)/include/uapi HDRCHECK=1
+headers_check:
+	@:
 
 ifdef CONFIG_HEADERS_INSTALL
 prepare: headers
 endif
 
-ifdef CONFIG_HEADERS_CHECK
-all: headers_check
-endif
-
 PHONY += scripts_unifdef
 scripts_unifdef: scripts_basic
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
@@ -1475,7 +1471,6 @@ help:
 	@echo  '  versioncheck    - Sanity check on version.h usage'
 	@echo  '  includecheck    - Check for duplicate included header files'
 	@echo  '  export_report   - List the usages of all exported symbols'
-	@echo  '  headers_check   - Sanity check on exported headers'
 	@echo  '  headerdep       - Detect inclusion cycles in headers'
 	@echo  '  coccicheck      - Check with Coccinelle'
 	@echo  ''
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -299,17 +299,6 @@ config HEADERS_INSTALL
 	  user-space program samples. It is also needed by some features such
 	  as uapi header sanity checks.
 
-config HEADERS_CHECK
-	bool "Run sanity checks on uapi headers when building 'all'"
-	depends on HEADERS_INSTALL
-	help
-	  This option will run basic sanity checks on uapi headers when
-	  building the 'all' target, for example, ensure that they do not
-	  attempt to include files which were not exported, etc.
-
-	  If you're making modifications to header files which are
-	  relevant for userspace, say 'Y'.
-
 config OPTIMIZE_INLINING
 	def_bool y
 	help
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -56,9 +56,6 @@ new-dirs      := $(filter-out $(existing
 $(if $(new-dirs), $(shell mkdir -p $(new-dirs)))
 
 # Rules
-
-ifndef HDRCHECK
-
 quiet_cmd_install = HDRINST $@
       cmd_install = $(CONFIG_SHELL) $(srctree)/scripts/headers_install.sh $< $@
 
@@ -81,21 +78,6 @@ existing-headers := $(filter $(old-heade
 
 -include $(foreach f,$(existing-headers),$(dir $(f)).$(notdir $(f)).cmd)
 
-else
-
-quiet_cmd_check = HDRCHK  $<
-      cmd_check = $(PERL) $(srctree)/scripts/headers_check.pl $(dst) $(SRCARCH) $<; touch $@
-
-check-files := $(addsuffix .chk, $(all-headers))
-
-$(check-files): $(dst)/%.chk : $(dst)/% $(srctree)/scripts/headers_check.pl
-	$(call cmd,check)
-
-__headers: $(check-files)
-	@:
-
-endif
-
 PHONY += FORCE
 FORCE:
 
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -99,11 +99,14 @@ endif
 # asm-generic/*.h is used by asm/*.h, and should not be included directly
 header-test- += asm-generic/%
 
-extra-y := $(patsubst %.h,%.hdrtest, $(filter-out $(header-test-), \
-		$(patsubst $(obj)/%,%, $(shell find $(obj) -name '*.h'))))
+extra-y := $(patsubst $(obj)/%.h,%.hdrtest, $(shell find $(obj) -name '*.h'))
 
 quiet_cmd_hdrtest = HDRTEST $<
-      cmd_hdrtest = $(CC) $(c_flags) -S -o /dev/null -x c /dev/null -include $<; touch $@
+      cmd_hdrtest = \
+		$(CC) $(c_flags) -S -o /dev/null -x c /dev/null \
+			$(if $(filter-out $(header-test-), $*.h), -include $<); \
+		$(PERL) $(srctree)/scripts/headers_check.pl $(obj) $(SRCARCH) $<; \
+		touch $@
 
 $(obj)/%.hdrtest: $(obj)/%.h FORCE
 	$(call if_changed_dep,hdrtest)


