Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E7F3301B8
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhCGN6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231713AbhCGN6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D548565121;
        Sun,  7 Mar 2021 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125501;
        bh=cj/AxbgGjFnam16XOdka9ZQwbtbHsAbczimqltTAP9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ti/2TrKL5e7QKm49t9LIXy2yr4MgP8KTeswHpkG+oXHYe8RyM7pbKWwbb3Nt0SsA0
         Q7Rjv1eCOZj4DLJIUJPP0dKkyzLhWx5+Vdv+29Mf73N1aIf2ZPxZEt7hlPcI3Au/n7
         bCiAC7Y1ujIJFF51/z6hkuyExTzwgNZ7+FzipSMjBrNAKHAl1Reo3nIEs0XLmQUjyR
         C13C8MEVuMt/eajL0Bl0rV7q1y9PtnUS7a23nOV4mkx2Uos/TI+6a/wP+QSfJQsx89
         7tKvafXk00Akz0GyUpq9egsPXncQETUFGvZmTHirH+9mY63qnE+uh/EcceSUtW0ja1
         FeDQxWqCzrYRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 2/3] tracing: Skip selftests if tracing is disabled
Date:   Sun,  7 Mar 2021 08:58:17 -0500
Message-Id: <20210307135818.967800-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135818.967800-1-sashal@kernel.org>
References: <20210307135818.967800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit ee666a185558ac9a929e53b902a568442ed62416 ]

If tracing is disabled for some reason (traceoff_on_warning, command line,
etc), the ftrace selftests are guaranteed to fail, as their results are
defined by trace data in the ring buffers. If the ring buffers are turned
off, the tests will fail, due to lack of data.

Because tracing being disabled is for a specific reason (warning, user
decided to, etc), it does not make sense to enable tracing to run the self
tests, as the test output may corrupt the reason for the tracing to be
disabled.

Instead, simply skip the self tests and report that they are being skipped
due to tracing being disabled.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 88a4f9e2d06c..8b707634ab1f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1484,6 +1484,12 @@ static int run_tracer_selftest(struct tracer *type)
 	if (!selftests_can_run)
 		return save_selftest(type);
 
+	if (!tracing_is_on()) {
+		pr_warn("Selftest for tracer %s skipped due to tracing disabled\n",
+			type->name);
+		return 0;
+	}
+
 	/*
 	 * Run a selftest on this tracer.
 	 * Here we reset the trace buffer, and set the current
-- 
2.30.1

