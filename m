Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0432C664A03
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbjAJS3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239349AbjAJS2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:28:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F706C770
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:23:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 083E6B818EF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8B2C433F1;
        Tue, 10 Jan 2023 18:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375029;
        bh=QnvjRGIqM9Ckpjf65P+sC2J/8O32NT2H6LdMzphI6l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X28SN7WtgxNuU1lZAcfrRRrjWPRGdCMsmj2UJaTSE0pOtcj7smDb+fvFAkP8GTumm
         NxG2AEZGXrVNtVXiw0KXbTry0n80mCT8xcdamwB+U10D7QhOMMnfvLDVBt+6fOPQ9Z
         bdqFzvh/HXCeti7jGvULaAPBes7tNEsfd4/4Gppw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.15 054/290] kcsan: Instrument memcpy/memset/memmove with newer Clang
Date:   Tue, 10 Jan 2023 19:02:26 +0100
Message-Id: <20230110180033.481725091@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 7c201739beef1a586d806463f1465429cdce34c5 upstream.

With Clang version 16+, -fsanitize=thread will turn
memcpy/memset/memmove calls in instrumented functions into
__tsan_memcpy/__tsan_memset/__tsan_memmove calls respectively.

Add these functions to the core KCSAN runtime, so that we (a) catch data
races with mem* functions, and (b) won't run into linker errors with
such newer compilers.

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
[ elver@google.com: adjust check_access() call for v5.15 and earlier. ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcsan/core.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

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
@@ -1060,3 +1062,51 @@ EXPORT_SYMBOL(__tsan_atomic_thread_fence
 void __tsan_atomic_signal_fence(int memorder);
 void __tsan_atomic_signal_fence(int memorder) { }
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
+	check_access(s, check_len, KCSAN_ACCESS_WRITE);
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
+	check_access(dst, check_len, KCSAN_ACCESS_WRITE);
+	check_access(src, check_len, 0);
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
+	check_access(dst, check_len, KCSAN_ACCESS_WRITE);
+	check_access(src, check_len, 0);
+	return memcpy(dst, src, len);
+}
+#else
+void *__tsan_memcpy(void *dst, const void *src, size_t len) __alias(memcpy);
+#endif
+EXPORT_SYMBOL(__tsan_memcpy);


