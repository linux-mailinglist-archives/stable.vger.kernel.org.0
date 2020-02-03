Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC23150E0F
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgBCQZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:25:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgBCQZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:46 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF1F2080C;
        Mon,  3 Feb 2020 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747145;
        bh=LZAGAJaQ3n3fZVaLbEAb93zTGMspTgL5PM6oViMILNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k05EFcoT8m4iKG7K45XoAEqHNEbdCn4D+dea3yFJyZ/GXjdPNMMFnMCq6hA81mp+l
         oQmMhSKqsZBI1QFu//TJumb12TvVu6OGIgCXFbLy5QHLfZxeFPKIC5SL9GKDzZ5KmA
         b8fbmW2nK6xfP3t8p2c6n8fhfsZkMlg6jbrDYZJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Dmitry Levin <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        kbuild test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 30/68] tools lib: Fix builds when glibc contains strlcpy()
Date:   Mon,  3 Feb 2020 16:19:26 +0000
Message-Id: <20200203161909.959158906@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Chikunov <vt@altlinux.org>

commit 6c4798d3f08b81c2c52936b10e0fa872590c96ae upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/include/linux/string.h |    8 ++++++++
 tools/lib/string.c           |    7 +++++++
 2 files changed, 15 insertions(+)

--- a/tools/include/linux/string.h
+++ b/tools/include/linux/string.h
@@ -13,7 +13,15 @@ int strtobool(const char *s, bool *res);
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
--- a/tools/lib/string.c
+++ b/tools/lib/string.c
@@ -76,6 +76,10 @@ int strtobool(const char *s, bool *res)
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
@@ -87,3 +91,6 @@ size_t __weak strlcpy(char *dest, const
 	}
 	return ret;
 }
+#ifdef __clang__
+#pragma clang diagnostic pop
+#endif


