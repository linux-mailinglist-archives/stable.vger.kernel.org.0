Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C5A1FB6D8
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbgFPPlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730535AbgFPPlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:41:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53D90208D5;
        Tue, 16 Jun 2020 15:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322064;
        bh=hZp3Mldm+3jkW42Y6cDhDCLhzps582Vypb3ZdBx/WTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+5W7LCpbOPbO9nljaFAvYoU+aJObuDO7y8QVjBt43Ygeetr1bDDK+caMTlNtpyOa
         KfFAdym0O602tIB/nZFssjwf78ZRJ386IaN41fFv5UtvKGjl2suDohkd7SvfaI9Qoc
         ShK/2ZJsOYO3owG98Ve6vVo3KDw8uSLyiMlG3LDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bb4935a5c09b5ff79940@syzkaller.appspotmail.com,
        Barret Rhoden <brho@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 122/134] perf: Add cond_resched() to task_function_call()
Date:   Tue, 16 Jun 2020 17:35:06 +0200
Message-Id: <20200616153106.631067401@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barret Rhoden <brho@google.com>

commit 2ed6edd33a214bca02bd2b45e3fc3038a059436b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -93,11 +93,11 @@ static void remote_function(void *data)
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
@@ -110,11 +110,16 @@ task_function_call(struct task_struct *p
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


