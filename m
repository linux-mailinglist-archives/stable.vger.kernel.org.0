Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C31761163EC
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 22:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfLHVze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 16:55:34 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:58156 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfLHVze (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 16:55:34 -0500
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2019 16:55:33 EST
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id CE56F72CCD5;
        Mon,  9 Dec 2019 00:46:15 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 9DF744A4AEF;
        Mon,  9 Dec 2019 00:46:15 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc:     "Dmitry V . Levin" <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: [PATCH] tools lib: Disable redundant-delcs error for strlcpy
Date:   Mon,  9 Dec 2019 00:46:07 +0300
Message-Id: <20191208214607.20679-1-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Disable `redundant-decls' error for strlcpy declaration and solve build
error allowing users to compile vanilla kernels.

When glibc have strlcpy (such as in ALT linux since 2004) objtool and
perf build fails with something like:

  In file included from exec-cmd.c:3:
  tools/include/linux/string.h:20:15: error: redundant redeclaration of ‘strlcpy’ [-Werror=redundant-decls]
     20 | extern size_t strlcpy(char *dest, const char *src, size_t size);
	|               ^~~~~~~

It's very hard to produce a perfect fix for that since it is a header
file indirectly pulled from many sources from different Makefile builds.

Fixes: ce99091 ("perf tools: Move strlcpy() from perf to tools/lib/string.c")
Fixes: 0215d59 ("tools lib: Reinstate strlcpy() header guard with __UCLIBC__")
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: stable@vger.kernel.org
---
 tools/include/linux/string.h | 3 +++
 1 file changed, 3 insertions(+)

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
-- 
2.11.0

