Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3802944B859
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241186AbhKIWmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239684AbhKIWkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:40:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09099619F5;
        Tue,  9 Nov 2021 22:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496617;
        bh=1oAp7J/bCObmfo+3iYaqyyj4MJqdk0r6G7ltQzbRWi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iy7JqtTqViH9AEj04A6X3onODkmP1T3F8gaS6UPcnucNLPnCSjznUJqmdcnmSS1xg
         oILFx1fWDIYg5JtC6KZgvo1zFuVyNaqp8nGG54rck35O2pm3oCNQF/56DRua2N5sdf
         bdJVXTuQs9bHvYOv8xLWVeezt7wjjnCHhVKSe3mtaP5yo20Oi2P3JR9Qpp6K2SS7kH
         EiAuTKnNX1Gpg6BXGZFXM2LZHNwKcyhnyuQxwW+/JgLf8qFFGp0xhqZO68+vqy9ypu
         X0QZSMXKuuOmJC1sBFQZMylAZOACm6w19+YeM3VyXbDisghUwC7pT9URU7dzf/6/FQ
         sUFQVSn5cFRNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, nab@linux-iscsi.org,
        rjui@broadcom.com, sbranden@broadcom.com, jonmason@broadcom.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 4.19 17/21] scsi: target: Fix ordered tag handling
Date:   Tue,  9 Nov 2021 17:23:06 -0500
Message-Id: <20211109222311.1235686-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit ed1227e080990ffec5bf39006ec8a57358e6689a ]

This patch fixes the following bugs:

1. If there are multiple ordered cmds queued and multiple simple cmds
   completing, target_restart_delayed_cmds() could be called on different
   CPUs and each instance could start a ordered cmd. They could then run in
   different orders than they were queued.

2. target_restart_delayed_cmds() and target_handle_task_attr() can race
   where:

   1. target_handle_task_attr() has passed the simple_cmds == 0 check.

   2. transport_complete_task_attr() then decrements simple_cmds to 0.

   3. transport_complete_task_attr() runs target_restart_delayed_cmds() and
      it does not see any cmds on the delayed_cmd_list.

   4. target_handle_task_attr() adds the cmd to the delayed_cmd_list.

   The cmd will then end up timing out.

3. If we are sent > 1 ordered cmds and simple_cmds == 0, we can execute
   them out of order, because target_handle_task_attr() will hit that
   simple_cmds check first and return false for all ordered cmds sent.

4. We run target_restart_delayed_cmds() after every cmd completion, so if
   there is more than 1 simple cmd running, we start executing ordered cmds
   after that first cmd instead of waiting for all of them to complete.

5. Ordered cmds are not supposed to start until HEAD OF QUEUE and all older
   cmds have completed, and not just simple.

6. It's not a bug but it doesn't make sense to take the delayed_cmd_lock
   for every cmd completion when ordered cmds are almost never used. Just
   replacing that lock with an atomic increases IOPs by up to 10% when
   completions are spread over multiple CPUs and there are multiple
   sessions/ mqs/thread accessing the same device.

This patch moves the queued delayed handling to a per device work to
serialze the cmd executions for each device and adds a new counter to track
HEAD_OF_QUEUE and SIMPLE cmds. We can then check the new counter to
determine when to run the work on the completion path.

Link: https://lore.kernel.org/r/20210930020422.92578-3-michael.christie@oracle.com
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c    |  2 +
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 76 ++++++++++++++++++--------
 include/target/target_core_base.h      |  6 +-
 4 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 22e97a93728db..1b381519c1649 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -790,6 +790,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	INIT_LIST_HEAD(&dev->t10_alua.lba_map_list);
 	spin_lock_init(&dev->t10_alua.lba_map_lock);
 
+	INIT_WORK(&dev->delayed_cmd_work, target_do_delayed_work);
+
 	dev->t10_wwn.t10_dev = dev;
 	dev->t10_alua.t10_dev = dev;
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 0c66355879301..c7e1fadcc5cc5 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -151,6 +151,7 @@ void	transport_clear_lun_ref(struct se_lun *);
 void	transport_send_task_abort(struct se_cmd *);
 sense_reason_t	target_cmd_size_check(struct se_cmd *cmd, unsigned int size);
 void	target_qf_do_work(struct work_struct *work);
+void	target_do_delayed_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9c60a090cfd17..64481a3a34d44 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1990,32 +1990,35 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	 */
 	switch (cmd->sam_task_attr) {
 	case TCM_HEAD_TAG:
+		atomic_inc_mb(&dev->non_ordered);
 		pr_debug("Added HEAD_OF_QUEUE for CDB: 0x%02x\n",
 			 cmd->t_task_cdb[0]);
 		return false;
 	case TCM_ORDERED_TAG:
-		atomic_inc_mb(&dev->dev_ordered_sync);
+		atomic_inc_mb(&dev->delayed_cmd_count);
 
 		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list\n",
 			 cmd->t_task_cdb[0]);
-
-		/*
-		 * Execute an ORDERED command if no other older commands
-		 * exist that need to be completed first.
-		 */
-		if (!atomic_read(&dev->simple_cmds))
-			return false;
 		break;
 	default:
 		/*
 		 * For SIMPLE and UNTAGGED Task Attribute commands
 		 */
-		atomic_inc_mb(&dev->simple_cmds);
+		atomic_inc_mb(&dev->non_ordered);
+
+		if (atomic_read(&dev->delayed_cmd_count) == 0)
+			return false;
 		break;
 	}
 
-	if (atomic_read(&dev->dev_ordered_sync) == 0)
-		return false;
+	if (cmd->sam_task_attr != TCM_ORDERED_TAG) {
+		atomic_inc_mb(&dev->delayed_cmd_count);
+		/*
+		 * We will account for this when we dequeue from the delayed
+		 * list.
+		 */
+		atomic_dec_mb(&dev->non_ordered);
+	}
 
 	spin_lock(&dev->delayed_cmd_lock);
 	list_add_tail(&cmd->se_delayed_node, &dev->delayed_cmd_list);
@@ -2023,6 +2026,12 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 
 	pr_debug("Added CDB: 0x%02x Task Attr: 0x%02x to delayed CMD listn",
 		cmd->t_task_cdb[0], cmd->sam_task_attr);
+	/*
+	 * We may have no non ordered cmds when this function started or we
+	 * could have raced with the last simple/head cmd completing, so kick
+	 * the delayed handler here.
+	 */
+	schedule_work(&dev->delayed_cmd_work);
 	return true;
 }
 
@@ -2073,29 +2082,48 @@ EXPORT_SYMBOL(target_execute_cmd);
  * Process all commands up to the last received ORDERED task attribute which
  * requires another blocking boundary
  */
-static void target_restart_delayed_cmds(struct se_device *dev)
+void target_do_delayed_work(struct work_struct *work)
 {
-	for (;;) {
+	struct se_device *dev = container_of(work, struct se_device,
+					     delayed_cmd_work);
+
+	spin_lock(&dev->delayed_cmd_lock);
+	while (!dev->ordered_sync_in_progress) {
 		struct se_cmd *cmd;
 
-		spin_lock(&dev->delayed_cmd_lock);
-		if (list_empty(&dev->delayed_cmd_list)) {
-			spin_unlock(&dev->delayed_cmd_lock);
+		if (list_empty(&dev->delayed_cmd_list))
 			break;
-		}
 
 		cmd = list_entry(dev->delayed_cmd_list.next,
 				 struct se_cmd, se_delayed_node);
+
+		if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
+			/*
+			 * Check if we started with:
+			 * [ordered] [simple] [ordered]
+			 * and we are now at the last ordered so we have to wait
+			 * for the simple cmd.
+			 */
+			if (atomic_read(&dev->non_ordered) > 0)
+				break;
+
+			dev->ordered_sync_in_progress = true;
+		}
+
 		list_del(&cmd->se_delayed_node);
+		atomic_dec_mb(&dev->delayed_cmd_count);
 		spin_unlock(&dev->delayed_cmd_lock);
 
+		if (cmd->sam_task_attr != TCM_ORDERED_TAG)
+			atomic_inc_mb(&dev->non_ordered);
+
 		cmd->transport_state |= CMD_T_SENT;
 
 		__target_execute_cmd(cmd, true);
 
-		if (cmd->sam_task_attr == TCM_ORDERED_TAG)
-			break;
+		spin_lock(&dev->delayed_cmd_lock);
 	}
+	spin_unlock(&dev->delayed_cmd_lock);
 }
 
 /*
@@ -2113,14 +2141,17 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		goto restart;
 
 	if (cmd->sam_task_attr == TCM_SIMPLE_TAG) {
-		atomic_dec_mb(&dev->simple_cmds);
+		atomic_dec_mb(&dev->non_ordered);
 		dev->dev_cur_ordered_id++;
 	} else if (cmd->sam_task_attr == TCM_HEAD_TAG) {
+		atomic_dec_mb(&dev->non_ordered);
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev_cur_ordered_id: %u for HEAD_OF_QUEUE\n",
 			 dev->dev_cur_ordered_id);
 	} else if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
-		atomic_dec_mb(&dev->dev_ordered_sync);
+		spin_lock(&dev->delayed_cmd_lock);
+		dev->ordered_sync_in_progress = false;
+		spin_unlock(&dev->delayed_cmd_lock);
 
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED\n",
@@ -2129,7 +2160,8 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	cmd->se_cmd_flags &= ~SCF_TASK_ATTR_SET;
 
 restart:
-	target_restart_delayed_cmds(dev);
+	if (atomic_read(&dev->delayed_cmd_count) > 0)
+		schedule_work(&dev->delayed_cmd_work);
 }
 
 static void transport_complete_qf(struct se_cmd *cmd)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2cfd3b4573b06..ac59a03d0d00e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -774,8 +774,9 @@ struct se_device {
 	atomic_long_t		read_bytes;
 	atomic_long_t		write_bytes;
 	/* Active commands on this virtual SE device */
-	atomic_t		simple_cmds;
-	atomic_t		dev_ordered_sync;
+	atomic_t		non_ordered;
+	bool			ordered_sync_in_progress;
+	atomic_t		delayed_cmd_count;
 	atomic_t		dev_qf_count;
 	u32			export_count;
 	spinlock_t		delayed_cmd_lock;
@@ -798,6 +799,7 @@ struct se_device {
 	struct list_head	dev_tmr_list;
 	struct workqueue_struct *tmr_wq;
 	struct work_struct	qf_work_queue;
+	struct work_struct	delayed_cmd_work;
 	struct list_head	delayed_cmd_list;
 	struct list_head	state_list;
 	struct list_head	qf_cmd_list;
-- 
2.33.0

