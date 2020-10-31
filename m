Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82ECD2A1702
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgJaLtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgJaLmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F9E720739;
        Sat, 31 Oct 2020 11:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144527;
        bh=ow25wOT9xQi0ASWc0Mbvg770YA+wjWXgttwOe8o3log=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ct4yDcSWjvqv00deQNskDeRfJImRpnr5jWNbMuxMH2Vol+BU5irbaUR4RosE+8eP6
         8C28L8DfuZm+lyWMMYn0zbrJH5BejSPS2mhuB/M+fyJfsZINslzSDaE3lNQYwKxdic
         VXMppKNW/G1KS20dKBoT7XAhEIuh7k40eLYkCp64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.8 22/70] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
Date:   Sat, 31 Oct 2020 12:35:54 +0100
Message-Id: <20201031113500.566611292@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
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
@@ -10,14 +10,14 @@
 #
 # Copyright (C) 1995-2001 by Russell King
 
-LDFLAGS_vmlinux	:=--no-undefined -X
+LDFLAGS_vmlinux	:=--no-undefined -X -z norelro
 CPPFLAGS_vmlinux.lds = -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 ifeq ($(CONFIG_RELOCATABLE), y)
 # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
 # for relative relocs, since this leads to better Image compression
 # with the relocation offsets always being zero.
-LDFLAGS_vmlinux		+= -shared -Bsymbolic -z notext -z norelro \
+LDFLAGS_vmlinux		+= -shared -Bsymbolic -z notext \
 			$(call ld-option, --no-apply-dynamic-relocs)
 endif
 


