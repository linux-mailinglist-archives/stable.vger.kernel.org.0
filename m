Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494D06A096A
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjBWNFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbjBWNFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:05:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B201515C2
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:05:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 290BD616EC
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEA2C433EF;
        Thu, 23 Feb 2023 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157538;
        bh=JOH1SuhiesmO6jSmiym+BaeamVU/tqr8oq4ctnFrtjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JN6X9Eb2Mm5D9Y5qHcRbCfnP1+A+wEXXOv5au27hJqxKYB5aw7YmyS2xYwz1Cdx9C
         ZeFxmtpLiE3dVtOmRz4BH0la3whEvuNGmWqm6EMtl53WeXd+6Ed8fKqoqkf3YxKRmO
         nrfOeXYBPPxaoqa/YiR2nEGTaMGPYKJKNGCY9p60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jordy Zomer <jordyzomer@google.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 09/11] uaccess: Add speculation barrier to copy_from_user()
Date:   Thu, 23 Feb 2023 14:04:50 +0100
Message-Id: <20230223130424.403472449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130424.079732181@linuxfoundation.org>
References: <20230223130424.079732181@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 kernel/bpf/core.c      |    2 --
 lib/usercopy.c         |    7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

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
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1373,9 +1373,7 @@ out:
 		 * reuse preexisting logic from Spectre v1 mitigation that
 		 * happens to produce the required code on x86 for v4 as well.
 		 */
-#ifdef CONFIG_X86
 		barrier_nospec();
-#endif
 		CONT;
 #define LDST(SIZEOP, SIZE)						\
 	STX_MEM_##SIZEOP:						\
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


