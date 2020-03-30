Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E6219761D
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 10:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgC3IEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 04:04:10 -0400
Received: from mail-qv1-f74.google.com ([209.85.219.74]:47614 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729474AbgC3IEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 04:04:09 -0400
Received: by mail-qv1-f74.google.com with SMTP id f9so6363978qvt.14
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 01:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=6uUpEI08oXikXCp5+9gsd81DMfh5aZ7xYc26aZNsMcE=;
        b=R5aQu0gPcdYxwympNDA6UKdwMEnC2lGvXrGlXdylt5YSMQ4nAlR4gXuAS+7DzVEFW9
         bncYZz2qzYyv60L9tsSIMS6mi7tymeJ2mjj2uFTPgT8gTz02xBhf4Ut/2l8JRwepapq6
         v7MV4eHIuJsBec5DldbEcDJ/X2g+0uDLUfpyPOsLAWJG+7u5noEunaLudIgD88epxYKv
         Jdolza7eiLG5kgnu5wfR62bw23CdRRHVOQAFXqOhIs2UJBqImVKGEcmPswTxOAVJmNqi
         QkhU2j1WsrWkCb5+2hNw1Xx4esmiKqnMFvbnwL0CIsgEPe//N0hq9yOnyhTr3R1xVQrZ
         tHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:cc;
        bh=6uUpEI08oXikXCp5+9gsd81DMfh5aZ7xYc26aZNsMcE=;
        b=WHKl4V82XSJr8JTdoYLPWLCql2VpPBoGyMpd9yNchXcCcozZ22qOBv/2RRLnvdYF3u
         lCbZDXj5q0ARVIvs+UokUOaoQo2Q0ljdkxC3dk3D1F67MIvW3qKGB487ELR+Yfk9s9Mp
         eJyhaCRUDGae25TnuFThj0T0mhjm9DshHxWjG6qie/SpCH8sBucomMLYSnb2E3qgreHQ
         7kXUs0dop0bUdUNkXtBOhXNqkSqTVQglI7pgQhU9QlGFBxAggfbQHYlSO5oa064xzMkA
         2MOMN1PfetgfgszaDaRlmJPdxIZK6PacM8Wz1lPdmPqcCzmFb2ols6V1Mh+bwPtIGZP/
         psFQ==
X-Gm-Message-State: ANhLgQ1X1HCH+gFsVkvp7mtO98HVjEV9C9cwqfwdcHovEBGPcvok9Jo5
        tErzLm744qBtxx2OtD96ptJnVCd2tdVm
X-Google-Smtp-Source: ADFU+vtYJzmxymIGka0/I/Su3giY+YfBRdfUHQGLXnJq4xIk/Xdj15dHeXATi7wBUj2ccVnQni5sms+J4AtS
X-Received: by 2002:ac8:6890:: with SMTP id m16mr10623891qtq.5.1585555446842;
 Mon, 30 Mar 2020 01:04:06 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:03:56 +0200
In-Reply-To: <20200327100801.161671-1-courbet@google.com>
Message-Id: <20200330080400.124803-1-courbet@google.com>
Mime-Version: 1.0
References: <20200327100801.161671-1-courbet@google.com>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
Subject: [PATCH v3] powerpc: Make setjmp/longjmp signature standard
From:   Clement Courbet <courbet@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Clement Courbet <courbet@google.com>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Declaring setjmp()/longjmp() as taking longs makes the signature
non-standard, and makes clang complain. In the past, this has been
worked around by adding -ffreestanding to the compile flags.

The implementation looks like it only ever propagates the value
(in longjmp) or sets it to 1 (in setjmp), and we only call longjmp
with integer parameters.

This allows removing -ffreestanding from the compilation flags.

Context:
https://lore.kernel.org/patchwork/patch/1214060
https://lore.kernel.org/patchwork/patch/1216174

Signed-off-by: Clement Courbet <courbet@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: stable@vger.kernel.org # v4.14+
Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")

---

v2:
Use and array type as suggested by Segher Boessenkool
Add fix tags.

v3:
Properly place tags.
---
 arch/powerpc/include/asm/setjmp.h | 6 ++++--
 arch/powerpc/kexec/Makefile       | 3 ---
 arch/powerpc/xmon/Makefile        | 3 ---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/setjmp.h b/arch/powerpc/include/asm/setjmp.h
index e9f81bb3f83b..f798e80e4106 100644
--- a/arch/powerpc/include/asm/setjmp.h
+++ b/arch/powerpc/include/asm/setjmp.h
@@ -7,7 +7,9 @@
 
 #define JMP_BUF_LEN    23
 
-extern long setjmp(long *) __attribute__((returns_twice));
-extern void longjmp(long *, long) __attribute__((noreturn));
+typedef long jmp_buf[JMP_BUF_LEN];
+
+extern int setjmp(jmp_buf env) __attribute__((returns_twice));
+extern void longjmp(jmp_buf env, int val) __attribute__((noreturn));
 
 #endif /* _ASM_POWERPC_SETJMP_H */
diff --git a/arch/powerpc/kexec/Makefile b/arch/powerpc/kexec/Makefile
index 378f6108a414..86380c69f5ce 100644
--- a/arch/powerpc/kexec/Makefile
+++ b/arch/powerpc/kexec/Makefile
@@ -3,9 +3,6 @@
 # Makefile for the linux kernel.
 #
 
-# Avoid clang warnings around longjmp/setjmp declarations
-CFLAGS_crash.o += -ffreestanding
-
 obj-y				+= core.o crash.o core_$(BITS).o
 
 obj-$(CONFIG_PPC32)		+= relocate_32.o
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index c3842dbeb1b7..6f9cccea54f3 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,9 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Avoid clang warnings around longjmp/setjmp declarations
-subdir-ccflags-y := -ffreestanding
-
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n
 UBSAN_SANITIZE := n
-- 
2.26.0.rc2.310.g2932bb562d-goog

