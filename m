Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB4449753F
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 20:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiAWTcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 14:32:20 -0500
Received: from mail.efficios.com ([167.114.26.124]:59614 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiAWTcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 14:32:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E826533CF67;
        Sun, 23 Jan 2022 14:32:16 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id h6IzOI8ey4hQ; Sun, 23 Jan 2022 14:32:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id BEC2B33CF66;
        Sun, 23 Jan 2022 14:32:15 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com BEC2B33CF66
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1642966335;
        bh=zzzUGnQTdXdaz95fMULZVWKGcJHsP+p8zelCLBiuEaA=;
        h=From:To:Date:Message-Id;
        b=RCQIiVl0Wyi30ejckwUYhClp8AMBdlKC2h4B+7YvKGGwsgUBN2P2qZISEu1A02zJy
         1zSTr9GESwsLAkduavn4r/MqRl61UCPqmjgp+qvEaDAkrlRTtw7O0JkwsJGpLeQwBZ
         CTf49W7bC3sVbXst+qVk4gNk4TZdglTydQJpWDMeWMSzLjyIXq2t3TB9RqkJ/EbD7c
         azOztK9yq8+friXdUSnHmUkHSFk51san3eS/XeAZ8+WQC14Lu0cK7tsqoHLyWU2gMx
         11sGO6iQr4R+AyydP9rEmUDE7pK1VtPN6WLSEJwgieaJOTZrN15DzRuCwo3OggOdmS
         U5xGqlvzOsqvQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NbSC7Oyozs_q; Sun, 23 Jan 2022 14:32:15 -0500 (EST)
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by mail.efficios.com (Postfix) with ESMTPSA id 1D2BE33D136;
        Sun, 23 Jan 2022 14:32:15 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Florian Weimer <fw@deneb.enyo.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Watson <davejwatson@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Ben Maurer <bmaurer@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Joel Fernandes <joelaf@google.com>
Subject: [RFC PATCH] rseq: Fix broken uapi field layout on 32-bit little endian
Date:   Sun, 23 Jan 2022 14:31:54 -0500
Message-Id: <20220123193154.14565-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rseq rseq_cs.ptr.{ptr32,padding} uapi endianness handling is
entirely wrong on 32-bit little endian: a preprocessor logic mistake
wrongly uses the big endian field layout on 32-bit little endian
architectures.

Fortunately, those ptr32 accessors were never used within the kernel,
and only meant as a convenience for user-space.

While working on fixing the ppc32 support in librseq [1], I made sure
all 32-bit little endian architectures stopped depending on little
endian byte ordering by using the ptr32 field. It led me to discover
this wrong ptr32 field ordering on little endian.

Because it is already exposed as a UAPI, all we can do for the existing
fields is document the wrong behavior and encourage users to use
alternative mechanisms.

Introduce a new rseq_cs.arch field with correct field ordering. Use this
opportunity to improve the layout so accesses to architecture fields on
both 32-bit and 64-bit architectures are done through the same field
hierarchy, which is much nicer than the previous scheme.

The intended use is now:

* rseq_thread_area->rseq_cs.ptr64: Access the 64-bit value of the rseq_cs
				   pointer. Available on all
                                   architectures (unchanged).

* rseq_thread_area->rseq_cs.arch.ptr: Access the architecture specific
				      layout of the rseq_cs pointer. This
				      is a 32-bit field on 32-bit
				      architectures, and a 64-bit field on
                                      64-bit architectures.

Link: https://git.kernel.org/pub/scm/libs/librseq/librseq.git/ [1]
Fixes: ec9c82e03a74 ("rseq: uapi: Declare rseq_cs field as union, update includes")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-api@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Watson <davejwatson@fb.com>
Cc: Paul Turner <pjt@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Ben Maurer <bmaurer@fb.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
---
 include/uapi/linux/rseq.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
index 9a402fdb60e9..68f61cdb45db 100644
--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -108,6 +108,12 @@ struct rseq {
 	 */
 	union {
 		__u64 ptr64;
+
+		/*
+		 * The "ptr" field layout is broken on little-endian
+		 * 32-bit architectures due to wrong preprocessor logic.
+		 * DO NOT USE.
+		 */
 #ifdef __LP64__
 		__u64 ptr;
 #else
@@ -121,6 +127,23 @@ struct rseq {
 #endif /* ENDIAN */
 		} ptr;
 #endif
+
+		/*
+		 * The "arch" field provides architecture accessor for
+		 * the ptr field based on architecture pointer size and
+		 * endianness.
+		 */
+		struct {
+#ifdef __LP64__
+			__u64 ptr;
+#elif defined(__BYTE_ORDER) ? (__BYTE_ORDER == __BIG_ENDIAN) : defined(__BIG_ENDIAN)
+			__u32 padding;		/* Initialized to zero. */
+			__u32 ptr;
+#else
+			__u32 ptr;
+			__u32 padding;		/* Initialized to zero. */
+#endif
+		} arch;
 	} rseq_cs;
 
 	/*
-- 
2.17.1

