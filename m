Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31DF1F2D3D
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733076AbgFIAbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730031AbgFHXPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 853DA2076A;
        Mon,  8 Jun 2020 23:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658125;
        bh=6tDz6kz3EWPvtiMKUTe9UWYLirmxVR7ibzaVILkuUvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLrAYinYQ1fy7K92Z6S1ikd/09nbUBxo6s+mqNwRHdYrRku9csj9bVz57tqD+TiXL
         E0Z/qYG8FvPXzQylJgABHXqxFqRVz3ZMezSriEz9wkglS6y4C65z82EmauRHAMgIfa
         H4PdABZ9V1OtliWlCRKgOYy+nNAjWGF9kypRNfkw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 5.6 161/606] vsprintf: don't obfuscate NULL and error pointers
Date:   Mon,  8 Jun 2020 19:04:46 -0400
Message-Id: <20200608231211.3363633-161-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 7bd57fbc4a4ddedc664cad0bbced1b469e24e921 upstream.

I don't see what security concern is addressed by obfuscating NULL
and IS_ERR() error pointers, printed with %p/%pK.  Given the number
of sites where %p is used (over 10000) and the fact that NULL pointers
aren't uncommon, it probably wouldn't take long for an attacker to
find the hash that corresponds to 0.  Although harder, the same goes
for most common error values, such as -1, -2, -11, -14, etc.

The NULL part actually fixes a regression: NULL pointers weren't
obfuscated until commit 3e5903eb9cff ("vsprintf: Prevent crash when
dereferencing invalid pointers") which went into 5.2.  I'm tacking
the IS_ERR() part on here because error pointers won't leak kernel
addresses and printing them as pointers shouldn't be any different
from e.g. %d with PTR_ERR_OR_ZERO().  Obfuscating them just makes
debugging based on existing pr_debug and friends excruciating.

Note that the "always print 0's for %pK when kptr_restrict == 2"
behaviour which goes way back is left as is.

Example output with the patch applied:

                             ptr         error-ptr              NULL
 %p:            0000000001f8cc5b  fffffffffffffff2  0000000000000000
 %pK, kptr = 0: 0000000001f8cc5b  fffffffffffffff2  0000000000000000
 %px:           ffff888048c04020  fffffffffffffff2  0000000000000000
 %pK, kptr = 1: ffff888048c04020  fffffffffffffff2  0000000000000000
 %pK, kptr = 2: 0000000000000000  0000000000000000  0000000000000000

Fixes: 3e5903eb9cff ("vsprintf: Prevent crash when dereferencing invalid pointers")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_printf.c | 19 ++++++++++++++++++-
 lib/vsprintf.c    |  7 +++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/lib/test_printf.c b/lib/test_printf.c
index 2d9f520d2f27..6b1622f4d7c2 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -214,6 +214,7 @@ test_string(void)
 #define PTR_STR "ffff0123456789ab"
 #define PTR_VAL_NO_CRNG "(____ptrval____)"
 #define ZEROS "00000000"	/* hex 32 zero bits */
+#define ONES "ffffffff"		/* hex 32 one bits */
 
 static int __init
 plain_format(void)
@@ -245,6 +246,7 @@ plain_format(void)
 #define PTR_STR "456789ab"
 #define PTR_VAL_NO_CRNG "(ptrval)"
 #define ZEROS ""
+#define ONES ""
 
 static int __init
 plain_format(void)
@@ -330,14 +332,28 @@ test_hashed(const char *fmt, const void *p)
 	test(buf, fmt, p);
 }
 
+/*
+ * NULL pointers aren't hashed.
+ */
 static void __init
 null_pointer(void)
 {
-	test_hashed("%p", NULL);
+	test(ZEROS "00000000", "%p", NULL);
 	test(ZEROS "00000000", "%px", NULL);
 	test("(null)", "%pE", NULL);
 }
 
+/*
+ * Error pointers aren't hashed.
+ */
+static void __init
+error_pointer(void)
+{
+	test(ONES "fffffff5", "%p", ERR_PTR(-11));
+	test(ONES "fffffff5", "%px", ERR_PTR(-11));
+	test("(efault)", "%pE", ERR_PTR(-11));
+}
+
 #define PTR_INVALID ((void *)0x000000ab)
 
 static void __init
@@ -649,6 +665,7 @@ test_pointer(void)
 {
 	plain();
 	null_pointer();
+	error_pointer();
 	invalid_pointer();
 	symbol_ptr();
 	kernel_ptr();
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 532b6606a18a..7c47ad52ce2f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -794,6 +794,13 @@ static char *ptr_to_id(char *buf, char *end, const void *ptr,
 	unsigned long hashval;
 	int ret;
 
+	/*
+	 * Print the real pointer value for NULL and error pointers,
+	 * as they are not actual addresses.
+	 */
+	if (IS_ERR_OR_NULL(ptr))
+		return pointer_string(buf, end, ptr, spec);
+
 	/* When debugging early boot use non-cryptographically secure hash. */
 	if (unlikely(debug_boot_weak_hash)) {
 		hashval = hash_long((unsigned long)ptr, 32);
-- 
2.25.1

