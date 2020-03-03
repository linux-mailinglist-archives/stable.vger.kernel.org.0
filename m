Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9039B1781C6
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbgCCSGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732660AbgCCR47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2449F20656;
        Tue,  3 Mar 2020 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258217;
        bh=BjvBwR9wfIQkcbw6f/vc4ogNDAmbRZYRGuqdD7B4jQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG97AJxZLDpxRrQpbjb27IseD00tLyLUkQ4Shxw6Ziu3O+xJI5tTVXsuR4PVmUqno
         WevRxOXlAOEqS8nQ73xzUsAjTQltISCtpkP/pZtIUnYs00+DXbxDJEthyMNQzqhoLi
         L9cmztVHV4zwYdpVOPqla0NsDarVHBneMZMyevDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 116/152] kbuild: make single target builds even faster
Date:   Tue,  3 Mar 2020 18:43:34 +0100
Message-Id: <20200303174315.952250016@linuxfoundation.org>
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

commit b1fbfcb4a20949df08dd995927cdc5ad220c128d upstream.

Commit 2dffd23f81a3 ("kbuild: make single target builds much faster")
made the situation much better.

To improve it even more, apply the similar idea to the top Makefile.
Trim unrelated directories from build-dirs.

The single build code must be moved above the 'descend' target.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |   90 ++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 47 insertions(+), 43 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1635,6 +1635,50 @@ help:
 PHONY += prepare
 endif # KBUILD_EXTMOD
 
+# Single targets
+# ---------------------------------------------------------------------------
+# To build individual files in subdirectories, you can do like this:
+#
+#   make foo/bar/baz.s
+#
+# The supported suffixes for single-target are listed in 'single-targets'
+#
+# To build only under specific subdirectories, you can do like this:
+#
+#   make foo/bar/baz/
+
+ifdef single-build
+
+# .ko is special because modpost is needed
+single-ko := $(sort $(filter %.ko, $(MAKECMDGOALS)))
+single-no-ko := $(sort $(patsubst %.ko,%.mod, $(MAKECMDGOALS)))
+
+$(single-ko): single_modpost
+	@:
+$(single-no-ko): descend
+	@:
+
+ifeq ($(KBUILD_EXTMOD),)
+# For the single build of in-tree modules, use a temporary file to avoid
+# the situation of modules_install installing an invalid modules.order.
+MODORDER := .modules.tmp
+endif
+
+PHONY += single_modpost
+single_modpost: $(single-no-ko)
+	$(Q){ $(foreach m, $(single-ko), echo $(extmod-prefix)$m;) } > $(MODORDER)
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
+
+KBUILD_MODULES := 1
+
+export KBUILD_SINGLE_TARGETS := $(addprefix $(extmod-prefix), $(single-no-ko))
+
+# trim unrelated directories
+build-dirs := $(foreach d, $(build-dirs), \
+			$(if $(filter $(d)/%, $(KBUILD_SINGLE_TARGETS)), $(d)))
+
+endif
+
 # Handle descending into subdirectories listed in $(build-dirs)
 # Preset locale variables to speed up the build process. Limit locale
 # tweaks to this spot to avoid wrong language settings when running
@@ -1643,7 +1687,9 @@ endif # KBUILD_EXTMOD
 PHONY += descend $(build-dirs)
 descend: $(build-dirs)
 $(build-dirs): prepare
-	$(Q)$(MAKE) $(build)=$@ single-build=$(single-build) need-builtin=1 need-modorder=1
+	$(Q)$(MAKE) $(build)=$@ \
+	single-build=$(if $(filter-out $@/, $(single-no-ko)),1) \
+	need-builtin=1 need-modorder=1
 
 clean-dirs := $(addprefix _clean_, $(clean-dirs))
 PHONY += $(clean-dirs) clean
@@ -1747,48 +1793,6 @@ tools/%: FORCE
 	$(Q)mkdir -p $(objtree)/tools
 	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(tools_silent) $(filter --j% -j,$(MAKEFLAGS))" O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/ $*
 
-# Single targets
-# ---------------------------------------------------------------------------
-# To build individual files in subdirectories, you can do like this:
-#
-#   make foo/bar/baz.s
-#
-# The supported suffixes for single-target are listed in 'single-targets'
-#
-# To build only under specific subdirectories, you can do like this:
-#
-#   make foo/bar/baz/
-
-ifdef single-build
-
-# .ko is special because modpost is needed
-single-ko := $(sort $(filter %.ko, $(MAKECMDGOALS)))
-single-no-ko := $(sort $(patsubst %.ko,%.mod, $(MAKECMDGOALS)))
-
-$(single-ko): single_modpost
-	@:
-$(single-no-ko): descend
-	@:
-
-ifeq ($(KBUILD_EXTMOD),)
-# For the single build of in-tree modules, use a temporary file to avoid
-# the situation of modules_install installing an invalid modules.order.
-MODORDER := .modules.tmp
-endif
-
-PHONY += single_modpost
-single_modpost: $(single-no-ko)
-	$(Q){ $(foreach m, $(single-ko), echo $(extmod-prefix)$m;) } > $(MODORDER)
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
-
-KBUILD_MODULES := 1
-
-export KBUILD_SINGLE_TARGETS := $(addprefix $(extmod-prefix), $(single-no-ko))
-
-single-build = $(if $(filter-out $@/, $(single-no-ko)),1)
-
-endif
-
 # FIXME Should go into a make.lib or something
 # ===========================================================================
 


