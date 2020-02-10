Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6523B156E97
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 06:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgBJFML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 00:12:11 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39138 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgBJFML (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 00:12:11 -0500
Received: by mail-pf1-f193.google.com with SMTP id 84so3107311pfy.6;
        Sun, 09 Feb 2020 21:12:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q20S8hhWKqJkPa0Qq9MX1fLi2t6ZznP3v1plpMhprv0=;
        b=NjO6YtOEvmVclqsng9dQGX1fF81vTy8tSxzQChmO5COorNDsZZJNk2wZSE0N1+PwGw
         UGPUFY/pdWK06/CoMbv/kOQge96j1cYc6xmmSIuXhg6v09DSsqRB74D2gslpLgMdwP07
         gJbrZpGW0ANn3a3VmT18/daMEgTVVltvixATl3smPPMSyXlgv0ullWtrZI7bAXhgFfMp
         I3ZHyYjsfldIcIOECL6kxSrYYHfNWPcNkoQmJzNVlmKSQgSyZfJJfmuUHX5XmO9gjgEu
         KoYNbfTBNDY7c8qyhE9+Nhpts7Dq00ylLwlqS18k2lOUGMqyI3iClDdyMDkTtpcUdCfS
         a+Vw==
X-Gm-Message-State: APjAAAUeQA8UlnwvaEoaOHmsIIAuZMuUNLXJlDoG8C/fpYbs2r8MnNoS
        2WbORP5nzhyELYXc8uIN+B8=
X-Google-Smtp-Source: APXvYqxqnXDtiIGW7AQNFE8oI4CnIv6UYAnt7UT7An+4GugjhqEit5krPf2LbEDyx+EWfTur5I3+Ng==
X-Received: by 2002:a63:64c5:: with SMTP id y188mr12232919pgb.10.1581311530399;
        Sun, 09 Feb 2020 21:12:10 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:20b3:5fd0:4962:3980])
        by smtp.gmail.com with ESMTPSA id v7sm10625384pfn.61.2020.02.09.21.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 21:12:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Pavel Zakharov <pavel.zakharov@delphix.com>,
        Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] Revert "target/core: Inline transport_lun_remove_cmd()"
Date:   Sun,  9 Feb 2020 21:12:02 -0800
Message-Id: <20200210051202.12934-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 83f85b8ec305 postponed the percpu_ref_put(&se_cmd->se_lun->lun_ref)
call from command completion to the time when the final command reference
is dropped. That approach is not compatible with the iSCSI target driver
because the iSCSI target driver keeps the command with the highest stat_sn
after it has completed until the next command is received (see also
iscsit_ack_from_expstatsn()). Fix this regression by reverting commit
83f85b8ec305.

Reported-by: Pavel Zakharov <pavel.zakharov@delphix.com>
Cc: Pavel Zakharov <pavel.zakharov@delphix.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: 83f85b8ec305 ("scsi: target/core: Inline transport_lun_remove_cmd()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 31 +++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ea482d4b1f00..0ae9e60fc4d5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -666,6 +666,11 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 
 	target_remove_from_state_list(cmd);
 
+	/*
+	 * Clear struct se_cmd->se_lun before the handoff to FE.
+	 */
+	cmd->se_lun = NULL;
+
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
@@ -693,6 +698,17 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
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
@@ -783,6 +799,8 @@ static void target_handle_abort(struct se_cmd *cmd)
 
 	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);
 
+	transport_lun_remove_cmd(cmd);
+
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
@@ -1708,6 +1726,7 @@ static void target_complete_tmr_failure(struct work_struct *work)
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
 
+	transport_lun_remove_cmd(se_cmd);
 	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
@@ -1898,6 +1917,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		goto queue_full;
 
 check_stop:
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
@@ -2195,6 +2215,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 		return;
 	}
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
@@ -2289,6 +2310,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		if (ret)
 			goto queue_full;
 
+		transport_lun_remove_cmd(cmd);
 		transport_cmd_check_stop_to_fabric(cmd);
 		return;
 	}
@@ -2314,6 +2336,7 @@ static void target_complete_ok_work(struct work_struct *work)
 			if (ret)
 				goto queue_full;
 
+			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2349,6 +2372,7 @@ static void target_complete_ok_work(struct work_struct *work)
 			if (ret)
 				goto queue_full;
 
+			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2384,6 +2408,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		break;
 	}
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
@@ -2710,6 +2735,9 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		 */
 		if (cmd->state_active)
 			target_remove_from_state_list(cmd);
+
+		if (cmd->se_lun)
+			transport_lun_remove_cmd(cmd);
 	}
 	if (aborted)
 		cmd->free_compl = &compl;
@@ -2781,9 +2809,6 @@ static void target_release_cmd_kref(struct kref *kref)
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 	unsigned long flags;
 
-	if (se_cmd->lun_ref_active)
-		percpu_ref_put(&se_cmd->se_lun->lun_ref);
-
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 		list_del_init(&se_cmd->se_cmd_list);
