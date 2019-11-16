Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8DDFEDC6
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfKPPqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:46:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729507AbfKPPqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:49 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC94320891;
        Sat, 16 Nov 2019 15:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919208;
        bh=Nrc5eOD04gcTvsjr92dKVjOYkgRw3rfa0B5zmPbSZM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hr6v/Cg3isyXjv2mQ+VlDICujkpWZCjGh+SFIhaNaPRrRg4X/T43pRjQH/WSgqUIg
         q04y4QJluYrXA8w2WCNm94O26UG3rWSCkiD/fwJdZplmusth/kxlpr9tHs7J6tMVk9
         YD/8d0CJ7oZr2VBQyYWe2plJtjNEDeCkDLZw/Gc4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 212/237] scsi: lpfc: fcoe: Fix link down issue after 1000+ link bounces
Date:   Sat, 16 Nov 2019 10:40:47 -0500
Message-Id: <20191116154113.7417-212-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 036cad1f1ac9ce03e2db94b8460f98eaf1e1ee4c ]

On FCoE adapters, when running link bounce test in a loop, initiator
failed to login with switch switch and required driver reload to
recover. Switch reached a point where all subsequent FLOGIs would be
LS_RJT'd. Further testing showed the condition to be related to not
performing FCF discovery between FLOGI's.

Fix by monitoring FLOGI failures and once a repeated error is seen
repeat FCF discovery.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c     |  2 ++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 20 ++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c    |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 11 ++---------
 drivers/scsi/lpfc/lpfc_sli4.h    |  1 +
 5 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f3c6801c0b312..8bf916b9a987d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1157,6 +1157,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 			phba->hba_flag &= ~(FCF_RR_INPROG | HBA_DEVLOSS_TMO);
 			spin_unlock_irq(&phba->hbalock);
+			phba->fcf.fcf_redisc_attempted = 0; /* reset */
 			goto out;
 		}
 		if (!rc) {
@@ -1171,6 +1172,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 			phba->hba_flag &= ~(FCF_RR_INPROG | HBA_DEVLOSS_TMO);
 			spin_unlock_irq(&phba->hbalock);
+			phba->fcf.fcf_redisc_attempted = 0; /* reset */
 			goto out;
 		}
 	}
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ccdd82b1123f7..38a9245fddba1 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1997,6 +1997,26 @@ int lpfc_sli4_fcf_rr_next_proc(struct lpfc_vport *vport, uint16_t fcf_index)
 				"failover and change port state:x%x/x%x\n",
 				phba->pport->port_state, LPFC_VPORT_UNKNOWN);
 		phba->pport->port_state = LPFC_VPORT_UNKNOWN;
+
+		if (!phba->fcf.fcf_redisc_attempted) {
+			lpfc_unregister_fcf(phba);
+
+			rc = lpfc_sli4_redisc_fcf_table(phba);
+			if (!rc) {
+				lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+						"3195 Rediscover FCF table\n");
+				phba->fcf.fcf_redisc_attempted = 1;
+				lpfc_sli4_clear_fcf_rr_bmask(phba);
+			} else {
+				lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+						"3196 Rediscover FCF table "
+						"failed. Status:x%x\n", rc);
+			}
+		} else {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+					"3197 Already rediscover FCF table "
+					"attempted. No more retry\n");
+		}
 		goto stop_flogi_current_fcf;
 	} else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_ELS,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9acb5b44ce4c1..a7d3e532e0f58 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5044,7 +5044,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 			break;
 		}
 		/* If fast FCF failover rescan event is pending, do nothing */
-		if (phba->fcf.fcf_flag & FCF_REDISC_EVT) {
+		if (phba->fcf.fcf_flag & (FCF_REDISC_EVT | FCF_REDISC_PEND)) {
 			spin_unlock_irq(&phba->hbalock);
 			break;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a490e63c94b67..210c05da64b47 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18435,15 +18435,8 @@ lpfc_sli4_fcf_rr_next_index_get(struct lpfc_hba *phba)
 			goto initial_priority;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
 				"2844 No roundrobin failover FCF available\n");
-		if (next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX)
-			return LPFC_FCOE_FCF_NEXT_NONE;
-		else {
-			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
-				"3063 Only FCF available idx %d, flag %x\n",
-				next_fcf_index,
-			phba->fcf.fcf_pri[next_fcf_index].fcf_rec.flag);
-			return next_fcf_index;
-		}
+
+		return LPFC_FCOE_FCF_NEXT_NONE;
 	}
 
 	if (next_fcf_index < LPFC_SLI4_FCF_TBL_INDX_MAX &&
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 399c0015c5465..3dcc6615a23b2 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -279,6 +279,7 @@ struct lpfc_fcf {
 #define FCF_REDISC_EVT	0x100 /* FCF rediscovery event to worker thread */
 #define FCF_REDISC_FOV	0x200 /* Post FCF rediscovery fast failover */
 #define FCF_REDISC_PROG (FCF_REDISC_PEND | FCF_REDISC_EVT)
+	uint16_t fcf_redisc_attempted;
 	uint32_t addr_mode;
 	uint32_t eligible_fcf_cnt;
 	struct lpfc_fcf_rec current_rec;
-- 
2.20.1

