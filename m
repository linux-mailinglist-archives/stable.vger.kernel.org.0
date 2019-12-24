Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DF512A357
	for <lists+stable@lfdr.de>; Tue, 24 Dec 2019 18:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfLXRV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Dec 2019 12:21:28 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:47696 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfLXRV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Dec 2019 12:21:28 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 75A3772CCD5;
        Tue, 24 Dec 2019 20:21:24 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 3B2204A4AE7;
        Tue, 24 Dec 2019 20:21:24 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Vitaly Chikunov <vt@altlinux.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: [PATCH v3] tools lib: Fix builds when glibc contains strlcpy
Date:   Tue, 24 Dec 2019 20:20:29 +0300
Message-Id: <20191224172029.19690-1-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Disable a couple of compilation warning (which are treated as errors) on
strlcpy definition and declaration, allow users to compile perf and
kernel (objtool).

1. When glibc have strlcpy (such as in ALT Linux since 2004) objtool and
perf build fails with this (in gcc):

  In file included from exec-cmd.c:3:
  tools/include/linux/string.h:20:15: error: redundant redeclaration of ‘strlcpy’ [-Werror=redundant-decls]
     20 | extern size_t strlcpy(char *dest, const char *src, size_t size);

2. Clang ignores `-Wredundant-decls', but produces another warning when
building perf:

    CC       util/string.o
  ../lib/string.c:99:8: error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
  size_t __weak strlcpy(char *dest, const char *src, size_t size)
  ../../tools/include/linux/compiler.h:66:34: note: expanded from macro '__weak'
  # define __weak                 __attribute__((weak))
  /usr/include/bits/string_fortified.h:151:8: note: previous definition is here
  __NTH (strlcpy (char *__restrict __dest, const char *__restrict __src,

Fixes: ce99091 ("perf tools: Move strlcpy() from perf to tools/lib/string.c")
Fixes: 0215d59 ("tools lib: Reinstate strlcpy() header guard with __UCLIBC__")
Resolves: https://bugzilla.kernel.org/show_bug.cgi?id=118481
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: stable@vger.kernel.org
---
Changes since v2:
- v2 was failing to compile on gcc-4.9, because there was no `-Wignored-attributes'.
  Make this pragma only efficient for Clang.
Reported-by: kbuild test robot <lkp@intel.com>

Changes since v1:
- Fix compiling with clang due to __weak triggering `-Wignored-attributes'.

 tools/include/linux/string.h | 3 +++
 tools/lib/string.c           | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/include/linux/string.h b/tools/include/linux/string.h
index 980cb9266718..99ede7f5dfb8 100644
--- a/tools/include/linux/string.h
+++ b/tools/include/linux/string.h
@@ -17,7 +17,10 @@ int strtobool(const char *s, bool *res);
  * However uClibc headers also define __GLIBC__ hence the hack below
  */
 #if defined(__GLIBC__) && !defined(__UCLIBC__)
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wredundant-decls"
 extern size_t strlcpy(char *dest, const char *src, size_t size);
+#pragma GCC diagnostic pop
 #endif
 
 char *str_error_r(int errnum, char *buf, size_t buflen);
diff --git a/tools/lib/string.c b/tools/lib/string.c
index f2ae1b87c719..f645343815de 100644
--- a/tools/lib/string.c
+++ b/tools/lib/string.c
@@ -96,6 +96,10 @@ int strtobool(const char *s, bool *res)
  * If libc has strlcpy() then that version will override this
  * implementation:
  */
+#ifdef __clang__
+#pragma clang diagnostic push
+#pragma clang diagnostic ignored "-Wignored-attributes"
+#endif
 size_t __weak strlcpy(char *dest, const char *src, size_t size)
 {
 	size_t ret = strlen(src);
@@ -107,6 +111,9 @@ size_t __weak strlcpy(char *dest, const char *src, size_t size)
 	}
 	return ret;
 }
+#ifdef __clang__
+#pragma clang diagnostic pop
+#endif
 
 /**
  * skip_spaces - Removes leading whitespace from @str.
-- 
2.11.0

