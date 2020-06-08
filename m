Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F28E1F2808
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbgFHXsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731877AbgFHXZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C1C52072F;
        Mon,  8 Jun 2020 23:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658752;
        bh=u2/M2VPBiquh6nEmd5eV3X5tqIeFEinXKQJxRrY9hIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IX6XzbF4i+GNhCuDG1WJQyc9JYOKT8TVvd21qkuD0a6/aIjVdjxfXsv6hLFLMjocI
         JtolRbu+WCcxZpYdWVC9n/phstLF+a5QqOlakPr8fwcBxYJmWg6HYA8kSv3p7nRfvY
         qBMeo6tpqb4MefPodH/7GkcCenQIM0S9zt1Ksy3E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Barret Rhoden <brho@google.com>,
        syzbot+bb4935a5c09b5ff79940@syzkaller.appspotmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 37/72] perf: Add cond_resched() to task_function_call()
Date:   Mon,  8 Jun 2020 19:24:25 -0400
Message-Id: <20200608232500.3369581-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barret Rhoden <brho@google.com>

[ Upstream commit 2ed6edd33a214bca02bd2b45e3fc3038a059436b ]

Under rare circumstances, task_function_call() can repeatedly fail and
cause a soft lockup.

There is a slight race where the process is no longer running on the cpu
we targeted by the time remote_function() runs.  The code will simply
try again.  If we are very unlucky, this will continue to fail, until a
watchdog fires.  This can happen in a heavily loaded, multi-core virtual
machine.

Reported-by: syzbot+bb4935a5c09b5ff79940@syzkaller.appspotmail.com
Signed-off-by: Barret Rhoden <brho@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200414222920.121401-1-brho@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5636c9c48545..e50b140053f9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -94,11 +94,11 @@ static void remote_function(void *data)
  * @info:	the function call argument
  *
  * Calls the function @func when the task is currently running. This might
- * be on the current CPU, which just calls the function directly
+ * be on the current CPU, which just calls the function directly.  This will
+ * retry due to any failures in smp_call_function_single(), such as if the
+ * task_cpu() goes offline concurrently.
  *
- * returns: @func return value, or
- *	    -ESRCH  - when the process isn't running
- *	    -EAGAIN - when the process moved away
+ * returns @func return value or -ESRCH when the process isn't running
  */
 static int
 task_function_call(struct task_struct *p, remote_function_f func, void *info)
@@ -111,11 +111,16 @@ task_function_call(struct task_struct *p, remote_function_f func, void *info)
 	};
 	int ret;
 
-	do {
-		ret = smp_call_function_single(task_cpu(p), remote_function, &data, 1);
-		if (!ret)
-			ret = data.ret;
-	} while (ret == -EAGAIN);
+	for (;;) {
+		ret = smp_call_function_single(task_cpu(p), remote_function,
+					       &data, 1);
+		ret = !ret ? data.ret : -EAGAIN;
+
+		if (ret != -EAGAIN)
+			break;
+
+		cond_resched();
+	}
 
 	return ret;
 }
-- 
2.25.1

