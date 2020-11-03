Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4067B2A3942
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgKCBYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbgKCBYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 20:24:18 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C62BC0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 17:24:18 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id u16so9868236qkm.22
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 17:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=BN0F7yyrVYxdknpr1rsFOSFEJ7httujvVbxZ/VWAHPE=;
        b=by5ZHAfa24D/MMmqYUhwUwxiDfKZrvxlrKsXM/ezLPzD9dsGTuOAgh8ZUOMhoLAJ/U
         x/qW1n1v5AMtSv5IZEcNTddQzS4E/kUXTVR3cVzRYt9a1SF2D8Y2vKe1HDtlG7a5uJet
         5EczKk7F3wEeXTG0Lnl98XZelfMTbcU4ThEucK5ocVZTq/gyfKXIGYCKGoogmiHtQj1w
         SRz0KXX6EORGP4bVTV+9b3vYMW0tcUc7z0lTpIt9SvmtkV5L541l8AB7Aeto9MUYYEFq
         8069XgbDaJlT7uWCBxSvianENuDriDChXzJZUpdPGLbVkBbTNlHC1u2v0/hG0HQ7IWyZ
         MyIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=BN0F7yyrVYxdknpr1rsFOSFEJ7httujvVbxZ/VWAHPE=;
        b=VyDfE2PTccbpasNe8JJ9xo2ohTSKV0k7JpjcG3U+TrTE4fUHEvIvEiQnnBFo/3G1kA
         8jqWcFxCjwcGcbvr40XpkFk6sCRRTkyRxePTN8pseDY8nUSu5iU5dCVM9uN/EyhsRvEB
         0TtMULigH3rCF5YcVvjlJ1fxMDDvfpsR1titUv8wO1cFSdA/Ki8d9JpaRASDorNIZ1iP
         MCH3b9VnmvFQtpHP2j0VIqQwZcvlEIAlugC6pxsaqjo3l2E/wQPT6xtFbgqeujwdNc63
         OAsl5dfq0xAKG7IfuUny6ogU7xw/rompQwzpYfVJ9LGHMT+m0f1VOOyVeWg9eTm2BfEm
         FnsA==
X-Gm-Message-State: AOAM532GnXIkq1xwYNvynzN2Z0cvpQ5Sg+ScNOJmSgL3oJoT168Wqw7c
        jU2EUH8LT6uNbDs0je4d+FPvR5qlkTDK
X-Google-Smtp-Source: ABdhPJx9qwE2i3z/UHQoN+soglCVnmLgR6LHeYHTby9zZX1PjOOkoA67jB41ZXn0ujVUfPou7OCth/YvZqcI
Sender: "maskray via sendgmr" <maskray@maskray1.svl.corp.google.com>
X-Received: from maskray1.svl.corp.google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
 (user=maskray job=sendgmr) by 2002:a0c:b897:: with SMTP id
 y23mr18028003qvf.60.1604366657094; Mon, 02 Nov 2020 17:24:17 -0800 (PST)
Date:   Mon,  2 Nov 2020 17:23:58 -0800
Message-Id: <20201103012358.168682-1-maskray@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH v2] x86_64: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S
From:   Fangrui Song <maskray@google.com>
To:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     clang-built-linux@googlegroups.com, Jian Cai <jiancai@google.com>,
        Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
---
Changes in v2
* Correct the message: SYM_FUNC_START_WEAK was not available at commit 393f203f5fd5.
* Mention Fixes: ef1e03152cb0
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

