Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0732F9E8E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390309AbhARLnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390815AbhARLnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6434D22573;
        Mon, 18 Jan 2021 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970173;
        bh=mYeu+wPSmKow5purnFSA8na6KJAizKa/dfDCL08jO0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVrhb4oKN7FFgQq36fUJ6Dajhz3om41S00s557H1ynZ+Tu2r0qP8T7GadpcghIRvQ
         dMs4EQW8fOQDztmr4SQs8WcSzoIncta49QBpNIoF6Ds5n0vQbZv+f3JDzv3wcovo4R
         emJR/OExQq/6l+dKS7EH3YvqaggL/GY6/ln+SH+4=
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
Subject: [PATCH 5.10 037/152] compiler.h: Raise minimum version of GCC to 5.1 for arm64
Date:   Mon, 18 Jan 2021 12:33:32 +0100
Message-Id: <20210118113354.561611007@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler-gcc.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -13,6 +13,12 @@
 /* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145 */
 #if GCC_VERSION < 40900
 # error Sorry, your version of GCC is too old - please use 4.9 or newer.
+#elif defined(CONFIG_ARM64) && GCC_VERSION < 50100
+/*
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63293
+ * https://lore.kernel.org/r/20210107111841.GN1551@shell.armlinux.org.uk
+ */
+# error Sorry, your version of GCC is too old - please use 5.1 or newer.
 #endif
 
 /*


