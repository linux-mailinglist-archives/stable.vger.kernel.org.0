Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86507F7F2D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfKKSdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:33:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728158AbfKKSdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:33:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ADDE214E0;
        Mon, 11 Nov 2019 18:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497213;
        bh=HF4uijMyGzKGfAH1v82FhCnktpAr5PkJtl1aztSZj0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLgxAilHg76UxI9oPp3oHUxExrWtsYaLUfhfDCLbmlZKMKwmVoQwJU89L67IyLb3j
         Q7aAUPwxNhs7ZrSq7pCOkCCw+ENQhh8yN/oVAgtcCt3mM7mI7h0IMjE3pUESQLoATz
         sjRGfGsQ/JwZknYg4xmdFbGmFFACbXIivCvMlZXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 40/65] scsi: qla2xxx: fixup incorrect usage of host_byte
Date:   Mon, 11 Nov 2019 19:28:40 +0100
Message-Id: <20191111181347.659641041@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

[ Upstream commit 66cf50e65b183c863825f5c28a818e3f47a72e40 ]

DRIVER_ERROR is a a driver byte setting, not a host byte.  The qla2xxx
driver should rather return DID_ERROR here to be in line with the other
drivers.

Link: https://lore.kernel.org/r/20191018140458.108278-1-hare@suse.de
Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 4a6e086279f9a..33e4dceb895f2 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -252,7 +252,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	srb_t *sp;
 	const char *type;
 	int req_sg_cnt, rsp_sg_cnt;
-	int rval =  (DRIVER_ERROR << 16);
+	int rval =  (DID_ERROR << 16);
 	uint16_t nextlid = 0;
 
 	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
@@ -426,7 +426,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	int rval = (DRIVER_ERROR << 16);
+	int rval = (DID_ERROR << 16);
 	int req_sg_cnt, rsp_sg_cnt;
 	uint16_t loop_id;
 	struct fc_port *fcport;
@@ -1911,7 +1911,7 @@ qlafx00_mgmt_cmd(struct fc_bsg_job *bsg_job)
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	int rval = (DRIVER_ERROR << 16);
+	int rval = (DID_ERROR << 16);
 	struct qla_mt_iocb_rqst_fx00 *piocb_rqst;
 	srb_t *sp;
 	int req_sg_cnt = 0, rsp_sg_cnt = 0;
-- 
2.20.1



