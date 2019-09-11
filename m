Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5D5B0382
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 20:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbfIKSVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 14:21:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38627 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729758AbfIKSVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 14:21:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so25653832wrx.5;
        Wed, 11 Sep 2019 11:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+GO23KGSs5kHbgoAK5zj/r8U5QGqjyd8r2ZN58CM8zQ=;
        b=px6b4SIHi7B132q4zg1w5hzHQ1m4CKKv3m/MiEVdt1uUL59NACme+DKlGdWGna5W5I
         a1r/Pvvz4XYWlLcYo9eGBJ1ZzPHjIBVTZ8WtFaqjYN4hTxo1dH/WtSItfQaiICCpjKpQ
         QVsKiSRVWKEZpX3svoLPnx5zSj1snwTefpaDm2GjaXjV9b1rYrEZDjBb6Jdo+1hsrnaK
         Gtaxjd0125CDUo3p/qtr/VCxWaA566gjpD+FlWMAseaN3I5bSqXsd1HnpTwFN9yRXUjM
         +UcdJu6U2kKikAVwNv2WgJoIpeXBxpbEQbERXYlhYk0twsoo923OXdhzZkyJDsmh9q2H
         fO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+GO23KGSs5kHbgoAK5zj/r8U5QGqjyd8r2ZN58CM8zQ=;
        b=oLvjX6JXot2JCdotPSygWp9zUkZ/mHWmf5vtkABtyEtR2yRemhufZC3vr5ukb1Q7iO
         tEASdWcDQhL/MB/ujWck3FZdAo7DujztkMk8l85l2poVfeOWu8qoYyrcgmQUPDxX+TAD
         ekOMBjnLzIpgL9NDIDY7tWVNhROCHGHGcba9+ixgzCsOKmvkEEld7IwkOxbEN5k6jT27
         lWaDkbOJPygg0D0tGfnh2eAw1h8Ep86s80ZjEGHqDTQCV6Gzls4YwUrxgt2Q5r0fMS6j
         H5XxPShF2iRfDwISNlgRqymxbuWoW4cM4PaJcF6Od8xnbDFFb7A/rm4uoNuR7OGg6kRc
         REAg==
X-Gm-Message-State: APjAAAWY72P6CEC3wyPJej9tswb6/nseq4ySdO2FUDHrj0DeqlhU+0Mf
        FVBmYOIxNciodGcB0+02Hk8=
X-Google-Smtp-Source: APXvYqxLJhyRMbR/c7ChtdkpyoJmx7ehdi/qJxEzmAmumCkVERS6ST//GMwU3xyqIByyT/h57RQx3Q==
X-Received: by 2002:adf:de03:: with SMTP id b3mr30023354wrm.14.1568226104312;
        Wed, 11 Sep 2019 11:21:44 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id q9sm2356753wmq.15.2019.09.11.11.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 11:21:43 -0700 (PDT)
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
Subject: [PATCH v3 2/3] powerpc: Avoid clang warnings around setjmp and longjmp
Date:   Wed, 11 Sep 2019 11:20:51 -0700
Message-Id: <20190911182049.77853-3-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190911182049.77853-1-natechancellor@gmail.com>
References: <20190911182049.77853-1-natechancellor@gmail.com>
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
Suggested-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v3:

* Use -ffreestanding instead of outright disabling the warning because
  it is legitimate.

I skipped v2 because the first patch in the series already had a v2.

 arch/powerpc/kernel/Makefile | 4 ++--
 arch/powerpc/xmon/Makefile   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index c9cc4b689e60..19f19c8c874b 100644
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

