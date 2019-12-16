Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFEB121784
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbfLPSGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:06:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbfLPSGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD293206E0;
        Mon, 16 Dec 2019 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519594;
        bh=utZknrgf3Zyu4lzfzcGaRaFwjQehVXiBoCs88W728mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5jT0N0JN+Y8th/YpwYCyRW70VM90g1qAz+izIKhP7qL9pxwIB8s4pv3JaSxV+Ehf
         c7InOHlIxu2mpnRsV9QTtiT9bILZFNp4m07e6Bv/QBlrPg6slHLWkfJeufVVULlx2I
         7Hn2kAaoar6Y2jm/BayLJNqPiHK0/XId+YsHtSLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 129/140] powerpc: Avoid clang warnings around setjmp and longjmp
Date:   Mon, 16 Dec 2019 18:49:57 +0100
Message-Id: <20191216174828.373385352@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit c9029ef9c95765e7b63c4d9aa780674447db1ec0 ]

Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
setjmp is used") disabled -Wbuiltin-requires-header because of a
warning about the setjmp and longjmp declarations.

r367387 in clang added another diagnostic around this, complaining
that there is no jmp_buf declaration.

  In file included from ../arch/powerpc/xmon/xmon.c:47:
  ../arch/powerpc/include/asm/setjmp.h:10:13: error: declaration of
  built-in function 'setjmp' requires the declaration of the 'jmp_buf'
  type, commonly provided in the header <setjmp.h>.
  [-Werror,-Wincomplete-setjmp-declaration]
  extern long setjmp(long *);
              ^
  ../arch/powerpc/include/asm/setjmp.h:11:13: error: declaration of
  built-in function 'longjmp' requires the declaration of the 'jmp_buf'
  type, commonly provided in the header <setjmp.h>.
  [-Werror,-Wincomplete-setjmp-declaration]
  extern void longjmp(long *, long);
              ^
  2 errors generated.

We are not using the standard library's longjmp/setjmp implementations
for obvious reasons; make this clear to clang by using -ffreestanding
on these files.

Cc: stable@vger.kernel.org # 4.14+
Suggested-by: Segher Boessenkool <segher@kernel.crashing.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191119045712.39633-3-natechancellor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/Makefile | 4 ++--
 arch/powerpc/xmon/Makefile   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index eac18790d1b15..d450280e5c29c 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -5,8 +5,8 @@
 
 CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
-# Disable clang warning for using setjmp without setjmp.h header
-CFLAGS_crash.o		+= $(call cc-disable-warning, builtin-requires-header)
+# Avoid clang warnings around longjmp/setjmp declarations
+CFLAGS_crash.o += -ffreestanding
 
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index 9ba44e190e5e4..365e711bebabb 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Disable clang warning for using setjmp without setjmp.h header
-subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header)
+# Avoid clang warnings around longjmp/setjmp declarations
+subdir-ccflags-y := -ffreestanding
 
 subdir-ccflags-$(CONFIG_PPC_WERROR) += -Werror
 
-- 
2.20.1



