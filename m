Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07512061AC
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392662AbgFWUrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392642AbgFWUrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:47:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 607E220781;
        Tue, 23 Jun 2020 20:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945239;
        bh=cUVD8MUa7zKGUm2OVDFHUR8FBVnWGLkMd7Cf7ZGfS2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvVtf1FvvyOIMcUuJmDO1VQNHczagI0c4iAtCj8PUQ38yGigRtTg+SzyR0WIOuGyw
         WnPInRNRSuQAw9PCTzewhvEYUDv0SFyJM6LdM9Skyws2kcEx9XtF9MWlGFRVKLrMC4
         cURqgl1hx2oVkIQC9+eQjo/oxYCgmiJdb3Cn7xQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 093/136] lib/zlib: remove outdated and incorrect pre-increment optimization
Date:   Tue, 23 Jun 2020 21:59:09 +0200
Message-Id: <20200623195308.342798785@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit acaab7335bd6f0c0b54ce3a00bd7f18222ce0f5f ]

The zlib inflate code has an old micro-optimization based on the
assumption that for pre-increment memory accesses, the compiler will
generate code that fits better into the processor's pipeline than what
would be generated for post-increment memory accesses.

This optimization was already removed in upstream zlib in 2016:
https://github.com/madler/zlib/commit/9aaec95e8211

This optimization causes UB according to C99, which says in section 6.5.6
"Additive operators": "If both the pointer operand and the result point to
elements of the same array object, or one past the last element of the
array object, the evaluation shall not produce an overflow; otherwise, the
behavior is undefined".

This UB is not only a theoretical concern, but can also cause trouble for
future work on compiler-based sanitizers.

According to the zlib commit, this optimization also is not optimal
anymore with modern compilers.

Replace uses of OFF, PUP and UP_UNALIGNED with their definitions in the
POSTINC case, and remove the macro definitions, just like in the upstream
patch.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Link: http://lkml.kernel.org/r/20200507123112.252723-1-jannh@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/zlib_inflate/inffast.c | 91 +++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 56 deletions(-)

diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
index 2c13ecc5bb2c7..ed1f3df272602 100644
--- a/lib/zlib_inflate/inffast.c
+++ b/lib/zlib_inflate/inffast.c
@@ -10,17 +10,6 @@
 
 #ifndef ASMINF
 
-/* Allow machine dependent optimization for post-increment or pre-increment.
-   Based on testing to date,
-   Pre-increment preferred for:
-   - PowerPC G3 (Adler)
-   - MIPS R5000 (Randers-Pehrson)
-   Post-increment preferred for:
-   - none
-   No measurable difference:
-   - Pentium III (Anderson)
-   - M68060 (Nikl)
- */
 union uu {
 	unsigned short us;
 	unsigned char b[2];
@@ -38,16 +27,6 @@ get_unaligned16(const unsigned short *p)
 	return mm.us;
 }
 
-#ifdef POSTINC
-#  define OFF 0
-#  define PUP(a) *(a)++
-#  define UP_UNALIGNED(a) get_unaligned16((a)++)
-#else
-#  define OFF 1
-#  define PUP(a) *++(a)
-#  define UP_UNALIGNED(a) get_unaligned16(++(a))
-#endif
-
 /*
    Decode literal, length, and distance codes and write out the resulting
    literal and match bytes until either not enough input or output is
@@ -115,9 +94,9 @@ void inflate_fast(z_streamp strm, unsigned start)
 
     /* copy state to local variables */
     state = (struct inflate_state *)strm->state;
-    in = strm->next_in - OFF;
+    in = strm->next_in;
     last = in + (strm->avail_in - 5);
-    out = strm->next_out - OFF;
+    out = strm->next_out;
     beg = out - (start - strm->avail_out);
     end = out + (strm->avail_out - 257);
 #ifdef INFLATE_STRICT
@@ -138,9 +117,9 @@ void inflate_fast(z_streamp strm, unsigned start)
        input data or output space */
     do {
         if (bits < 15) {
-            hold += (unsigned long)(PUP(in)) << bits;
+            hold += (unsigned long)(*in++) << bits;
             bits += 8;
-            hold += (unsigned long)(PUP(in)) << bits;
+            hold += (unsigned long)(*in++) << bits;
             bits += 8;
         }
         this = lcode[hold & lmask];
@@ -150,14 +129,14 @@ void inflate_fast(z_streamp strm, unsigned start)
         bits -= op;
         op = (unsigned)(this.op);
         if (op == 0) {                          /* literal */
-            PUP(out) = (unsigned char)(this.val);
+            *out++ = (unsigned char)(this.val);
         }
         else if (op & 16) {                     /* length base */
             len = (unsigned)(this.val);
             op &= 15;                           /* number of extra bits */
             if (op) {
                 if (bits < op) {
-                    hold += (unsigned long)(PUP(in)) << bits;
+                    hold += (unsigned long)(*in++) << bits;
                     bits += 8;
                 }
                 len += (unsigned)hold & ((1U << op) - 1);
@@ -165,9 +144,9 @@ void inflate_fast(z_streamp strm, unsigned start)
                 bits -= op;
             }
             if (bits < 15) {
-                hold += (unsigned long)(PUP(in)) << bits;
+                hold += (unsigned long)(*in++) << bits;
                 bits += 8;
-                hold += (unsigned long)(PUP(in)) << bits;
+                hold += (unsigned long)(*in++) << bits;
                 bits += 8;
             }
             this = dcode[hold & dmask];
@@ -180,10 +159,10 @@ void inflate_fast(z_streamp strm, unsigned start)
                 dist = (unsigned)(this.val);
                 op &= 15;                       /* number of extra bits */
                 if (bits < op) {
-                    hold += (unsigned long)(PUP(in)) << bits;
+                    hold += (unsigned long)(*in++) << bits;
                     bits += 8;
                     if (bits < op) {
-                        hold += (unsigned long)(PUP(in)) << bits;
+                        hold += (unsigned long)(*in++) << bits;
                         bits += 8;
                     }
                 }
@@ -205,13 +184,13 @@ void inflate_fast(z_streamp strm, unsigned start)
                         state->mode = BAD;
                         break;
                     }
-                    from = window - OFF;
+                    from = window;
                     if (write == 0) {           /* very common case */
                         from += wsize - op;
                         if (op < len) {         /* some from window */
                             len -= op;
                             do {
-                                PUP(out) = PUP(from);
+                                *out++ = *from++;
                             } while (--op);
                             from = out - dist;  /* rest from output */
                         }
@@ -222,14 +201,14 @@ void inflate_fast(z_streamp strm, unsigned start)
                         if (op < len) {         /* some from end of window */
                             len -= op;
                             do {
-                                PUP(out) = PUP(from);
+                                *out++ = *from++;
                             } while (--op);
-                            from = window - OFF;
+                            from = window;
                             if (write < len) {  /* some from start of window */
                                 op = write;
                                 len -= op;
                                 do {
-                                    PUP(out) = PUP(from);
+                                    *out++ = *from++;
                                 } while (--op);
                                 from = out - dist;      /* rest from output */
                             }
@@ -240,21 +219,21 @@ void inflate_fast(z_streamp strm, unsigned start)
                         if (op < len) {         /* some from window */
                             len -= op;
                             do {
-                                PUP(out) = PUP(from);
+                                *out++ = *from++;
                             } while (--op);
                             from = out - dist;  /* rest from output */
                         }
                     }
                     while (len > 2) {
-                        PUP(out) = PUP(from);
-                        PUP(out) = PUP(from);
-                        PUP(out) = PUP(from);
+                        *out++ = *from++;
+                        *out++ = *from++;
+                        *out++ = *from++;
                         len -= 3;
                     }
                     if (len) {
-                        PUP(out) = PUP(from);
+                        *out++ = *from++;
                         if (len > 1)
-                            PUP(out) = PUP(from);
+                            *out++ = *from++;
                     }
                 }
                 else {
@@ -264,29 +243,29 @@ void inflate_fast(z_streamp strm, unsigned start)
                     from = out - dist;          /* copy direct from output */
 		    /* minimum length is three */
 		    /* Align out addr */
-		    if (!((long)(out - 1 + OFF) & 1)) {
-			PUP(out) = PUP(from);
+		    if (!((long)(out - 1) & 1)) {
+			*out++ = *from++;
 			len--;
 		    }
-		    sout = (unsigned short *)(out - OFF);
+		    sout = (unsigned short *)(out);
 		    if (dist > 2) {
 			unsigned short *sfrom;
 
-			sfrom = (unsigned short *)(from - OFF);
+			sfrom = (unsigned short *)(from);
 			loops = len >> 1;
 			do
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-			    PUP(sout) = PUP(sfrom);
+			    *sout++ = *sfrom++;
 #else
-			    PUP(sout) = UP_UNALIGNED(sfrom);
+			    *sout++ = get_unaligned16(sfrom++);
 #endif
 			while (--loops);
-			out = (unsigned char *)sout + OFF;
-			from = (unsigned char *)sfrom + OFF;
+			out = (unsigned char *)sout;
+			from = (unsigned char *)sfrom;
 		    } else { /* dist == 1 or dist == 2 */
 			unsigned short pat16;
 
-			pat16 = *(sout-1+OFF);
+			pat16 = *(sout-1);
 			if (dist == 1) {
 				union uu mm;
 				/* copy one char pattern to both bytes */
@@ -296,12 +275,12 @@ void inflate_fast(z_streamp strm, unsigned start)
 			}
 			loops = len >> 1;
 			do
-			    PUP(sout) = pat16;
+			    *sout++ = pat16;
 			while (--loops);
-			out = (unsigned char *)sout + OFF;
+			out = (unsigned char *)sout;
 		    }
 		    if (len & 1)
-			PUP(out) = PUP(from);
+			*out++ = *from++;
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */
@@ -336,8 +315,8 @@ void inflate_fast(z_streamp strm, unsigned start)
     hold &= (1U << bits) - 1;
 
     /* update state and return */
-    strm->next_in = in + OFF;
-    strm->next_out = out + OFF;
+    strm->next_in = in;
+    strm->next_out = out;
     strm->avail_in = (unsigned)(in < last ? 5 + (last - in) : 5 - (in - last));
     strm->avail_out = (unsigned)(out < end ?
                                  257 + (end - out) : 257 - (out - end));
-- 
2.25.1



