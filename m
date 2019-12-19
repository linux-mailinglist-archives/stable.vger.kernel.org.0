Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3767126A14
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfLSSn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728923AbfLSSn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2930C222C2;
        Thu, 19 Dec 2019 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781036;
        bh=5c+/LOE4VJVhhZOOjd+xD/vKB1b/odbuOaqjEBdegP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxKl6SrnktfWnF9log1T/B+97jvRGwCSrcQhOKKtaT0uWHBW3DIpk++DegTnOa5/M
         kdpZHBY6JqWuZS31bL/d00er/gqMdECS9sKyg3Nm9o6D8vD9z8ftwyGZ8GrhsDQRGi
         jBjWgWcvzsB1c8uDf+IUpc1DDkIHgYFMjgHkq3ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 057/199] kbuild: fix single target build for external module
Date:   Thu, 19 Dec 2019 19:32:19 +0100
Message-Id: <20191219183218.120498975@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit e07db28eea38ed4e332b3a89f3995c86b713cb5b ]

Building a single target in an external module fails due to missing
.tmp_versions directory.

For example,

  $ make -C /lib/modules/$(uname -r)/build M=$PWD foo.o

will fail in the following way:

  CC [M]  /home/masahiro/foo/foo.o
/bin/sh: 1: cannot create /home/masahiro/foo/.tmp_versions/foo.mod: Directory nonexistent

This is because $(cmd_crmodverdir) is executed only before building
/, %/, %.ko single targets of external modules. Create .tmp_versions
in the 'prepare' target.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 55a91bc3d8f9c..6baf1e6324255 100644
--- a/Makefile
+++ b/Makefile
@@ -1521,9 +1521,6 @@ else # KBUILD_EXTMOD
 
 # We are always building modules
 KBUILD_MODULES := 1
-PHONY += crmodverdir
-crmodverdir:
-	$(cmd_crmodverdir)
 
 PHONY += $(objtree)/Module.symvers
 $(objtree)/Module.symvers:
@@ -1535,7 +1532,7 @@ $(objtree)/Module.symvers:
 
 module-dirs := $(addprefix _module_,$(KBUILD_EXTMOD))
 PHONY += $(module-dirs) modules
-$(module-dirs): crmodverdir $(objtree)/Module.symvers
+$(module-dirs): prepare $(objtree)/Module.symvers
 	$(Q)$(MAKE) $(build)=$(patsubst _module_%,%,$@)
 
 modules: $(module-dirs)
@@ -1576,7 +1573,8 @@ help:
 
 # Dummies...
 PHONY += prepare scripts
-prepare: ;
+prepare:
+	$(cmd_crmodverdir)
 scripts: ;
 endif # KBUILD_EXTMOD
 
@@ -1701,17 +1699,14 @@ endif
 
 # Modules
 /: prepare scripts FORCE
-	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)
 # Make sure the latest headers are built for Documentation
 Documentation/ samples/: headers_install
 %/: prepare scripts FORCE
-	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)
 %.ko: prepare scripts FORCE
-	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1)   \
 	$(build)=$(build-dir) $(@:.ko=.o)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
-- 
2.20.1



