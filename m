Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990EC1974A4
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 08:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgC3Gnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 02:43:35 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:37826 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbgC3Gnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 02:43:35 -0400
Received: by mail-pl1-f201.google.com with SMTP id t12so12241113plo.4
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 23:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=xapqDhPFeX4c/sEZFBXwtVQVL9ia2nDPE/e7jpQzTQA=;
        b=d8hUdfNwN+8iAFJdBnwUiTZeEYcdMVOCOWJfgJWR7/vu/vixLec11deCzX+uCdblaJ
         vKTaEhiX0gbcQtU4EApIuDXMtuTCWFoDKk4CgV8V935/DxbKWIDs72JckC3qfblOJpgk
         G9weGGi1TLjXnb+sCyklu/HBRr22EUaVJtVA40MdyL4HyOlURlp86JTaxm5hNpkh/Ucp
         HprDqPmzfRmnX01nh+JznDUcsbJGNU+qhqlQlILFD+CnXbBVSFh4f8+tvKF4yDKkNhJV
         AqXyZPKRB5yIndXdCOloQ2x0tlgm5EJ08HcBtcME/64wFkfUFajpMjx7jSKtQTt64fW9
         P6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:cc;
        bh=xapqDhPFeX4c/sEZFBXwtVQVL9ia2nDPE/e7jpQzTQA=;
        b=ftbvLi6MuXYWm3Qw3FKzIX9zoxp8hZJKSbKFwu4U7+jMDW2wgu3GWsRMRtLTvJGAKj
         PesGP/tFGgyqYz5jrKAO1ORRaIT65L+0AhYmSnIs3FSaLo5mRGlb2sLyS8xPFC2HoKm/
         +WN4nJchW8WEBG8wnkrhgQbq0sVOdAU1SP+5FJH4gzJ3LI69bYcJyRajrvcJbr8Qwf/K
         o/F4JXxnJBAutPxpMB3F68wG85aCA1T1SPXc/s0raGRMjkKMLyWttDrbEEzoMmCZiWeW
         Nx+5RW7YnG+w973CNB+URn+YTTq8cOb0HnwT2FDNM/FnNz0stNTQ3sPeW/VBW0p/n5z4
         1goA==
X-Gm-Message-State: ANhLgQ35uO6qTKp4oDGlPLShn8cwDdtSIS0erWF3jFLxzUZ0G9MWn7eD
        8OtRBMtYKY4NS9B/IsYX7K3tnd9abkot
X-Google-Smtp-Source: ADFU+vt/FJekYfgoafMZ/9Mp0r3DKbDy5dLBs00R2iJNcH8rD82TihvKhdtepI0FKoL9nXRN2ERfhcyim+8b
X-Received: by 2002:a17:90a:65c8:: with SMTP id i8mr14048414pjs.156.1585550612534;
 Sun, 29 Mar 2020 23:43:32 -0700 (PDT)
Date:   Mon, 30 Mar 2020 08:43:19 +0200
In-Reply-To: <20200327100801.161671-1-courbet@google.com>
Message-Id: <20200330064323.76162-1-courbet@google.com>
Mime-Version: 1.0
References: <20200327100801.161671-1-courbet@google.com>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
Subject: [PATCH v2] powerpc: Make setjmp/longjmp signature standard
From:   Clement Courbet <courbet@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Clement Courbet <courbet@google.com>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Allison Randal <allison@lohutok.net>,
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

---

v2:
Use and array type as suggested by Segher Boessenkool
Cc: stable@vger.kernel.org # v4.14+
Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")
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

