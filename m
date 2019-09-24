Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF8BCFEA
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfIXRCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632846AbfIXQm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71F8F2196E;
        Tue, 24 Sep 2019 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343377;
        bh=bL9gZIONi5x1sP8K0K9+7JkjNGb4N9JAG6j5LpCsJzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJla8/fBKKwkxkfeKk9ya/fDbTcTX9WFqvOWvvRO3scEUMbnMZickaLmjH0C0qb4+
         70TK9+YJ8nqMTrG8yAMv1ArcJbTL38BfILCER6xI8YjjB71VtOxlT9roYaVBmYwzhy
         c38beySeDsF8d3TmgZqjYi7Rf08VNx8WjyX63A74=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 26/87] ipmi_si: Only schedule continuously in the thread in maintenance mode
Date:   Tue, 24 Sep 2019 12:40:42 -0400
Message-Id: <20190924164144.25591-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 340ff31ab00bca5c15915e70ad9ada3030c98cf8 ]

ipmi_thread() uses back-to-back schedule() to poll for command
completion which, on some machines, can push up CPU consumption and
heavily tax the scheduler locks leading to noticeable overall
performance degradation.

This was originally added so firmware updates through IPMI would
complete in a timely manner.  But we can't kill the scheduler
locks for that one use case.

Instead, only run schedule() continuously in maintenance mode,
where firmware updates should run.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_si_intf.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index da5b6723329a9..28693dbcb0c38 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -221,6 +221,9 @@ struct smi_info {
 	 */
 	bool irq_enable_broken;
 
+	/* Is the driver in maintenance mode? */
+	bool in_maintenance_mode;
+
 	/*
 	 * Did we get an attention that we did not handle?
 	 */
@@ -1007,11 +1010,20 @@ static int ipmi_thread(void *data)
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 		busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
 						  &busy_until);
-		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
+		if (smi_result == SI_SM_CALL_WITHOUT_DELAY) {
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
-			schedule();
-		else if (smi_result == SI_SM_IDLE) {
+		} else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait) {
+			/*
+			 * In maintenance mode we run as fast as
+			 * possible to allow firmware updates to
+			 * complete as fast as possible, but normally
+			 * don't bang on the scheduler.
+			 */
+			if (smi_info->in_maintenance_mode)
+				schedule();
+			else
+				usleep_range(100, 200);
+		} else if (smi_result == SI_SM_IDLE) {
 			if (atomic_read(&smi_info->need_watch)) {
 				schedule_timeout_interruptible(100);
 			} else {
@@ -1019,8 +1031,9 @@ static int ipmi_thread(void *data)
 				__set_current_state(TASK_INTERRUPTIBLE);
 				schedule();
 			}
-		} else
+		} else {
 			schedule_timeout_interruptible(1);
+		}
 	}
 	return 0;
 }
@@ -1198,6 +1211,7 @@ static void set_maintenance_mode(void *send_info, bool enable)
 
 	if (!enable)
 		atomic_set(&smi_info->req_events, 0);
+	smi_info->in_maintenance_mode = enable;
 }
 
 static void shutdown_smi(void *send_info);
-- 
2.20.1

