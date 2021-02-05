Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4C9311077
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhBEROJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:14:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233494AbhBEQBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 11:01:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33BC46509B;
        Fri,  5 Feb 2021 14:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534441;
        bh=xhEBF5950Wxomp4nlv6r/gQ21RaGS0+9JtqvkNBSfTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDqmk973hQplUgGpNPnqEP+MQpLFaObN4WQvnw/7D6sIivyhlkcAKhRIjUq32Hy6P
         EN5rV0m+x0F9HhHkah4gJUnyB7SvY8jTHVGvc2x9GaWjQxVE1UbhoQjeH7W7qh5hWU
         miLPHeCujhjbRMbVaA6Iyl6KT2iQ9LZ5joOf2mCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Brauner <christian@brauner.io>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joerg Vehlow <lkml@jv-coder.de>
Subject: [PATCH 4.19 04/17] sysctl: handle overflow in proc_get_long
Date:   Fri,  5 Feb 2021 15:07:58 +0100
Message-Id: <20210205140649.997401406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian@brauner.io>

commit 7f2923c4f73f21cfd714d12a2d48de8c21f11cfe upstream.

proc_get_long() is a funny function.  It uses simple_strtoul() and for a
good reason.  proc_get_long() wants to always succeed the parse and
return the maybe incorrect value and the trailing characters to check
against a pre-defined list of acceptable trailing values.  However,
simple_strtoul() explicitly ignores overflows which can cause funny
things like the following to happen:

  echo 18446744073709551616 > /proc/sys/fs/file-max
  cat /proc/sys/fs/file-max
  0

(Which will cause your system to silently die behind your back.)

On the other hand kstrtoul() does do overflow detection but does not
return the trailing characters, and also fails the parse when anything
other than '\n' is a trailing character whereas proc_get_long() wants to
be more lenient.

Now, before adding another kstrtoul() function let's simply add a static
parse strtoul_lenient() which:
 - fails on overflow with -ERANGE
 - returns the trailing characters to the caller

The reason why we should fail on ERANGE is that we already do a partial
fail on overflow right now.  Namely, when the TMPBUFLEN is exceeded.  So
we already reject values such as 184467440737095516160 (21 chars) but
accept values such as 18446744073709551616 (20 chars) but both are
overflows.  So we should just always reject 64bit overflows and not
special-case this based on the number of chars.

Link: http://lkml.kernel.org/r/20190107222700.15954-2-christian@brauner.io
Signed-off-by: Christian Brauner <christian@brauner.io>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joerg Vehlow <lkml@jv-coder.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sysctl.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -68,6 +68,8 @@
 #include <linux/mount.h>
 #include <linux/pipe_fs_i.h>
 
+#include "../lib/kstrtox.h"
+
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 
@@ -2069,6 +2071,41 @@ static void proc_skip_char(char **buf, s
 	}
 }
 
+/**
+ * strtoul_lenient - parse an ASCII formatted integer from a buffer and only
+ *                   fail on overflow
+ *
+ * @cp: kernel buffer containing the string to parse
+ * @endp: pointer to store the trailing characters
+ * @base: the base to use
+ * @res: where the parsed integer will be stored
+ *
+ * In case of success 0 is returned and @res will contain the parsed integer,
+ * @endp will hold any trailing characters.
+ * This function will fail the parse on overflow. If there wasn't an overflow
+ * the function will defer the decision what characters count as invalid to the
+ * caller.
+ */
+static int strtoul_lenient(const char *cp, char **endp, unsigned int base,
+			   unsigned long *res)
+{
+	unsigned long long result;
+	unsigned int rv;
+
+	cp = _parse_integer_fixup_radix(cp, &base);
+	rv = _parse_integer(cp, base, &result);
+	if ((rv & KSTRTOX_OVERFLOW) || (result != (unsigned long)result))
+		return -ERANGE;
+
+	cp += rv;
+
+	if (endp)
+		*endp = (char *)cp;
+
+	*res = (unsigned long)result;
+	return 0;
+}
+
 #define TMPBUFLEN 22
 /**
  * proc_get_long - reads an ASCII formatted integer from a user buffer
@@ -2112,7 +2149,8 @@ static int proc_get_long(char **buf, siz
 	if (!isdigit(*p))
 		return -EINVAL;
 
-	*val = simple_strtoul(p, &p, 0);
+	if (strtoul_lenient(p, &p, 0, val))
+		return -EINVAL;
 
 	len = p - tmp;
 


