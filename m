Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552287D758
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfHAIV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35392 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfHAIV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so27433661pgr.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q2P7nbVondTzzEiUufavLpCtXHz6lnekor7t8KaG36c=;
        b=pTRCSsFiNu8OBieM4n9EH1oBWaf9DxqQrE8qfxItoRa9cD/Spg5spSoIPphBVmAIai
         rokTXzv97smMqkOdkzzyKoEUTdP3B+H++HwiH9+qNX60puKsd6dpA61w4Dn6n2GhvmH7
         cVxFAgwWjdW1QLRyXVrIBUPaKR73xXXmvr5m7gAwvGcGLbJ39BMne+Xfj7MVv0Bh6mQj
         KcbBBnVOhhBhVRn/Ry9JiNyiQfHvZeqhXZzhDIblc8b020MRzcQ8Z+yxtBM52JqBNwYh
         HZWPgcTne1OqI6kvSgxDABJIJzN9Kahd5jeUObH6yW4QM1CbXdAxwjYLazDrslXSI564
         gDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2P7nbVondTzzEiUufavLpCtXHz6lnekor7t8KaG36c=;
        b=PktlvLVBzCm+d1oBmKtJJKKcIxsVIiiLivY9rTH9ZJLbzAZfZyRcXyZ0ysKLtgGpDB
         TtoZ38DGGCPH+tIUcpEX5ZcX6EDAhoCtLMLQofjEFBukB189GIJZPkhbegtWBqZCdso4
         S+nf0/DfRYQR5dxj4zTEP+k5eq0d7jNjv2mlAnRqLbT+hBJQqawmmivWboaNt0tUwbVU
         F/ItZUwIsz1TpszxmuXD3q2b/gyWSEOSuUS6cs+C5gJdLk/8+X3BTTX8Yl5Ve/uFrCFZ
         XlRw/+zDEf3Uvg/SiYXwNqub+pP0mQDZOT7CleZpY8Uc9Sz8pl2AkVyA4wbx3ykzKukC
         cM3w==
X-Gm-Message-State: APjAAAWhxZvoEcJ+x6D8mayGXPxYMuWw5mPVXIJ3rm3MStwAivrR107J
        rAfbHqCUXw03zqt+A6jCRj1mfGzPU9Y=
X-Google-Smtp-Source: APXvYqyinL72Ad1WC23YEaPJqW0xWZohjAv/ucPmvqt5ElYyOzPq0U5gBpJHjgVmPygyojXAbQoijA==
X-Received: by 2002:a63:6206:: with SMTP id w6mr1819946pgb.428.1564647686306;
        Thu, 01 Aug 2019 01:21:26 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id u7sm64635107pfm.96.2019.08.01.01.21.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:25 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 43/47] arch: Introduce post-init read-only memory
Date:   Thu,  1 Aug 2019 13:46:27 +0530
Message-Id: <e67e17015952a4c4b1cca19756d3c5c14153b33c.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Commit c74ba8b3480da6ddaea17df2263ec09b869ac496 upstream.

One of the easiest ways to protect the kernel from attack is to reduce
the internal attack surface exposed when a "write" flaw is available. By
making as much of the kernel read-only as possible, we reduce the
attack surface.

Many things are written to only during __init, and never changed
again. These cannot be made "const" since the compiler will do the wrong
thing (we do actually need to write to them). Instead, move these items
into a memory region that will be made read-only during mark_rodata_ro()
which happens after all kernel __init code has finished.

This introduces __ro_after_init as a way to mark such memory, and adds
some documentation about the existing __read_mostly marking.

This improves the security of the Linux kernel by marking formerly
read-write memory regions as read-only on a fully booted up system.

Based on work by PaX Team and Brad Spengler.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: David Brown <david.brown@linaro.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-hardening@lists.openwall.com
Cc: linux-arch <linux-arch@vger.kernel.org>
Link: http://lkml.kernel.org/r/1455748879-21872-5-git-send-email-keescook@chromium.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/parisc/include/asm/cache.h   |  3 +++
 include/asm-generic/vmlinux.lds.h |  1 +
 include/linux/cache.h             | 14 ++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/parisc/include/asm/cache.h b/arch/parisc/include/asm/cache.h
index 3d0e17bcc8e9..df0f52bd18b4 100644
--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -22,6 +22,9 @@
 
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
+/* Read-only memory is marked before mark_rodata_ro() is called. */
+#define __ro_after_init	__read_mostly
+
 void parisc_cache_init(void);	/* initializes cache-flushing */
 void disable_sr_hashing_asm(int); /* low level support for above */
 void disable_sr_hashing(void);   /* turns off space register hashing */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a461b6604fd9..c63f92150eda 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -256,6 +256,7 @@
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
+		*(.data..ro_after_init)	/* Read only after init */	\
 		*(__vermagic)		/* Kernel version magic */	\
 		. = ALIGN(8);						\
 		VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;		\
diff --git a/include/linux/cache.h b/include/linux/cache.h
index 17e7e82d2aa7..1be04f8c563a 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -12,10 +12,24 @@
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 #endif
 
+/*
+ * __read_mostly is used to keep rarely changing variables out of frequently
+ * updated cachelines. If an architecture doesn't support it, ignore the
+ * hint.
+ */
 #ifndef __read_mostly
 #define __read_mostly
 #endif
 
+/*
+ * __ro_after_init is used to mark things that are read-only after init (i.e.
+ * after mark_rodata_ro() has been called). These are effectively read-only,
+ * but may get written to during init, so can't live in .rodata (via "const").
+ */
+#ifndef __ro_after_init
+#define __ro_after_init __attribute__((__section__(".data..ro_after_init")))
+#endif
+
 #ifndef ____cacheline_aligned
 #define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
 #endif
-- 
2.21.0.rc0.269.g1a574e7a288b

