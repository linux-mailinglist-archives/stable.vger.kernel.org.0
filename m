Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4115A27884D
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgIYMy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729569AbgIYMy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3457E21741;
        Fri, 25 Sep 2020 12:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038466;
        bh=rHj9sRhJntAzO0JLGuynsGUS6iDb8qG5E+w0MCVmR58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUK3n8sW7YInno4cfLw/X7+cQViZaatg3yLCwt22dNuB7sG/KK83Kgp5K+ov8iG/b
         RrmA2sInWfqFQCYVKl423YKBdsj9wyfPwYl0qd3G2tf+RVs6Cytja9wNJhNNzAbfzk
         BRu1whpwFxZ8wRL0rIQ7mEU9Y/X2lxGe9npP+dVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 28/37] net: wan: wanxl: use allow to pass CROSS_COMPILE_M68k for rebuilding firmware
Date:   Fri, 25 Sep 2020 14:48:56 +0200
Message-Id: <20200925124725.211971609@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 63b903dfebdea92aa92ad337d8451a6fbfeabf9d upstream.

As far as I understood from the Kconfig help text, this build rule is
used to rebuild the driver firmware, which runs on an old m68k-based
chip. So, you need m68k tools for the firmware rebuild.

wanxl.c is a PCI driver, but CONFIG_M68K does not select CONFIG_HAVE_PCI.
So, you cannot enable CONFIG_WANXL_BUILD_FIRMWARE for ARCH=m68k. In other
words, ifeq ($(ARCH),m68k) is false here.

I am keeping the dead code for now, but rebuilding the firmware requires
'as68k' and 'ld68k', which I do not have in hand.

Instead, the kernel.org m68k GCC [1] successfully built it.

Allowing a user to pass in CROSS_COMPILE_M68K= is handier.

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/9.2.0/x86_64-gcc-9.2.0-nolibc-m68k-linux.tar.xz

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/Kconfig  |    2 +-
 drivers/net/wan/Makefile |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -199,7 +199,7 @@ config WANXL_BUILD_FIRMWARE
 	depends on WANXL && !PREVENT_FIRMWARE_BUILD
 	help
 	  Allows you to rebuild firmware run by the QUICC processor.
-	  It requires as68k, ld68k and hexdump programs.
+	  It requires m68k toolchains and hexdump programs.
 
 	  You should never need this option, say N.
 
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -41,17 +41,17 @@ $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
 
 ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
 ifeq ($(ARCH),m68k)
-  AS68K = $(AS)
-  LD68K = $(LD)
+  M68KAS = $(AS)
+  M68KLD = $(LD)
 else
-  AS68K = as68k
-  LD68K = ld68k
+  M68KAS = $(CROSS_COMPILE_M68K)as
+  M68KLD = $(CROSS_COMPILE_M68K)ld
 endif
 
 quiet_cmd_build_wanxlfw = BLD FW  $@
       cmd_build_wanxlfw = \
-	$(CPP) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi $< | $(AS68K) -m68360 -o $(obj)/wanxlfw.o; \
-	$(LD68K) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
+	$(CPP) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi $< | $(M68KAS) -m68360 -o $(obj)/wanxlfw.o; \
+	$(M68KLD) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
 	hexdump -ve '"\n" 16/1 "0x%02X,"' $(obj)/wanxlfw.bin | sed 's/0x  ,//g;1s/^/static const u8 firmware[]={/;$$s/,$$/\n};\n/' >$(obj)/wanxlfw.inc; \
 	rm -f $(obj)/wanxlfw.bin $(obj)/wanxlfw.o
 


