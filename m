Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC1389569
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 04:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfHLCmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 22:42:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38849 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfHLCmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 22:42:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so103257517wrr.5;
        Sun, 11 Aug 2019 19:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yf3qi63BI9X/BYxP9kfuXNqP3LoeT8xFrAy0fp782mo=;
        b=dGYrhLjUkDj2WJPilmQW4xy3C/uREHCHQArXSMNPDpqIEW9bXvBveorN4AIx/dBEBe
         0IkYNrxa9lAnkMJQXZ8wtfmbkrk+mazm1sj+6pmuwC6RtgaCLHWHvMBXtwwj5i4Bwr6z
         XSdF0bZl23ZHz02JGh+C6o0Ogd7SV07ZxeFGWc5pLmEIv37r71wPOVREl39RsxL4WeQi
         LjrWDs8vWNaphnVGSXNBpuEOY3FEWcLexSOZjN3/XqToEJ4aIAhvO6DSvpf3equX5y+N
         A9BH5e2HrddMzVAAQqxQG5cw91i83TPYgUZrvmZWjx2Kl+fMd8XA4R1I8w25DqBfrbRi
         yLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yf3qi63BI9X/BYxP9kfuXNqP3LoeT8xFrAy0fp782mo=;
        b=IX4ZrdCDZhYWmqZRr1riXnqtoJBxizo4pPHiF4E3NuQuayqtRZPtYtZVNAPaILr1CV
         SOKQi8Tc6BXITOYVG+TKeubTClqg0gItL/SfTr2EfmhObPGh55uKa8n7bam3kEcX8ivx
         wD0YqUhQ9sVvY4/RA+pDliRgEMLG2Ik6Yt0bffTMlknLREXd4tkqhuCDh6HisVll98Rs
         GS5nH4XnuUeU0VDkGGb0d3gBKIjYnG4qmIoFOkY6sj+uHXIDvL2/SZagEwZMNEJxVvAy
         b3NY3qglgrWPT1KChq8dKSrZkUNZgPUt89cOOuNXLFFAFfo0Fu6D7mfHIm7/Kq0BMYuC
         gDCQ==
X-Gm-Message-State: APjAAAU8e6Y+k+cIxQVGRT0mZ4Ypbexn1fyEyd7xptMMwnqflEs1c720
        7paxix5gYRX0S5QVLkrxrMc=
X-Google-Smtp-Source: APXvYqznAqEJ+GJ49TKqcvfBU6PxEdk43wnddnbNxpFj/DrvwKZy6Mob6j4soONcsG3hwYBtyUIFZg==
X-Received: by 2002:adf:dbcc:: with SMTP id e12mr28643909wrj.205.1565577728170;
        Sun, 11 Aug 2019 19:42:08 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id a26sm16705786wmg.45.2019.08.11.19.42.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 11 Aug 2019 19:42:07 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Date:   Sun, 11 Aug 2019 19:32:15 -0700
Message-Id: <20190812023214.107817-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0.rc2
MIME-Version: 1.0
X-Patchwork-Bot: notify
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

Take the same approach as the above commit by disabling the warning for
the same reason, we provide our own longjmp/setjmp function.

Cc: stable@vger.kernel.org # 4.19+
Link: https://github.com/ClangBuiltLinux/linux/issues/625
Link: https://github.com/llvm/llvm-project/commit/3be25e79477db2d31ac46493d97eca8c20592b07
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

It may be worth using -fno-builtin-setjmp and -fno-builtin-longjmp
instead as it makes it clear to clang that we are not using the builtin
longjmp and setjmp functions, which I think is why these warnings are
appearing (at least according to the commit that introduced this waring).

Sample patch:
https://github.com/ClangBuiltLinux/linux/issues/625#issuecomment-519251372

However, this is the most conservative approach, as I have already had
someone notice this error when building LLVM with PGO on tip of tree
LLVM.

 arch/powerpc/kernel/Makefile | 5 +++--
 arch/powerpc/xmon/Makefile   | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index ea0c69236789..44e340ed4722 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -5,8 +5,9 @@
 
 CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
-# Disable clang warning for using setjmp without setjmp.h header
-CFLAGS_crash.o		+= $(call cc-disable-warning, builtin-requires-header)
+# Avoid clang warnings about longjmp and setjmp built-ins (inclusion of setjmp.h and declaration of jmp_buf type)
+CFLAGS_crash.o		+= $(call cc-disable-warning, builtin-requires-header) \
+			   $(call cc-disable-warning, incomplete-setjmp-declaration)
 
 ifdef CONFIG_PPC64
 CFLAGS_prom_init.o	+= $(NO_MINIMAL_TOC)
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index f142570ad860..53f341391210 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Disable clang warning for using setjmp without setjmp.h header
-subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header)
+# Avoid clang warnings about longjmp and setjmp built-ins (inclusion of setjmp.h and declaration of jmp_buf type)
+subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header) \
+		    $(call cc-disable-warning, incomplete-setjmp-declaration)
 
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n
-- 
2.23.0.rc2

