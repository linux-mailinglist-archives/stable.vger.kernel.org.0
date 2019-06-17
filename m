Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDEB492EE
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfFQVZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729693AbfFQVZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:25:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D69B920657;
        Mon, 17 Jun 2019 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806724;
        bh=fqkjKtFeCYJPAeyGJH6xJYw/kbvNAqSDYjsLukaKB+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMKXJ30pqGrUeC32GXWDwUnx0MgMCcc43PuZ39vsOQV10j8XrI6ZodakmTapoApA6
         NEdSbYA1jrUIwwpLA/j3d/Ds2vC2bbme7ccyFxQ2bVsY4kKA4fm/PqOhcDw9tZNw/J
         +RL/suq1k7wH/yiz7C+z7KhDhyB4mmNwtkSJyoww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/75] scsi: lpfc: correct rcu unlock issue in lpfc_nvme_info_show
Date:   Mon, 17 Jun 2019 23:09:47 +0200
Message-Id: <20190617210754.185875136@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 79080d349f7f58a2e86c56043a3d04184d5f294a ]

Many of the exit cases were not releasing the rcu read lock.  Corrected the
exit paths.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index cb19b12e7211..55cd96e2469c 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -341,7 +341,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  phba->sli4_hba.scsi_xri_max,
 		  lpfc_sli4_get_els_iocb_cnt(phba));
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+		goto rcu_unlock_buf_done;
 
 	/* Port state is only one of two values for now. */
 	if (localport->port_id)
@@ -357,7 +357,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  wwn_to_u64(vport->fc_nodename.u.wwn),
 		  localport->port_id, statep);
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+		goto rcu_unlock_buf_done;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		nrport = NULL;
@@ -384,39 +384,39 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 
 		/* Tab in to show lport ownership. */
 		if (strlcat(buf, "NVME RPORT       ", PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 		if (phba->brd_no >= 10) {
 			if (strlcat(buf, " ", PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 
 		scnprintf(tmp, sizeof(tmp), "WWPN x%llx ",
 			  nrport->port_name);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 
 		scnprintf(tmp, sizeof(tmp), "WWNN x%llx ",
 			  nrport->node_name);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 
 		scnprintf(tmp, sizeof(tmp), "DID x%06x ",
 			  nrport->port_id);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 
 		/* An NVME rport can have multiple roles. */
 		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR) {
 			if (strlcat(buf, "INITIATOR ", PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET) {
 			if (strlcat(buf, "TARGET ", PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY) {
 			if (strlcat(buf, "DISCSRVC ", PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 		if (nrport->port_role & ~(FC_PORT_ROLE_NVME_INITIATOR |
 					  FC_PORT_ROLE_NVME_TARGET |
@@ -424,12 +424,12 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 			scnprintf(tmp, sizeof(tmp), "UNKNOWN ROLE x%x",
 				  nrport->port_role);
 			if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 
 		scnprintf(tmp, sizeof(tmp), "%s\n", statep);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 	}
 	rcu_read_unlock();
 
@@ -491,7 +491,13 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  atomic_read(&lport->cmpl_fcp_err));
 	strlcat(buf, tmp, PAGE_SIZE);
 
-buffer_done:
+	/* RCU is already unlocked. */
+	goto buffer_done;
+
+ rcu_unlock_buf_done:
+	rcu_read_unlock();
+
+ buffer_done:
 	len = strnlen(buf, PAGE_SIZE);
 
 	if (unlikely(len >= (PAGE_SIZE - 1))) {
-- 
2.20.1



