Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23959406226
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhIJAoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233714AbhIJAUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C276023D;
        Fri, 10 Sep 2021 00:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233177;
        bh=cJmoLDW+FeQvvnwfsFnptMQFLO6o/YXr/fMCpA/IybI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMcf8Irbd7ZYUMzy+NkHpI5fCD4Om1HVmJL1P/6xHuyW2PWZJ2nudiE1slSJlwhPF
         NlOq6mVij+bfb31Nvv3oADAxI/0R7mzRSvyYO9kgBAtBMLh4NpmXwKgWu/Tw05DB8J
         aPnS3R0fVJuIoPRKdcTkSc1xiWicXLZnGL4fhD/Q/gyi92FEVI2oDNF8qLdXT3b/lE
         /E83Aw7WnZspLZow/WxmxV18QKbnD5hOqaI1qjazfBMNcb4avRZmoI81par9nw+z3C
         mblZlsJpLsvRJMSy4V8QY2p0mM4B0+j4OpDfuOpeiimtq+hgrDlBVna01mVg5r71AB
         jI5rJV/psXtKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 54/88] scsi: qla2xxx: Fix NVMe | FCP personality change
Date:   Thu,  9 Sep 2021 20:17:46 -0400
Message-Id: <20210910001820.174272-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit f6e327fc09e48271c103efb3b69fc4ccda3f408b ]

Currently driver saves the personality type (FCP|NVMe) at the start of
first discovery of the remote device. If the remote device personality do
change over time, then qla driver needs to present that to user to decide.

Link: https://lore.kernel.org/r/20210817051315.2477-8-njavali@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5b6e04a91a18..f6ed1d62e16b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3498,6 +3498,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 				continue;
 			fcport->scan_state = QLA_FCPORT_FOUND;
 			fcport->last_rscn_gen = fcport->rscn_gen;
+			fcport->fc4_type = rp->fc4type;
 			found = true;
 			/*
 			 * If device was not a fabric device before.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index dc2ddb8c9dd8..bd74ec862832 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1538,11 +1538,12 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u16 sec;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d8,
-	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d\n",
+	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d fc4type %x\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
 	    fcport->conflict, fcport->last_rscn_gen, fcport->rscn_gen,
-	    fcport->login_gen, fcport->loop_id, fcport->scan_state);
+	    fcport->login_gen, fcport->loop_id, fcport->scan_state,
+	    fcport->fc4_type);
 
 	if (fcport->scan_state != QLA_FCPORT_FOUND)
 		return 0;
-- 
2.30.2

