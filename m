Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEED82900D8
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405559AbgJPJJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395008AbgJPJJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D0F22201;
        Fri, 16 Oct 2020 09:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839350;
        bh=9/KavjPpjCjgC9Xo1z5AQ+wvlPqVxMJADq7ikWKfOQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rz0aA2tE8z/bPfZy4TDinc9HVA6qopVtf9E6rcUu45xDsAwIEIIrmJoq/hsL9xaMw
         RtzZdMq4b0b5eLiEEIPaOhID08O+cSJfQ54ov/vTno6X1dHC37LngdTwPmhvjx/icq
         uIJ06OHkbXmBsKKDLh2bsl6K4QA2yCxAuycriKJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/21] ARM: 8858/1: vdso: use $(LD) instead of $(CC) to link VDSO
Date:   Fri, 16 Oct 2020 11:07:21 +0200
Message-Id: <20201016090437.421644062@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.301376476@linuxfoundation.org>
References: <20201016090437.301376476@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit fe00e50b2db8c60e4ec90befad1f5bab8ca2c800 ]

We use $(LD) to link vmlinux, modules, decompressors, etc.

VDSO is the only exceptional case where $(CC) is used as the linker
driver, but I do not know why we need to do so. VDSO uses a special
linker script, and does not link standard libraries at all.

I changed the Makefile to use $(LD) rather than $(CC). I confirmed
the same vdso.so.raw was still produced.

Users will be able to use their favorite linker (e.g. lld instead of
of bfd) by passing LD= from the command line.

My plan is to rewrite all VDSO Makefiles to use $(LD), then delete

cc-ldoption.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/vdso/Makefile | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index f4efff9d3afbb..fadf554d93917 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -10,12 +10,12 @@ obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 ccflags-y := -fPIC -fno-common -fno-builtin -fno-stack-protector
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 
-VDSO_LDFLAGS := -Wl,-Bsymbolic -Wl,--no-undefined -Wl,-soname=linux-vdso.so.1
-VDSO_LDFLAGS += -Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
-VDSO_LDFLAGS += -nostdlib -shared
-VDSO_LDFLAGS += $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
-VDSO_LDFLAGS += $(call cc-ldoption, -Wl$(comma)--build-id)
-VDSO_LDFLAGS += $(call cc-ldoption, -fuse-ld=bfd)
+ldflags-y = -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
+	    -z max-page-size=4096 -z common-page-size=4096 \
+	    -nostdlib -shared \
+	    $(call ld-option, --hash-style=sysv) \
+	    $(call ld-option, --build-id) \
+	    -T
 
 obj-$(CONFIG_VDSO) += vdso.o
 extra-$(CONFIG_VDSO) += vdso.lds
@@ -37,8 +37,8 @@ KCOV_INSTRUMENT := n
 $(obj)/vdso.o : $(obj)/vdso.so
 
 # Link rule for the .so file
-$(obj)/vdso.so.raw: $(src)/vdso.lds $(obj-vdso) FORCE
-	$(call if_changed,vdsold)
+$(obj)/vdso.so.raw: $(obj)/vdso.lds $(obj-vdso) FORCE
+	$(call if_changed,ld)
 
 $(obj)/vdso.so.dbg: $(obj)/vdso.so.raw $(obj)/vdsomunge FORCE
 	$(call if_changed,vdsomunge)
@@ -48,11 +48,6 @@ $(obj)/%.so: OBJCOPYFLAGS := -S
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
-# Actual build commands
-quiet_cmd_vdsold = VDSO    $@
-      cmd_vdsold = $(CC) $(c_flags) $(VDSO_LDFLAGS) \
-                   -Wl,-T $(filter %.lds,$^) $(filter %.o,$^) -o $@
-
 quiet_cmd_vdsomunge = MUNGE   $@
       cmd_vdsomunge = $(objtree)/$(obj)/vdsomunge $< $@
 
-- 
2.25.1



