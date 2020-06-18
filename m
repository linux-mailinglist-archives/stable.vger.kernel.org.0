Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B881FDC8A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgFRBUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730264AbgFRBUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492A7206F1;
        Thu, 18 Jun 2020 01:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443208;
        bh=Wu4ICg6jA0FGpJIu5+ZL5+NISmPgf8HVCI+TMn6vJas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCkLAQ5HbpFmsMIYsXMBQ8uFlf2cJz25GydPjXm8M39Kx7eVrpFs7DxB4ZzFmB+58
         7Y0262LypAvEllE+2EtfXA/Qaelin/lfiO8GNZwMqAIPwIM8XES3sj8E2EMqWj81fk
         J8NjPjS1ARvJ36ZaoPheDOBghk59ltrJie/hpFCQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <mchristi@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 165/266] scsi: target: tcmu: Userspace must not complete queued commands
Date:   Wed, 17 Jun 2020 21:14:50 -0400
Message-Id: <20200618011631.604574-165-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 61fb2482216679b9e1e797440c148bb143a5040a ]

When tcmu queues a new command - no matter whether in command ring or in
qfull_queue - a cmd_id from IDR udev->commands is assigned to the command.

If userspace sends a wrong command completion containing the cmd_id of a
command on the qfull_queue, tcmu_handle_completions() finds the command in
the IDR and calls tcmu_handle_completion() for it. This might do some nasty
things because commands in qfull_queue do not have a valid dbi list.

To fix this bug, we no longer add queued commands to the idr.  Instead the
cmd_id is assign when a command is written to the command ring.

Due to this change I had to adapt the source code at several places where
up to now an idr_for_each had been done.

[mkp: fix checkpatch warnings]

Link: https://lore.kernel.org/r/20200518164833.12775-1-bstroesser@ts.fujitsu.com
Acked-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 154 ++++++++++++++----------------
 1 file changed, 71 insertions(+), 83 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9425354aef99..70c64e69a1d2 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -882,41 +882,24 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 	return command_size;
 }
 
-static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
-				struct timer_list *timer)
+static void tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
+				 struct timer_list *timer)
 {
-	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
-	int cmd_id;
-
-	if (tcmu_cmd->cmd_id)
-		goto setup_timer;
-
-	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
-	if (cmd_id < 0) {
-		pr_err("tcmu: Could not allocate cmd id.\n");
-		return cmd_id;
-	}
-	tcmu_cmd->cmd_id = cmd_id;
-
-	pr_debug("allocated cmd %u for dev %s tmo %lu\n", tcmu_cmd->cmd_id,
-		 udev->name, tmo / MSEC_PER_SEC);
-
-setup_timer:
 	if (!tmo)
-		return 0;
+		return;
 
 	tcmu_cmd->deadline = round_jiffies_up(jiffies + msecs_to_jiffies(tmo));
 	if (!timer_pending(timer))
 		mod_timer(timer, tcmu_cmd->deadline);
 
-	return 0;
+	pr_debug("Timeout set up for cmd %p, dev = %s, tmo = %lu\n", tcmu_cmd,
+		 tcmu_cmd->tcmu_dev->name, tmo / MSEC_PER_SEC);
 }
 
 static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	unsigned int tmo;
-	int ret;
 
 	/*
 	 * For backwards compat if qfull_time_out is not set use
@@ -931,13 +914,11 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 	else
 		tmo = TCMU_TIME_OUT;
 
-	ret = tcmu_setup_cmd_timer(tcmu_cmd, tmo, &udev->qfull_timer);
-	if (ret)
-		return ret;
+	tcmu_setup_cmd_timer(tcmu_cmd, tmo, &udev->qfull_timer);
 
 	list_add_tail(&tcmu_cmd->queue_entry, &udev->qfull_queue);
-	pr_debug("adding cmd %u on dev %s to ring space wait queue\n",
-		 tcmu_cmd->cmd_id, udev->name);
+	pr_debug("adding cmd %p on dev %s to ring space wait queue\n",
+		 tcmu_cmd, udev->name);
 	return 0;
 }
 
@@ -959,7 +940,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd_entry *entry;
 	struct iovec *iov;
-	int iov_cnt, ret;
+	int iov_cnt, cmd_id;
 	uint32_t cmd_head;
 	uint64_t cdb_off;
 	bool copy_to_data_area;
@@ -1060,14 +1041,21 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	}
 	entry->req.iov_bidi_cnt = iov_cnt;
 
-	ret = tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out,
-				   &udev->cmd_timer);
-	if (ret) {
-		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
+	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
+	if (cmd_id < 0) {
+		pr_err("tcmu: Could not allocate cmd id.\n");
 
+		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
 		*scsi_err = TCM_OUT_OF_RESOURCES;
 		return -1;
 	}
+	tcmu_cmd->cmd_id = cmd_id;
+
+	pr_debug("allocated cmd id %u for cmd %p dev %s\n", tcmu_cmd->cmd_id,
+		 tcmu_cmd, udev->name);
+
+	tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out, &udev->cmd_timer);
+
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 
 	/*
@@ -1279,50 +1267,39 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 	return handled;
 }
 
-static int tcmu_check_expired_cmd(int id, void *p, void *data)
+static void tcmu_check_expired_ring_cmd(struct tcmu_cmd *cmd)
 {
-	struct tcmu_cmd *cmd = p;
-	struct tcmu_dev *udev = cmd->tcmu_dev;
-	u8 scsi_status;
 	struct se_cmd *se_cmd;
-	bool is_running;
-
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
-		return 0;
 
 	if (!time_after(jiffies, cmd->deadline))
-		return 0;
+		return;
 
-	is_running = test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
+	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
+	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
+	cmd->se_cmd = NULL;
 
-	if (is_running) {
-		/*
-		 * If cmd_time_out is disabled but qfull is set deadline
-		 * will only reflect the qfull timeout. Ignore it.
-		 */
-		if (!udev->cmd_time_out)
-			return 0;
+	pr_debug("Timing out inflight cmd %u on dev %s.\n",
+		 cmd->cmd_id, cmd->tcmu_dev->name);
 
-		set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
-		/*
-		 * target_complete_cmd will translate this to LUN COMM FAILURE
-		 */
-		scsi_status = SAM_STAT_CHECK_CONDITION;
-		list_del_init(&cmd->queue_entry);
-		cmd->se_cmd = NULL;
-	} else {
-		list_del_init(&cmd->queue_entry);
-		idr_remove(&udev->commands, id);
-		tcmu_free_cmd(cmd);
-		scsi_status = SAM_STAT_TASK_SET_FULL;
-	}
+	target_complete_cmd(se_cmd, SAM_STAT_CHECK_CONDITION);
+}
 
-	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
-		 id, udev->name, is_running ? "inflight" : "queued");
+static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
+{
+	struct se_cmd *se_cmd;
 
-	target_complete_cmd(se_cmd, scsi_status);
-	return 0;
+	if (!time_after(jiffies, cmd->deadline))
+		return;
+
+	list_del_init(&cmd->queue_entry);
+	se_cmd = cmd->se_cmd;
+	tcmu_free_cmd(cmd);
+
+	pr_debug("Timing out queued cmd %p on dev %s.\n",
+		  cmd, cmd->tcmu_dev->name);
+
+	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
 }
 
 static void tcmu_device_timedout(struct tcmu_dev *udev)
@@ -1407,16 +1384,15 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	return &udev->se_dev;
 }
 
-static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
+static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 {
 	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
 	LIST_HEAD(cmds);
-	bool drained = true;
 	sense_reason_t scsi_ret;
 	int ret;
 
 	if (list_empty(&udev->qfull_queue))
-		return true;
+		return;
 
 	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
 
@@ -1425,11 +1401,10 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
 	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, queue_entry) {
 		list_del_init(&tcmu_cmd->queue_entry);
 
-	        pr_debug("removing cmd %u on dev %s from queue\n",
-		         tcmu_cmd->cmd_id, udev->name);
+		pr_debug("removing cmd %p on dev %s from queue\n",
+			 tcmu_cmd, udev->name);
 
 		if (fail) {
-			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
 			/*
 			 * We were not able to even start the command, so
 			 * fail with busy to allow a retry in case runner
@@ -1444,10 +1419,8 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
 
 		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 		if (ret < 0) {
-		        pr_debug("cmd %u on dev %s failed with %u\n",
-			         tcmu_cmd->cmd_id, udev->name, scsi_ret);
-
-			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
+			pr_debug("cmd %p on dev %s failed with %u\n",
+				 tcmu_cmd, udev->name, scsi_ret);
 			/*
 			 * Ignore scsi_ret for now. target_complete_cmd
 			 * drops it.
@@ -1462,13 +1435,11 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
 			 * the queue
 			 */
 			list_splice_tail(&cmds, &udev->qfull_queue);
-			drained = false;
 			break;
 		}
 	}
 
 	tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
-	return drained;
 }
 
 static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
@@ -1652,6 +1623,8 @@ static void tcmu_dev_kref_release(struct kref *kref)
 		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
 			all_expired = false;
 	}
+	if (!list_empty(&udev->qfull_queue))
+		all_expired = false;
 	idr_destroy(&udev->commands);
 	WARN_ON(!all_expired);
 
@@ -2037,9 +2010,6 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mutex_lock(&udev->cmdr_lock);
 
 	idr_for_each_entry(&udev->commands, cmd, i) {
-		if (!test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags))
-			continue;
-
 		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
 			  cmd->cmd_id, udev->name,
 			  test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags));
@@ -2077,6 +2047,8 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 	del_timer(&udev->cmd_timer);
 
+	run_qfull_queue(udev, false);
+
 	mutex_unlock(&udev->cmdr_lock);
 }
 
@@ -2698,6 +2670,7 @@ static void find_free_blocks(void)
 static void check_timedout_devices(void)
 {
 	struct tcmu_dev *udev, *tmp_dev;
+	struct tcmu_cmd *cmd, *tmp_cmd;
 	LIST_HEAD(devs);
 
 	spin_lock_bh(&timed_out_udevs_lock);
@@ -2708,9 +2681,24 @@ static void check_timedout_devices(void)
 		spin_unlock_bh(&timed_out_udevs_lock);
 
 		mutex_lock(&udev->cmdr_lock);
-		idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
 
-		tcmu_set_next_deadline(&udev->inflight_queue, &udev->cmd_timer);
+		/*
+		 * If cmd_time_out is disabled but qfull is set deadline
+		 * will only reflect the qfull timeout. Ignore it.
+		 */
+		if (udev->cmd_time_out) {
+			list_for_each_entry_safe(cmd, tmp_cmd,
+						 &udev->inflight_queue,
+						 queue_entry) {
+				tcmu_check_expired_ring_cmd(cmd);
+			}
+			tcmu_set_next_deadline(&udev->inflight_queue,
+					       &udev->cmd_timer);
+		}
+		list_for_each_entry_safe(cmd, tmp_cmd, &udev->qfull_queue,
+					 queue_entry) {
+			tcmu_check_expired_queue_cmd(cmd);
+		}
 		tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
 
 		mutex_unlock(&udev->cmdr_lock);
-- 
2.25.1

