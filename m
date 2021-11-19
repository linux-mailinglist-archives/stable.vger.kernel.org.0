Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06804575EC
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhKSRnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhKSRmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:42:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E7AB6113A;
        Fri, 19 Nov 2021 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343581;
        bh=Hy8SscTAiv7mBa0A9uGV8T8aGBMiHvsJHtdyfiwDGwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyNDWGcQe6OO+V0Vo+jO7qL7RIWH05yYOeZ0jgEsoSOscui3GnEjKfzYVlRhiiDSY
         UIt+05BGuElORliJ9Gr7UU+T9wTFremsjlP1r2FY7PB6bzGS7gynPFchoXdPY0/pZw
         e29Z0j0owbhT0lXA8Kr9YuRacr4Vtnd2lRXDBx9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 01/20] string: uninline memcpy_and_pad
Date:   Fri, 19 Nov 2021 18:39:19 +0100
Message-Id: <20211119171444.686925925@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 5c4e0a21fae877a7ef89be6dcc6263ec672372b8 upstream.

When building m68k:allmodconfig, recent versions of gcc generate the
following error if the length of UTS_RELEASE is less than 8 bytes.

  In function 'memcpy_and_pad',
    inlined from 'nvmet_execute_disc_identify' at
      drivers/nvme/target/discovery.c:268:2: arch/m68k/include/asm/string.h:72:25: error:
	'__builtin_memcpy' reading 8 bytes from a region of size 7

Discussions around the problem suggest that this only happens if an
architecture does not provide strlen(), if -ffreestanding is provided as
compiler option, and if CONFIG_FORTIFY_SOURCE=n. All of this is the case
for m68k. The exact reasons are unknown, but seem to be related to the
ability of the compiler to evaluate the return value of strlen() and
the resulting execution flow in memcpy_and_pad(). It would be possible
to work around the problem by using sizeof(UTS_RELEASE) instead of
strlen(UTS_RELEASE), but that would only postpone the problem until the
function is called in a similar way. Uninline memcpy_and_pad() instead
to solve the problem for good.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/string.h |   19 ++-----------------
 lib/string_helpers.c   |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 17 deletions(-)

--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -262,23 +262,8 @@ void __write_overflow(void) __compiletim
 #include <linux/fortify-string.h>
 #endif
 
-/**
- * memcpy_and_pad - Copy one buffer to another with padding
- * @dest: Where to copy to
- * @dest_len: The destination buffer size
- * @src: Where to copy from
- * @count: The number of bytes to copy
- * @pad: Character to use for padding if space is left in destination.
- */
-static inline void memcpy_and_pad(void *dest, size_t dest_len,
-				  const void *src, size_t count, int pad)
-{
-	if (dest_len > count) {
-		memcpy(dest, src, count);
-		memset(dest + count, pad,  dest_len - count);
-	} else
-		memcpy(dest, src, dest_len);
-}
+void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
+		    int pad);
 
 /**
  * str_has_prefix - Test if a string has a given prefix
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -696,3 +696,23 @@ void kfree_strarray(char **array, size_t
 	kfree(array);
 }
 EXPORT_SYMBOL_GPL(kfree_strarray);
+
+/**
+ * memcpy_and_pad - Copy one buffer to another with padding
+ * @dest: Where to copy to
+ * @dest_len: The destination buffer size
+ * @src: Where to copy from
+ * @count: The number of bytes to copy
+ * @pad: Character to use for padding if space is left in destination.
+ */
+void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
+		    int pad)
+{
+	if (dest_len > count) {
+		memcpy(dest, src, count);
+		memset(dest + count, pad,  dest_len - count);
+	} else {
+		memcpy(dest, src, dest_len);
+	}
+}
+EXPORT_SYMBOL(memcpy_and_pad);


