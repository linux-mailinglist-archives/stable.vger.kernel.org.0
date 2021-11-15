Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182B4450EFC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241618AbhKOSXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:23:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241366AbhKOSTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F66C6327C;
        Mon, 15 Nov 2021 17:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998717;
        bh=0pH9uIAL8bTEuS39SJd8GfiK60uXhb8Fs3WE7QGjqyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdzpISJOcNxmy4G0/SItrMBlUrmFLJzkdZ2WOq9HcAS2DDI5D6qJHfDuFxf+0glsu
         2+az+jjnlQKS610K1RWCPqdMbZ6o/tZnRsZ4lu7N47D9xotEH1LCirnYkJEN2HHlG5
         LwFMgNYuPe16ftI/CZxLOZNXYwheJFQ0AE9uhBms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.14 008/849] scsi: core: Avoid leaving shost->last_reset with stale value if EH does not run
Date:   Mon, 15 Nov 2021 17:51:31 +0100
Message-Id: <20211115165420.266400381@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ewan D. Milne <emilne@redhat.com>

commit 5ae17501bc62a49b0b193dcce003f16375f16654 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hosts.c      |    1 +
 drivers/scsi/scsi_error.c |   25 +++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |    1 +
 include/scsi/scsi_cmnd.h  |    2 +-
 include/scsi/scsi_host.h  |    1 +
 5 files changed, 29 insertions(+), 1 deletion(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -388,6 +388,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
+	INIT_LIST_HEAD(&shost->eh_abort_list);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -135,6 +135,23 @@ static bool scsi_eh_should_retry_cmd(str
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
@@ -152,6 +169,7 @@ scmd_eh_abort_handler(struct work_struct
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
 	enum scsi_disposition rtn;
+	unsigned long flags;
 
 	if (scsi_host_eh_past_deadline(sdev->host)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
@@ -175,12 +193,14 @@ scmd_eh_abort_handler(struct work_struct
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
@@ -193,6 +213,9 @@ scmd_eh_abort_handler(struct work_struct
 		}
 	}
 
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	list_del_init(&scmd->eh_entry);
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 	scsi_eh_scmd_add(scmd);
 }
 
@@ -223,6 +246,8 @@ scsi_abort_command(struct scsi_cmnd *scm
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
+	BUG_ON(!list_empty(&scmd->eh_entry));
+	list_add_tail(&scmd->eh_entry, &shost->eh_abort_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1136,6 +1136,7 @@ void scsi_init_command(struct scsi_devic
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
 	cmd->flags = flags;
+	INIT_LIST_HEAD(&cmd->eh_entry);
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies_at_alloc;
 	cmd->retries = retries;
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -68,7 +68,7 @@ struct scsi_pointer {
 struct scsi_cmnd {
 	struct scsi_request req;
 	struct scsi_device *device;
-	struct list_head eh_entry; /* entry for the host eh_cmd_q */
+	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
 	struct delayed_work abort_work;
 
 	struct rcu_head rcu;
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -556,6 +556,7 @@ struct Scsi_Host {
 
 	struct mutex		scan_mutex;/* serialize scanning activity */
 
+	struct list_head	eh_abort_list;
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct completion     * eh_action; /* Wait for specific actions on the


