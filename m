Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4255D2FA23D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 14:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392503AbhARNzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 08:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392423AbhARNzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 08:55:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A8B72225C;
        Mon, 18 Jan 2021 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610978079;
        bh=Zgp6oPRleT8q3XNHbBe3iby58DT4TI2i6w1BoM9t8YA=;
        h=From:To:Cc:Subject:Date:From;
        b=JcG5CdDGxDvYL6EoaLGrtKiN8/LI7sg0B4FWTabbtbnZLhEnPUZW924pNJ7T2MX2v
         v5tiit9TPc+jEV8gEAMkuqQapXcEcAiLBqyiQ26XeIH3LwXARAr4AC40RYf3LJSC5o
         OT4PJO/5xxnhMZ5vUWvKgCRPORDhSfp/aW5NcRwZvRPe23O0kZF5nUmVTblSclJtxR
         P7HH+aHQ4eWXzIyHqsZ17THrydTvoyxrBkOgOI4DGmHNMpVD5HAnw9oPaBQZoIGyVE
         8gkKxXdfdwYT9l53eqap06QwnXVEw7ZOtEoJRuVTA/19KaX41lDa1ubCUXgztwYSdP
         Q5FhAvkZCh5Ug==
From:   Will Deacon <will@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [STABLE BACKPORT 4.4.y, 4.9.y and 4.14.y] compiler.h: Raise minimum version of GCC to 5.1 for arm64
Date:   Mon, 18 Jan 2021 13:54:25 +0000
Message-Id: <20210118135426.17372-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit dca5244d2f5b94f1809f0c02a549edf41ccd5493 upstream.

GCC versions >= 4.9 and < 5.1 have been shown to emit memory references
beyond the stack pointer, resulting in memory corruption if an interrupt
is taken after the stack pointer has been adjusted but before the
reference has been executed. This leads to subtle, infrequent data
corruption such as the EXT4 problems reported by Russell King at the
link below.

Life is too short for buggy compilers, so raise the minimum GCC version
required by arm64 to 5.1.

Reported-by: Russell King <linux@armlinux.org.uk>
Suggested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 4.4.y, 4.9.y and 4.14.y only
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20210105154726.GD1551@shell.armlinux.org.uk
Link: https://lore.kernel.org/r/20210112224832.10980-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[will: backport to 4.4.y/4.9.y/4.14.y]
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/compiler-gcc.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index af8b4a879934..3cc8adede67b 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -145,6 +145,12 @@
 
 #if GCC_VERSION < 30200
 # error Sorry, your compiler is too old - please upgrade it.
+#elif defined(CONFIG_ARM64) && GCC_VERSION < 50100
+/*
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63293
+ * https://lore.kernel.org/r/20210107111841.GN1551@shell.armlinux.org.uk
+ */
+# error Sorry, your version of GCC is too old - please use 5.1 or newer.
 #endif
 
 #if GCC_VERSION < 30300
-- 
2.30.0.284.gd98b1dd5eaa7-goog

