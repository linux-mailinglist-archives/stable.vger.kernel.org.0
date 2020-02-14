Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71CD15F2C2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgBNPul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbgBNPul (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C0D2467E;
        Fri, 14 Feb 2020 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695440;
        bh=ERfQ3eAbohrmh759MhxBh8l+4EKx0sFujaFwkM2jL3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8jEdBgmBZeh3KNLNaX/BSAFHJuISr9VUNgeqjgzw6DznjKp/0U6CXgemgPt5KOJK
         zcx70d/bOGs57ipvq0glbEeceZMm9djERoR8IyhL953FXbakRNt9i9BAjBy3Q3IcX/
         Lm6ZnSMcAYUWgcTXtuJ+b2mMD/hc7tel0oC6x2xw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siddhesh Poyarekar <siddhesh@gotplt.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Tim Bird <tim.bird@sony.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 081/542] kselftest: Minimise dependency of get_size on C library interfaces
Date:   Fri, 14 Feb 2020 10:41:13 -0500
Message-Id: <20200214154854.6746-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddhesh Poyarekar <siddhesh@gotplt.org>

[ Upstream commit 6b64a650f0b2ae3940698f401732988699eecf7a ]

It was observed[1] on arm64 that __builtin_strlen led to an infinite
loop in the get_size selftest.  This is because __builtin_strlen (and
other builtins) may sometimes result in a call to the C library
function.  The C library implementation of strlen uses an IFUNC
resolver to load the most efficient strlen implementation for the
underlying machine and hence has a PLT indirection even for static
binaries.  Because this binary avoids the C library startup routines,
the PLT initialization never happens and hence the program gets stuck
in an infinite loop.

On x86_64 the __builtin_strlen just happens to expand inline and avoid
the call but that is not always guaranteed.

Further, while testing on x86_64 (Fedora 31), it was observed that the
test also failed with a segfault inside write() because the generated
code for the write function in glibc seems to access TLS before the
syscall (probably due to the cancellation point check) and fails
because TLS is not initialised.

To mitigate these problems, this patch reduces the interface with the
C library to just the syscall function.  The syscall function still
sets errno on failure, which is undesirable but for now it only
affects cases where syscalls fail.

[1] https://bugs.linaro.org/show_bug.cgi?id=5479

Signed-off-by: Siddhesh Poyarekar <siddhesh@gotplt.org>
Reported-by: Masami Hiramatsu <masami.hiramatsu@linaro.org>
Tested-by: Masami Hiramatsu <masami.hiramatsu@linaro.org>
Reviewed-by: Tim Bird <tim.bird@sony.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/size/get_size.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/size/get_size.c b/tools/testing/selftests/size/get_size.c
index 2ad45b9443550..2980b1a63366b 100644
--- a/tools/testing/selftests/size/get_size.c
+++ b/tools/testing/selftests/size/get_size.c
@@ -11,23 +11,35 @@
  * own execution.  It also attempts to have as few dependencies
  * on kernel features as possible.
  *
- * It should be statically linked, with startup libs avoided.
- * It uses no library calls, and only the following 3 syscalls:
+ * It should be statically linked, with startup libs avoided.  It uses
+ * no library calls except the syscall() function for the following 3
+ * syscalls:
  *   sysinfo(), write(), and _exit()
  *
  * For output, it avoids printf (which in some C libraries
  * has large external dependencies) by  implementing it's own
  * number output and print routines, and using __builtin_strlen()
+ *
+ * The test may crash if any of the above syscalls fails because in some
+ * libc implementations (e.g. the GNU C Library) errno is saved in
+ * thread-local storage, which does not get initialized due to avoiding
+ * startup libs.
  */
 
 #include <sys/sysinfo.h>
 #include <unistd.h>
+#include <sys/syscall.h>
 
 #define STDOUT_FILENO 1
 
 static int print(const char *s)
 {
-	return write(STDOUT_FILENO, s, __builtin_strlen(s));
+	size_t len = 0;
+
+	while (s[len] != '\0')
+		len++;
+
+	return syscall(SYS_write, STDOUT_FILENO, s, len);
 }
 
 static inline char *num_to_str(unsigned long num, char *buf, int len)
@@ -79,12 +91,12 @@ void _start(void)
 	print("TAP version 13\n");
 	print("# Testing system size.\n");
 
-	ccode = sysinfo(&info);
+	ccode = syscall(SYS_sysinfo, &info);
 	if (ccode < 0) {
 		print("not ok 1");
 		print(test_name);
 		print(" ---\n reason: \"could not get sysinfo\"\n ...\n");
-		_exit(ccode);
+		syscall(SYS_exit, ccode);
 	}
 	print("ok 1");
 	print(test_name);
@@ -100,5 +112,5 @@ void _start(void)
 	print(" ...\n");
 	print("1..1\n");
 
-	_exit(0);
+	syscall(SYS_exit, 0);
 }
-- 
2.20.1

