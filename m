Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0829B27C5C0
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbgI2Lif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729832AbgI2Lif (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 614BD22262;
        Tue, 29 Sep 2020 11:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379507;
        bh=ZNSLXRuNGa52uCWoAOHJVDfW8rqDBqg8ZhRQmPT57Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9UGCLDqM2kIKM0EWM1YZvViv3bkx1ddOLcydr3Gph7OEaoW462gY5bQMdgGkXROk
         d1IwPEZoDwptgyjwhchN36d+kvnF5yU8ZpcaeEm5/JOKsw9gGXxpf7QM018UbtySMw
         s4QHuA2fEOd3I9PafurgLinQ1oJtik0aGNYL71pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/388] kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
Date:   Tue, 29 Sep 2020 12:58:46 +0200
Message-Id: <20200929110019.919104260@linuxfoundation.org>
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



