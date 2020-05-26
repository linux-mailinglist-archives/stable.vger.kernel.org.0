Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92FA1E2C50
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392056AbgEZTOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392026AbgEZTOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:14:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8560F208B8;
        Tue, 26 May 2020 19:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520442;
        bh=kQNd34cmik6TcoAVHlkHhkO1e2MtsAltfeIAfLZeifU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lj+UKqLujONiQuQXsWupvvedgmX00pPnn2hccHHUiIu2CWcQ3DpDovoaiAsgJIXV3
         ZLHRtHPizZATjvsW11bkdHTEdHgdRiCqFOtLQNDpaXw4DtK6iVXbJYUCyPGiZwxr75
         nsXMs2wDI7sEQsVs/1VSksQaNE1o+vDI1HJuAspY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 082/126] vsprintf: dont obfuscate NULL and error pointers
Date:   Tue, 26 May 2020 20:53:39 +0200
Message-Id: <20200526183944.975389852@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 lib/test_printf.c |   19 ++++++++++++++++++-
 lib/vsprintf.c    |    7 +++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

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
@@ -330,14 +332,28 @@ test_hashed(const char *fmt, const void
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
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -794,6 +794,13 @@ static char *ptr_to_id(char *buf, char *
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


