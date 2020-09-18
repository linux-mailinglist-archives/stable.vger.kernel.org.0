Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625A626EE7E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgIRCPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:15:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbgIRCPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1119F239D3;
        Fri, 18 Sep 2020 02:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395307;
        bh=xMWo6gQJnLHFx0RULkxtuZ0tMMGpI2IuSZbhL/Cuah4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otWoQA+Pzmqr6tc/wueO7h2E3ujkERT1vdjhEEiAAYBS5JChBtmJjW4T6VbqHqFnD
         I9EHrreqmXEtFLiF472r+01t9OaW2IYFKSNmzP14zIS9+GqmCLHjQwGVHFIHbo2XaL
         oBvp+iOjcWPm3W3qHuKgGZUiWzj3fZ1SRi0yX/Jk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Divya Indi <divya.indi@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 10/90] tracing: Adding NULL checks for trace_array descriptor pointer
Date:   Thu, 17 Sep 2020 22:13:35 -0400
Message-Id: <20200918021455.2067301-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Divya Indi <divya.indi@oracle.com>

[ Upstream commit 953ae45a0c25e09428d4a03d7654f97ab8a36647 ]

As part of commit f45d1225adb0 ("tracing: Kernel access to Ftrace
instances") we exported certain functions. Here, we are adding some additional
NULL checks to ensure safe usage by users of these APIs.

Link: http://lkml.kernel.org/r/1565805327-579-4-git-send-email-divya.indi@oracle.com

Signed-off-by: Divya Indi <divya.indi@oracle.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c        | 3 +++
 kernel/trace/trace_events.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b2fb25aefb2fc..67cee2774a6b8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2600,6 +2600,9 @@ int trace_array_printk(struct trace_array *tr,
 	if (!(global_trace.trace_flags & TRACE_ITER_PRINTK))
 		return 0;
 
+	if (!tr)
+		return -ENOENT;
+
 	va_start(ap, fmt);
 	ret = trace_array_vprintk(tr, ip, fmt, ap);
 	va_end(ap);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index af969f753e5e9..5bf072e437c41 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -790,6 +790,8 @@ static int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set)
 	char *event = NULL, *sub = NULL, *match;
 	int ret;
 
+	if (!tr)
+		return -ENOENT;
 	/*
 	 * The buf format can be <subsystem>:<event-name>
 	 *  *:<event-name> means any event by that name.
-- 
2.25.1

