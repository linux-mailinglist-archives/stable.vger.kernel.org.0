Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5882660421A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiJSKz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiJSKy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:54:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C9F1633AE;
        Wed, 19 Oct 2022 03:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8940B8249E;
        Wed, 19 Oct 2022 09:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1565FC433D7;
        Wed, 19 Oct 2022 09:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170475;
        bh=hzbiDCjgP4PWpxtEpRK2mCWbxYUpFdc6paCISbBKNxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aP5Zn1SK9z8B6dSkbPmRbDIJV1LQD90djpZKfjIU3I1+wtdJ5BJgZZfLLXMj5N8+c
         Xg8110o38O1r/XDeL/hytAl1Vct10HwUrEd5BYWG1K8gbkYkDHcxdmQb+Nlur5OOGe
         CK/fFgPIHb4EmUgwuGohz7I7ae5uY8spPvGuTtQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        David Gow <davidgow@google.com>,
        Yury Norov <yury.norov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sander Vanheule <sander@svanheule.net>,
        linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 668/862] fortify: Fix __compiletime_strlen() under UBSAN_BOUNDS_LOCAL
Date:   Wed, 19 Oct 2022 10:32:35 +0200
Message-Id: <20221019083319.471583012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit d07c0acb4f41cc42a0d97530946965b3e4fa68c1 ]

With CONFIG_FORTIFY=y and CONFIG_UBSAN_LOCAL_BOUNDS=y enabled, we observe
a runtime panic while running Android's Compatibility Test Suite's (CTS)
android.hardware.input.cts.tests. This is stemming from a strlen()
call in hidinput_allocate().

__compiletime_strlen() is implemented in terms of __builtin_object_size(),
then does an array access to check for NUL-termination. A quirk of
__builtin_object_size() is that for strings whose values are runtime
dependent, __builtin_object_size(str, 1 or 0) returns the maximum size
of possible values when those sizes are determinable at compile time.
Example:

  static const char *v = "FOO BAR";
  static const char *y = "FOO BA";
  unsigned long x (int z) {
      // Returns 8, which is:
      // max(__builtin_object_size(v, 1), __builtin_object_size(y, 1))
      return __builtin_object_size(z ? v : y, 1);
  }

So when FORTIFY_SOURCE is enabled, the current implementation of
__compiletime_strlen() will try to access beyond the end of y at runtime
using the size of v. Mixed with UBSAN_LOCAL_BOUNDS we get a fault.

hidinput_allocate() has a local C string whose value is control flow
dependent on a switch statement, so __builtin_object_size(str, 1)
evaluates to the maximum string length, making all other cases fault on
the last character check. hidinput_allocate() could be cleaned up to
avoid runtime calls to strlen() since the local variable can only have
literal values, so there's no benefit to trying to fortify the strlen
call site there.

Perform a __builtin_constant_p() check against index 0 earlier in the
macro to filter out the control-flow-dependant case. Add a KUnit test
for checking the expected behavioral characteristics of FORTIFY_SOURCE
internals.

Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tom Rix <trix@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Cc: David Gow <davidgow@google.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: linux-hardening@vger.kernel.org
Cc: llvm@lists.linux.dev
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Android Treehugger Robot
Link: https://android-review.googlesource.com/c/kernel/common/+/2206839
Co-developed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 3b401fa0f374..fce2fb2fc962 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -19,7 +19,8 @@ void __write_overflow_field(size_t avail, size_t wanted) __compiletime_warning("
 	unsigned char *__p = (unsigned char *)(p);		\
 	size_t __ret = (size_t)-1;				\
 	size_t __p_size = __builtin_object_size(p, 1);		\
-	if (__p_size != (size_t)-1) {				\
+	if (__p_size != (size_t)-1 &&				\
+	    __builtin_constant_p(*__p)) {			\
 		size_t __p_len = __p_size - 1;			\
 		if (__builtin_constant_p(__p[__p_len]) &&	\
 		    __p[__p_len] == '\0')			\
-- 
2.35.1



