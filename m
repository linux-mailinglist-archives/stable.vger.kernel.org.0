Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE882A442F
	for <lists+stable@lfdr.de>; Sat, 31 Aug 2019 12:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfHaKyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Aug 2019 06:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbfHaKyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Aug 2019 06:54:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A292342C;
        Sat, 31 Aug 2019 10:54:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1i411G-0001K2-Aa; Sat, 31 Aug 2019 06:54:10 -0400
Message-Id: <20190831105410.217140090@goodmis.org>
User-Agent: quilt/0.65
Date:   Sat, 31 Aug 2019 06:53:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [for-linus][PATCH 3/7] ftrace: Check for successful allocation of hash
References: <20190831105329.122820332@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

In register_ftrace_function_probe(), we are not checking the return
value of alloc_and_copy_ftrace_hash(). The subsequent call to
ftrace_match_records() may end up dereferencing the same. Add a check to
ensure this doesn't happen.

Link: http://lkml.kernel.org/r/26e92574f25ad23e7cafa3cf5f7a819de1832cbe.1562249521.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Fixes: 1ec3a81a0cf42 ("ftrace: Have each function probe use its own ftrace_ops")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6200a6fe10e3..f9821a3374e9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4338,6 +4338,11 @@ register_ftrace_function_probe(char *glob, struct trace_array *tr,
 	old_hash = *orig_hash;
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, old_hash);
 
+	if (!hash) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	ret = ftrace_match_records(hash, glob, strlen(glob));
 
 	/* Nothing found? */
-- 
2.20.1


