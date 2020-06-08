Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0A1F2729
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbgFHXnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731732AbgFHX1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:27:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CBD420801;
        Mon,  8 Jun 2020 23:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658835;
        bh=PHQbE860ApbPuK+H3E8U3wnViA0onuHhCR33vzRV5Io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhNiF6adbtZVjRaICAF4zgW5r3LClhwHUUc0jSr7nFUSf4Df4hRjDA9BwoPgvEJ5G
         uNUeiVtdYvfjhNHV3L90RW5i+VJ0MKbjhLZrBT+N8x53xJ5qVOtVn7mIQgB1wCoFeL
         8Oc97hhSEr/ZTLtXPP4UVlqMtnDm+tCdhw1oRdqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Barret Rhoden <brho@google.com>,
        syzbot+bb4935a5c09b5ff79940@syzkaller.appspotmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 25/50] perf: Add cond_resched() to task_function_call()
Date:   Mon,  8 Jun 2020 19:26:15 -0400
Message-Id: <20200608232640.3370262-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232640.3370262-1-sashal@kernel.org>
References: <20200608232640.3370262-1-sashal@kernel.org>
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
index 1f27b73bd7d4..b562467d2d49 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -90,11 +90,11 @@ static void remote_function(void *data)
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
@@ -107,11 +107,16 @@ task_function_call(struct task_struct *p, remote_function_f func, void *info)
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

