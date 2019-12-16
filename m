Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551DE121948
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfLPRyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbfLPRyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9168021582;
        Mon, 16 Dec 2019 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518862;
        bh=RfmMguvOsEmVTvPQcmmNoPaMeAWc9qTU28XzeE79xCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHbGoTNjQmeP4GqpkQ8xRuW4LHeMqLhJ/LRi7M+plG0ASYWQjZhMM4truSQuqrihV
         IHBBVV3Y1zCl3AJ5SnlHgfWpAkgEcUAmiTd39xaX7WbUa4wautxZGZbS6YYU3NlkY2
         W+ZN+EkDC5xT2fBue+aylul/EQCQCQpRRicRZ42A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 096/267] kbuild: fix single target build for external module
Date:   Mon, 16 Dec 2019 18:47:02 +0100
Message-Id: <20191216174901.982408463@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index d97288c0754fe..4de172b2e1fba 100644
--- a/Makefile
+++ b/Makefile
@@ -1529,9 +1529,6 @@ else # KBUILD_EXTMOD
 
 # We are always building modules
 KBUILD_MODULES := 1
-PHONY += crmodverdir
-crmodverdir:
-	$(cmd_crmodverdir)
 
 PHONY += $(objtree)/Module.symvers
 $(objtree)/Module.symvers:
@@ -1543,7 +1540,7 @@ $(objtree)/Module.symvers:
 
 module-dirs := $(addprefix _module_,$(KBUILD_EXTMOD))
 PHONY += $(module-dirs) modules
-$(module-dirs): crmodverdir $(objtree)/Module.symvers
+$(module-dirs): prepare $(objtree)/Module.symvers
 	$(Q)$(MAKE) $(build)=$(patsubst _module_%,%,$@)
 
 modules: $(module-dirs)
@@ -1584,7 +1581,8 @@ help:
 
 # Dummies...
 PHONY += prepare scripts
-prepare: ;
+prepare:
+	$(cmd_crmodverdir)
 scripts: ;
 endif # KBUILD_EXTMOD
 
@@ -1709,17 +1707,14 @@ endif
 
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



