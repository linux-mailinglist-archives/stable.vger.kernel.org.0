Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7B8D59AC
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 04:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbfJNCvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Oct 2019 22:51:25 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37119 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729712AbfJNCvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Oct 2019 22:51:24 -0400
Received: by mail-oi1-f196.google.com with SMTP id i16so12574762oie.4;
        Sun, 13 Oct 2019 19:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F36EaD5caKU9PTKbiMakPn6QNXZEgKWjgXwIAtKPD44=;
        b=q4vo8JFU4HugUERMWeB4mHp+fw5ON+93BhOylrPtQkKaqZFfDIVrpOI058PORX4ei/
         4Hn53KbXlJBc+Lb8QNW7fHlCUD80Mc8lsyFrLV3A9nZb3I9fUthgPkRYm/zkEYx/bWt4
         bOark5DAZa5oJYf0hn6FaM941/TMhBhsD21D7UOL29rHMZ7OlSPqTetpsNxp2ISsPOYw
         XpSF8cZQVABFIkW/wj83bqNW07tSrE47jJvVBLDxgUUJbQawgownaEircNT+0Matmc65
         gSrGwtWsybRFx0VzHTUbtSNxJsDinfJ+zJP5W8gNfguBxiSqKyzwGyQHRwI2qbSW8B0N
         ZjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F36EaD5caKU9PTKbiMakPn6QNXZEgKWjgXwIAtKPD44=;
        b=mH6FEBxdFYYJ9Lnx9PRlB0ZFrSAjHrL4HNHHlGrQ1mXkYVuxY7oFghcktRLjII4diM
         OYf1ru6XenTgrw1hNj7axft3lZI1RXtiw1bBCnlNagXEm1Cxqs+LecalqYMkzDfzbBgl
         lmzivw+BCyPFFb/8yrcg67G2p0F+xZ2YPzLsMmhdc2G38SiHl1/EGXY8/gtGPVfvyoqV
         ZldL0hc6m9+9TfLrG4qimE4o68CNrARpS6JJtEcG1DLIe1xWsFozwFWrB25T5Qkrrrdc
         9JPxi/sK4uLH4MYwcBogZCHPEPtR0Uny4Rg76ZPNn+UBvhZitr3/ab4CKMwZP1iENnXb
         2BGw==
X-Gm-Message-State: APjAAAXCg+IbmPDXS0B8xzTV+0yGhngtBNhZpt5mnM8m8ZEhImry9hDI
        5bH4So6oQv1mzzfGO8a0Z5A=
X-Google-Smtp-Source: APXvYqy3kpE2sfbwIeSFxIb/hb5mCSnlacPCXCspcSJ3kpbP6k1gek+DidMuI5Jk8HkzUiU5Nl5vhQ==
X-Received: by 2002:aca:53c3:: with SMTP id h186mr23216972oib.174.1571021483233;
        Sun, 13 Oct 2019 19:51:23 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 11sm5612491otg.62.2019.10.13.19.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 19:51:22 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org,
        Segher Boessenkool <segher@kernel.crashing.org>
Subject: [PATCH v4 2/3] powerpc: Avoid clang warnings around setjmp and longjmp
Date:   Sun, 13 Oct 2019 19:51:00 -0700
Message-Id: <20191014025101.18567-3-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191014025101.18567-1-natechancellor@gmail.com>
References: <20190911182049.77853-1-natechancellor@gmail.com>
 <20191014025101.18567-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
setjmp is used") disabled -Wbuiltin-requires-header because of a warning
about the setjmp and longjmp declarations.

r367387 in clang added another diagnostic around this, complaining that
there is no jmp_buf declaration.

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
Link: https://github.com/ClangBuiltLinux/linux/issues/625
Link: https://github.com/llvm/llvm-project/commit/3be25e79477db2d31ac46493d97eca8c20592b07
Link: https://godbolt.org/z/B2oQnl
Suggested-by: Segher Boessenkool <segher@kernel.crashing.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v3 (I skipped v2 because the first patch in the series already
          had a v2):

* Use -ffreestanding instead of outright disabling the warning because
  it is legitimate.

v3 -> v4:

* Rebase on v5.4-rc3

* Add Nick's reviewed-by and Compiler Explorer link.

 arch/powerpc/kernel/Makefile | 4 ++--
 arch/powerpc/xmon/Makefile   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index a7ca8fe62368..f1f362146135 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -5,8 +5,8 @@
 
 CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
-# Disable clang warning for using setjmp without setjmp.h header
-CFLAGS_crash.o		+= $(call cc-disable-warning, builtin-requires-header)
+# Avoid clang warnings around longjmp/setjmp declarations
+CFLAGS_crash.o		+= -ffreestanding
 
 ifdef CONFIG_PPC64
 CFLAGS_prom_init.o	+= $(NO_MINIMAL_TOC)
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index f142570ad860..c3842dbeb1b7 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Disable clang warning for using setjmp without setjmp.h header
-subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header)
+# Avoid clang warnings around longjmp/setjmp declarations
+subdir-ccflags-y := -ffreestanding
 
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n
-- 
2.23.0

