Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566D2657FDB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbiL1QKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiL1QKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2980C1A82F;
        Wed, 28 Dec 2022 08:09:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E377C6157C;
        Wed, 28 Dec 2022 16:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AEFC433D2;
        Wed, 28 Dec 2022 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243723;
        bh=KGOpQeadAjIJXwPDqtm5r3ZSwHPdj7oZFOW8drFnvzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaa3x7V2z5RC98/IP1A9cG8pIU8vFNK7o7r7l37ZeNitvk1qU/p7YOmrcrU4TzMr3
         cCQHQd+z8T5sdDslaQT64ttcEnt5TllcV3NYErE0687qM2wv/4wZG1gW/Xo3qKeIPi
         n3+YpfRCL+44h/CSUkRcAFK6MO+SKsMlGfGMAWqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-hardening@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0577/1073] fortify: Use SIZE_MAX instead of (size_t)-1
Date:   Wed, 28 Dec 2022 15:36:05 +0100
Message-Id: <20221228144343.723901257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 311fb40aa0569abacc430b0d66ee41470803111f ]

Clean up uses of "(size_t)-1" in favor of SIZE_MAX.

Cc: linux-hardening@vger.kernel.org
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: e9a40e1585d7 ("fortify: Do not cast to "unsigned char"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index fce2fb2fc962..ae076aae9e66 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -3,6 +3,7 @@
 #define _LINUX_FORTIFY_STRING_H_
 
 #include <linux/const.h>
+#include <linux/limits.h>
 
 #define __FORTIFY_INLINE extern __always_inline __gnu_inline __overloadable
 #define __RENAME(x) __asm__(#x)
@@ -17,9 +18,9 @@ void __write_overflow_field(size_t avail, size_t wanted) __compiletime_warning("
 #define __compiletime_strlen(p)					\
 ({								\
 	unsigned char *__p = (unsigned char *)(p);		\
-	size_t __ret = (size_t)-1;				\
+	size_t __ret = SIZE_MAX;				\
 	size_t __p_size = __builtin_object_size(p, 1);		\
-	if (__p_size != (size_t)-1 &&				\
+	if (__p_size != SIZE_MAX &&				\
 	    __builtin_constant_p(*__p)) {			\
 		size_t __p_len = __p_size - 1;			\
 		if (__builtin_constant_p(__p[__p_len]) &&	\
@@ -95,7 +96,7 @@ char *strcat(char * const POS p, const char *q)
 {
 	size_t p_size = __builtin_object_size(p, 1);
 
-	if (p_size == (size_t)-1)
+	if (p_size == SIZE_MAX)
 		return __underlying_strcat(p, q);
 	if (strlcat(p, q, p_size) >= p_size)
 		fortify_panic(__func__);
@@ -110,7 +111,7 @@ __FORTIFY_INLINE __kernel_size_t strnlen(const char * const POS p, __kernel_size
 	size_t ret;
 
 	/* We can take compile-time actions when maxlen is const. */
-	if (__builtin_constant_p(maxlen) && p_len != (size_t)-1) {
+	if (__builtin_constant_p(maxlen) && p_len != SIZE_MAX) {
 		/* If p is const, we can use its compile-time-known len. */
 		if (maxlen >= p_size)
 			return p_len;
@@ -138,7 +139,7 @@ __kernel_size_t __fortify_strlen(const char * const POS p)
 	size_t p_size = __builtin_object_size(p, 1);
 
 	/* Give up if we don't know how large p is. */
-	if (p_size == (size_t)-1)
+	if (p_size == SIZE_MAX)
 		return __underlying_strlen(p);
 	ret = strnlen(p, p_size);
 	if (p_size <= ret)
@@ -155,7 +156,7 @@ __FORTIFY_INLINE size_t strlcpy(char * const POS p, const char * const POS q, si
 	size_t q_len;	/* Full count of source string length. */
 	size_t len;	/* Count of characters going into destination. */
 
-	if (p_size == (size_t)-1 && q_size == (size_t)-1)
+	if (p_size == SIZE_MAX && q_size == SIZE_MAX)
 		return __real_strlcpy(p, q, size);
 	q_len = strlen(q);
 	len = (q_len >= size) ? size - 1 : q_len;
@@ -183,7 +184,7 @@ __FORTIFY_INLINE ssize_t strscpy(char * const POS p, const char * const POS q, s
 	size_t q_size = __builtin_object_size(q, 1);
 
 	/* If we cannot get size of p and q default to call strscpy. */
-	if (p_size == (size_t) -1 && q_size == (size_t) -1)
+	if (p_size == SIZE_MAX && q_size == SIZE_MAX)
 		return __real_strscpy(p, q, size);
 
 	/*
@@ -228,7 +229,7 @@ char *strncat(char * const POS p, const char * const POS q, __kernel_size_t coun
 	size_t p_size = __builtin_object_size(p, 1);
 	size_t q_size = __builtin_object_size(q, 1);
 
-	if (p_size == (size_t)-1 && q_size == (size_t)-1)
+	if (p_size == SIZE_MAX && q_size == SIZE_MAX)
 		return __underlying_strncat(p, q, count);
 	p_len = strlen(p);
 	copy_len = strnlen(q, count);
@@ -269,10 +270,10 @@ __FORTIFY_INLINE void fortify_memset_chk(__kernel_size_t size,
 	/*
 	 * Always stop accesses beyond the struct that contains the
 	 * field, when the buffer's remaining size is known.
-	 * (The -1 test is to optimize away checks where the buffer
+	 * (The SIZE_MAX test is to optimize away checks where the buffer
 	 * lengths are unknown.)
 	 */
-	if (p_size != (size_t)(-1) && p_size < size)
+	if (p_size != SIZE_MAX && p_size < size)
 		fortify_panic("memset");
 }
 
@@ -363,11 +364,11 @@ __FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
 	/*
 	 * Always stop accesses beyond the struct that contains the
 	 * field, when the buffer's remaining size is known.
-	 * (The -1 test is to optimize away checks where the buffer
+	 * (The SIZE_MAX test is to optimize away checks where the buffer
 	 * lengths are unknown.)
 	 */
-	if ((p_size != (size_t)(-1) && p_size < size) ||
-	    (q_size != (size_t)(-1) && q_size < size))
+	if ((p_size != SIZE_MAX && p_size < size) ||
+	    (q_size != SIZE_MAX && q_size < size))
 		fortify_panic(func);
 }
 
@@ -466,7 +467,7 @@ char *strcpy(char * const POS p, const char * const POS q)
 	size_t size;
 
 	/* If neither buffer size is known, immediately give up. */
-	if (p_size == (size_t)-1 && q_size == (size_t)-1)
+	if (p_size == SIZE_MAX && q_size == SIZE_MAX)
 		return __underlying_strcpy(p, q);
 	size = strlen(q) + 1;
 	/* Compile-time check for const size overflow. */
-- 
2.35.1



