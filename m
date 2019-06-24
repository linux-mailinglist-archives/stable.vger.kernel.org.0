Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B720350767
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbfFXKGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729599AbfFXKGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:50 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 982B421473;
        Mon, 24 Jun 2019 10:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370809;
        bh=/lLAJYDQGzK0dJdUaekE5OmOKBa+Yz4MjnphOvkmKyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8cr9Jrl3Vy75fBe8bMzIIAlD/QYBOdqg+CImhixtREjER+nGpZ+UHaoCkKiIinJ8
         9c9lv9g4bdNBEEX9/i+tTs+oycbiKohMhDkS3/8onL+mQFrII/mMdZwXe/55ZnagWA
         Em+HLCF5ybRsMGcMGorPPzf333NUyiSFfN+rcOyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.1 001/121] tracing: Silence GCC 9 array bounds warning
Date:   Mon, 24 Jun 2019 17:55:33 +0800
Message-Id: <20190624092320.733047084@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

commit 0c97bf863efce63d6ab7971dad811601e6171d2f upstream.

Starting with GCC 9, -Warray-bounds detects cases when memset is called
starting on a member of a struct but the size to be cleared ends up
writing over further members.

Such a call happens in the trace code to clear, at once, all members
after and including `seq` on struct trace_iterator:

    In function 'memset',
        inlined from 'ftrace_dump' at kernel/trace/trace.c:8914:3:
    ./include/linux/string.h:344:9: warning: '__builtin_memset' offset
    [8505, 8560] from the object at 'iter' is out of the bounds of
    referenced subobject 'seq' with type 'struct trace_seq' at offset
    4368 [-Warray-bounds]
      344 |  return __builtin_memset(p, c, size);
          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to avoid GCC complaining about it, we compute the address
ourselves by adding the offsetof distance instead of referring
directly to the member.

Since there are two places doing this clear (trace.c and trace_kdb.c),
take the chance to move the workaround into a single place in
the internal header.

Link: http://lkml.kernel.org/r/20190523124535.GA12931@gmail.com

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
[ Removed unnecessary parenthesis around "iter" ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c     |    6 +-----
 kernel/trace/trace.h     |   18 ++++++++++++++++++
 kernel/trace/trace_kdb.c |    6 +-----
 3 files changed, 20 insertions(+), 10 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8627,12 +8627,8 @@ void ftrace_dump(enum ftrace_dump_mode o
 
 		cnt++;
 
-		/* reset all but tr, trace, and overruns */
-		memset(&iter.seq, 0,
-		       sizeof(struct trace_iterator) -
-		       offsetof(struct trace_iterator, seq));
+		trace_iterator_reset(&iter);
 		iter.iter_flags |= TRACE_FILE_LAT_FMT;
-		iter.pos = -1;
 
 		if (trace_find_next_entry_inc(&iter) != NULL) {
 			int ret;
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1964,4 +1964,22 @@ static inline void tracer_hardirqs_off(u
 
 extern struct trace_iterator *tracepoint_print_iter;
 
+/*
+ * Reset the state of the trace_iterator so that it can read consumed data.
+ * Normally, the trace_iterator is used for reading the data when it is not
+ * consumed, and must retain state.
+ */
+static __always_inline void trace_iterator_reset(struct trace_iterator *iter)
+{
+	const size_t offset = offsetof(struct trace_iterator, seq);
+
+	/*
+	 * Keep gcc from complaining about overwriting more than just one
+	 * member in the structure.
+	 */
+	memset((char *)iter + offset, 0, sizeof(struct trace_iterator) - offset);
+
+	iter->pos = -1;
+}
+
 #endif /* _LINUX_KERNEL_TRACE_H */
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -41,12 +41,8 @@ static void ftrace_dump_buf(int skip_lin
 
 	kdb_printf("Dumping ftrace buffer:\n");
 
-	/* reset all but tr, trace, and overruns */
-	memset(&iter.seq, 0,
-		   sizeof(struct trace_iterator) -
-		   offsetof(struct trace_iterator, seq));
+	trace_iterator_reset(&iter);
 	iter.iter_flags |= TRACE_FILE_LAT_FMT;
-	iter.pos = -1;
 
 	if (cpu_file == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {


