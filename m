Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF95769F6
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbfGZNm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387943AbfGZNm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:42:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E0E322BF5;
        Fri, 26 Jul 2019 13:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148546;
        bh=ZVMbaLsKposierDugw05RSu2Ih9slD9YWGimhb+npNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMECLQnuKeSjGxBnq6IjShGjK4mIVI6TF5GfnknxnAz/n6yxbB0Fq6i9BrXuLD64d
         D4TvnM5D/SwEuDwvVFWkqh+ruj3EMIn7j6FPTml7B9hLkQBOBpsCvP2pn5D7qk7iEF
         aQr+gTK+NvkND6FwtnCOrjR1rcCP9nbzzyWGWZQ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 09/47] firmware/psci: psci_checker: Park kthreads before stopping them
Date:   Fri, 26 Jul 2019 09:41:32 -0400
Message-Id: <20190726134210.12156-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134210.12156-1-sashal@kernel.org>
References: <20190726134210.12156-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

[ Upstream commit 92e074acf6f7694e96204265eb18ac113f546e80 ]

Since commit 85f1abe0019f ("kthread, sched/wait: Fix kthread_parkme()
completion issue"), kthreads that are bound to a CPU must be parked
before being stopped. At the moment the PSCI checker calls
kthread_stop() directly on the suspend kthread, which triggers the
following warning:

[    6.068288] WARNING: CPU: 1 PID: 1 at kernel/kthread.c:398 __kthread_bind_mask+0x20/0x78
               ...
[    6.190151] Call trace:
[    6.192566]  __kthread_bind_mask+0x20/0x78
[    6.196615]  kthread_unpark+0x74/0x80
[    6.200235]  kthread_stop+0x44/0x1d8
[    6.203769]  psci_checker+0x3bc/0x484
[    6.207389]  do_one_initcall+0x48/0x260
[    6.211180]  kernel_init_freeable+0x2c8/0x368
[    6.215488]  kernel_init+0x10/0x100
[    6.218935]  ret_from_fork+0x10/0x1c
[    6.222467] ---[ end trace e05e22863d043cd3 ]---

kthread_unpark() tries to bind the thread to its CPU and aborts with a
WARN() if the thread wasn't in TASK_PARKED state. Park the kthreads
before stopping them.

Fixes: 85f1abe0019f ("kthread, sched/wait: Fix kthread_parkme() completion issue")
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/psci_checker.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/psci_checker.c b/drivers/firmware/psci_checker.c
index 346943657962..cbd53cb1b2d4 100644
--- a/drivers/firmware/psci_checker.c
+++ b/drivers/firmware/psci_checker.c
@@ -366,16 +366,16 @@ static int suspend_test_thread(void *arg)
 	for (;;) {
 		/* Needs to be set first to avoid missing a wakeup. */
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (kthread_should_stop()) {
-			__set_current_state(TASK_RUNNING);
+		if (kthread_should_park())
 			break;
-		}
 		schedule();
 	}
 
 	pr_info("CPU %d suspend test results: success %d, shallow states %d, errors %d\n",
 		cpu, nb_suspend, nb_shallow_sleep, nb_err);
 
+	kthread_parkme();
+
 	return nb_err;
 }
 
@@ -440,8 +440,10 @@ static int suspend_tests(void)
 
 
 	/* Stop and destroy all threads, get return status. */
-	for (i = 0; i < nb_threads; ++i)
+	for (i = 0; i < nb_threads; ++i) {
+		err += kthread_park(threads[i]);
 		err += kthread_stop(threads[i]);
+	}
  out:
 	cpuidle_resume_and_unlock();
 	kfree(threads);
-- 
2.20.1

