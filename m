Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682A2171E74
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbgB0OIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:08:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730186AbgB0OIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:08:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0E9B20801;
        Thu, 27 Feb 2020 14:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812487;
        bh=IzUhqFyqkl3dMF0O/IH/ZJ6MJuwVTQ07z70oJ/G8tEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqqTWe+u/kUDgJq66/x7uOsXGuT3v4rYUyaVppEqi4D3mQ5BtQLx35nUCATilhug7
         x0YmNaYTNyJ8thxvZq8dOaPC7H2XdY/d0KlkW9WIbJQrMhwVrDfnhV73ivozGvdjjw
         LfCcZJuklsdKHhwFPutUgc5U32/RGbyya2LeYZps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavel Zakharov <pavel.zakharov@delphix.com>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 037/135] scsi: Revert "target/core: Inline transport_lun_remove_cmd()"
Date:   Thu, 27 Feb 2020 14:36:17 +0100
Message-Id: <20200227132234.513109266@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit c14335ebb92a98646ddbf447e6cacc66de5269ad upstream.

Commit 83f85b8ec305 postponed the percpu_ref_put(&se_cmd->se_lun->lun_ref)
call from command completion to the time when the final command reference
is dropped. That approach is not compatible with the iSCSI target driver
because the iSCSI target driver keeps the command with the highest stat_sn
after it has completed until the next command is received (see also
iscsit_ack_from_expstatsn()). Fix this regression by reverting commit
83f85b8ec305.

Fixes: 83f85b8ec305 ("scsi: target/core: Inline transport_lun_remove_cmd()")
Cc: Pavel Zakharov <pavel.zakharov@delphix.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200210051202.12934-1-bvanassche@acm.org
Reported-by: Pavel Zakharov <pavel.zakharov@delphix.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -666,6 +666,11 @@ static int transport_cmd_check_stop_to_f
 
 	target_remove_from_state_list(cmd);
 
+	/*
+	 * Clear struct se_cmd->se_lun before the handoff to FE.
+	 */
+	cmd->se_lun = NULL;
+
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
@@ -693,6 +698,17 @@ static int transport_cmd_check_stop_to_f
 	return cmd->se_tfo->check_stop_free(cmd);
 }
 
+static void transport_lun_remove_cmd(struct se_cmd *cmd)
+{
+	struct se_lun *lun = cmd->se_lun;
+
+	if (!lun)
+		return;
+
+	if (cmpxchg(&cmd->lun_ref_active, true, false))
+		percpu_ref_put(&lun->lun_ref);
+}
+
 static void target_complete_failure_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
@@ -783,6 +799,8 @@ static void target_handle_abort(struct s
 
 	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);
 
+	transport_lun_remove_cmd(cmd);
+
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
@@ -1695,6 +1713,7 @@ static void target_complete_tmr_failure(
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
 
+	transport_lun_remove_cmd(se_cmd);
 	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
@@ -1885,6 +1904,7 @@ void transport_generic_request_failure(s
 		goto queue_full;
 
 check_stop:
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
@@ -2182,6 +2202,7 @@ queue_status:
 		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 		return;
 	}
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
@@ -2276,6 +2297,7 @@ static void target_complete_ok_work(stru
 		if (ret)
 			goto queue_full;
 
+		transport_lun_remove_cmd(cmd);
 		transport_cmd_check_stop_to_fabric(cmd);
 		return;
 	}
@@ -2301,6 +2323,7 @@ static void target_complete_ok_work(stru
 			if (ret)
 				goto queue_full;
 
+			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2336,6 +2359,7 @@ queue_rsp:
 			if (ret)
 				goto queue_full;
 
+			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2371,6 +2395,7 @@ queue_status:
 		break;
 	}
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
@@ -2697,6 +2722,9 @@ int transport_generic_free_cmd(struct se
 		 */
 		if (cmd->state_active)
 			target_remove_from_state_list(cmd);
+
+		if (cmd->se_lun)
+			transport_lun_remove_cmd(cmd);
 	}
 	if (aborted)
 		cmd->free_compl = &compl;
@@ -2768,9 +2796,6 @@ static void target_release_cmd_kref(stru
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 	unsigned long flags;
 
-	if (se_cmd->lun_ref_active)
-		percpu_ref_put(&se_cmd->se_lun->lun_ref);
-
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 		list_del_init(&se_cmd->se_cmd_list);


