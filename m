Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB0B2A5B49
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 01:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgKDAxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 19:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729558AbgKDAxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 19:53:50 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CDAC040203
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 16:53:49 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p63so19898825ybc.7
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 16:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6nth1Ay7JTmqSTdpD6CAIOaNAdyMhdLz3pdbFkquv2w=;
        b=qCw8+F/+nLz5LxsUHleH+9cNH3m8jIH+wWmS6NvhkoTCDOMXb3tPmg8l3btrBOReNq
         Y3ULifDeAVzxVrvFjzWIP1iObBG+hhd9ukxP6x3WCo3dzJDy0kHhduok9ejP4WQQCnWh
         H++8qGkqToOvbQNp8Ja7apwvBL8Rcz4eq/A796u+jVOzUj8+5MXstB9lsmhVGkRLC7ZX
         tCuL/kx4KAa4n72lYDbz4OxAYWGyq+6j5y32iRTp90UQJFZZHX//2R00WF9QHVUvR6Uj
         YtzglSsEY6CUtUJ4ibwKiIJPwoyEryxCrqXFvsBu5z0g3ZXDq1VpbNx8dK5KvKco/zyo
         WyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6nth1Ay7JTmqSTdpD6CAIOaNAdyMhdLz3pdbFkquv2w=;
        b=nxvf/CNglH8vebiykjH0qBiAnlNZP3fDaJekCICcf6Ft+fFdSx7lOfLqEZwAu59LFy
         M7JA1twAQM84yBfGrt/k6VAYLzrG5/IabrtFhGiTjkLLXfHGHZmmWKJkCo4SvgL+t9il
         L2rksinbzzi+l2/Xyf9P1MtTwrWNYBTyE4/tnPkGdNv9Xwtb2uBYq3vhl1/qSV7W84kY
         6k+XZkY1R+brOsYzouoAPKRMqQavTyb9bFPwJKvDXcnpWclERUC79lMYpXZ41ANxxgmC
         7JBJBVT3eLkpM3O6zSRSqbjwUk06e99nIYNkk76oQ1MbUghPuJwAxNZcliH1Ty5PXWHq
         ycxQ==
X-Gm-Message-State: AOAM533/u/7nZX4i2MQJgQATtAVCF2K/OLrIS0cF3D4ZP/M5dIgEqtfA
        chtzG1M5TLnaFwr7tQyvk+A1FDf7W36moOyNflk=
X-Google-Smtp-Source: ABdhPJx/YEnHn2ke8YQZ6NNMbl/+wfh/QJAeszOxk2mXyJULZvY9SeogSn5s2PHinLgK78CnPoKZgYLDaG7YOiu0+l8=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a25:3188:: with SMTP id
 x130mr31763518ybx.64.1604451228585; Tue, 03 Nov 2020 16:53:48 -0800 (PST)
Date:   Tue,  3 Nov 2020 16:53:40 -0800
In-Reply-To: <20201104005343.4192504-1-ndesaulniers@google.com>
Message-Id: <20201104005343.4192504-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAK7LNAST0Ma4bGGOA_HATzYAmRhZG=x_X=8p_9dKGX7bYc2FMA@mail.gmail.com>
 <20201104005343.4192504-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH v2 1/4] x86_64: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Jakub Jelinek <jakub@redhat.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-toolchains@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Alistair Delva <adelva@google.com>,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

Commit 393f203f5fd5 ("x86_64: kasan: add interceptors for
memset/memmove/memcpy functions") added .weak directives to
arch/x86/lib/mem*_64.S instead of changing the existing ENTRY macros to
WEAK. This can lead to the assembly snippet `.weak memcpy ... .globl
memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
https://reviews.llvm.org/D90108) will error on such an overridden symbol
binding.

Commit ef1e03152cb0 ("x86/asm: Make some functions local") changed ENTRY in
arch/x86/lib/memcpy_64.S to SYM_FUNC_START_LOCAL, which was ineffective due to
the preceding .weak directive.

Use the appropriate SYM_FUNC_START_WEAK instead.

Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")
Fixes: ef1e03152cb0 ("x86/asm: Make some functions local")
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/lib/memcpy_64.S  | 4 +---
 arch/x86/lib/memmove_64.S | 4 +---
 arch/x86/lib/memset_64.S  | 4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 037faac46b0c..1e299ac73c86 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -16,8 +16,6 @@
  * to a jmp to memcpy_erms which does the REP; MOVSB mem copy.
  */
 
-.weak memcpy
-
 /*
  * memcpy - Copy a memory block.
  *
@@ -30,7 +28,7 @@
  * rax original destination
  */
 SYM_FUNC_START_ALIAS(__memcpy)
-SYM_FUNC_START_LOCAL(memcpy)
+SYM_FUNC_START_WEAK(memcpy)
 	ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
 		      "jmp memcpy_erms", X86_FEATURE_ERMS
 
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 7ff00ea64e4f..41902fe8b859 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -24,9 +24,7 @@
  * Output:
  * rax: dest
  */
-.weak memmove
-
-SYM_FUNC_START_ALIAS(memmove)
+SYM_FUNC_START_WEAK(memmove)
 SYM_FUNC_START(__memmove)
 
 	mov %rdi, %rax
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 9ff15ee404a4..0bfd26e4ca9e 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -6,8 +6,6 @@
 #include <asm/alternative-asm.h>
 #include <asm/export.h>
 
-.weak memset
-
 /*
  * ISO C memset - set a memory block to a byte value. This function uses fast
  * string to get better performance than the original function. The code is
@@ -19,7 +17,7 @@
  *
  * rax   original destination
  */
-SYM_FUNC_START_ALIAS(memset)
+SYM_FUNC_START_WEAK(memset)
 SYM_FUNC_START(__memset)
 	/*
 	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
-- 
2.29.1.341.ge80a0c044ae-goog

