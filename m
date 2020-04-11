Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2481A591B
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgDKXJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbgDKXJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A31AE214D8;
        Sat, 11 Apr 2020 23:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646554;
        bh=5dpFX36ulwAFfK6+EtSvRlqV9/JL9zotlrJl7FJdqqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLvBJ9Xr/ZlEGLjCogjYXNy3+/S0ZIQN/lXmDr2fJqF7h8zyIaV72p9CDasdfZVAY
         9bA0Kl2JebKaITrvK8I/pv1JBFm2MQiF7ms/YoF8HeURGf3YyfKnI9wn/7K78ZVPpa
         pSwWJIECkpZyIPSi4Rg9z37ZX8Njey3VLg9nPh9g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 104/121] scsi: qla2xxx: Fix control flags for login/logout IOCB
Date:   Sat, 11 Apr 2020 19:06:49 -0400
Message-Id: <20200411230706.23855-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
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
index 8b050f0b43330..b0e1bf9abe218 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2362,6 +2362,8 @@ qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	logio->control_flags = cpu_to_le16(LCF_COMMAND_PLOGI);
+
 	if (lio->u.logio.flags & SRB_LOGIN_PRLI_ONLY) {
 		logio->control_flags = cpu_to_le16(LCF_COMMAND_PRLI);
 	} else {
@@ -2912,7 +2914,6 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	sp->fcport = fcport;
 
 	elsio->timeout = qla2x00_els_dcmd2_iocb_timeout;
-	init_completion(&elsio->u.els_plogi.comp);
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
@@ -2922,7 +2923,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	elsio->u.els_plogi.tx_size = elsio->u.els_plogi.rx_size = DMA_POOL_SIZE;
 
 	ptr = elsio->u.els_plogi.els_plogi_pyld =
-	    dma_alloc_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	    dma_alloc_coherent(&ha->pdev->dev, elsio->u.els_plogi.tx_size,
 		&elsio->u.els_plogi.els_plogi_pyld_dma, GFP_KERNEL);
 
 	if (!elsio->u.els_plogi.els_plogi_pyld) {
@@ -2931,7 +2932,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	}
 
 	resp_ptr = elsio->u.els_plogi.els_resp_pyld =
-	    dma_alloc_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	    dma_alloc_coherent(&ha->pdev->dev, elsio->u.els_plogi.rx_size,
 		&elsio->u.els_plogi.els_resp_pyld_dma, GFP_KERNEL);
 
 	if (!elsio->u.els_plogi.els_resp_pyld) {
@@ -2955,6 +2956,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
 	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
+	init_completion(&elsio->u.els_plogi.comp);
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
-- 
2.20.1

