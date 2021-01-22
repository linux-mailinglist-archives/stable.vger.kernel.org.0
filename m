Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ECE300FD2
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 23:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbhAVT45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727869AbhAVOKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:10:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EDC923A6A;
        Fri, 22 Jan 2021 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324560;
        bh=KAkjzOBtXldkxQV3S9hnXuJJoDsRFiDiuXFWx2/s5j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpc3OG6QTDJRLljuEaNutOX52vvSveaK0Lps83xHFbOh9gkEHCC7zr8UxMmMzXz42
         xK6gjJZajbmfHuTRYCaUBsimXjbMBt7YSgsEH1IDBb/fL6B3rNl+N8uQAAxejgzl8n
         wR4Pf89YT63ds1ZTE8Qc8VvlISnpD3ovIgzNG+pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>, Will Deacon <will@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.4 20/31] compiler.h: Raise minimum version of GCC to 5.1 for arm64
Date:   Fri, 22 Jan 2021 15:08:34 +0100
Message-Id: <20210122135732.683452710@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

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
Cc: <stable@vger.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20210105154726.GD1551@shell.armlinux.org.uk
Link: https://lore.kernel.org/r/20210112224832.10980-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[will: backport to 4.4.y/4.9.y/4.14.y]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler-gcc.h |    6 ++++++
 1 file changed, 6 insertions(+)

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


