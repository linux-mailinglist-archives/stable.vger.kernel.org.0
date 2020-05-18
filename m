Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE61D83CE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732482AbgERSHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733062AbgERSHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C554E20715;
        Mon, 18 May 2020 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825262;
        bh=Rbkkvs8tCi4BeoTmrDf2qjp1r6RMp5VSBZn8Hw6Byo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gofMo9fU6sK78rV0nJ+fKWcUUM8KQs4LZ9MezWjHu/TvSURFqNboOl+x0tH6vS9At
         x4Q24m6VD7kT5U01fhDVNlQmAjA6odEv5OWXp+YqOenHLpKgWUBaZXRh/dkoFnOljZ
         yWGanm1pmqapdZDt3L+eRGFWvDcIUUs8QSvsEE9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: [PATCH 5.6 193/194] bpf: Restrict bpf_trace_printk()s %s usage and add %pks, %pus specifier
Date:   Mon, 18 May 2020 19:38:03 +0200
Message-Id: <20200518173547.452696174@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit b2a5212fb634561bb734c6356904e37f6665b955 upstream.

Usage of plain %s conversion specifier in bpf_trace_printk() suffers from the
very same issue as bpf_probe_read{,str}() helpers, that is, it is broken on
archs with overlapping address ranges.

While the helpers have been addressed through work in 6ae08ae3dea2 ("bpf: Add
probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers"), we need
an option for bpf_trace_printk() as well to fix it.

Similarly as with the helpers, force users to make an explicit choice by adding
%pks and %pus specifier to bpf_trace_printk() which will then pick the corresponding
strncpy_from_unsafe*() variant to perform the access under KERNEL_DS or USER_DS.
The %pk* (kernel specifier) and %pu* (user specifier) can later also be extended
for other objects aside strings that are probed and printed under tracing, and
reused out of other facilities like bpf_seq_printf() or BTF based type printing.

Existing behavior of %s for current users is still kept working for archs where it
is not broken and therefore gated through CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE.
For archs not having this property we fall-back to pick probing under KERNEL_DS as
a sensible default.

Fixes: 8d3b7dce8622 ("bpf: add support for %s specifier to bpf_trace_printk()")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Link: https://lore.kernel.org/bpf/20200515101118.6508-4-daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/core-api/printk-formats.rst |   14 ++++
 kernel/trace/bpf_trace.c                  |   94 +++++++++++++++++++-----------
 lib/vsprintf.c                            |   12 +++
 3 files changed, 88 insertions(+), 32 deletions(-)

--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -112,6 +112,20 @@ used when printing stack backtraces. The
 consideration the effect of compiler optimisations which may occur
 when tail-calls are used and marked with the noreturn GCC attribute.
 
+Probed Pointers from BPF / tracing
+----------------------------------
+
+::
+
+	%pks	kernel string
+	%pus	user string
+
+The ``k`` and ``u`` specifiers are used for printing prior probed memory from
+either kernel memory (k) or user memory (u). The subsequent ``s`` specifier
+results in printing a string. For direct use in regular vsnprintf() the (k)
+and (u) annotation is ignored, however, when used out of BPF's bpf_trace_printk(),
+for example, it reads the memory it is pointing to without faulting.
+
 Kernel Pointers
 ---------------
 
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -325,17 +325,15 @@ static const struct bpf_func_proto *bpf_
 
 /*
  * Only limited trace_printk() conversion specifiers allowed:
- * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %s
+ * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
  */
 BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 	   u64, arg2, u64, arg3)
 {
+	int i, mod[3] = {}, fmt_cnt = 0;
+	char buf[64], fmt_ptype;
+	void *unsafe_ptr = NULL;
 	bool str_seen = false;
-	int mod[3] = {};
-	int fmt_cnt = 0;
-	u64 unsafe_addr;
-	char buf[64];
-	int i;
 
 	/*
 	 * bpf_check()->check_func_arg()->check_stack_boundary()
@@ -361,40 +359,71 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt
 		if (fmt[i] == 'l') {
 			mod[fmt_cnt]++;
 			i++;
-		} else if (fmt[i] == 'p' || fmt[i] == 's') {
+		} else if (fmt[i] == 'p') {
 			mod[fmt_cnt]++;
+			if ((fmt[i + 1] == 'k' ||
+			     fmt[i + 1] == 'u') &&
+			    fmt[i + 2] == 's') {
+				fmt_ptype = fmt[i + 1];
+				i += 2;
+				goto fmt_str;
+			}
+
 			/* disallow any further format extensions */
 			if (fmt[i + 1] != 0 &&
 			    !isspace(fmt[i + 1]) &&
 			    !ispunct(fmt[i + 1]))
 				return -EINVAL;
-			fmt_cnt++;
-			if (fmt[i] == 's') {
-				if (str_seen)
-					/* allow only one '%s' per fmt string */
-					return -EINVAL;
-				str_seen = true;
-
-				switch (fmt_cnt) {
-				case 1:
-					unsafe_addr = arg1;
-					arg1 = (long) buf;
-					break;
-				case 2:
-					unsafe_addr = arg2;
-					arg2 = (long) buf;
-					break;
-				case 3:
-					unsafe_addr = arg3;
-					arg3 = (long) buf;
-					break;
-				}
-				buf[0] = 0;
-				strncpy_from_unsafe(buf,
-						    (void *) (long) unsafe_addr,
+
+			goto fmt_next;
+		} else if (fmt[i] == 's') {
+			mod[fmt_cnt]++;
+			fmt_ptype = fmt[i];
+fmt_str:
+			if (str_seen)
+				/* allow only one '%s' per fmt string */
+				return -EINVAL;
+			str_seen = true;
+
+			if (fmt[i + 1] != 0 &&
+			    !isspace(fmt[i + 1]) &&
+			    !ispunct(fmt[i + 1]))
+				return -EINVAL;
+
+			switch (fmt_cnt) {
+			case 0:
+				unsafe_ptr = (void *)(long)arg1;
+				arg1 = (long)buf;
+				break;
+			case 1:
+				unsafe_ptr = (void *)(long)arg2;
+				arg2 = (long)buf;
+				break;
+			case 2:
+				unsafe_ptr = (void *)(long)arg3;
+				arg3 = (long)buf;
+				break;
+			}
+
+			buf[0] = 0;
+			switch (fmt_ptype) {
+			case 's':
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+				strncpy_from_unsafe(buf, unsafe_ptr,
 						    sizeof(buf));
+				break;
+#endif
+			case 'k':
+				strncpy_from_unsafe_strict(buf, unsafe_ptr,
+							   sizeof(buf));
+				break;
+			case 'u':
+				strncpy_from_unsafe_user(buf,
+					(__force void __user *)unsafe_ptr,
+							 sizeof(buf));
+				break;
 			}
-			continue;
+			goto fmt_next;
 		}
 
 		if (fmt[i] == 'l') {
@@ -405,6 +434,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt
 		if (fmt[i] != 'i' && fmt[i] != 'd' &&
 		    fmt[i] != 'u' && fmt[i] != 'x')
 			return -EINVAL;
+fmt_next:
 		fmt_cnt++;
 	}
 
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2168,6 +2168,10 @@ char *fwnode_string(char *buf, char *end
  *		f full name
  *		P node name, including a possible unit address
  * - 'x' For printing the address. Equivalent to "%lx".
+ * - '[ku]s' For a BPF/tracing related format specifier, e.g. used out of
+ *           bpf_trace_printk() where [ku] prefix specifies either kernel (k)
+ *           or user (u) memory to probe, and:
+ *              s a string, equivalent to "%s" on direct vsnprintf() use
  *
  * ** When making changes please also update:
  *	Documentation/core-api/printk-formats.rst
@@ -2251,6 +2255,14 @@ char *pointer(const char *fmt, char *buf
 		if (!IS_ERR(ptr))
 			break;
 		return err_ptr(buf, end, ptr, spec);
+	case 'u':
+	case 'k':
+		switch (fmt[1]) {
+		case 's':
+			return string(buf, end, ptr, spec);
+		default:
+			return error_string(buf, end, "(einval)", spec);
+		}
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */


