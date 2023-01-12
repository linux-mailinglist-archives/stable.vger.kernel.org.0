Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B6E667680
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbjALOca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237564AbjALObp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:31:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E3A52C54
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B0C162030
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7031FC433D2;
        Thu, 12 Jan 2023 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533407;
        bh=4HmoX3BkXMkXTfzQyYnlaYpfE1AsMQG+VhXikBc+GAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MXsCIrAkb6lZkiPdZiGBOYtW/18QNeitpoNEf/k61iFEq/pXj2qp12K/iUxleSnU
         C9LnTRFGcUEHkMA55oXUuIvTid8kQVAuKYZVe02WPVtOQOc/pwOK6W0ziZ29AqDwb3
         UHd47VACoJu/fotA1h6MT17ioKSTGvrsmZ2Udx5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/783] kbuild: unify modules(_install) for in-tree and external modules
Date:   Thu, 12 Jan 2023 14:52:34 +0100
Message-Id: <20230112135544.601736740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 3e3005df73b535cb849cf4ec8075d6aa3c460f68 ]

If you attempt to build or install modules ('make modules(_install)'
with CONFIG_MODULES disabled, you will get a clear error message, but
nothing for external module builds.

Factor out the modules and modules_install rules into the common part,
so you will get the same error message when you try to build external
modules with CONFIG_MODULES=n.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: c7b98de745cf ("phy: qcom-qmp-combo: fix runtime suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 85 ++++++++++++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 49 deletions(-)

diff --git a/Makefile b/Makefile
index 9be2a818d4d7..e32d3137b1d9 100644
--- a/Makefile
+++ b/Makefile
@@ -1425,7 +1425,6 @@ endif
 
 PHONY += modules
 modules: $(if $(KBUILD_BUILTIN),vmlinux) modules_check modules_prepare
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
 PHONY += modules_check
 modules_check: modules.order
@@ -1443,12 +1442,9 @@ PHONY += modules_prepare
 modules_prepare: prepare
 	$(Q)$(MAKE) $(build)=scripts scripts/module.lds
 
-# Target to install modules
-PHONY += modules_install
-modules_install: _modinst_ _modinst_post
-
-PHONY += _modinst_
-_modinst_:
+modules_install: __modinst_pre
+PHONY += __modinst_pre
+__modinst_pre:
 	@rm -rf $(MODLIB)/kernel
 	@rm -f $(MODLIB)/source
 	@mkdir -p $(MODLIB)/kernel
@@ -1460,14 +1456,6 @@ _modinst_:
 	@sed 's:^:kernel/:' modules.order > $(MODLIB)/modules.order
 	@cp -f modules.builtin $(MODLIB)/
 	@cp -f $(objtree)/modules.builtin.modinfo $(MODLIB)/
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
-
-# This depmod is only for convenience to give the initial
-# boot a modules.dep even before / is mounted read-write.  However the
-# boot script depmod is the master version.
-PHONY += _modinst_post
-_modinst_post: _modinst_
-	$(call cmd,depmod)
 
 ifeq ($(CONFIG_MODULE_SIG), y)
 PHONY += modules_sign
@@ -1475,20 +1463,6 @@ modules_sign:
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modsign
 endif
 
-else # CONFIG_MODULES
-
-# Modules not configured
-# ---------------------------------------------------------------------------
-
-PHONY += modules modules_install
-modules modules_install:
-	@echo >&2
-	@echo >&2 "The present kernel configuration has modules disabled."
-	@echo >&2 "Type 'make config' and enable loadable module support."
-	@echo >&2 "Then build a kernel with module support enabled."
-	@echo >&2
-	@exit 1
-
 endif # CONFIG_MODULES
 
 ###
@@ -1736,24 +1710,9 @@ KBUILD_BUILTIN :=
 KBUILD_MODULES := 1
 
 build-dirs := $(KBUILD_EXTMOD)
-PHONY += modules
-modules: $(MODORDER)
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
-
 $(MODORDER): descend
 	@:
 
-PHONY += modules_install
-modules_install: _emodinst_ _emodinst_post
-
-PHONY += _emodinst_
-_emodinst_:
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
-
-PHONY += _emodinst_post
-_emodinst_post: _emodinst_
-	$(call cmd,depmod)
-
 compile_commands.json: $(extmod-prefix)compile_commands.json
 PHONY += compile_commands.json
 
@@ -1776,6 +1735,39 @@ PHONY += prepare modules_prepare
 
 endif # KBUILD_EXTMOD
 
+# ---------------------------------------------------------------------------
+# Modules
+
+PHONY += modules modules_install
+
+ifdef CONFIG_MODULES
+
+modules: $(MODORDER)
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
+
+quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
+      cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
+                   $(KERNELRELEASE)
+
+modules_install:
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
+	$(call cmd,depmod)
+
+else # CONFIG_MODULES
+
+# Modules not configured
+# ---------------------------------------------------------------------------
+
+modules modules_install:
+	@echo >&2 '***'
+	@echo >&2 '*** The present kernel configuration has modules disabled.'
+	@echo >&2 '*** To use the module feature, please run "make menuconfig" etc.'
+	@echo >&2 '*** to enable CONFIG_MODULES.'
+	@echo >&2 '***'
+	@exit 1
+
+endif # CONFIG_MODULES
+
 # Single targets
 # ---------------------------------------------------------------------------
 # To build individual files in subdirectories, you can do like this:
@@ -1963,11 +1955,6 @@ tools/%: FORCE
 quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files)))
       cmd_rmfiles = rm -rf $(rm-files)
 
-# Run depmod only if we have System.map and depmod is executable
-quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
-      cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
-                   $(KERNELRELEASE)
-
 # read saved command lines for existing targets
 existing-targets := $(wildcard $(sort $(targets)))
 
-- 
2.35.1



