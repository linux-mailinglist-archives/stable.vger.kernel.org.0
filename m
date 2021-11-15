Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6118A4520AA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349993AbhKPAz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343529AbhKOTVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73650635A6;
        Mon, 15 Nov 2021 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001688;
        bh=Yk+6y3MIWso31w8GoTd4+7ZttxrL6yGEtLQspATe/gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9+OMIPGy76w0am8eAGC6b/eF8vF1PL1Rf2Qmk5KlHrzfmaHiVtOx8GTWtqxTohwo
         mtuc+IvxIhuntjmkay/joWMmjQllIJtTiJ03vQKC75RtJNGRSRjuAayw4VvXf7JNf7
         RcZJMBuRswsojhFlzBIXHR/aAdGTVBZgCprsxDyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Henneman <henneman@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/917] arm64: vdso32: suppress error message for make mrproper
Date:   Mon, 15 Nov 2021 17:56:18 +0100
Message-Id: <20211115165438.365171082@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 14831fad73f5ac30ac61760487d95a538e6ab3cb ]

When running the following command without arm-linux-gnueabi-gcc in
one's $PATH, the following warning is observed:

$ ARCH=arm64 CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make -j72 LLVM=1 mrproper
make[1]: arm-linux-gnueabi-gcc: No such file or directory

This is because KCONFIG is not run for mrproper, so CONFIG_CC_IS_CLANG
is not set, and we end up eagerly evaluating various variables that try
to invoke CC_COMPAT.

This is a similar problem to what was observed in
commit dc960bfeedb0 ("h8300: suppress error messages for 'make clean'")

Reported-by: Lucas Henneman <henneman@google.com>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20211019223646.1146945-4-ndesaulniers@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vdso32/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 3dba0c4f8f42b..764d1900d5aab 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -40,7 +40,8 @@ cc32-as-instr = $(call try-run,\
 # As a result we set our own flags here.
 
 # KBUILD_CPPFLAGS and NOSTDINC_FLAGS from top-level Makefile
-VDSO_CPPFLAGS := -DBUILD_VDSO -D__KERNEL__ -nostdinc -isystem $(shell $(CC_COMPAT) -print-file-name=include)
+VDSO_CPPFLAGS := -DBUILD_VDSO -D__KERNEL__ -nostdinc
+VDSO_CPPFLAGS += -isystem $(shell $(CC_COMPAT) -print-file-name=include 2>/dev/null)
 VDSO_CPPFLAGS += $(LINUXINCLUDE)
 
 # Common C and assembly flags
-- 
2.33.0



