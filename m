Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3A3D60FA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbhGZPZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238220AbhGZPZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:25:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D852760F38;
        Mon, 26 Jul 2021 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315540;
        bh=WfrCcXBRTMj/UBj1gJQha44WgJRYVm1uKZW6czcbfL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IS6ALpgxoSv8/z+J5hhFdR5pG4IEqVC2s2C2epihC9NXJQOeWlID6bHA+7lwdD5Xq
         XaPl/tGZ6e5870kDAz5DnWcdHtl0PLlwP7VVOn9DnAEYVUObTbI7b36N37wCMhTH2G
         i6arpiy9RRtZiBFuy1/qeuvkxUYGh7m7ZMtf5xEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Haoran Luo <www@aegistudio.net>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 136/167] tracing: Fix bug in rb_per_cpu_empty() that might cause deadloop.
Date:   Mon, 26 Jul 2021 17:39:29 +0200
Message-Id: <20210726153843.954370750@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haoran Luo <www@aegistudio.net>

commit 67f0d6d9883c13174669f88adac4f0ee656cc16a upstream.

The "rb_per_cpu_empty()" misinterpret the condition (as not-empty) when
"head_page" and "commit_page" of "struct ring_buffer_per_cpu" points to
the same buffer page, whose "buffer_data_page" is empty and "read" field
is non-zero.

An error scenario could be constructed as followed (kernel perspective):

1. All pages in the buffer has been accessed by reader(s) so that all of
them will have non-zero "read" field.

2. Read and clear all buffer pages so that "rb_num_of_entries()" will
return 0 rendering there's no more data to read. It is also required
that the "read_page", "commit_page" and "tail_page" points to the same
page, while "head_page" is the next page of them.

3. Invoke "ring_buffer_lock_reserve()" with large enough "length"
so that it shot pass the end of current tail buffer page. Now the
"head_page", "commit_page" and "tail_page" points to the same page.

4. Discard current event with "ring_buffer_discard_commit()", so that
"head_page", "commit_page" and "tail_page" points to a page whose buffer
data page is now empty.

When the error scenario has been constructed, "tracing_read_pipe" will
be trapped inside a deadloop: "trace_empty()" returns 0 since
"rb_per_cpu_empty()" returns 0 when it hits the CPU containing such
constructed ring buffer. Then "trace_find_next_entry_inc()" always
return NULL since "rb_num_of_entries()" reports there's no more entry
to read. Finally "trace_seq_to_user()" returns "-EBUSY" spanking
"tracing_read_pipe" back to the start of the "waitagain" loop.

I've also written a proof-of-concept script to construct the scenario
and trigger the bug automatically, you can use it to trace and validate
my reasoning above:

  https://github.com/aegistudio/RingBufferDetonator.git

Tests has been carried out on linux kernel 5.14-rc2
(2734d6c1b1a089fb593ef6a23d4b70903526fe0c), my fixed version
of kernel (for testing whether my update fixes the bug) and
some older kernels (for range of affected kernels). Test result is
also attached to the proof-of-concept repository.

Link: https://lore.kernel.org/linux-trace-devel/YPaNxsIlb2yjSi5Y@aegistudio/
Link: https://lore.kernel.org/linux-trace-devel/YPgrN85WL9VyrZ55@aegistudio

Cc: stable@vger.kernel.org
Fixes: bf41a158cacba ("ring-buffer: make reentrant")
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Haoran Luo <www@aegistudio.net>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3649,10 +3649,30 @@ static bool rb_per_cpu_empty(struct ring
 	if (unlikely(!head))
 		return true;
 
-	return reader->read == rb_page_commit(reader) &&
-		(commit == reader ||
-		 (commit == head &&
-		  head->read == rb_page_commit(commit)));
+	/* Reader should exhaust content in reader page */
+	if (reader->read != rb_page_commit(reader))
+		return false;
+
+	/*
+	 * If writers are committing on the reader page, knowing all
+	 * committed content has been read, the ring buffer is empty.
+	 */
+	if (commit == reader)
+		return true;
+
+	/*
+	 * If writers are committing on a page other than reader page
+	 * and head page, there should always be content to read.
+	 */
+	if (commit != head)
+		return false;
+
+	/*
+	 * Writers are committing on the head page, we just need
+	 * to care about there're committed data, and the reader will
+	 * swap reader page with head page when it is to read data.
+	 */
+	return rb_page_commit(commit) == 0;
 }
 
 /**


