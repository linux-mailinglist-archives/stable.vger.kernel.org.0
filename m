Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A794640606F
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhIJARY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhIJART (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C73B61167;
        Fri, 10 Sep 2021 00:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232968;
        bh=XU1/vmmkr13Prw7CaK4GZDXBS+qZhLZsYnYbnDwrdSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqjLn7TKYEfiMOeppffkjNamyn4U1pbsxFsMm8D7qJbXV8RTVCluDvjjxSl/p1O9l
         kvfrGyEhqnFbz1HRK+XS4byHo1uNdtqtMBBOqdQ2cNT5Iekff7wMOjOREvsGEGYsYv
         oX1PK6VjTj50gNtzGKAYtJHDehp+GQrRxapGdycZ8ltddHtzM2MvemqQxaYLKy8XhJ
         cWtUJQHaEt7AwCI3Sn9Q4SPil+ee/ZJx0Vqzsn4oD66mzWeFg+yINWBlu7VKuYyZ7G
         PnXrdbASnVn210tVXAJivC1WbxZI3+SOzd02JCByi/eBwkWDailPnDr6VQRFtp/Tjb
         qRrHYyIDmXN+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 07/99] scsi: lpfc: Remove use of kmalloc() in trace event logging
Date:   Thu,  9 Sep 2021 20:14:26 -0400
Message-Id: <20210910001558.173296-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit e8613084053d406c22914385a488e8b85072100c ]

There are instances when trace event logs are triggered from an interrupt
context. The trace event log may attempt to alloc memory causing scheduling
while atomic bug call traces.

Remove the need for the kmalloc'ed vport array when checking the
log_verbose flag, which eliminates the need for any allocation.

Link: https://lore.kernel.org/r/20210707184351.67872-3-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4bbc621e77e9..cb7773a9167d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14163,8 +14163,9 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	unsigned int temp_idx;
 	int i;
 	int j = 0;
-	unsigned long rem_nsec;
-	struct lpfc_vport **vports;
+	unsigned long rem_nsec, iflags;
+	bool log_verbose = false;
+	struct lpfc_vport *port_iterator;
 
 	/* Don't dump messages if we explicitly set log_verbose for the
 	 * physical port or any vport.
@@ -14172,16 +14173,24 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	if (phba->cfg_log_verbose)
 		return;
 
-	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL) {
-		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
-			if (vports[i]->cfg_log_verbose) {
-				lpfc_destroy_vport_work_array(phba, vports);
+	spin_lock_irqsave(&phba->port_list_lock, iflags);
+	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
+		if (port_iterator->load_flag & FC_UNLOADING)
+			continue;
+		if (scsi_host_get(lpfc_shost_from_vport(port_iterator))) {
+			if (port_iterator->cfg_log_verbose)
+				log_verbose = true;
+
+			scsi_host_put(lpfc_shost_from_vport(port_iterator));
+
+			if (log_verbose) {
+				spin_unlock_irqrestore(&phba->port_list_lock,
+						       iflags);
 				return;
 			}
 		}
 	}
-	lpfc_destroy_vport_work_array(phba, vports);
+	spin_unlock_irqrestore(&phba->port_list_lock, iflags);
 
 	if (atomic_cmpxchg(&phba->dbg_log_dmping, 0, 1) != 0)
 		return;
-- 
2.30.2

