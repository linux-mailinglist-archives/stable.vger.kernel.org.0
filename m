Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDB238A443
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhETKC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231851AbhETKAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C7D4616EB;
        Thu, 20 May 2021 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503548;
        bh=T30I8SCD3Hl5RBxVNqjZ733Zzpi4xbosYPgJyvP5Rm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NY0JpcR03f1da2Q/buEBVnCBaEOlvQGP3eEXL9TwQj66hE1lnYnZ5MI5xeZHazBzC
         iHSmAfuTvCSnVvn7TS8pOsigTGuCqSLQrn++FqbPIZgZwQVSNMJYycxatKRYveeBS9
         IMJmOxyVFS+coIwU40v3PMHbQBW9IyMyGNY19hm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Scull <ascull@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 254/425] bug: Remove redundant condition check in report_bug
Date:   Thu, 20 May 2021 11:20:23 +0200
Message-Id: <20210520092139.766396435@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Scull <ascull@google.com>

[ Upstream commit 3ad1a6cb0abc63d036fc866bd7c2c5983516dec5 ]

report_bug() will return early if it cannot find a bug corresponding to
the provided address. The subsequent test for the bug will always be
true so remove it.

Fixes: 1b4cfe3c0a30d ("lib/bug.c: exclude non-BUG/WARN exceptions from report_bug()")
Signed-off-by: Andrew Scull <ascull@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210318143311.839894-2-ascull@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bug.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/lib/bug.c b/lib/bug.c
index 1077366f496b..f4fcac5dd766 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -155,30 +155,27 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 
 	file = NULL;
 	line = 0;
-	warning = 0;
 
-	if (bug) {
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 #ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
-		file = bug->file;
+	file = bug->file;
 #else
-		file = (const char *)bug + bug->file_disp;
+	file = (const char *)bug + bug->file_disp;
 #endif
-		line = bug->line;
+	line = bug->line;
 #endif
-		warning = (bug->flags & BUGFLAG_WARNING) != 0;
-		once = (bug->flags & BUGFLAG_ONCE) != 0;
-		done = (bug->flags & BUGFLAG_DONE) != 0;
-
-		if (warning && once) {
-			if (done)
-				return BUG_TRAP_TYPE_WARN;
-
-			/*
-			 * Since this is the only store, concurrency is not an issue.
-			 */
-			bug->flags |= BUGFLAG_DONE;
-		}
+	warning = (bug->flags & BUGFLAG_WARNING) != 0;
+	once = (bug->flags & BUGFLAG_ONCE) != 0;
+	done = (bug->flags & BUGFLAG_DONE) != 0;
+
+	if (warning && once) {
+		if (done)
+			return BUG_TRAP_TYPE_WARN;
+
+		/*
+		 * Since this is the only store, concurrency is not an issue.
+		 */
+		bug->flags |= BUGFLAG_DONE;
 	}
 
 	if (warning) {
-- 
2.30.2



