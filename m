Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2E5133475
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgAGU7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbgAGU7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BEC1214D8;
        Tue,  7 Jan 2020 20:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430746;
        bh=w7hS21l4Ab8SljiLavSQJM154nNNKvNmXLEasB/FU8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3QO+wRPXOoG6dc/y/TXyBt+G1gyyzcjHvuXM1gp780beIDzwvhyAFpK/tD8wRuQJ
         JcegRWlyj5PPE54O1JZEgRAI2ekYtoPsyaE77iccumG7oPrBep+vBn1oinxKW7ADit
         UpM15AwTG6H74uNGdoVE167xm89pWDyzyxE5AUzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-mips@vger.kernel.org
Subject: [PATCH 5.4 078/191] MIPS: Avoid VDSO ABI breakage due to global register variable
Date:   Tue,  7 Jan 2020 21:53:18 +0100
Message-Id: <20200107205337.156961744@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paulburton@kernel.org>

commit bbcc5672b0063b0e9d65dc8787a4f09c3b5bb5cc upstream.

Declaring __current_thread_info as a global register variable has the
effect of preventing GCC from saving & restoring its value in cases
where the ABI would typically do so.

To quote GCC documentation:

> If the register is a call-saved register, call ABI is affected: the
> register will not be restored in function epilogue sequences after the
> variable has been assigned. Therefore, functions cannot safely return
> to callers that assume standard ABI.

When our position independent VDSO is built for the n32 or n64 ABIs all
functions it exposes should be preserving the value of $gp/$28 for their
caller, but in the presence of the __current_thread_info global register
variable GCC stops doing so & simply clobbers $gp/$28 when calculating
the address of the GOT.

In cases where the VDSO returns success this problem will typically be
masked by the caller in libc returning & restoring $gp/$28 itself, but
that is by no means guaranteed. In cases where the VDSO returns an error
libc will typically contain a fallback path which will now fail
(typically with a bad memory access) if it attempts anything which
relies upon the value of $gp/$28 - eg. accessing anything via the GOT.

One fix for this would be to move the declaration of
__current_thread_info inside the current_thread_info() function,
demoting it from global register variable to local register variable &
avoiding inadvertently creating a non-standard calling ABI for the VDSO.
Unfortunately this causes issues for clang, which doesn't support local
register variables as pointed out by commit fe92da0f355e ("MIPS: Changed
current_thread_info() to an equivalent supported by both clang and GCC")
which introduced the global register variable before we had a VDSO to
worry about.

Instead, fix this by continuing to use the global register variable for
the kernel proper but declare __current_thread_info as a simple extern
variable when building the VDSO. It should never be referenced, and will
cause a link error if it is. This resolves the calling convention issue
for the VDSO without having any impact upon the build of the kernel
itself for either clang or gcc.

Signed-off-by: Paul Burton <paulburton@kernel.org>
Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <christian.brauner@canonical.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org> # v4.4+
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/thread_info.h |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -49,8 +49,26 @@ struct thread_info {
 	.addr_limit	= KERNEL_DS,		\
 }
 
-/* How to get the thread information struct from C.  */
+/*
+ * A pointer to the struct thread_info for the currently executing thread is
+ * held in register $28/$gp.
+ *
+ * We declare __current_thread_info as a global register variable rather than a
+ * local register variable within current_thread_info() because clang doesn't
+ * support explicit local register variables.
+ *
+ * When building the VDSO we take care not to declare the global register
+ * variable because this causes GCC to not preserve the value of $28/$gp in
+ * functions that change its value (which is common in the PIC VDSO when
+ * accessing the GOT). Since the VDSO shouldn't be accessing
+ * __current_thread_info anyway we declare it extern in order to cause a link
+ * failure if it's referenced.
+ */
+#ifdef __VDSO__
+extern struct thread_info *__current_thread_info;
+#else
 register struct thread_info *__current_thread_info __asm__("$28");
+#endif
 
 static inline struct thread_info *current_thread_info(void)
 {


