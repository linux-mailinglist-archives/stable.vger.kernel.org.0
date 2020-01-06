Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3553B1315C1
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 17:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgAFQI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 11:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgAFQI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 11:08:29 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7209F2146E;
        Mon,  6 Jan 2020 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578326908;
        bh=ErlFtkVUff7rJnFn/VFWsrlXzAljL/V8L0g2Dbm0nYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEONPov6elHV2X6LUJYG+o0dnJDZKEj0GZOVcyd1fjHvSqT3qeciKpUiZSa5LymlH
         PsGIkMj/67V8W8m6aSfob0z4VdhrQVoiK+0Ty8nyNzXo/mFh0/GEvPDNlMpQvKENSg
         oQ9ijyIta5hpZXFmySh4szHpIoik1wBxdOfmWoGU=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vitaly Chikunov <vt@altlinux.org>,
        Dmitry Levin <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        kbuild test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/20] tools lib: Fix builds when glibc contains strlcpy()
Date:   Mon,  6 Jan 2020 13:07:05 -0300
Message-Id: <20200106160705.10899-21-acme@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200106160705.10899-1-acme@kernel.org>
References: <20200106160705.10899-1-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Chikunov <vt@altlinux.org>

Disable a couple of compilation warnings (which are treated as errors)
on strlcpy() definition and declaration, allowing users to compile perf
and kernel (objtool) when:

1. glibc have strlcpy() (such as in ALT Linux since 2004) objtool and
   perf build fails with this (in gcc):

  In file included from exec-cmd.c:3:
  tools/include/linux/string.h:20:15: error: redundant redeclaration of ‘strlcpy’ [-Werror=redundant-decls]
     20 | extern size_t strlcpy(char *dest, const char *src, size_t size);

2. clang ignores `-Wredundant-decls', but produces another warning when
   building perf:

    CC       util/string.o
  ../lib/string.c:99:8: error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
  size_t __weak strlcpy(char *dest, const char *src, size_t size)
  ../../tools/include/linux/compiler.h:66:34: note: expanded from macro '__weak'
  # define __weak                 __attribute__((weak))
  /usr/include/bits/string_fortified.h:151:8: note: previous definition is here
  __NTH (strlcpy (char *__restrict __dest, const char *__restrict __src,

Committer notes:

The

 #pragma GCC diagnostic

directive was introduced in gcc 4.6, so check for that as well.

Fixes: ce99091 ("perf tools: Move strlcpy() from perf to tools/lib/string.c")
Fixes: 0215d59 ("tools lib: Reinstate strlcpy() header guard with __UCLIBC__")
Resolves: https://bugzilla.kernel.org/show_bug.cgi?id=118481
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Dmitry Levin <ldv@altlinux.org>
Cc: Dmitry Levin <ldv@altlinux.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: kbuild test robot <lkp@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Link: http://lore.kernel.org/lkml/20191224172029.19690-1-vt@altlinux.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/string.h | 8 ++++++++
 tools/lib/string.c           | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/tools/include/linux/string.h b/tools/include/linux/string.h
index 980cb9266718..5e9e781905ed 100644
--- a/tools/include/linux/string.h
+++ b/tools/include/linux/string.h
@@ -17,7 +17,15 @@ int strtobool(const char *s, bool *res);
  * However uClibc headers also define __GLIBC__ hence the hack below
  */
 #if defined(__GLIBC__) && !defined(__UCLIBC__)
+// pragma diagnostic was introduced in gcc 4.6
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wredundant-decls"
+#endif
 extern size_t strlcpy(char *dest, const char *src, size_t size);
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
+#pragma GCC diagnostic pop
+#endif
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
2.21.1

