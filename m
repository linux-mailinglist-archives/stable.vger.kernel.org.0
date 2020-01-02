Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9AA12E26C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 05:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgABEsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 23:48:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37532 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgABEsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 23:48:22 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so21343532pga.4;
        Wed, 01 Jan 2020 20:48:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B7VbcHmZbM3YsGNwkGdEQ8Jr7FxCK1RfjAyLy6V4uRU=;
        b=I6YPOk0FCuNMJTPGCC25jH5nUjKrUOVOohhy+eCyn/qs+zqBr600RclrzeTcjwpMxE
         bbTuFv4TK/YF4gNtaIr09TP/l2iGH6x1ad1LM4ciKytel+6W5ePw85Ec1pXPaqQAoFaW
         +HZZ29Jc2KSbnTBUnnDf21urrYqaoVs7diJloZQViIt2ZvKEiLSPB6DngW/HZ5mJ3Vnf
         jnd3pYvWlFuba7WAru6BqCfN2QnuXpQnREJ0axWaNjrPKCjUbNpSUO+sd6BTESb/Klcp
         0PLS8dlbPND2WjHAOxr1AiWNpueUfXEGzay3cmeGRvSZqpMafXODHKxg5grkNll0884F
         aZtA==
X-Gm-Message-State: APjAAAUHQbUPGa72QY8r7lqz8n4mAc6x+X+W0gBuNBHhmlcGsRTCl2Xu
        Fc6t5iMhhXAMugLJbbnQfqKWdCCBNU9Rkox/
X-Google-Smtp-Source: APXvYqxK9iMqZLXVnHDdjdCQZ7AhzV5WtLxYWtjbvQVsPwWaW7Y1wFjlXxKkXomeYr+p46wHO4P/vA==
X-Received: by 2002:aa7:9d9c:: with SMTP id f28mr86834652pfq.20.1577940501206;
        Wed, 01 Jan 2020 20:48:21 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id a10sm58253531pgm.81.2020.01.01.20.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 20:48:20 -0800 (PST)
From:   Paul Burton <paulburton@kernel.org>
To:     linux-mips@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] MIPS: Avoid VDSO ABI breakage due to global register variable
Date:   Wed,  1 Jan 2020 20:50:38 -0800
Message-Id: <20200102045038.102772-1-paulburton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102005343.GA495913@rani.riverdale.lan>
References: <20200102005343.GA495913@rani.riverdale.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Reported-by: "Jason A. Donenfeld" <Jason@zx2c4.com>
Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <christian.brauner@canonical.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org> # v4.4+
---
Changes in v2:
- Switch to the #ifdef __VDSO__ approach rather than using a local
  register variable which clang doesn't support.
---
 arch/mips/include/asm/thread_info.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 4993db40482c..ee26f9a4575d 100644
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
-- 
2.24.1

