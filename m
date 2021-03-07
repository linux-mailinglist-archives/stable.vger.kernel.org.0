Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194733301BD
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhCGN6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231753AbhCGN60 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AFB365125;
        Sun,  7 Mar 2021 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125505;
        bh=mTEep7D6LvP3a090vf+ufclFx4bYZ0nuG/dHyHMjBKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGhQeV1KZIVxvaQ+SZsqQrQGq/bBPWwyx//QsX9G0WPbDcKPMs/RKMW5pp4j2AbZX
         mmuLniE9/Sy6YWvxUTPWzhXDtFZaJqQZso2lPCjBi9ThwHizRl/I5L9O7qx8EsH2XA
         0hiPIiJY9dHJnIutddF+SkhOCubRtc8SZRY3yoWgSNSE9HnPCyuq2y3nJgLNqYvdiD
         zYstY+s+wYXsYhwv7jEXKoDjQF66tW/ylIbxZMuxQeBdYSuybu8UNDaAr6+ly1Wlal
         /fhZfm4zaOXgkykQSjxOafka5OYHRItwOWv8FgHFlG9eHioqlole1G6yuQS/2iAHfh
         kpSy55O7SdX5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 2/2] tracing: Skip selftests if tracing is disabled
Date:   Sun,  7 Mar 2021 08:58:23 -0500
Message-Id: <20210307135823.967879-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135823.967879-1-sashal@kernel.org>
References: <20210307135823.967879-1-sashal@kernel.org>
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
index 3a0691c64704..8dbc21ca140d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1478,6 +1478,12 @@ static int run_tracer_selftest(struct tracer *type)
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

