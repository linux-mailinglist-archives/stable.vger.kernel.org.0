Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC9926F181
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgIRCvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgIRCIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC74B2388E;
        Fri, 18 Sep 2020 02:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394902;
        bh=IxCA4cikSGbdMv1b/t6Gfd0J3dPHUmZkz+mdtdpQs6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yb+cIqMy+o8Zt29UmQwA5JfIt9SEmLN6HGgmDmeEAT9QAIvgIJTd0h5EoTEZ7nEjB
         Wjsz78vhSYJV8zPaP3eDqM7AUxb8J+xmTRiKooqJgi6xwIvnK5l6aq48e5kBcaZPWS
         Wtf68J5Y+/vfHGoxINFJnlNVScufjxydFzFaIIGI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 016/206] scsi: lpfc: Fix kernel crash at lpfc_nvme_info_show during remote port bounce
Date:   Thu, 17 Sep 2020 22:04:52 -0400
Message-Id: <20200918020802.2065198-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 6c1e803eac846f886cd35131e6516fc51a8414b9 ]

When reading sysfs nvme_info file while a remote port leaves and comes
back, a NULL pointer is encountered. The issue is due to ndlp list
corruption as the the nvme_info_show does not use the same lock as the rest
of the code.

Correct by removing the rcu_xxx_lock calls and replace by the host_lock and
phba->hbaLock spinlocks that are used by the rest of the driver.  Given
we're called from sysfs, we are safe to use _irq rather than _irqsave.

Link: https://lore.kernel.org/r/20191105005708.7399-4-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index fe084d47ed9e5..3447d19d4147a 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -332,7 +332,6 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	if (strlcat(buf, "\nNVME Initiator Enabled\n", PAGE_SIZE) >= PAGE_SIZE)
 		goto buffer_done;
 
-	rcu_read_lock();
 	scnprintf(tmp, sizeof(tmp),
 		  "XRI Dist lpfc%d Total %d NVME %d SCSI %d ELS %d\n",
 		  phba->brd_no,
@@ -341,7 +340,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  phba->sli4_hba.scsi_xri_max,
 		  lpfc_sli4_get_els_iocb_cnt(phba));
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto rcu_unlock_buf_done;
+		goto buffer_done;
 
 	/* Port state is only one of two values for now. */
 	if (localport->port_id)
@@ -357,7 +356,9 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  wwn_to_u64(vport->fc_nodename.u.wwn),
 		  localport->port_id, statep);
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto rcu_unlock_buf_done;
+		goto buffer_done;
+
+	spin_lock_irq(shost->host_lock);
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		nrport = NULL;
@@ -384,39 +385,39 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 
 		/* Tab in to show lport ownership. */
 		if (strlcat(buf, "NVME RPORT       ", PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 		if (phba->brd_no >= 10) {
 			if (strlcat(buf, " ", PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 
 		scnprintf(tmp, sizeof(tmp), "WWPN x%llx ",
 			  nrport->port_name);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 
 		scnprintf(tmp, sizeof(tmp), "WWNN x%llx ",
 			  nrport->node_name);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 
 		scnprintf(tmp, sizeof(tmp), "DID x%06x ",
 			  nrport->port_id);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 
 		/* An NVME rport can have multiple roles. */
 		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR) {
 			if (strlcat(buf, "INITIATOR ", PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET) {
 			if (strlcat(buf, "TARGET ", PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY) {
 			if (strlcat(buf, "DISCSRVC ", PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 		if (nrport->port_role & ~(FC_PORT_ROLE_NVME_INITIATOR |
 					  FC_PORT_ROLE_NVME_TARGET |
@@ -424,14 +425,14 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 			scnprintf(tmp, sizeof(tmp), "UNKNOWN ROLE x%x",
 				  nrport->port_role);
 			if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 
 		scnprintf(tmp, sizeof(tmp), "%s\n", statep);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 	}
-	rcu_read_unlock();
+	spin_unlock_irq(shost->host_lock);
 
 	if (!lport)
 		goto buffer_done;
@@ -491,11 +492,11 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  atomic_read(&lport->cmpl_fcp_err));
 	strlcat(buf, tmp, PAGE_SIZE);
 
-	/* RCU is already unlocked. */
+	/* host_lock is already unlocked. */
 	goto buffer_done;
 
- rcu_unlock_buf_done:
-	rcu_read_unlock();
+ unlock_buf_done:
+	spin_unlock_irq(shost->host_lock);
 
  buffer_done:
 	len = strnlen(buf, PAGE_SIZE);
-- 
2.25.1

