Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAC2111FFE
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfLCWlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727731AbfLCWlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DC212080A;
        Tue,  3 Dec 2019 22:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412872;
        bh=EaplAfuheF1sBF4x0lD26ZSodyHdeqvGBmEQkvmT834=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSmvNfosgqxixKjFTIsIglyJTlBDnVM6oXOLblal5oM/N1IgbqupWtjdTLky1Wumh
         T9t07g8SDyGFBtPCDNF9YIhkaYUBBBTtchoiBvWNzZqmOLsqqnGvy8NK4e/2D87U2n
         nwi6QCQf9VksbzCSdk0yJtMKAHi6d4di3Y3PS8e0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michal Suchanek <msuchanek@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 050/135] stacktrace: Dont skip first entry on noncurrent tasks
Date:   Tue,  3 Dec 2019 23:34:50 +0100
Message-Id: <20191203213019.500970064@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit b0c51f158455e31d5024100cf3580fcd88214b0e ]

When doing cat /proc/<PID>/stack, the output is missing the first entry.
When the current code walks the stack starting in stack_trace_save_tsk,
it skips all scheduler functions (that's OK) plus one more function. But
this one function should be skipped only for the 'current' task as it is
stack_trace_save_tsk proper.

The original code (before the common infrastructure) skipped one
function only for the 'current' task -- see save_stack_trace_tsk before
3599fe12a125. So do so also in the new infrastructure now.

Fixes: 214d8ca6ee85 ("stacktrace: Provide common infrastructure")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20191030072545.19462-1-jslaby@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/stacktrace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index f5440abb75329..9bbfbdb96ae51 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -141,7 +141,8 @@ unsigned int stack_trace_save_tsk(struct task_struct *tsk, unsigned long *store,
 	struct stacktrace_cookie c = {
 		.store	= store,
 		.size	= size,
-		.skip	= skipnr + 1,
+		/* skip this function if they are tracing us */
+		.skip	= skipnr + !!(current == tsk),
 	};
 
 	if (!try_get_task_stack(tsk))
@@ -298,7 +299,8 @@ unsigned int stack_trace_save_tsk(struct task_struct *task,
 	struct stack_trace trace = {
 		.entries	= store,
 		.max_entries	= size,
-		.skip		= skipnr + 1,
+		/* skip this function if they are tracing us */
+		.skip	= skipnr + !!(current == task),
 	};
 
 	save_stack_trace_tsk(task, &trace);
-- 
2.20.1



