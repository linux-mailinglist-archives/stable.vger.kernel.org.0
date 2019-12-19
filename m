Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24C126A81
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfLSSr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:47:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfLSSr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:47:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F7A924679;
        Thu, 19 Dec 2019 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781277;
        bh=3bJlusAh5B1PUDWK6hqOtwF7hN+vS38PI+Tu5fQTsQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uK2He40+0NykG+QGCIykZyCU5Ohk0/Ef/nIVOg259dJHFuAl8+VRDCLfOT6rnJUQ7
         eZ5xIvX2S8Aj+yxm7nP37xSBOY5AFOaYgjQ/cGWFGN5E9PDKj7YJbYH7VeTx/8AjOE
         Ze37MOIFEj7/RiFrzaHLfMMlOrmOZnHXr5i0BfHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 154/199] scsi: lpfc: Cap NPIV vports to 256
Date:   Thu, 19 Dec 2019 19:33:56 +0100
Message-Id: <20191219183223.836891450@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 8b47ae69e049ae0b3373859d901f0334322f9fe9 ]

Depending on the chipset, the number of NPIV vports may vary and be in
excess of what most switches support (256). To avoid confusion with the
users, limit the reported NPIV vports to 256.

Additionally correct the 16G adapter which is reporting a bogus NPIV vport
number if the link is down.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h      |  3 ++-
 drivers/scsi/lpfc/lpfc_attr.c | 12 ++++++++++--
 drivers/scsi/lpfc/lpfc_init.c |  3 +++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index b484859464f6b..f0f6d71d28b81 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -878,7 +878,8 @@ struct lpfc_hba {
 	struct list_head port_list;
 	struct lpfc_vport *pport;	/* physical lpfc_vport pointer */
 	uint16_t max_vpi;		/* Maximum virtual nports */
-#define LPFC_MAX_VPI 0xFFFF		/* Max number of VPI supported */
+#define LPFC_MAX_VPI	0xFF		/* Max number VPI supported 0 - 0xff */
+#define LPFC_MAX_VPORTS	0x100		/* Max vports per port, with pport */
 	uint16_t max_vports;            /*
 					 * For IOV HBAs max_vpi can change
 					 * after a reset. max_vports is max
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index cf15b9754402b..aa0435b1ea1e7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1214,6 +1214,9 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		max_vpi = (bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config) > 0) ?
 			(bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config) - 1) : 0;
 
+		/* Limit the max we support */
+		if (max_vpi > LPFC_MAX_VPI)
+			max_vpi = LPFC_MAX_VPI;
 		if (mvpi)
 			*mvpi = max_vpi;
 		if (avpi)
@@ -1229,8 +1232,13 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 			*axri = pmb->un.varRdConfig.avail_xri;
 		if (mvpi)
 			*mvpi = pmb->un.varRdConfig.max_vpi;
-		if (avpi)
-			*avpi = pmb->un.varRdConfig.avail_vpi;
+		if (avpi) {
+			/* avail_vpi is only valid if link is up and ready */
+			if (phba->link_state == LPFC_HBA_READY)
+				*avpi = pmb->un.varRdConfig.avail_vpi;
+			else
+				*avpi = pmb->un.varRdConfig.max_vpi;
+		}
 	}
 
 	mempool_free(pmboxq, phba->mbox_mem_pool);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2f80b2c0409e0..8c640bcf107bd 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6973,6 +6973,9 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 			bf_get(lpfc_mbx_rd_conf_xri_base, rd_config);
 		phba->sli4_hba.max_cfg_param.max_vpi =
 			bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config);
+		/* Limit the max we support */
+		if (phba->sli4_hba.max_cfg_param.max_vpi > LPFC_MAX_VPORTS)
+			phba->sli4_hba.max_cfg_param.max_vpi = LPFC_MAX_VPORTS;
 		phba->sli4_hba.max_cfg_param.vpi_base =
 			bf_get(lpfc_mbx_rd_conf_vpi_base, rd_config);
 		phba->sli4_hba.max_cfg_param.max_rpi =
-- 
2.20.1



