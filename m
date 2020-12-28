Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F021C2E3EF5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505180AbgL1Oem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:34:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505060AbgL1Odj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8A97223E8;
        Mon, 28 Dec 2020 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165978;
        bh=JCCIwnAkYZl/TItTolxMNXFepOdChg6HaYymP+PFLrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCsKGuTZf0E9zUIFMgmShzbp1ooIkcWeb7NHy4lxU0Rg9hYRpArz7+3Ay95BOhOsH
         aQZMf3NvR4WxZ5wGXU8yKPDi/Ftzu9Cn9N/Vi8Rkc7nZBeFxzwOvEjO/Ne/MiUa/6A
         14+aMze8zXWLBHDJlT4afJSvOt5/rR0eIey+7rIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anatoly Pugachev <matorola@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 715/717] Revert: "ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"
Date:   Mon, 28 Dec 2020 13:51:53 +0100
Message-Id: <20201228125055.261009257@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit adab66b71abfe206a020f11e561f4df41f0b2aba upstream.

It was believed that metag was the only architecture that required the ring
buffer to keep 8 byte words aligned on 8 byte architectures, and with its
removal, it was assumed that the ring buffer code did not need to handle
this case. It appears that sparc64 also requires this.

The following was reported on a sparc64 boot up:

   kernel: futex hash table entries: 65536 (order: 9, 4194304 bytes, linear)
   kernel: Running postponed tracer tests:
   kernel: Testing tracer function:
   kernel: Kernel unaligned access at TPC[552a20] trace_function+0x40/0x140
   kernel: Kernel unaligned access at TPC[552a24] trace_function+0x44/0x140
   kernel: Kernel unaligned access at TPC[552a20] trace_function+0x40/0x140
   kernel: Kernel unaligned access at TPC[552a24] trace_function+0x44/0x140
   kernel: Kernel unaligned access at TPC[552a20] trace_function+0x40/0x140
   kernel: PASSED

Need to put back the 64BIT aligned code for the ring buffer.

Link: https://lore.kernel.org/r/CADxRZqzXQRYgKc=y-KV=S_yHL+Y8Ay2mh5ezeZUnpRvg+syWKw@mail.gmail.com

Cc: stable@vger.kernel.org
Fixes: 86b3de60a0b6 ("ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS")
Reported-by: Anatoly Pugachev <matorola@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/Kconfig               |   16 ++++++++++++++++
 kernel/trace/ring_buffer.c |   17 +++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -143,6 +143,22 @@ config UPROBES
 	    managed by the kernel and kept transparent to the probed
 	    application. )
 
+config HAVE_64BIT_ALIGNED_ACCESS
+	def_bool 64BIT && !HAVE_EFFICIENT_UNALIGNED_ACCESS
+	help
+	  Some architectures require 64 bit accesses to be 64 bit
+	  aligned, which also requires structs containing 64 bit values
+	  to be 64 bit aligned too. This includes some 32 bit
+	  architectures which can do 64 bit accesses, as well as 64 bit
+	  architectures without unaligned access.
+
+	  This symbol should be selected by an architecture if 64 bit
+	  accesses are required to be 64 bit aligned in this way even
+	  though it is not a 64 bit architecture.
+
+	  See Documentation/unaligned-memory-access.txt for more
+	  information on the topic of unaligned memory accesses.
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -129,7 +129,16 @@ int ring_buffer_print_entry_header(struc
 #define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 #define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
-#define RB_ALIGN_DATA		__aligned(RB_ALIGNMENT)
+
+#ifndef CONFIG_HAVE_64BIT_ALIGNED_ACCESS
+# define RB_FORCE_8BYTE_ALIGNMENT	0
+# define RB_ARCH_ALIGNMENT		RB_ALIGNMENT
+#else
+# define RB_FORCE_8BYTE_ALIGNMENT	1
+# define RB_ARCH_ALIGNMENT		8U
+#endif
+
+#define RB_ALIGN_DATA		__aligned(RB_ARCH_ALIGNMENT)
 
 /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
 #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
@@ -2719,7 +2728,7 @@ rb_update_event(struct ring_buffer_per_c
 
 	event->time_delta = delta;
 	length -= RB_EVNT_HDR_SIZE;
-	if (length > RB_MAX_SMALL_DATA) {
+	if (length > RB_MAX_SMALL_DATA || RB_FORCE_8BYTE_ALIGNMENT) {
 		event->type_len = 0;
 		event->array[0] = length;
 	} else
@@ -2734,11 +2743,11 @@ static unsigned rb_calculate_event_lengt
 	if (!length)
 		length++;
 
-	if (length > RB_MAX_SMALL_DATA)
+	if (length > RB_MAX_SMALL_DATA || RB_FORCE_8BYTE_ALIGNMENT)
 		length += sizeof(event.array[0]);
 
 	length += RB_EVNT_HDR_SIZE;
-	length = ALIGN(length, RB_ALIGNMENT);
+	length = ALIGN(length, RB_ARCH_ALIGNMENT);
 
 	/*
 	 * In case the time delta is larger than the 27 bits for it


