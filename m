Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642782EEF6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732177AbfE3Dvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfE3DTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:46 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A38248AF;
        Thu, 30 May 2019 03:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186385;
        bh=N70H1+R5SeViVNqndvuL3AyU8G493F/y+Q0HGRBG2lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odhoDSHIijj1FfMxRccGUcThlgtPBJc2Mt2OJj2Iygq1rmiIvvf+MHuDhygnRC8wf
         DcwFiQZca8C8f3YnC8AzAza+WcYzb9gMLlgwTUn7+Y//qlPNHURY+Tbx8XO2bD8wz3
         Z47at8YiRdXIQNLtZE32vFYCm5mgbe4P2U1fqp90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 152/193] x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP
Date:   Wed, 29 May 2019 20:06:46 -0700
Message-Id: <20190530030509.374491243@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4a6c91fbdef846ec7250b82f2eeeb87ac5f18cf9 ]

For CONFIG_TRACE_BRANCH_PROFILING=y the likely/unlikely things get
overloaded and generate callouts to this code, and thus also when
AC=1.

Make it safe.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_branch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 4ad967453b6fb..3ea65cdff30d5 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -205,6 +205,8 @@ void trace_likely_condition(struct ftrace_likely_data *f, int val, int expect)
 void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 			  int expect, int is_constant)
 {
+	unsigned long flags = user_access_save();
+
 	/* A constant is always correct */
 	if (is_constant) {
 		f->constant++;
@@ -223,6 +225,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 		f->data.correct++;
 	else
 		f->data.incorrect++;
+
+	user_access_restore(flags);
 }
 EXPORT_SYMBOL(ftrace_likely_update);
 
-- 
2.20.1



