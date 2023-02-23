Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1A6A095B
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbjBWNFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbjBWNFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:05:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2EC53EFC
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:05:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A907A616EC
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7F6C433EF;
        Thu, 23 Feb 2023 13:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157505;
        bh=AE1KArWFZKKSBxE9z90qk6HgmUiw1GQ5E4OlHPZfTls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRWqwfsoQ77JtqICPeDUPOSuNaMBaotf+kgdbb9RQJhTdQNlsbFvBMJb8t+sXSFZZ
         7sU2Wqx5f6vcF7oCFKxRrrbxA3bA3Pel9wbIo5TJ2/NwmjVjAbsJWqB9YbVFzC5ELI
         rczTI16tyktytM8TF2Wqmm84Td3wQO2VdxF1TFqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jordy Zomer <jordyzomer@google.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.14 6/7] uaccess: Add speculation barrier to copy_from_user()
Date:   Thu, 23 Feb 2023 14:04:43 +0100
Message-Id: <20230223130423.662749238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
References: <20230223130423.369876969@linuxfoundation.org>
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

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 74e19ef0ff8061ef55957c3abd71614ef0f42f47 upstream.

The results of "access_ok()" can be mis-speculated.  The result is that
you can end speculatively:

	if (access_ok(from, size))
		// Right here

even for bad from/size combinations.  On first glance, it would be ideal
to just add a speculation barrier to "access_ok()" so that its results
can never be mis-speculated.

But there are lots of system calls just doing access_ok() via
"copy_to_user()" and friends (example: fstat() and friends).  Those are
generally not problematic because they do not _consume_ data from
userspace other than the pointer.  They are also very quick and common
system calls that should not be needlessly slowed down.

"copy_from_user()" on the other hand uses a user-controller pointer and
is frequently followed up with code that might affect caches.  Take
something like this:

	if (!copy_from_user(&kernelvar, uptr, size))
		do_something_with(kernelvar);

If userspace passes in an evil 'uptr' that *actually* points to a kernel
addresses, and then do_something_with() has cache (or other)
side-effects, it could allow userspace to infer kernel data values.

Add a barrier to the common copy_from_user() code to prevent
mis-speculated values which happen after the copy.

Also add a stub for architectures that do not define barrier_nospec().
This makes the macro usable in generic code.

Since the barrier is now usable in generic code, the x86 #ifdef in the
BPF code can also go away.

Reported-by: Jordy Zomer <jordyzomer@google.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>   # BPF bits
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/nospec.h |    4 ++++
 lib/usercopy.c         |    7 +++++++
 2 files changed, 11 insertions(+)

--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -9,6 +9,10 @@
 
 struct task_struct;
 
+#ifndef barrier_nospec
+# define barrier_nospec() do { } while (0)
+#endif
+
 /**
  * array_index_mask_nospec() - generate a ~0 mask when index < size, 0 otherwise
  * @index: array element index
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 
 /* out-of-line parts */
 
@@ -9,6 +10,12 @@ unsigned long _copy_from_user(void *to,
 	unsigned long res = n;
 	might_fault();
 	if (likely(access_ok(VERIFY_READ, from, n))) {
+		/*
+		 * Ensure that bad access_ok() speculation will not
+		 * lead to nasty side effects *after* the copy is
+		 * finished:
+		 */
+		barrier_nospec();
 		kasan_check_write(to, n);
 		res = raw_copy_from_user(to, from, n);
 	}


