Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6433543C
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfFDXWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfFDXWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EE6F20B1F;
        Tue,  4 Jun 2019 23:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690564;
        bh=Cn/3GksDHaeFm4Kju5WqUV7aw6XN+tfHzoHCK/j2FKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpaZYaD3LtsMzkeYODZDCC6DXDBwcTTaIlpR8u6j17zZaO4Np69BUtSuBMN4jCRKZ
         1yx5Y9irpFM4n1CoFjiEIUvfLghmMCYD3G+I3k7jHsEl8agjTVveLKeNUQEkOkttkK
         gT0lNQ2wh+o6v5Q3S+bdL9IUCYsdDTAGIacHlYPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 19/60] scsi: lpfc: correct rcu unlock issue in lpfc_nvme_info_show
Date:   Tue,  4 Jun 2019 19:21:29 -0400
Message-Id: <20190604232212.6753-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

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
index f30cb0fb9a82..26a22e41204e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -338,7 +338,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  phba->sli4_hba.io_xri_max,
 		  lpfc_sli4_get_els_iocb_cnt(phba));
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+		goto rcu_unlock_buf_done;
 
 	/* Port state is only one of two values for now. */
 	if (localport->port_id)
@@ -354,7 +354,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  wwn_to_u64(vport->fc_nodename.u.wwn),
 		  localport->port_id, statep);
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+		goto rcu_unlock_buf_done;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		nrport = NULL;
@@ -381,39 +381,39 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 
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
@@ -421,12 +421,12 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
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
 
@@ -488,7 +488,13 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
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

