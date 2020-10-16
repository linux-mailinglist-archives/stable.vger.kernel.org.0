Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45498290144
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406020AbgJPJMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405286AbgJPJKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:10:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C488020848;
        Fri, 16 Oct 2020 09:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839437;
        bh=3YinR5z+Sbg7wxo+bifXxdhFG//sN09p2yYY0SF4g2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqNn9MdBEET+RzGNWwb5LytXs1ssfOhrjMeeNSDduORcTRtXsWWDv4P5JPU6VLXtT
         VH/vQ2h0tikh8+LZ7j4WJ2EOjkuhEETOniBDE6Jk2bUHXrdl66yGi+acm1gKme80ps
         Olagmwe/RB80ioVGwKLauZjGwh3/ctl/KLGiGWqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Matthias Maennich <maennich@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/22] ARM: 8939/1: kbuild: use correct nm executable
Date:   Fri, 16 Oct 2020 11:07:32 +0200
Message-Id: <20201016090437.530919822@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Golovin <dima@golovin.in>

[ Upstream commit 29c623d64f0dcd6aa10e0eabd16233e77114090b ]

Since $(NM) variable can be easily overridden for the whole build, it's
better to use it instead of $(CROSS_COMPILE)nm. The use of $(CROSS_COMPILE)
prefixed variables where their calculated equivalents can be used is
incorrect. This fixes issues with builds where $(NM) is set to llvm-nm.

Link: https://github.com/ClangBuiltLinux/linux/issues/766

Signed-off-by: Dmitry Golovin <dima@golovin.in>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Matthias Maennich <maennich@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 1483966dcf23b..6da67789ac221 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -121,7 +121,7 @@ ccflags-y := -fpic $(call cc-option,-mno-single-pic-base,) -fno-builtin \
 asflags-y := -DZIMAGE
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
-KBSS_SZ = $(shell echo $$(($$($(CROSS_COMPILE)nm $(obj)/../../../../vmlinux | \
+KBSS_SZ = $(shell echo $$(($$($(NM) $(obj)/../../../../vmlinux | \
 		sed -n -e 's/^\([^ ]*\) [AB] __bss_start$$/-0x\1/p' \
 		       -e 's/^\([^ ]*\) [AB] __bss_stop$$/+0x\1/p') )) )
 LDFLAGS_vmlinux = --defsym _kernel_bss_size=$(KBSS_SZ)
@@ -165,7 +165,7 @@ $(obj)/bswapsdi2.S: $(srctree)/arch/$(SRCARCH)/lib/bswapsdi2.S
 # The .data section is already discarded by the linker script so no need
 # to bother about it here.
 check_for_bad_syms = \
-bad_syms=$$($(CROSS_COMPILE)nm $@ | sed -n 's/^.\{8\} [bc] \(.*\)/\1/p') && \
+bad_syms=$$($(NM) $@ | sed -n 's/^.\{8\} [bc] \(.*\)/\1/p') && \
 [ -z "$$bad_syms" ] || \
   ( echo "following symbols must have non local/private scope:" >&2; \
     echo "$$bad_syms" >&2; false )
-- 
2.25.1



