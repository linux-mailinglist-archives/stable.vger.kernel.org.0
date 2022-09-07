Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AE15B0B97
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIGRjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 13:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiIGRjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 13:39:09 -0400
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12D9AB40A
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 10:39:08 -0700 (PDT)
Received: by mail-ed1-x54a.google.com with SMTP id y14-20020a056402440e00b0044301c7ccd9so10016650eda.19
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=sHsT3YDwhM+0jjwjlaGB8MngokRR5HRxbTTGftCU/LU=;
        b=j8sE6fYTVOBfnvhd4sm/oSb2hwD47yzJVngf0DKpeOSTOLJyqSvXgsLamHaNOmIod2
         bk4Cr20MDfwnQXpC21xZk16bIy4vhB5m9TzxVLfg8FLLtXWa0NMwUp55v6X8db/RBu4u
         vdLp5YlCTYUbyYd+sFgPsUKaTCh255jBSJoq2cYirvI1sABKKWEaO/BN4DfG0qGZOxSG
         8ecj5Rxospyu93oPYwQ4JpFIxBwVhAWti1sJvk+rEHfbLh2tyqMnpU9Ays9XoM6PLE9d
         HE6IGUKcDaH7wUhycoA8SyjTCVNRAhN3LTXZZScw1D6hva+kRupryuIkReGA4Y2ALlou
         Uclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=sHsT3YDwhM+0jjwjlaGB8MngokRR5HRxbTTGftCU/LU=;
        b=nIr4rb+FaBuxOPf7sbJvjkXOUnPDIeuVkV6uPmC2FnMy8thn6E6Mx2/LRCL7aiDTHC
         hdCHeX4YnxLMWrtj9/bQq2oCqdGzFJBtpigCzVUjkp3uSxVwmKEVYi7Taf1fNlRt54aY
         dGAAmCPQeZEH1nGESC15h3kXb3RZLax6n/iAsRj2G23pIcW1BngC4r5rSVg05n+OL1Oz
         WhZC5Op9S2xvmx7fmADwP4sq+HtQn9x0CZuyjlIxQGy3J9sPjEAd1v3rtduHF+f0EnLd
         ZKaQmw75KdsEvJFDZgebjIxWfWGmcp5vPZVUYEo3t9w7Shy7arGfiTNp0CFxcM/1v57w
         q6Pw==
X-Gm-Message-State: ACgBeo2U2rZHNd2KYKaclS+JMFRGesshdQ2jalWCb3Q+93S21pnknNfQ
        F3o9WfwTQusnx7mk17fl6DlBqnFpYg==
X-Google-Smtp-Source: AA6agR5d9x9s9m+e7YC9j9xzF56Mb/hRV+gwOp4RgArCUr/r/3QBfUwnaKEKW086XZceJHRKAbUD+9w+eg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:ba52:c371:837f:3864])
 (user=elver job=sendgmr) by 2002:a05:6402:d06:b0:440:3e9d:77d with SMTP id
 eb6-20020a0564020d0600b004403e9d077dmr3852449edb.286.1662572347297; Wed, 07
 Sep 2022 10:39:07 -0700 (PDT)
Date:   Wed,  7 Sep 2022 19:39:02 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220907173903.2268161-1-elver@google.com>
Subject: [PATCH 1/2] kcsan: Instrument memcpy/memset/memmove with newer Clang
From:   Marco Elver <elver@google.com>
To:     elver@google.com, "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org
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
 kernel/kcsan/core.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index fe12dfe254ec..66ef48aa86e0 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/sched.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #include "encoding.h"
@@ -1308,3 +1309,29 @@ noinline void __tsan_atomic_signal_fence(int memorder)
 	}
 }
 EXPORT_SYMBOL(__tsan_atomic_signal_fence);
+
+void *__tsan_memset(void *s, int c, size_t count);
+noinline void *__tsan_memset(void *s, int c, size_t count)
+{
+	check_access(s, count, KCSAN_ACCESS_WRITE, _RET_IP_);
+	return __memset(s, c, count);
+}
+EXPORT_SYMBOL(__tsan_memset);
+
+void *__tsan_memmove(void *dst, const void *src, size_t len);
+noinline void *__tsan_memmove(void *dst, const void *src, size_t len)
+{
+	check_access(dst, len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	check_access(src, len, 0, _RET_IP_);
+	return __memmove(dst, src, len);
+}
+EXPORT_SYMBOL(__tsan_memmove);
+
+void *__tsan_memcpy(void *dst, const void *src, size_t len);
+noinline void *__tsan_memcpy(void *dst, const void *src, size_t len)
+{
+	check_access(dst, len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	check_access(src, len, 0, _RET_IP_);
+	return __memcpy(dst, src, len);
+}
+EXPORT_SYMBOL(__tsan_memcpy);
-- 
2.37.2.789.g6183377224-goog

