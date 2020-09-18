Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9BD26F2DA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgIRCFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIRCFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D8123772;
        Fri, 18 Sep 2020 02:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394717;
        bh=ZNSLXRuNGa52uCWoAOHJVDfW8rqDBqg8ZhRQmPT57Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bH49yQSTywvR4Nw1PwDEjaUFl3Q8N5fTtf33Zq0B5dJwhbG701FBLZDK5/2CR2jhi
         yznNxT2kN+7mBPe3fMFi0QS0FZdlnWhiudVHXSZQI76QeKun8a0cL/S6HA6KMqZwvb
         s7H/4l8zEZ10ScmvLRGqxzscDfQOKMRCdmQiYOd0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 201/330] kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
Date:   Thu, 17 Sep 2020 21:59:01 -0400
Message-Id: <20200918020110.2063155-201-sashal@kernel.org>
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

[ Upstream commit 454e3126cb842388e22df6b3ac3da44062c00765 ]

This changes kcmp_epoll_target to use the new exec_update_mutex
instead of cred_guard_mutex.

This should be safe, as the credentials are only used for reading,
and furthermore ->mm and ->sighand are updated on execve,
but only under the new exec_update_mutex.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcmp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index a0e3d7a0e8b81..b3ff9288c6cc9 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -173,8 +173,8 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 	/*
 	 * One should have enough rights to inspect task details.
 	 */
-	ret = kcmp_lock(&task1->signal->cred_guard_mutex,
-			&task2->signal->cred_guard_mutex);
+	ret = kcmp_lock(&task1->signal->exec_update_mutex,
+			&task2->signal->exec_update_mutex);
 	if (ret)
 		goto err;
 	if (!ptrace_may_access(task1, PTRACE_MODE_READ_REALCREDS) ||
@@ -229,8 +229,8 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 	}
 
 err_unlock:
-	kcmp_unlock(&task1->signal->cred_guard_mutex,
-		    &task2->signal->cred_guard_mutex);
+	kcmp_unlock(&task1->signal->exec_update_mutex,
+		    &task2->signal->exec_update_mutex);
 err:
 	put_task_struct(task1);
 	put_task_struct(task2);
-- 
2.25.1

