Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FBF6662A
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfGLF3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41521 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so3786736pff.8
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+i1PP70VM4gp+yGXoK79tVzWNeTCN5YHgyu+1fomQgA=;
        b=LtvPtrcrU4nwJykst8A48fEuE3P2blvqxFdxg8DC+CmmLab12J4Rvsuf4DNsV/4r4L
         G9sOtdUSY0tXKPqUQYw9hUhneYuPKUq95ApUFd2QFvgr/soFj9RSY3703vLrgLc/Cqrt
         M1AnQwz3IqtIKK0fKC2O7ULga6D6GzcMfhtryK7DmnSihcgVJl0/36Jrz0ikXiXUC+E6
         jSCOknmaouHblQ2fAkBIkVUObQ/zy3pt02ELF/ZGmL88Z1O6hUNpFXLNybKwctEPuQfY
         dcq/4E+tsfvBSfgCHxENCqS2nN/Ix9N7UgkgYNbOQZ6V5oXRbq4We4ZksjVKg4RvVXcd
         29Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+i1PP70VM4gp+yGXoK79tVzWNeTCN5YHgyu+1fomQgA=;
        b=UWEGLa5dVPmRpPUMLQwNOrd9q8YjzQCAUlMJGzapeNN37HxFSo32IRCrblf5Js0F7s
         UURq0LTyiyWVTqFhEgRy4L7g12YzsadrWcAlbEi55fyjGSGiRw4FrUUoH9Bsu6ADtTPJ
         GiQw7MSpotBz/BR++Zbty2ZdlQ6nMp6aXe1e58gFxuUJEY1vmaAVM8ApoQ0yFvLTzD7+
         rYR3Q9+9I2HKIYhwu7mUTqA+Y75kAx+lDzhFGDj/qZ9VOEo72VKL5WGdRy/0fNcS6iPw
         OuWHDQNkBrrm/btJ/2F88VwviqjF5WRVGz3w7bhxPtC+nCjUJAAemXq7oLouYlVqj+kq
         NrgQ==
X-Gm-Message-State: APjAAAWocAqFdaI+xmwifo2HCJQOEEZo0lDipfTQTjGK31yC4fkqdUgp
        NZl+bCYAK97BGvKjUd3gxBKZu70FjrI=
X-Google-Smtp-Source: APXvYqy6laduSzW4J2fHIwGuSgLVFtG+of8Xeu9hr2v3uq9ggFfUKWP4KUK0kFGztZINIO7uuxCp5w==
X-Received: by 2002:a17:90a:db44:: with SMTP id u4mr9411661pjx.52.1562909363505;
        Thu, 11 Jul 2019 22:29:23 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id b26sm10186974pfo.129.2019.07.11.22.29.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:23 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 09/43] mm/kasan: add API to check memory regions
Date:   Fri, 12 Jul 2019 10:57:57 +0530
Message-Id: <45ff1598be62861928069f5907f6b41d3eb05c68.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

