Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743141332D9
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgAGVJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgAGVJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D7852077B;
        Tue,  7 Jan 2020 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431379;
        bh=Q76nd1rY7PubR1tz37aB6Z90FHySurzEY50SY9L8GaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVe7QEpAmDElS216yw8J25jZekq+lUc4pC/2HO1T/WDnOWC33w0HZo8s/cbHfzgDG
         pRm1f44AtkXbqF5hEogw9R3yK2wU+Ot52s4TPVjXEacjZlBGbAxgFDJP0Fe68zJg1+
         xUq8dgxLjEdpXMj8BjLQ9f8eQozD0B8lPbTebyOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-mips@vger.kernel.org
Subject: [PATCH 4.14 25/74] MIPS: Avoid VDSO ABI breakage due to global register variable
Date:   Tue,  7 Jan 2020 21:54:50 +0100
Message-Id: <20200107205155.093712308@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
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
@@ -52,8 +52,26 @@ struct thread_info {
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
 
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


