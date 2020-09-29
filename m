Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDC727C88E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgI2Lif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729101AbgI2Lif (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9935F22574;
        Tue, 29 Sep 2020 11:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379510;
        bh=1mIj69/AdI66ecJ3kzCGsxsb13fML65mPCSlmdkpGvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpzvnA7vY9lSDcdL/s0nfFw6yHRi7goWQ1LoAWRwaxhGFgybtBGx5zu+nLqJ2//Mx
         Fwa/XO3xPf/ctpVoga7EHZ6gZYsgNH2DHi/p+nochWnz1TgWMXABe0n6MUHmPj0aPu
         /F815LkuUfiuL4fgKMHKKFvj4sHN9eWWD78MSPLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 196/388] proc: Use new infrastructure to fix deadlocks in execve
Date:   Tue, 29 Sep 2020 12:58:47 +0200
Message-Id: <20200929110019.967823686@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

[ Upstream commit 2db9dbf71bf98d02a0bf33e798e5bfd2a9944696 ]

This changes lock_trace to use the new exec_update_mutex
instead of cred_guard_mutex.

This fixes possible deadlocks when the trace is accessing
/proc/$pid/stack for instance.

This should be safe, as the credentials are only used for reading,
and task->mm is updated on execve under the new exec_update_mutex.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ebea9501afb84..4fdfe4faa74ee 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -403,11 +403,11 @@ print0:
 
 static int lock_trace(struct task_struct *task)
 {
-	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	int err = mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (err)
 		return err;
 	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH_FSCREDS)) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
+		mutex_unlock(&task->signal->exec_update_mutex);
 		return -EPERM;
 	}
 	return 0;
@@ -415,7 +415,7 @@ static int lock_trace(struct task_struct *task)
 
 static void unlock_trace(struct task_struct *task)
 {
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 }
 
 #ifdef CONFIG_STACKTRACE
-- 
2.25.1



