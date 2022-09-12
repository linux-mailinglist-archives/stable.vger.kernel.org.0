Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EBA5B575B
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 11:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiILJpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 05:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiILJpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 05:45:54 -0400
Received: from mail-ej1-x649.google.com (mail-ej1-x649.google.com [IPv6:2a00:1450:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AE23343C
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 02:45:52 -0700 (PDT)
Received: by mail-ej1-x649.google.com with SMTP id xj11-20020a170906db0b00b0077b6ecb23fcso1102427ejb.5
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 02:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=jBoH9dZtU8u1abW3Qj3aDrAs7nz5caMLzMPJv+JY2CE=;
        b=MR5DigsBS0/ITOnUWHz7rgazRDEBSqjosdzYJAXuVO6gDRUXtNg9chMfS+KizD1tgT
         9NaYvF1m/6aPRfa8q0xlZJcT7MFNTWJt/SK7OV5dCQEJyRr1taZhhd3hLeVb7dRd+rHb
         UGUKoKbJFmxiV2W/B6LtSwf4iwULzTbONwflcqTnChdS03U+IxEJ/yFcZ7dVJ7NnN4Gd
         d1pPqhxUY0oWLOmM1K3C76rAD19FozAhJvuGY7E4b0idk28B42yT/GrEy+1W15xnFWdW
         0uwCqdrVJ2BrFjX0Gypno+SDEw850aI/+OeTLYWq/BCXtDetEIgN54LDioLlIM3kfgpT
         MfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=jBoH9dZtU8u1abW3Qj3aDrAs7nz5caMLzMPJv+JY2CE=;
        b=nuWIw3lqDPZuIkEGPSfnHxS41h5bzT0lPkiUA+SA1IrLLIs01MTX8dOonU4I++HGBE
         hEsIdhI6KbePphiZr1mbXUK0NETjYY1iIeqYcXdFNX1lTRk5sVKNtIQuiyeRtctFMtv7
         7AgLv/F98IBSHq/3Z2F77hJGr65Q2ZGsg4CTKSNPmPcCvXPLs4mEvpDhraujJDGPMHgI
         ZCsIlXrWxDMmlsLuiFK/j11ag9S5pg9OdQNEDChqvwxsvvRx6D0J0nGDZAYt+myNqQpp
         3HogyaZvvS0mHOgjELCILTrXO0yxiePbeCuYAUf3VTIF3ULua9O8Ggm/p4Libstji8wX
         vz/w==
X-Gm-Message-State: ACgBeo0MSTndUEy1zEBOP8evhBXJU3rjOzjUdpLHeejr5eLlF+fSY4je
        Z14amxAvx80SDkrcT/T2nxLqm9BO9g==
X-Google-Smtp-Source: AA6agR5+oeruIkBj1HE2zrvAygBUxfE3HyDxczIWzvFPZx3yXg43HU2XyG1ItaJyA72oGU8vzG5byHrq1g==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:f693:9fff:fef4:2449])
 (user=elver job=sendgmr) by 2002:a05:6402:5002:b0:444:26fd:d341 with SMTP id
 p2-20020a056402500200b0044426fdd341mr21825632eda.351.1662975950998; Mon, 12
 Sep 2022 02:45:50 -0700 (PDT)
Date:   Mon, 12 Sep 2022 11:45:40 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912094541.929856-1-elver@google.com>
Subject: [PATCH v3 1/2] kcsan: Instrument memcpy/memset/memmove with newer Clang
From:   Marco Elver <elver@google.com>
To:     elver@google.com, "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
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
v3:
* Truncate sizes larger than MAX_ENCODABLE_SIZE, so we still set up
  watchpoints on them. Iterating through MAX_ENCODABLE_SIZE blocks may
  result in pathological cases where performance would seriously suffer.
  So let's avoid that for now.
* Just use memcpy/memset/memmove instead of __mem*() functions. Many
  architectures that already support KCSAN don't define them (mips,
  s390), and having both __mem* and mem versions of the functions
  provides little benefit elsewhere; and backporting would become more
  difficult, too. The compiler should not inline them given all
  parameters are non-constants here.

v2:
* Fix for architectures which do not provide their own
  memcpy/memset/memmove and instead use the generic versions in
  lib/string. In this case we'll just alias the __tsan_ variants.
---
 kernel/kcsan/core.c | 50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index fe12dfe254ec..54d077e1a2dc 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -14,10 +14,12 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/sched.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #include "encoding.h"
@@ -1308,3 +1310,51 @@ noinline void __tsan_atomic_signal_fence(int memorder)
 	}
 }
 EXPORT_SYMBOL(__tsan_atomic_signal_fence);
+
+#ifdef __HAVE_ARCH_MEMSET
+void *__tsan_memset(void *s, int c, size_t count);
+noinline void *__tsan_memset(void *s, int c, size_t count)
+{
+	/*
+	 * Instead of not setting up watchpoints where accessed size is greater
+	 * than MAX_ENCODABLE_SIZE, truncate checked size to MAX_ENCODABLE_SIZE.
+	 */
+	size_t check_len = min_t(size_t, count, MAX_ENCODABLE_SIZE);
+
+	check_access(s, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	return memset(s, c, count);
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
+	size_t check_len = min_t(size_t, len, MAX_ENCODABLE_SIZE);
+
+	check_access(dst, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	check_access(src, check_len, 0, _RET_IP_);
+	return memmove(dst, src, len);
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
+	size_t check_len = min_t(size_t, len, MAX_ENCODABLE_SIZE);
+
+	check_access(dst, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	check_access(src, check_len, 0, _RET_IP_);
+	return memcpy(dst, src, len);
+}
+#else
+void *__tsan_memcpy(void *dst, const void *src, size_t len) __alias(memcpy);
+#endif
+EXPORT_SYMBOL(__tsan_memcpy);
-- 
2.37.2.789.g6183377224-goog

