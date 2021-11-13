Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A78644F2CA
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 12:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhKMLdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 06:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233765AbhKMLdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 06:33:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 288AC610CE;
        Sat, 13 Nov 2021 11:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636803024;
        bh=2dXgt+zj1vJ7qvu87p9BcmDhbAwAHcfcVlhFEqDsLtA=;
        h=Subject:To:Cc:From:Date:From;
        b=W+e4ElvQkuiW6uW7S/6mwJVRu+snfNNgAOp4uOihgD3St2l5tBSmBlnaQWlRCwXcJ
         O3cpGrNN6qZ8zyh/frdY8r7gowTmpDXCIUmTkcP0ncBwMbQa9Mtg3Gd9Ze79kX2rIR
         CFa7MGlz7wv6riPvzPZyqoVyh7qnQLyml2pJn7hA=
Subject: FAILED: patch "[PATCH] scsi: core: Avoid leaving shost->last_reset with stale value" failed to apply to 4.4-stable tree
To:     emilne@redhat.com, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 12:30:22 +0100
Message-ID: <1636803022142229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5ae17501bc62a49b0b193dcce003f16375f16654 Mon Sep 17 00:00:00 2001
From: "Ewan D. Milne" <emilne@redhat.com>
Date: Fri, 29 Oct 2021 15:43:10 -0400
Subject: [PATCH] scsi: core: Avoid leaving shost->last_reset with stale value
 if EH does not run

The changes to issue the abort from the scmd->abort_work instead of the EH
thread introduced a problem if eh_deadline is used.  If aborting the
command(s) is successful, and there are never any scmds added to the
shost->eh_cmd_q, there is no code path which will reset the ->last_reset
value back to zero.

The effect of this is that after a successful abort with no EH thread
activity, a subsequent timeout, perhaps a long time later, might
immediately be considered past a user-set eh_deadline time, and the host
will be reset with no attempt at recovery.

Fix this by resetting ->last_reset back to zero in scmd_eh_abort_handler()
if it is determined that the EH thread will not run to do this.

Thanks to Gopinath Marappan for investigating this problem.

Link: https://lore.kernel.org/r/20211029194311.17504-2-emilne@redhat.com
Fixes: e494f6a72839 ("[SCSI] improved eh timeout handler")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 17aef936bc90..2cb7163e24cc 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -387,6 +387,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
+	INIT_LIST_HEAD(&shost->eh_abort_list);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3de03925550e..bdf782d9cb86 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -133,6 +133,23 @@ static bool scsi_eh_should_retry_cmd(struct scsi_cmnd *cmd)
 	return true;
 }
 
+static void scsi_eh_complete_abort(struct scsi_cmnd *scmd, struct Scsi_Host *shost)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del_init(&scmd->eh_entry);
+	/*
+	 * If the abort succeeds, and there is no further
+	 * EH action, clear the ->last_reset time.
+	 */
+	if (list_empty(&shost->eh_abort_list) &&
+	    list_empty(&shost->eh_cmd_q))
+		if (shost->eh_deadline != -1)
+			shost->last_reset = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
@@ -150,6 +167,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
 	enum scsi_disposition rtn;
+	unsigned long flags;
 
 	if (scsi_host_eh_past_deadline(sdev->host)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
@@ -173,12 +191,14 @@ scmd_eh_abort_handler(struct work_struct *work)
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "retry aborted command\n"));
+				scsi_eh_complete_abort(scmd, sdev->host);
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 				return;
 			} else {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "finish aborted command\n"));
+				scsi_eh_complete_abort(scmd, sdev->host);
 				scsi_finish_command(scmd);
 				return;
 			}
@@ -191,6 +211,9 @@ scmd_eh_abort_handler(struct work_struct *work)
 		}
 	}
 
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	list_del_init(&scmd->eh_entry);
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 	scsi_eh_scmd_add(scmd);
 }
 
@@ -221,6 +244,8 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
+	BUG_ON(!list_empty(&scmd->eh_entry));
+	list_add_tail(&scmd->eh_entry, &shost->eh_abort_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d0b7c6dc74f8..c851c05d6091 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1143,6 +1143,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
 	cmd->flags = flags;
+	INIT_LIST_HEAD(&cmd->eh_entry);
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies_at_alloc;
 	cmd->retries = retries;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7958a604f979..29ac40cf1aae 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -73,7 +73,7 @@ enum scsi_cmnd_submitter {
 struct scsi_cmnd {
 	struct scsi_request req;
 	struct scsi_device *device;
-	struct list_head eh_entry; /* entry for the host eh_cmd_q */
+	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
 	struct delayed_work abort_work;
 
 	struct rcu_head rcu;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ae715959f886..ebe059badba0 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -551,6 +551,7 @@ struct Scsi_Host {
 
 	struct mutex		scan_mutex;/* serialize scanning activity */
 
+	struct list_head	eh_abort_list;
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct completion     * eh_action; /* Wait for specific actions on the

