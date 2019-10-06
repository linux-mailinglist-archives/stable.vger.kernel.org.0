Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EC5CD870
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfJFRYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbfJFRYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:24:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3A4720867;
        Sun,  6 Oct 2019 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382654;
        bh=pNwcDY5adZIASHbxH2YPHMcw4V0qqTCiDHEkIG00gyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSM+KDB8rtcQ3wygW6E3jaa61vDh1EAu0NE7Avx6khlqzuD6rEdrBB4ubfPzjkCT8
         OHH22+6Oxp7HpD5tT7VscahpqnLUmHaT3atCyNjXzJbGwT3X5myjsO8pnsOafOnJB6
         l3a5JO0OFn99w6Z0GRSkqNCyPkQi0r5926jMF1WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/47] ipmi_si: Only schedule continuously in the thread in maintenance mode
Date:   Sun,  6 Oct 2019 19:20:52 +0200
Message-Id: <20191006172017.171981686@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e0a53156b782f..82af658184444 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -283,6 +283,9 @@ struct smi_info {
 	 */
 	bool irq_enable_broken;
 
+	/* Is the driver in maintenance mode? */
+	bool in_maintenance_mode;
+
 	/*
 	 * Did we get an attention that we did not handle?
 	 */
@@ -1093,11 +1096,20 @@ static int ipmi_thread(void *data)
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
@@ -1105,8 +1117,9 @@ static int ipmi_thread(void *data)
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
@@ -1285,6 +1298,7 @@ static void set_maintenance_mode(void *send_info, bool enable)
 
 	if (!enable)
 		atomic_set(&smi_info->req_events, 0);
+	smi_info->in_maintenance_mode = enable;
 }
 
 static const struct ipmi_smi_handlers handlers = {
-- 
2.20.1



