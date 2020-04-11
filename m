Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CDD1A576C
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgDKXWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbgDKXNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D2B20708;
        Sat, 11 Apr 2020 23:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646794;
        bh=Nor3LFQx5gasX/TffxXutfOivoR3WUsiFJPiv1MKceg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxKlm8zRYOcG8MJaHfEWDNPVmuVtuds7byNvMxGib2HRQSEATTfCZDHNI+TFju0m8
         n/0UIyUwhrLZnB+Wr1dfwqJPtbfXY6bmj6iq7YxP3O0De2LxQhqulZZxlZxjHuVgrd
         3vvyrNY8GQ/4JCYXnC4r9+MCrVgoXWoIBcVtynco=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 58/66] scsi: qla2xxx: Fix control flags for login/logout IOCB
Date:   Sat, 11 Apr 2020 19:11:55 -0400
Message-Id: <20200411231203.25933-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit 419ae5fe73e50084fa794934fb62fab34f564b7c ]

This patch fixes control flag options for login/logout IOCB.

Link: https://lore.kernel.org/r/20200212214436.25532-23-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7e47321e003c8..f07aa045f3f93 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2224,6 +2224,8 @@ qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	logio->control_flags = cpu_to_le16(LCF_COMMAND_PLOGI);
+
 	if (lio->u.logio.flags & SRB_LOGIN_PRLI_ONLY) {
 		logio->control_flags = cpu_to_le16(LCF_COMMAND_PRLI);
 	} else {
@@ -2663,7 +2665,6 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	sp->fcport = fcport;
 
 	elsio->timeout = qla2x00_els_dcmd2_iocb_timeout;
-	init_completion(&elsio->u.els_plogi.comp);
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
@@ -2673,7 +2674,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	elsio->u.els_plogi.tx_size = elsio->u.els_plogi.rx_size = DMA_POOL_SIZE;
 
 	ptr = elsio->u.els_plogi.els_plogi_pyld =
-	    dma_alloc_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	    dma_alloc_coherent(&ha->pdev->dev, elsio->u.els_plogi.tx_size,
 		&elsio->u.els_plogi.els_plogi_pyld_dma, GFP_KERNEL);
 	ptr_dma = elsio->u.els_plogi.els_plogi_pyld_dma;
 
@@ -2683,7 +2684,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	}
 
 	resp_ptr = elsio->u.els_plogi.els_resp_pyld =
-	    dma_alloc_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	    dma_alloc_coherent(&ha->pdev->dev, elsio->u.els_plogi.rx_size,
 		&elsio->u.els_plogi.els_resp_pyld_dma, GFP_KERNEL);
 
 	if (!elsio->u.els_plogi.els_resp_pyld) {
@@ -2707,6 +2708,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
 	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
+	init_completion(&elsio->u.els_plogi.comp);
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
-- 
2.20.1

