Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C6226F2EA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgIRDCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbgIRCFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B5F23718;
        Fri, 18 Sep 2020 02:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394718;
        bh=1mIj69/AdI66ecJ3kzCGsxsb13fML65mPCSlmdkpGvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oa22KzgkC5FUx3BEwtIBu+GyabC1Ya5xkW1AxuC78IQWsN6zCUZwX0ZsWhqA2+Lo4
         cdnadsWiwp7F90a2q9N/7vYk6Zl9PaYYrMu7VMEgUiwktUJ0vwTebTkk+P0Jz1zWS/
         qfKRWf5bVdLCZlw2e/30g/Dn6eZGZ1MZqCvAIQr8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 202/330] proc: Use new infrastructure to fix deadlocks in execve
Date:   Thu, 17 Sep 2020 21:59:02 -0400
Message-Id: <20200918020110.2063155-202-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

