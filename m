Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DCC2A565C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbgKCV0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387463AbgKCVB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:01:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96ACC205ED;
        Tue,  3 Nov 2020 21:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437287;
        bh=dAckfZUvuQTzjuGDQr/NoLlGwNVuu2+sA3yLjksJmoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLveqYnmDWKzG2Ht15jpB42YBac5AY4WtX+BADDIVTSwbhRSWGBDhyjN1B848dWFJ
         taMdRSLAmEsLPa4XRTP2xeRO9heoprT97dj6LRj+elxWo1LRKRmkM45lWEvELu2pyf
         Tmm2Mz6G+dhvO4b5N5WLDHv4YokYX7dy38du2rP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 004/191] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
Date:   Tue,  3 Nov 2020 21:34:56 +0100
Message-Id: <20201103203233.221060805@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 3b92fa7485eba16b05166fddf38ab42f2ff6ab95 upstream.

With CONFIG_EXPERT=y, CONFIG_KASAN=y, CONFIG_RANDOMIZE_BASE=n,
CONFIG_RELOCATABLE=n, we observe the following failure when trying to
link the kernel image with LD=ld.lld:

error: section: .exit.data is not contiguous with other relro sections

ld.lld defaults to -z relro while ld.bfd defaults to -z norelro. This
was previously fixed, but only for CONFIG_RELOCATABLE=y.

Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker script and options")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201016175339.2429280-1-ndesaulniers@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King
 
-LDFLAGS_vmlinux	:=--no-undefined -X
+LDFLAGS_vmlinux	:=--no-undefined -X -z norelro
 CPPFLAGS_vmlinux.lds = -DTEXT_OFFSET=$(TEXT_OFFSET)
 GZFLAGS		:=-9
 
@@ -18,7 +18,7 @@ ifeq ($(CONFIG_RELOCATABLE), y)
 # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
 # for relative relocs, since this leads to better Image compression
 # with the relocation offsets always being zero.
-LDFLAGS_vmlinux		+= -shared -Bsymbolic -z notext -z norelro \
+LDFLAGS_vmlinux		+= -shared -Bsymbolic -z notext \
 			$(call ld-option, --no-apply-dynamic-relocs)
 endif
 


