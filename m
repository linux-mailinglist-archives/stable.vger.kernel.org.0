Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E10145262
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbfFNDMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:06 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39349 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so674080pgc.6
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vMZj+hWBB8samdoJQ8dZeG0SPfvI6Nq94YHPh34WYvc=;
        b=qZTuV61HYt+mNEoxm47Arta+AvblJfpAXxtCf6Cy9Jj4OYBf9JT63spIYo7L/86a4z
         olm2CItSss1P/Qsl2f/9/OaCleH8YTNnNXwpDUztGYGNa04ADDli3hNx2gRukRBDF3cr
         puxxMINy4NvrMY1CXjJVzEazG7hiYpIv7CatQve8ja1UZsQ7Ju1j2lOgy8gB90Lvdqqv
         zNhIv9wDAvvABCdcA9VWXC4vifs1DMd9mZo7zIj7T7O5Ka3VgZX6An0RXDF54mBMCm6T
         eQSXsZ1vxFBb1gplCgCAZkENcz2Tandan0zhMICsIWRTrQAESmvjuwRE539lEHy1LqhE
         QahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vMZj+hWBB8samdoJQ8dZeG0SPfvI6Nq94YHPh34WYvc=;
        b=qVaDGrMX4ZtsBEqoB759D1yp8kswy6VWY6zNtdPj5ZH/BACHr6tWePPXCUYA2FHiQ/
         Dhz9Bs1ZbtvpIhkby79kphl9ZArD34bEDc19JBhxYe5KqrmaSGRmY69M/LvGDU2582TZ
         aM8xWz5JjDSWnIcnCLQUADFlBK1tA6LRYCzQfYZLZr0zzsP4gV7xo2fmRWZhDBh7NUzf
         eWZa/jhJFIGJgwnJVZ8B2aynXNx2n78rFFJwOiReQiE6S+nnHoLuisJ9uriCEEA0s1Fd
         Gdk56QQv/q0vU6Nxkdxz7JJCqdYgxJQzQH1fAo++CxrOdQ3m09oYSFJ6sAHypGwA5hu3
         xZwQ==
X-Gm-Message-State: APjAAAXp1KZqZ+sQOD6PXDMlNO+l+Z0h7IcOXvcAYnNS0RoZU7KFw5ov
        YQN4QLoxixfv1jOkSjx6sFAPgw==
X-Google-Smtp-Source: APXvYqwqQ0yet8UnqoAPnV8oW4AYrTo0RPoqjWqgR9pZ3WiS8ZrQ3aC619e+Z6q0Bmnv8ia0BZHdNA==
X-Received: by 2002:aa7:8acb:: with SMTP id b11mr95598816pfd.115.1560481924997;
        Thu, 13 Jun 2019 20:12:04 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id z2sm579066pgg.58.2019.06.13.20.12.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:04 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 04/45] arm64: move TASK_* definitions to <asm/processor.h>
Date:   Fri, 14 Jun 2019 08:37:47 +0530
Message-Id: <8e205c0d0442af886efa2996d6149ce9dbec39ce.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yury Norov <ynorov@caviumnetworks.com>

commit eef94a3d09aab437c8c254de942d8b1aa76455e2 upstream.

ILP32 series [1] introduces the dependency on <asm/is_compat.h> for
TASK_SIZE macro. Which in turn requires <asm/thread_info.h>, and
<asm/thread_info.h> include <asm/memory.h>, giving a circular dependency,
because TASK_SIZE is currently located in <asm/memory.h>.

In other architectures, TASK_SIZE is defined in <asm/processor.h>, and
moving TASK_SIZE there fixes the problem.

Discussion: https://patchwork.kernel.org/patch/9929107/

[1] https://github.com/norov/linux/tree/ilp32-next

CC: Will Deacon <will.deacon@arm.com>
CC: Laura Abbott <labbott@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/memory.h    | 15 ---------------
 arch/arm64/include/asm/processor.h | 21 +++++++++++++++++++++
 arch/arm64/kernel/entry.S          |  2 +-
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index b42b930cc19a..959a1e9188fe 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -43,8 +43,6 @@
  *		 (VA_BITS - 1))
  * VA_BITS - the maximum number of bits for virtual addresses.
  * VA_START - the first kernel virtual address.
- * TASK_SIZE - the maximum size of a user space task.
- * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
  * The module space lives between the addresses given by TASK_SIZE
  * and PAGE_OFFSET - it must be within 128MB of the kernel text.
  */
@@ -58,19 +56,6 @@
 #define PCI_IO_END		(MODULES_VADDR - SZ_2M)
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
 #define FIXADDR_TOP		(PCI_IO_START - SZ_2M)
-#define TASK_SIZE_64		(UL(1) << VA_BITS)
-
-#ifdef CONFIG_COMPAT
-#define TASK_SIZE_32		UL(0x100000000)
-#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
-				TASK_SIZE_32 : TASK_SIZE_64)
-#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
-				TASK_SIZE_32 : TASK_SIZE_64)
-#else
-#define TASK_SIZE		TASK_SIZE_64
-#endif /* CONFIG_COMPAT */
-
-#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
 
 /*
  * Physical vs virtual RAM address space conversion.  These are
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index b1126eea73ae..12d5b2b97f04 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -19,6 +19,10 @@
 #ifndef __ASM_PROCESSOR_H
 #define __ASM_PROCESSOR_H
 
+#define TASK_SIZE_64		(UL(1) << VA_BITS)
+
+#ifndef __ASSEMBLY__
+
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
@@ -35,6 +39,22 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
+/*
+ * TASK_SIZE - the maximum size of a user space task.
+ * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
+ */
+#ifdef CONFIG_COMPAT
+#define TASK_SIZE_32		UL(0x100000000)
+#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
+				TASK_SIZE_32 : TASK_SIZE_64)
+#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
+				TASK_SIZE_32 : TASK_SIZE_64)
+#else
+#define TASK_SIZE		TASK_SIZE_64
+#endif /* CONFIG_COMPAT */
+
+#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
+
 #define STACK_TOP_MAX		TASK_SIZE_64
 #ifdef CONFIG_COMPAT
 #define AARCH32_VECTORS_BASE	0xffff0000
@@ -186,4 +206,5 @@ static inline void spin_lock_prefetch(const void *x)
 
 int cpu_enable_pan(void *__unused);
 
+#endif /* __ASSEMBLY__ */
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 586326981769..c849be9231bb 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -27,7 +27,7 @@
 #include <asm/cpufeature.h>
 #include <asm/errno.h>
 #include <asm/esr.h>
-#include <asm/memory.h>
+#include <asm/processor.h>
 #include <asm/thread_info.h>
 #include <asm/asm-uaccess.h>
 #include <asm/unistd.h>
-- 
2.21.0.rc0.269.g1a574e7a288b

