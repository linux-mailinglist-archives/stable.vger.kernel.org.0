Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D333D45E534
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358389AbhKZCkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358179AbhKZCiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 833EA61206;
        Fri, 26 Nov 2021 02:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894022;
        bh=6M1DrmYjg6Bm8AXLmemc8UGMz0PjPuEeuy9tlqFORuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEK3bdPxeaPheaYzHmwWEbIZSbpraFeh991xMX0p1K6ctz9O33mID+JIpiX49Hxp4
         ZDaFNa6EZSMs6yLR1/JTsL+cdQgRYE36oLh8smDZ5dVLG4FAv5a5hW6W3q/hSQitVu
         3lz6+bBOTa7nCzKd0+Td72dGfOyMJCnn60mGgznypZp48cpJB7jFURxr0iiEmsWT+H
         FVM5LxIRFC5C3LD1zuPivoJBrU0awbQFxEe7uYkyAEdToYh8bRmKjphHaid4AvCAxF
         aiQLwkdxdQk343DIKsRjoeMOMtO7ZHTgPLDgg9au0gysW14XIL7B6yxem1UE6UFUiF
         OSxg+VrIHFdLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.15 39/39] tracing: Don't use out-of-sync va_list in event printing
Date:   Thu, 25 Nov 2021 21:31:56 -0500
Message-Id: <20211126023156.441292-39-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>

[ Upstream commit 2ef75e9bd2c998f1c6f6f23a3744136105ddefd5 ]

If trace_seq becomes full, trace_seq_vprintf() no longer consumes
arguments from va_list, making va_list out of sync with format
processing by trace_check_vprintf().

This causes va_arg() in trace_check_vprintf() to return wrong
positional argument, which results into a WARN_ON_ONCE() hit.

ftrace_stress_test from LTP triggers this situation.

Fix it by explicitly avoiding further use if va_list at the point
when it's consistency can no longer be guaranteed.

Link: https://lkml.kernel.org/r/20211118145516.13219-1-nikita.yushchenko@virtuozzo.com

Signed-off-by: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5e452dd57af01..18db461f77cdf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3836,6 +3836,18 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		iter->fmt[i] = '\0';
 		trace_seq_vprintf(&iter->seq, iter->fmt, ap);
 
+		/*
+		 * If iter->seq is full, the above call no longer guarantees
+		 * that ap is in sync with fmt processing, and further calls
+		 * to va_arg() can return wrong positional arguments.
+		 *
+		 * Ensure that ap is no longer used in this case.
+		 */
+		if (iter->seq.full) {
+			p = "";
+			break;
+		}
+
 		if (star)
 			len = va_arg(ap, int);
 
-- 
2.33.0

