Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD271EAD9E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgFASIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbgFASIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:08:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDF9220872;
        Mon,  1 Jun 2020 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034910;
        bh=qOxoZU27BS4ecyYbGhcESok/bly/SpCHfZfU+pixZLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bf3AZK17CTbWsVEitNDAM3VJAa5PMQwItQG2DWjUFvKNtc8IwAX/Ef9jOUjKYvliU
         gfLfkIryQGN/bSpuyKwwIiG+fO4Xg7dwADZ935A+1tgXYmlTAPRqR05hCGfNO5p7YX
         gP0BDVmIQO+SKesraAHM+CMYZPoPEnqnHpARSsZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/142] csky: Fixup raw_copy_from_user()
Date:   Mon,  1 Jun 2020 19:53:38 +0200
Message-Id: <20200601174044.154177905@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 51bb38cb78363fdad1f89e87357b7bc73e39ba88 ]

If raw_copy_from_user(to, from, N) returns K, callers expect
the first N - K bytes starting at to to have been replaced with
the contents of corresponding area starting at from and the last
K bytes of destination *left* *unmodified*.

What arch/sky/lib/usercopy.c is doing is broken - it can lead to e.g.
data corruption on write(2).

raw_copy_to_user() is inaccurate about return value, which is a bug,
but consequences are less drastic than for raw_copy_from_user().
And just what are those access_ok() doing in there?  I mean, look into
linux/uaccess.h; that's where we do that check (as well as zero tail
on failure in the callers that need zeroing).

AFAICS, all of that shouldn't be hard to fix; something like a patch
below might make a useful starting point.

I would suggest moving these macros into usercopy.c (they are never
used anywhere else) and possibly expanding them there; if you leave
them alive, please at least rename __copy_user_zeroing(). Again,
it must not zero anything on failed read.

Said that, I'm not sure we won't be better off simply turning
usercopy.c into usercopy.S - all that is left there is a couple of
functions, each consisting only of inline asm.

Guo Ren reply:

Yes, raw_copy_from_user is wrong, it's no need zeroing code.

unsigned long _copy_from_user(void *to, const void __user *from,
unsigned long n)
{
        unsigned long res = n;
        might_fault();
        if (likely(access_ok(from, n))) {
                kasan_check_write(to, n);
                res = raw_copy_from_user(to, from, n);
        }
        if (unlikely(res))
                memset(to + (n - res), 0, res);
        return res;
}
EXPORT_SYMBOL(_copy_from_user);

You are right and access_ok() should be removed.

but, how about:
do {
...
        "2:     stw     %3, (%1, 0)     \n"             \
+       "       subi    %0, 4          \n"               \
        "9:     stw     %4, (%1, 4)     \n"             \
+       "       subi    %0, 4          \n"               \
        "10:    stw     %5, (%1, 8)     \n"             \
+       "       subi    %0, 4          \n"               \
        "11:    stw     %6, (%1, 12)    \n"             \
+       "       subi    %0, 4          \n"               \
        "       addi    %2, 16          \n"             \
        "       addi    %1, 16          \n"             \

Don't expand __ex_table

AI Viro reply:

Hey, I've no idea about the instruction scheduling on csky -
if that doesn't slow the things down, all the better.  It's just
that copy_to_user() and friends are on fairly hot codepaths,
and in quite a few situations they will dominate the speed of
e.g. read(2).  So I tried to keep the fast path unchanged.
Up to the architecture maintainers, obviously.  Which would be
you...

As for the fixups size increase (__ex_table size is unchanged)...
You have each of those macros expanded exactly once.
So the size is not a serious argument, IMO - useless complexity
would be, if it is, in fact, useless; the size... not really,
especially since those extra subi will at least offset it.

Again, up to you - asm optimizations of (essentially)
memcpy()-style loops are tricky and can depend upon the
fairly subtle details of architecture.  So even on something
I know reasonably well I would resort to direct experiments
if I can't pass the buck to architecture maintainers.

It *is* worth optimizing - this is where read() from a file
that is already in page cache spends most of the time, etc.

Guo Ren reply:

Thx, after fixup some typo “sub %0, 4”, apply the patch.

TODO:
 - user copy/from codes are still need optimizing.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/include/asm/uaccess.h | 49 +++++++++++++++++----------------
 arch/csky/lib/usercopy.c        |  8 ++----
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/csky/include/asm/uaccess.h b/arch/csky/include/asm/uaccess.h
index eaa1c3403a42..60f8a4112588 100644
--- a/arch/csky/include/asm/uaccess.h
+++ b/arch/csky/include/asm/uaccess.h
@@ -254,7 +254,7 @@ do {								\
 
 extern int __get_user_bad(void);
 
-#define __copy_user(to, from, n)			\
+#define ___copy_to_user(to, from, n)			\
 do {							\
 	int w0, w1, w2, w3;				\
 	asm volatile(					\
@@ -289,31 +289,34 @@ do {							\
 	"       subi    %0, 4           \n"		\
 	"       br      3b              \n"		\
 	"5:     cmpnei  %0, 0           \n"  /* 1B */   \
-	"       bf      8f              \n"		\
+	"       bf      13f             \n"		\
 	"       ldb     %3, (%2, 0)     \n"		\
 	"6:     stb     %3, (%1, 0)     \n"		\
 	"       addi    %2,  1          \n"		\
 	"       addi    %1,  1          \n"		\
 	"       subi    %0,  1          \n"		\
 	"       br      5b              \n"		\
-	"7:     br      8f              \n"		\
+	"7:     subi	%0,  4          \n"		\
+	"8:     subi	%0,  4          \n"		\
+	"12:    subi	%0,  4          \n"		\
+	"       br      13f             \n"		\
 	".section __ex_table, \"a\"     \n"		\
 	".align   2                     \n"		\
-	".long    2b, 7b                \n"		\
-	".long    9b, 7b                \n"		\
-	".long   10b, 7b                \n"		\
+	".long    2b, 13f               \n"		\
+	".long    4b, 13f               \n"		\
+	".long    6b, 13f               \n"		\
+	".long    9b, 12b               \n"		\
+	".long   10b, 8b                \n"		\
 	".long   11b, 7b                \n"		\
-	".long    4b, 7b                \n"		\
-	".long    6b, 7b                \n"		\
 	".previous                      \n"		\
-	"8:                             \n"		\
+	"13:                            \n"		\
 	: "=r"(n), "=r"(to), "=r"(from), "=r"(w0),	\
 	  "=r"(w1), "=r"(w2), "=r"(w3)			\
 	: "0"(n), "1"(to), "2"(from)			\
 	: "memory");					\
 } while (0)
 
-#define __copy_user_zeroing(to, from, n)		\
+#define ___copy_from_user(to, from, n)			\
 do {							\
 	int tmp;					\
 	int nsave;					\
@@ -356,22 +359,22 @@ do {							\
 	"       addi    %1,  1          \n"		\
 	"       subi    %0,  1          \n"		\
 	"       br      5b              \n"		\
-	"8:     mov     %3, %0          \n"		\
-	"       movi    %4, 0           \n"		\
-	"9:     stb     %4, (%1, 0)     \n"		\
-	"       addi    %1, 1           \n"		\
-	"       subi    %3, 1           \n"		\
-	"       cmpnei  %3, 0           \n"		\
-	"       bt      9b              \n"		\
-	"       br      7f              \n"		\
+	"8:     stw     %3, (%1, 0)     \n"		\
+	"       subi    %0, 4           \n"		\
+	"       bf      7f              \n"		\
+	"9:     subi    %0, 8           \n"		\
+	"       bf      7f              \n"		\
+	"13:    stw     %3, (%1, 8)     \n"		\
+	"       subi    %0, 12          \n"		\
+	"       bf      7f              \n"		\
 	".section __ex_table, \"a\"     \n"		\
 	".align   2                     \n"		\
-	".long    2b, 8b                \n"		\
+	".long    2b, 7f                \n"		\
+	".long    4b, 7f                \n"		\
+	".long    6b, 7f                \n"		\
 	".long   10b, 8b                \n"		\
-	".long   11b, 8b                \n"		\
-	".long   12b, 8b                \n"		\
-	".long    4b, 8b                \n"		\
-	".long    6b, 8b                \n"		\
+	".long   11b, 9b                \n"		\
+	".long   12b,13b                \n"		\
 	".previous                      \n"		\
 	"7:                             \n"		\
 	: "=r"(n), "=r"(to), "=r"(from), "=r"(nsave),	\
diff --git a/arch/csky/lib/usercopy.c b/arch/csky/lib/usercopy.c
index 647a23986fb5..3c9bd645e643 100644
--- a/arch/csky/lib/usercopy.c
+++ b/arch/csky/lib/usercopy.c
@@ -7,10 +7,7 @@
 unsigned long raw_copy_from_user(void *to, const void *from,
 			unsigned long n)
 {
-	if (access_ok(from, n))
-		__copy_user_zeroing(to, from, n);
-	else
-		memset(to, 0, n);
+	___copy_from_user(to, from, n);
 	return n;
 }
 EXPORT_SYMBOL(raw_copy_from_user);
@@ -18,8 +15,7 @@ EXPORT_SYMBOL(raw_copy_from_user);
 unsigned long raw_copy_to_user(void *to, const void *from,
 			unsigned long n)
 {
-	if (access_ok(to, n))
-		__copy_user(to, from, n);
+	___copy_to_user(to, from, n);
 	return n;
 }
 EXPORT_SYMBOL(raw_copy_to_user);
-- 
2.25.1



