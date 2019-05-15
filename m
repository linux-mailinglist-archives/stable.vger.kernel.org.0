Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6953D1F1F8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbfEOLPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730334AbfEOLPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05BD2084E;
        Wed, 15 May 2019 11:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918941;
        bh=IrG606G2ac9Y9jrMvCLPLa5ctK/pQzOopwKA7yfSsE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QB5BPnSFumtRJVhuPviNulA77hEZiqQ5r7E3KrhKjvOHTvjKOQ6vq8pj415udPW6z
         pLlvFxNH4gKgs11UKPMRZoaQPOouXbEDmf3XXdI6UX6wutQEDgEgchVT/RuhxfUzmv
         yeAOaw+BNA/bfMmsYDtq4pI8P4s785/kG5my8gMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 35/51] Revert "x86: vdso: Use $LD instead of $CC to link"
Date:   Wed, 15 May 2019 12:56:10 +0200
Message-Id: <20190515090626.919390908@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 94c0c4f033eee2304a98cf30a141f9dae35d3a62.

The commit message in the 4.9 stable tree did not have a reference to
the upstream commit id.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/Makefile | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 2ae92c6b1de6d..d5409660f5de6 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -47,8 +47,10 @@ targets += $(vdso_img_sodbg)
 
 export CPPFLAGS_vdso.lds += -P -C
 
-VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -soname linux-vdso.so.1 --no-undefined \
-			-z max-page-size=4096 -z common-page-size=4096
+VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
+			-Wl,--no-undefined \
+			-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096 \
+			$(DISABLE_LTO)
 
 $(obj)/vdso64.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso)
@@ -94,8 +96,10 @@ CFLAGS_REMOVE_vvar.o = -pg
 #
 
 CPPFLAGS_vdsox32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdsox32.lds = -m elf32_x86_64 -soname linux-vdso.so.1 \
-			   -z max-page-size=4096 -z common-page-size=4096
+VDSO_LDFLAGS_vdsox32.lds = -Wl,-m,elf32_x86_64 \
+			   -Wl,-soname=linux-vdso.so.1 \
+			   -Wl,-z,max-page-size=4096 \
+			   -Wl,-z,common-page-size=4096
 
 # 64-bit objects to re-brand as x32
 vobjs64-for-x32 := $(filter-out $(vobjs-nox32),$(vobjs-y))
@@ -123,7 +127,7 @@ $(obj)/vdsox32.so.dbg: $(src)/vdsox32.lds $(vobjx32s) FORCE
 	$(call if_changed,vdso)
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -soname linux-gate.so.1
+VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-m,elf_i386 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
 # is not a kbuild sub-make subdirectory.
@@ -161,13 +165,13 @@ $(obj)/vdso32.so.dbg: FORCE \
 # The DSO images are built using a special linker script.
 #
 quiet_cmd_vdso = VDSO    $@
-      cmd_vdso = $(LD) -nostdlib -o $@ \
+      cmd_vdso = $(CC) -nostdlib -o $@ \
 		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
-		       -T $(filter %.lds,$^) $(filter %.o,$^) && \
+		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^) && \
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
-VDSO_LDFLAGS = -shared $(call ld-option, --hash-style=both) \
-	$(call ld-option, --build-id) -Bsymbolic
+VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=both) \
+	$(call cc-ldoption, -Wl$(comma)--build-id) -Wl,-Bsymbolic $(LTO_CFLAGS)
 GCOV_PROFILE := n
 
 #
-- 
2.20.1



