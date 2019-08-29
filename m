Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8810A18BF
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfH2LfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40957 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbfH2LfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so1447320pgj.7
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+i1PP70VM4gp+yGXoK79tVzWNeTCN5YHgyu+1fomQgA=;
        b=VUGv1GtX697HgH14HXO402w5rt/hVrHKuxPDrzMYrHA9MNrwKcBeVp5QmFZ0Yn2bIe
         8wm3Gp/vNV/ttw6PDnQWJFwtjUuU7B9ReAuSsbzGHUNGuIB2f5QtbRHwEQ+AMqq/Flyw
         yFaYeLpOJ7nVVGHUDfoh2DV4TWHaKHT43C2xbhddaZgP3nk65dlOe3PMRz9dzfoVlYaK
         j7gyfJzh095YjY0vpih0lyQ75vA9+CzVnxR4U6CUyt7b6Y80gckwZnDAIzSsvP6v8//f
         Rv9wcWgH7Pcrh/MtZItqr3LmAOxBd/IVCOc1edVYJ5ouX+L8qxo0AQAkO7tP2yOagYMJ
         /5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+i1PP70VM4gp+yGXoK79tVzWNeTCN5YHgyu+1fomQgA=;
        b=ZwKIaXSGbVbyUDJ0Z1v7T7Vo7Zg5hTvoK/SeHBfEdkM1SCyiH9XN+vY7EegWi1iWI4
         2hcqfSAoN8bXv35atj+QbcbgjWtiJOP/EprZV+M5qwXdeWdccTeLt+hTZ0wy05nhsWA6
         IAq6x/4Kjc1Z+EYMNg/XYOZ//z3C3RDbp1GDCID7pOAnwpXPGzwlmgxyjMODoEoVRxn3
         xGWkxa6qv6cAsIvwlAg2MzwBGzmO0/VZniVGBys920GD+Whs73VhpkC+iHJP7OcrgP7x
         BFcZwQ1evGZIY3ZhW6Qu5+Cq12jf8oi9yxFcA/oJi+cufQUlR+2/2uqXZ1yAf3/uP4BN
         IW8w==
X-Gm-Message-State: APjAAAX+15EHroog4x7UA5cIIqgN40Li4xo6hc20gyPfSFHRvHKwkr/3
        g0StxZwsLDuwAQPpZ1Z6w1XyR4Wr58o=
X-Google-Smtp-Source: APXvYqy6FKu6fTFxt/X3FC1r+EO8AUYEeqE0ZffTU6mDy/jwg68UlVIQksgaJl20dvMY1UgMrEq0VQ==
X-Received: by 2002:aa7:8d42:: with SMTP id s2mr10851725pfe.185.1567078516102;
        Thu, 29 Aug 2019 04:35:16 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id f12sm2154596pgo.85.2019.08.29.04.35.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:15 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 09/44] mm/kasan: add API to check memory regions
Date:   Thu, 29 Aug 2019 17:03:54 +0530
Message-Id: <ea16af1feddcaa85dc5369c79f78c00256c698cd.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit 64f8ebaf115bcddc4aaa902f981c57ba6506bc42 upstream.

Memory access coded in an assembly won't be seen by KASAN as a compiler
can instrument only C code.  Add kasan_check_[read,write]() API which is
going to be used to check a certain memory range.

Link: http://lkml.kernel.org/r/1462538722-1574-3-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ v4.4: Fixed MAINTAINERS conflict and added whole kasan entry. Drop 4th
	argument to check_memory_region(). ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 MAINTAINERS                  | 14 ++++++++++++++
 include/linux/kasan-checks.h | 12 ++++++++++++
 mm/kasan/kasan.c             | 12 ++++++++++++
 3 files changed, 38 insertions(+)
 create mode 100644 include/linux/kasan-checks.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f4d4a5544dc1..2a8826732967 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5982,6 +5982,20 @@ S:	Maintained
 F:	Documentation/hwmon/k8temp
 F:	drivers/hwmon/k8temp.c
 
+KASAN
+M:	Andrey Ryabinin <aryabinin@virtuozzo.com>
+R:	Alexander Potapenko <glider@google.com>
+R:	Dmitry Vyukov <dvyukov@google.com>
+L:	kasan-dev@googlegroups.com
+S:	Maintained
+F:	arch/*/include/asm/kasan.h
+F:	arch/*/mm/kasan_init*
+F:	Documentation/kasan.txt
+F:	include/linux/kasan*.h
+F:	lib/test_kasan.c
+F:	mm/kasan/
+F:	scripts/Makefile.kasan
+
 KCONFIG
 M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
 L:	linux-kbuild@vger.kernel.org
diff --git a/include/linux/kasan-checks.h b/include/linux/kasan-checks.h
new file mode 100644
index 000000000000..b7f8aced7870
--- /dev/null
+++ b/include/linux/kasan-checks.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_KASAN_CHECKS_H
+#define _LINUX_KASAN_CHECKS_H
+
+#ifdef CONFIG_KASAN
+void kasan_check_read(const void *p, unsigned int size);
+void kasan_check_write(const void *p, unsigned int size);
+#else
+static inline void kasan_check_read(const void *p, unsigned int size) { }
+static inline void kasan_check_write(const void *p, unsigned int size) { }
+#endif
+
+#endif
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index b7397b459960..1cdcab0c976a 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -274,6 +274,18 @@ static __always_inline void check_memory_region(unsigned long addr,
 void __asan_loadN(unsigned long addr, size_t size);
 void __asan_storeN(unsigned long addr, size_t size);
 
+void kasan_check_read(const void *p, unsigned int size)
+{
+	check_memory_region((unsigned long)p, size, false);
+}
+EXPORT_SYMBOL(kasan_check_read);
+
+void kasan_check_write(const void *p, unsigned int size)
+{
+	check_memory_region((unsigned long)p, size, true);
+}
+EXPORT_SYMBOL(kasan_check_write);
+
 #undef memset
 void *memset(void *addr, int c, size_t len)
 {
-- 
2.21.0.rc0.269.g1a574e7a288b

