Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EE045269
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfFNDMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44908 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id n2so661584pgp.11
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q/AGFfvfHGuDn+dFoAxSTyRFru9zQTVknf0DUmu2KKo=;
        b=EXoJEH537ekXX3OvBiXCvmYHnyJHpvoGxXHrkSWsLSUvuohlVgtJEa16Btv4b48dDT
         WPz9HDGvXX8/nfn9lVM72XeiB9o9Oud6n17yMvo6jFo1TBKW2w7jxU5eKNxnx/qxJwPL
         AvlDDz8H11flscmdP85UFmYZo0xJOIPPWY194dVFEKTIGoyk/pXK9Gui6nQtoZazb9Fm
         Kuuxgi5vx34eECek4Lpt0jUWDQb0csa1Q7tO8kDvWPzNqWI1rAfkYQwhqAtu1wm6Dv14
         HHIg5YEPsOZ0S8qPY/dHrduCyZN09fRXoq9Za4pf24DYyYETtGvVSyIrAHZzS+KvYQuv
         rDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/AGFfvfHGuDn+dFoAxSTyRFru9zQTVknf0DUmu2KKo=;
        b=FYwC3rPqWmdQsLwM2W7sXs0y/XO1afZRqDlIe1Chg1TAmoprzf96NpSE0Uni3V3ibX
         7J5w+bM1Zrmocmwsw0EoDBUuRlQL7I2KJaoUv8gH2AHmZ8okNCd/BChnIcexZZl675iA
         yJp62iIIzyYNAgBpUEH4SKaKiqu97hDKqegZldC6aUtnC9jvN89nW8iR7B0G42udMfeO
         ethNUfPUNceScJMgQKl4JUyYK/sbC5xLmk1izF9NyhZZ05EgWI8pk+ZUottzDcGgwaNm
         dEk+NuMj4LgILy1MkBuC5w0U8fC/6ufm33PxCNNIzHYLuqcdCqZCs4qXOkFeV6c2eEGI
         tI8Q==
X-Gm-Message-State: APjAAAUrWlbQ4s3ohTF4fKgK8JnQjGvN5c+DBm83naS16K4+mC9WPn5+
        C3QcnHppUIhc7rnqI1Noy4KKUw==
X-Google-Smtp-Source: APXvYqxADLqV+smHWmh91RQy7xN6UqYx5UMo5b+CFqcbc0DPVdnSlPrfqYQnPo4j6Vszd2MKRpyvVQ==
X-Received: by 2002:a17:90a:cf0d:: with SMTP id h13mr8016081pju.63.1560481940227;
        Thu, 13 Jun 2019 20:12:20 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id r4sm1129694pjd.25.2019.06.13.20.12.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:19 -0700 (PDT)
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
Subject: [PATCH v4.4 10/45] mm/kasan: add API to check memory regions
Date:   Fri, 14 Jun 2019 08:37:53 +0530
Message-Id: <0cedfc51f5941ab2c2e9a09149d34c7451efda56.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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
[ v4.4: Fixed MAINTAINERS conflict and added whole kasan entry ]
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
index b7397b459960..3ad31df33e76 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -274,6 +274,18 @@ static __always_inline void check_memory_region(unsigned long addr,
 void __asan_loadN(unsigned long addr, size_t size);
 void __asan_storeN(unsigned long addr, size_t size);
 
+void kasan_check_read(const void *p, unsigned int size)
+{
+	check_memory_region((unsigned long)p, size, false, _RET_IP_);
+}
+EXPORT_SYMBOL(kasan_check_read);
+
+void kasan_check_write(const void *p, unsigned int size)
+{
+	check_memory_region((unsigned long)p, size, true, _RET_IP_);
+}
+EXPORT_SYMBOL(kasan_check_write);
+
 #undef memset
 void *memset(void *addr, int c, size_t len)
 {
-- 
2.21.0.rc0.269.g1a574e7a288b

