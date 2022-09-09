Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7A95B307E
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 09:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiIIHoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 03:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiIIHoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 03:44:02 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42364138832
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 00:41:09 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id q18-20020a056402519200b0043dd2ff50feso652890edd.9
        for <stable@vger.kernel.org>; Fri, 09 Sep 2022 00:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=CwJgI/zqEG/WNCJEuUp+CMHdoz4DAXmnbuoZdi14Bqk=;
        b=nx4UO6FGWdB0vzP8FiBCRGi6jWAecwwGmolsdjQeS05N/w/aqKfjKcXAYVgegeQje0
         bqB/2LoH0zy2VvDaVaMjkhOmK7jEHBFQ0bxK8+tFG309lQiFZBL9hQqHXBqa2uHZ+ISO
         vSS9lWhdz4gtoi0yFjfirj42Ywv5YL08vEHsKsmwS2258lt8g8bziZI3VT42AtyowGTo
         tyUkMkyFR4ifx0HtUF53XLpG5aW87CT5KGtWoB0X2/5QUn+I+rUr79GU9LDlTZzsgUA+
         MZRGI7gznSV5BWKds3sFjufh/v40H+2KpNALNG9bdu2PV75mdnduygY/DEZ1vQTGj20n
         JjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=CwJgI/zqEG/WNCJEuUp+CMHdoz4DAXmnbuoZdi14Bqk=;
        b=bh5OyLg3MjcqNRISDoGax0vhA9wm0sXtMo0tUeWHrmMED7tN26PtBbRzRQuB9nVJ3L
         zamAQdSVoOA1W/J2DS4rjrnLCdAW0FmBiHvLTTODWy6ONYL2M9k3kBwxrnLbZhStV2Kr
         yVSMSQLx/5wR2Pmly4PfoivrYLbksHRlHFSMNFNkGgrlmbEW8RKTdSp4Bt51b2u2qNNs
         w85VMxHaksNCWokkOqYs/Tc9CDpxDrIFZfXtY9GCaQfYZ5yBpJ3VTMtt1xsm27vQQiGe
         +i2TDYpMPUJB72VylCahMJ0EN3C3AEfIL28nZdYI0AZtZv7umHTBiGGvDogXLqWpj+bQ
         7g3Q==
X-Gm-Message-State: ACgBeo1TE1/snKuWjUexLN/0qo0AMBONyVzIVifjasQrvfX1/mGzYOjQ
        pP59SRTiPY13kl+aX6wTYeAbekNVDg==
X-Google-Smtp-Source: AA6agR55zHiBLxwKUigYV5E03IlRE8G/bXLTNM2ZQLcfJB47hg02LfbZ5lxPABjqhEP6sHcAmk436ldycg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:1d1e:ddcd:2020:36c2])
 (user=elver job=sendgmr) by 2002:a17:907:3f26:b0:770:8852:9bed with SMTP id
 hq38-20020a1709073f2600b0077088529bedmr7603132ejc.658.1662709134191; Fri, 09
 Sep 2022 00:38:54 -0700 (PDT)
Date:   Fri,  9 Sep 2022 09:38:39 +0200
In-Reply-To: <20220909073840.45349-1-elver@google.com>
Mime-Version: 1.0
References: <20220909073840.45349-1-elver@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909073840.45349-2-elver@google.com>
Subject: [PATCH v2 2/3] kcsan: Instrument memcpy/memset/memmove with newer Clang
From:   Marco Elver <elver@google.com>
To:     elver@google.com, "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With Clang version 16+, -fsanitize=thread will turn
memcpy/memset/memmove calls in instrumented functions into
__tsan_memcpy/__tsan_memset/__tsan_memmove calls respectively.

Add these functions to the core KCSAN runtime, so that we (a) catch data
races with mem* functions, and (b) won't run into linker errors with
such newer compilers.

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Fix for architectures which do not provide their own
  memcpy/memset/memmove and instead use the generic versions in
  lib/string. In this case we'll just alias the __tsan_ variants.
---
 kernel/kcsan/core.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index fe12dfe254ec..4015f2a3e7f6 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/sched.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #include "encoding.h"
@@ -1308,3 +1309,41 @@ noinline void __tsan_atomic_signal_fence(int memorder)
 	}
 }
 EXPORT_SYMBOL(__tsan_atomic_signal_fence);
+
+#ifdef __HAVE_ARCH_MEMSET
+void *__tsan_memset(void *s, int c, size_t count);
+noinline void *__tsan_memset(void *s, int c, size_t count)
+{
+	check_access(s, count, KCSAN_ACCESS_WRITE, _RET_IP_);
+	return __memset(s, c, count);
+}
+#else
+void *__tsan_memset(void *s, int c, size_t count) __alias(memset);
+#endif
+EXPORT_SYMBOL(__tsan_memset);
+
+#ifdef __HAVE_ARCH_MEMMOVE
+void *__tsan_memmove(void *dst, const void *src, size_t len);
+noinline void *__tsan_memmove(void *dst, const void *src, size_t len)
+{
+	check_access(dst, len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	check_access(src, len, 0, _RET_IP_);
+	return __memmove(dst, src, len);
+}
+#else
+void *__tsan_memmove(void *dst, const void *src, size_t len) __alias(memmove);
+#endif
+EXPORT_SYMBOL(__tsan_memmove);
+
+#ifdef __HAVE_ARCH_MEMCPY
+void *__tsan_memcpy(void *dst, const void *src, size_t len);
+noinline void *__tsan_memcpy(void *dst, const void *src, size_t len)
+{
+	check_access(dst, len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	check_access(src, len, 0, _RET_IP_);
+	return __memcpy(dst, src, len);
+}
+#else
+void *__tsan_memcpy(void *dst, const void *src, size_t len) __alias(memcpy);
+#endif
+EXPORT_SYMBOL(__tsan_memcpy);
-- 
2.37.2.789.g6183377224-goog

