Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EE32FA24C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 14:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392537AbhARN5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 08:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392529AbhARN5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 08:57:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5CC6221F8;
        Mon, 18 Jan 2021 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610978229;
        bh=sktShgX6RCXBHxlq9b/brFn15NcU/CnqgAeNbrpoabE=;
        h=From:To:Cc:Subject:Date:From;
        b=F7oIietyOrCBA0W4hUBXzBldgH/jT2fIMY2boP0XgnAkbRIXJGcczRIJF8izLFn/C
         M5l5CNhHU+iZEnC53ZhjMQK91J9pCUUeyJ8qj1YxgNd16vaW5qo5qNs+l1eVPfiavT
         0gFm/qAGQdVHaJKpoil4sb83VM1gKDk71F04QzPtr1vxnYHRSggrFh2OJDC//jWw6i
         8jTWmxWN8mvT3Nq65tM0Nd/ZntIpkZmRM1+5XFmuwl9hMbYzN0kU0D+xm1fzLTTsjh
         rmSg1TuUTKdWERwOk8ry2hUlEPjTu14H6YOpIPQ6VcUDcPRKtyzgEEvR7YKrEVB82S
         YfaYUab31nq9A==
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
Subject: [STABLE BACKPORT 4.19.y and 5.14.y] compiler.h: Raise minimum version of GCC to 5.1 for arm64
Date:   Mon, 18 Jan 2021 13:57:00 +0000
Message-Id: <20210118135700.17447-1-will@kernel.org>
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
Cc: <stable@vger.kernel.org> # 4.19.y and 5.4.y only
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20210105154726.GD1551@shell.armlinux.org.uk
Link: https://lore.kernel.org/r/20210112224832.10980-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[will: backport to 4.19.y/5.4.y]
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/compiler-gcc.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 14be09537109..a80d6de3c8ad 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -12,6 +12,12 @@
 
 #if GCC_VERSION < 40600
 # error Sorry, your compiler is too old - please upgrade it.
+#elif defined(CONFIG_ARM64) && GCC_VERSION < 50100
+/*
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63293
+ * https://lore.kernel.org/r/20210107111841.GN1551@shell.armlinux.org.uk
+ */
+# error Sorry, your version of GCC is too old - please use 5.1 or newer.
 #endif
 
 /*
-- 
2.30.0.284.gd98b1dd5eaa7-goog

