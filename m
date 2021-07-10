Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED03C2D2E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhGJCWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232530AbhGJCVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC475613F8;
        Sat, 10 Jul 2021 02:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883532;
        bh=LJZFFQqB/CbRyDrn14s8L9SlJoFUOzlZDhDP4dh9RFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFZsIufYqk71KYgkVWTKLQdQXIVcMatB2RLDow5REQjy9zY5jmwr784/DgcHfelBX
         dTD13HXVgL0U+y5tJyDAS5IuMIMsw7CIPOVds2VJHits6p/IsC9W0G42NOgSolL9tw
         xBV/3oU//7R24XrsQCrMZk9AkbTIqQRCng7PlVU4vTRSBox9IcKQb0JT3u7Ti62veM
         7elmUw/7dAc6JUGxV9uIxGcio0IYdK2fmjhxlS4O0NFpvV6LBJ5A/QNsag97Cnk4NL
         MhsUuKLuoAdLO6ijDQrgzDZVW2wESXGRBbt700rJx+vq6wJlyG7xbTHC2UlNE1lKpV
         U60Bgwp5JMWCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 046/114] scsi: iscsi: Fix shost->max_id use
Date:   Fri,  9 Jul 2021 22:16:40 -0400
Message-Id: <20210710021748.3167666-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit bdd4aad7ff92ae39c2e93c415bb6761cb8b584da ]

The iscsi offload drivers are setting the shost->max_id to the max number
of sessions they support. The problem is that max_id is not the max number
of targets but the highest identifier the targets can have. To use it to
limit the number of targets we need to set it to max sessions - 1, or we
can end up with a session we might not have preallocated resources for.

Link: https://lore.kernel.org/r/20210525181821.7617-15-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/be2iscsi/be_main.c  | 4 ++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c    | 4 ++--
 drivers/scsi/qedi/qedi_main.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 27c4f1598f76..d941e1561527 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -416,7 +416,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 			"beiscsi_hba_alloc - iscsi_host_alloc failed\n");
 		return NULL;
 	}
-	shost->max_id = BE2_MAX_SESSIONS;
+	shost->max_id = BE2_MAX_SESSIONS - 1;
 	shost->max_channel = 0;
 	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
 	shost->max_lun = BEISCSI_NUM_MAX_LUN;
@@ -5318,7 +5318,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 	/* Re-enable UER. If different TPE occurs then it is recoverable. */
 	beiscsi_set_uer_feature(phba);
 
-	phba->shost->max_id = phba->params.cxns_per_ctrl;
+	phba->shost->max_id = phba->params.cxns_per_ctrl - 1;
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b6c1da46d582..197aca76a69d 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -791,7 +791,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 		return NULL;
 	shost->dma_boundary = cnic->pcidev->dma_mask;
 	shost->transportt = bnx2i_scsi_xport_template;
-	shost->max_id = ISCSI_MAX_CONNS_PER_HBA;
+	shost->max_id = ISCSI_MAX_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = 512;
 	shost->max_cmd_len = 16;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..ecb134b4699f 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -337,7 +337,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
 
 int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
-		unsigned int max_id, struct scsi_host_template *sht,
+		unsigned int max_conns, struct scsi_host_template *sht,
 		struct scsi_transport_template *stt)
 {
 	struct cxgbi_hba *chba;
@@ -357,7 +357,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
 
 		shost->transportt = stt;
 		shost->max_lun = max_lun;
-		shost->max_id = max_id;
+		shost->max_id = max_conns - 1;
 		shost->max_channel = 0;
 		shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 2455d1448a7e..edf915432704 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -640,7 +640,7 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
 		goto exit_setup_shost;
 	}
 
-	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA;
+	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = ~0;
 	shost->max_cmd_len = 16;
-- 
2.30.2

