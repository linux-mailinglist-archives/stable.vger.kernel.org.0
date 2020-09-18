Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C2926F2E9
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgIRDCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbgIRCFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC06F2389E;
        Fri, 18 Sep 2020 02:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394719;
        bh=6h2dBenQ50K3IFjlwte/EwE+N6avJPpgBmGXxDM0h9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4A58lfZoVhWB+sw1qXgYZdZbXsYhpjUiN87J7CwxMBRY/Te8xfNY8oAjr5TPJ1jO
         pHa73f4TQ9qEAsqaD4kzdeH9xh/hY2mYToxo3TFA61SKnF444E3W873EtpF28GQNkU
         JKmhJDg8VKcZxXDrpQAEi84MpTKNMboLXM3xDCKI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 203/330] proc: io_accounting: Use new infrastructure to fix deadlocks in execve
Date:   Thu, 17 Sep 2020 21:59:03 -0400
Message-Id: <20200918020110.2063155-203-sashal@kernel.org>
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

[ Upstream commit 76518d3798855242817e8a8ed76b2d72f4415624 ]

This changes do_io_accounting to use the new exec_update_mutex
instead of cred_guard_mutex.

This fixes possible deadlocks when the trace is accessing
/proc/$pid/io for instance.

This should be safe, as the credentials are only used for reading.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4fdfe4faa74ee..529d0c6ec6f9c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2770,7 +2770,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	unsigned long flags;
 	int result;
 
-	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	result = mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (result)
 		return result;
 
@@ -2806,7 +2806,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	result = 0;
 
 out_unlock:
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 	return result;
 }
 
-- 
2.25.1

