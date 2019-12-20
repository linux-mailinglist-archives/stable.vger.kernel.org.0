Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672ED1285B6
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 00:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLTXwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 18:52:51 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:46176 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfLTXwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 18:52:51 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 32B7872CCE9;
        Sat, 21 Dec 2019 02:52:48 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id B4EFF4A4AEF;
        Sat, 21 Dec 2019 02:52:47 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Vitaly Chikunov <vt@altlinux.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] tools lib: Fix builds when glibc contains strlcpy
Date:   Sat, 21 Dec 2019 02:52:39 +0300
Message-Id: <20191220235239.26928-1-vt@altlinux.org>
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
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: stable@vger.kernel.org
---
 tools/include/linux/string.h | 3 +++
 tools/lib/string.c           | 3 +++
 2 files changed, 6 insertions(+)

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
index f2ae1b87c719..65b569014446 100644
--- a/tools/lib/string.c
+++ b/tools/lib/string.c
@@ -96,6 +96,8 @@ int strtobool(const char *s, bool *res)
  * If libc has strlcpy() then that version will override this
  * implementation:
  */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wignored-attributes"
 size_t __weak strlcpy(char *dest, const char *src, size_t size)
 {
 	size_t ret = strlen(src);
@@ -107,6 +109,7 @@ size_t __weak strlcpy(char *dest, const char *src, size_t size)
 	}
 	return ret;
 }
+#pragma GCC diagnostic pop
 
 /**
  * skip_spaces - Removes leading whitespace from @str.
-- 
2.11.0

