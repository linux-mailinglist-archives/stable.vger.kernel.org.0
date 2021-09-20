Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E744123E6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379205AbhITS2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378789AbhITS00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851AD632DB;
        Mon, 20 Sep 2021 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158754;
        bh=5vfnFv5YTe1smOkZHNVJBYzX67YVWPYp3juTMNgC++Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwzBgkqPMh3bqQG4wmgXcnkjxKdZYoQFj3HGTYw2Wns50EtQ2+i2b29oej84qHpCN
         C8J73T/Ea6XFParTsSAwPReRLsPm9V4PwQBCZkF1pK1lFVjdwO3M7TC8Meykh5wkAE
         igD78k9SpGDyUfOrTfMs6psSwXBR5DnMeEHRvVO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bill Wendling <morbo@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 041/122] x86/uaccess: Fix 32-bit __get_user_asm_u64() when CC_HAS_ASM_GOTO_OUTPUT=y
Date:   Mon, 20 Sep 2021 18:43:33 +0200
Message-Id: <20210920163917.135546735@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit a69ae291e1cc2d08ae77c2029579c59c9bde5061 upstream.

Commit 865c50e1d279 ("x86/uaccess: utilize CONFIG_CC_HAS_ASM_GOTO_OUTPUT")
added an optimised version of __get_user_asm() for x86 using 'asm goto'.

Like the non-optimised code, the 32-bit implementation of 64-bit
get_user() expands to a pair of 32-bit accesses.  Unlike the
non-optimised code, the _original_ pointer is incremented to copy the
high word instead of loading through a new pointer explicitly
constructed to point at a 32-bit type.  Consequently, if the pointer
points at a 64-bit type then we end up loading the wrong data for the
upper 32-bits.

This was observed as a mount() failure in Android targeting i686 after
b0cfcdd9b967 ("d_path: make 'prepend()' fill up the buffer exactly on
overflow") because the call to copy_from_kernel_nofault() from
prepend_copy() ends up in __get_kernel_nofault() and casts the source
pointer to a 'u64 __user *'.  An attempt to mount at "/debug_ramdisk"
therefore ends up failing trying to mount "/debumdismdisk".

Use the existing '__gu_ptr' source pointer to unsigned int for 32-bit
__get_user_asm_u64() instead of the original pointer.

Cc: Bill Wendling <morbo@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 865c50e1d279 ("x86/uaccess: utilize CONFIG_CC_HAS_ASM_GOTO_OUTPUT")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -301,8 +301,8 @@ do {									\
 	unsigned int __gu_low, __gu_high;				\
 	const unsigned int __user *__gu_ptr;				\
 	__gu_ptr = (const void __user *)(ptr);				\
-	__get_user_asm(__gu_low, ptr, "l", "=r", label);		\
-	__get_user_asm(__gu_high, ptr+1, "l", "=r", label);		\
+	__get_user_asm(__gu_low, __gu_ptr, "l", "=r", label);		\
+	__get_user_asm(__gu_high, __gu_ptr+1, "l", "=r", label);	\
 	(x) = ((unsigned long long)__gu_high << 32) | __gu_low;		\
 } while (0)
 #else


