Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF32A4431
	for <lists+stable@lfdr.de>; Sat, 31 Aug 2019 12:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfHaKyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Aug 2019 06:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfHaKyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Aug 2019 06:54:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0109323429;
        Sat, 31 Aug 2019 10:54:10 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1i411G-0001JY-5f; Sat, 31 Aug 2019 06:54:10 -0400
Message-Id: <20190831105410.061248409@goodmis.org>
User-Agent: quilt/0.65
Date:   Sat, 31 Aug 2019 06:53:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 2/7] ftrace: Check for empty hash and comment the race with registering
 probes
References: <20190831105329.122820332@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The race between adding a function probe and reading the probes that exist
is very subtle. It needs a comment. Also, the issue can also happen if the
probe has has the EMPTY_HASH as its func_hash.

Cc: stable@vger.kernel.org
Fixes: 7b60f3d876156 ("ftrace: Dynamically create the probe ftrace_ops for the trace_array")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 80beed2cf0da..6200a6fe10e3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3096,7 +3096,11 @@ t_probe_next(struct seq_file *m, loff_t *pos)
 
 	hash = iter->probe->ops.func_hash->filter_hash;
 
-	if (!hash)
+	/*
+	 * A probe being registered may temporarily have an empty hash
+	 * and it's at the end of the func_probes list.
+	 */
+	if (!hash || hash == EMPTY_HASH)
 		return NULL;
 
 	size = 1 << hash->size_bits;
@@ -4324,6 +4328,10 @@ register_ftrace_function_probe(char *glob, struct trace_array *tr,
 
 	mutex_unlock(&ftrace_lock);
 
+	/*
+	 * Note, there's a small window here that the func_hash->filter_hash
+	 * may be NULL or empty. Need to be carefule when reading the loop.
+	 */
 	mutex_lock(&probe->ops.func_hash->regex_lock);
 
 	orig_hash = &probe->ops.func_hash->filter_hash;
-- 
2.20.1


