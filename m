Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C311B29F3DB
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 19:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgJ2SLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 14:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgJ2SFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 14:05:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C17C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:05:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z11so2596141pln.0
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=TFVBAa3RYz8IYFna+GiAaNLsKOoOUuSXlq1eujs3Qh8=;
        b=Juj++IZc3lSNCiiQKlsX2xGGWtciIsFGhkU/BjW/dVuczbq/r6kIb7sv+OiBmt2Fum
         wy3QTRkVqAQ8r6R8auKz9HldWIqqUZYndKCC5iYT63FW5zMYw+Wf5i32VZlrUP6vyeC2
         PE2JmUni9inhxWko4FzPxEhTpqLDIzecIAij28IYgJkmto3eLVN3UwLjxNRhqbNFrPp9
         hAyHSL0//CuYgoI3z2GhNtLCq8gQcuuONoNHmmLoFfzZ9DiqZcQc7TonASNgMFGbMhMR
         BOFUlZwyJZ468+Yru01BuFvxAViVHh3JCdEJTIDPrWWh7XmARQ53PjL13bfkuZlc3lZV
         g37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=TFVBAa3RYz8IYFna+GiAaNLsKOoOUuSXlq1eujs3Qh8=;
        b=CnTWghI3gCZGOjlXr8ZAdsoJCT6q2u4n4L9dKPnx4rfk2qvEpEaLryNSf3tiVkdU78
         x2daJMGV9Wi5IfciuX48YZkbBahWiCHAGqtachP+htyiGzTZv9fE4N+pQOdA4BrSPoz+
         fb/cKBi8NanJ25/5fuwMj7w2OvsTPgTMd3Hq6MVSkekgrz7m2b+ZbeZK9qIsMYEpYjx3
         s8fyaGgMK6qIHoGu+NYqEtCPjEwtabTxlg6/0rJV0XG4BSY9I2jGcfS0wFydTKho7HDR
         aLKlIU5IEhYPe3BDhFTeAcyBo5cr41ur3x9Xslw/KxGFzA7PaDzBSfqNrSxywrK8Jjeu
         e+cg==
X-Gm-Message-State: AOAM533bMJ6EHVYkJoCmiGIKaVkhGYGUuwJFO3GDCNPFYT++ExYVW+H6
        f9yI/bnB5vxGbSzsPl5vv9zd/cA8AM8K
X-Google-Smtp-Source: ABdhPJzi7jxnbvZDKUzR8TxbeI+79bLhBWvevXZpkjf8sMsmi3CeNe4f58x0A/gxVSN7sERoUXIONJFErukz
Sender: "maskray via sendgmr" <maskray@maskray1.svl.corp.google.com>
X-Received: from maskray1.svl.corp.google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
 (user=maskray job=sendgmr) by 2002:a62:4e0f:0:b029:156:13e0:efa7 with SMTP id
 c15-20020a624e0f0000b029015613e0efa7mr5285238pfb.73.1603994731999; Thu, 29
 Oct 2020 11:05:31 -0700 (PDT)
Date:   Thu, 29 Oct 2020 11:05:25 -0700
Message-Id: <20201029180525.1797645-1-maskray@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] x86_64: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S
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
arch/x86/lib/mem*_64.S instead of changing the existing SYM_FUNC_START_*
macros. This can lead to the assembly snippet `.weak memcpy ... .globl
memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
https://reviews.llvm.org/D90108) will error on such an overridden symbol
binding.

Use the appropriate SYM_FUNC_START_WEAK instead.

Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Fangrui Song <maskray@google.com>
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

